namespace backendquickquote.Models
{

    record Product(
    int Id,
    string Name,
    decimal Price,
    int Stock,
    string? Category
);

    record Quote(
        int Id,
        int Items,
        decimal Total,
        string Status,
        DateTime CreatedAt,
        DateTime UpdatedAt
    );

    record QuoteItem(
        int Id,
        int QuoteId,
        int ProductId,
        int Quantity,
        decimal UnitPrice
    );

    // Para devolver quote con items y productos
    record QuoteItemDetail(
        int Id,
        int QuoteId,
        int ProductId,
        string ProductName,
        int Quantity,
        decimal UnitPrice,
        decimal LineTotal
    );

    record QuoteWithItems(
        Quote Quote,
        List<QuoteItemDetail> Items
    );
    public record Project(
    int Id,
    string Name
    );

    public record QuotePriorityDto(
        int Id,
        int Items,
        decimal Total,
        string Status,
        DateTime CreatedAt,
        DateTime UpdatedAt,
        int? ProjectId,
        string? ProjectName,
        string CustomerImpact,
        DateTime ExpiresAt,
        int ImpactScore,
        double HoursLeft
    );

    public record QuoteProjectGroup(
        int? ProjectId,
        string ProjectName,
        List<QuotePriorityDto> Quotes
    );

}
