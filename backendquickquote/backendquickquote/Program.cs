
using backendquickquote.Models;
using Npgsql;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Swagger
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

        app.MapGet("/", () => "welcome");

        // GET /products  (con skip/take)
        app.MapGet("/products", async(NpgsqlConnection conn, int skip = 0, int take = 10) =>
        {
            if (skip < 0) skip = 0;
            if (take <= 0) take = 10;
            if (take > 100) take = 100; 

            var products = new List<Product>();

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
                products.Add(new Product(
                    Id: reader.GetInt32(0),
                    Name: reader.GetString(1),
                    Price: reader.GetDecimal(2),
                    Stock: reader.GetInt32(3),
                    Category: reader.IsDBNull(4) ? null : reader.GetString(4)
                ));
            }

            return Results.Ok(products);
        });

        // GET /products/{id}
        app.MapGet("/products/{id:int}", async (int id, NpgsqlConnection conn) =>
        {
            await conn.OpenAsync();

            const string sql = @"
                SELECT id, name, price, stock, category
                FROM product
                WHERE id = @id;
            ";

            await using var cmd = new NpgsqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("id", id);

            await using var reader = await cmd.ExecuteReaderAsync();

            if (!await reader.ReadAsync())
                return Results.NotFound();

            var product = new Product(
                Id: reader.GetInt32(0),
                Name: reader.GetString(1),
                Price: reader.GetDecimal(2),
                Stock: reader.GetInt32(3),
                Category: reader.IsDBNull(4) ? null : reader.GetString(4)
            );

            return Results.Ok(product);
        });

        // GET /quotes/by-priority
        // ?skip=0&take=10&groupByProject=true
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
                return Results.Ok(list);
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

            var response = new
            {
                GroupByProject = true,
                Groups = groups
            };

            return Results.Ok(response);
        });


        // GET /quotes/{id} (con items)
        app.MapGet("/quotes/{id:int}", async (int id, NpgsqlConnection conn) =>
        {
            await conn.OpenAsync();

            // 1) Traer la quote
            const string quoteSql = @"
                SELECT id, items, total, status, created_at, updated_at
                FROM quotes
                WHERE id = @id;
            ";

            Quote? quote = null;

            await using (var quoteCmd = new NpgsqlCommand(quoteSql, conn))
            {
                quoteCmd.Parameters.AddWithValue("id", id);
                await using var reader = await quoteCmd.ExecuteReaderAsync();

                if (!await reader.ReadAsync())
                    return Results.NotFound();

                quote = new Quote(
                    Id: reader.GetInt32(0),
                    Items: reader.GetInt32(1),
                    Total: reader.GetDecimal(2),
                    Status: reader.GetString(3),
                    CreatedAt: reader.GetDateTime(4),
                    UpdatedAt: reader.GetDateTime(5)
                );
            }

            // 2) Traer los items con info del producto
            const string itemsSql = @"
                SELECT 
                    qi.id,
                    qi.quote_id,
                    qi.product_id,
                    p.name AS product_name,
                    qi.quantity,
                    qi.unit_price,
                    (qi.quantity * qi.unit_price) AS line_total
                FROM quote_items qi
                JOIN product p ON p.id = qi.product_id
                WHERE qi.quote_id = @quote_id;
            ";

            var items = new List<QuoteItemDetail>();

            await using (var itemsCmd = new NpgsqlCommand(itemsSql, conn))
            {
                itemsCmd.Parameters.AddWithValue("quote_id", id);
                await using var reader = await itemsCmd.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    items.Add(new QuoteItemDetail(
                        Id: reader.GetInt32(0),
                        QuoteId: reader.GetInt32(1),
                        ProductId: reader.GetInt32(2),
                        ProductName: reader.GetString(3),
                        Quantity: reader.GetInt32(4),
                        UnitPrice: reader.GetDecimal(5),
                        LineTotal: reader.GetDecimal(6)
                    ));
                }
            }

            var result = new QuoteWithItems(quote!, items);
            return Results.Ok(result);
        });

        app.Run();
    }
}
