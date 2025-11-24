using backendquickquote.Models;
using Npgsql;
using System.Text.Json;
using System.Text.RegularExpressions;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddScoped<NpgsqlConnection>(_ => new NpgsqlConnection(connectionString));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapGet("/", () =>
{
    var resp = new ApiResponse<string>(
        Code: 200,
        Message: "API de QuickQuote arriba y rulay 😎",
        Data: "OK"
    );
    return Results.Ok(resp);
});

// GET /products  
app.MapGet("/products", async (NpgsqlConnection conn,int skip = 0, int take = 10 ) =>
{
    if (skip < 0) skip = 0;
    if (take <= 0) take = 10;
    if (take > 100) take = 100;

    var list = new List<Product>();

    await conn.OpenAsync();

    const string sql = @"
        SELECT id, name, price, stock, category
        FROM product
        ORDER BY id
        LIMIT @take OFFSET @skip;
    ";

    await using var cmd = new NpgsqlCommand(sql, conn);
    cmd.Parameters.AddWithValue("take", take);
    cmd.Parameters.AddWithValue("skip", skip);

    await using var reader = await cmd.ExecuteReaderAsync();

    while (await reader.ReadAsync())
    {
        list.Add(new Product(
            reader.GetInt32(0),
            reader.GetString(1),
            reader.GetDecimal(2),
            reader.GetInt32(3),
            reader.IsDBNull(4) ? null : reader.GetString(4)
        ));
    }

    var resp = new ApiResponse<List<Product>>(
        Code: 200,
        Message: "Productos obtenidos.",
        Data: list
    );

    return Results.Ok(resp);
});


// GET /products/{id}
app.MapGet("/products/{id:int}", async (int id, NpgsqlConnection conn) =>
{
    await conn.OpenAsync();

    const string sql = @"
        SELECT id, description, specs
        FROM product_detail
        WHERE id = @id;
    ";

    await using var cmd = new NpgsqlCommand(sql, conn);
    cmd.Parameters.AddWithValue("id", id);

    await using var reader = await cmd.ExecuteReaderAsync();

    if (!await reader.ReadAsync())
    {
        var notFound = new ApiResponse<object>(
            Code: 404,
            Message: "Producto no encontrado.",
            Data: null
        );
        return Results.NotFound(notFound);
    }

    var data = new ProductDetail(
        reader.GetInt32(0),
        reader.GetString(1),
        JsonDocument.Parse(reader.GetString(2))
    );

    var resp = new ApiResponse<ProductDetail>(
        Code: 200,
        Message: "Producto obtenido.",
        Data: data
    );

    return Results.Ok(resp);
});


// GET /quotes
app.MapGet("/quotes/by-priority", async (
    NpgsqlConnection conn,
    int skip = 0,
    int take = 10,
    bool groupByProject = true
    ) =>
{
    if (skip < 0) skip = 0;
    if (take <= 0) take = 10;
    if (take > 100) take = 100;

    await conn.OpenAsync();

    const string sql = @"
        SELECT 
            q.id,
            q.items,
            q.total,
            q.status,
            q.created_at,
            q.updated_at,
            q.project_id,
            p.name AS project_name,
            q.customer_impact,
            q.expires_at,
            CASE LOWER(q.customer_impact)
                WHEN 'vip' THEN 3
                WHEN 'standard' THEN 2
                WHEN 'internal' THEN 1
                ELSE 0
            END AS impact_score,
            EXTRACT(EPOCH FROM (q.expires_at - NOW())) / 3600.0 AS hours_left
        FROM quotes q
        LEFT JOIN projects p ON p.id = q.project_id
        WHERE q.status <> 'cancelled' -- ejemplo de filtro
        ORDER BY
            impact_score DESC,      -- primero impacto
            q.expires_at ASC       -- luego lo que vence antes
        LIMIT @take OFFSET @skip;
    ";

    var list = new List<QuotePriorityDto>();

    await using (var cmd = new NpgsqlCommand(sql, conn))
    {
        cmd.Parameters.AddWithValue("take", take);
        cmd.Parameters.AddWithValue("skip", skip);

        await using var reader = await cmd.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            list.Add(new QuotePriorityDto(
                Id: reader.GetInt32(0),
                Items: reader.GetInt32(1),
                Total: reader.GetDecimal(2),
                Status: reader.GetString(3),
                CreatedAt: reader.GetDateTime(4),
                UpdatedAt: reader.GetDateTime(5),
                ProjectId: reader.IsDBNull(6) ? null : reader.GetInt32(6),
                ProjectName: reader.IsDBNull(7) ? null : reader.GetString(7),
                CustomerImpact: reader.GetString(8),
                ExpiresAt: reader.GetDateTime(9),
                ImpactScore: reader.GetInt32(10),
                HoursLeft: reader.GetDouble(11)
            ));
        }
    }

    if (!groupByProject)
    {
        // Respuesta plana, solo ordenada por prioridad
        var respOkNoGroup = new ApiResponse<List<QuotePriorityDto>>(
        Code: 200,
        Message: "Cotización obtenida.",
        Data: list
    );
        return Results.Ok(respOkNoGroup);
    }

    // Agrupar por proyecto (incluyendo los que no tienen proyecto)
    var groups = new List<QuoteProjectGroup>();

    foreach (var grp in list.GroupBy(q => q.ProjectId))
    {
        var projectId = grp.Key;
        var projectName = grp.First().ProjectName ?? "Sin proyecto";

        groups.Add(new QuoteProjectGroup(
            ProjectId: projectId,
            ProjectName: projectName,
            Quotes: grp.ToList()
        ));
    }

    var response = new QuotePriorityResponse(
    GroupByProject: true,
    Groups: groups
);

    var respOk = new ApiResponse<QuotePriorityResponse>(
        Code: 200,
        Message: "Cotización obtenida.",
        Data: response
    );
    return Results.Ok(respOk);
});

// GET /quotes/{id} 
app.MapGet("/quotes/{id:int}", async (int id, NpgsqlConnection conn) =>
{
    await conn.OpenAsync();

    // 1) Obtener quote
    const string qSql = @"
        SELECT id, items, total, status, created_at, updated_at
        FROM quotes
        WHERE id = @id;
    ";

    Quote? quote = null;

    await using (var qCmd = new NpgsqlCommand(qSql, conn))
    {
        qCmd.Parameters.AddWithValue("id", id);
        await using var reader = await qCmd.ExecuteReaderAsync();

        if (!await reader.ReadAsync())
        {
            var resp404 = new ApiResponse<object>(
                Code: 404,
                Message: "Cotización no encontrada.",
                Data: null
            );
            return Results.NotFound(resp404);
        }

        quote = new Quote(
            reader.GetInt32(0),
            reader.GetInt32(1),
            reader.GetDecimal(2),
            reader.GetString(3),
            reader.GetDateTime(4),
            reader.GetDateTime(5)
        );
    }

    const string itemsSql = @"
        SELECT 
            qi.id,
            qi.quote_id,
            qi.product_id,
            p.name,
            qi.quantity,
            qi.unit_price,
            (qi.quantity * qi.unit_price) AS line_total
        FROM quote_items qi
        JOIN product p ON p.id = qi.product_id
        WHERE qi.quote_id = @qid;
    ";

    var items = new List<QuoteItemDetail>();

    await using (var cmdItems = new NpgsqlCommand(itemsSql, conn))
    {
        cmdItems.Parameters.AddWithValue("qid", id);

        await using var r = await cmdItems.ExecuteReaderAsync();

        while (await r.ReadAsync())
        {
            items.Add(new QuoteItemDetail(
                r.GetInt32(0),
                r.GetInt32(1),
                r.GetInt32(2),
                r.GetString(3),
                r.GetInt32(4),
                r.GetDecimal(5),
                r.GetDecimal(6)
            ));
        }
    }

    var fullData = new QuoteWithItems(quote!, items);

    var respOk = new ApiResponse<QuoteWithItems>(
        Code: 200,
        Message: "Cotización obtenida.",
        Data: fullData
    );

    return Results.Ok(respOk);
});

app.Run();

