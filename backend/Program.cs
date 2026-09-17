using Npgsql;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddCors(options => {
    options.AddDefaultPolicy(p => p.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});
var app = builder.Build();
app.UseCors();

var connStr = builder.Configuration.GetConnectionString("DefaultConnection") 
              ?? "Host=postgres-db;Port=5432;Database=appdb;Username=postgres;Password=securepassword123";

// Table ensure karo
try {
    using var conn = new NpgsqlConnection(connStr);
    conn.Open();
    using var cmd = new NpgsqlCommand(@"
        CREATE TABLE IF NOT EXISTS products (
            id SERIAL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            price NUMERIC(10,2) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    ", conn);
    cmd.ExecuteNonQuery();
} catch (Exception ex) {
    Console.WriteLine($"DB Init Warning: {ex.Message}");
}

// Health endpoint
app.MapGet("/health", async () => {
    try {
        await using var conn = new NpgsqlConnection(connStr);
        await conn.OpenAsync();
        return Results.Ok(new { status = "Healthy", database = "Connected" });
    } catch (Exception ex) {
        return Results.Problem(detail: ex.Message, statusCode: 503);
    }
});

// GET products (dono path support karega)
var getProducts = async () => {
    var list = new List<object>();
    await using var conn = new NpgsqlConnection(connStr);
    await conn.OpenAsync();
    await using var cmd = new NpgsqlCommand("SELECT id, name, price, to_char(created_at, 'YYYY-MM-DD HH24:MI') FROM products ORDER BY id DESC LIMIT 10", conn);
    await using var reader = await cmd.ExecuteReaderAsync();
    while (await reader.ReadAsync()) {
        list.Add(new {
            id = reader.GetInt32(0),
            name = reader.GetString(1),
            price = reader.GetDecimal(2),
            createdAt = reader.GetString(3)
        });
    }
    return Results.Ok(list);
};
app.MapGet("/products", getProducts);
app.MapGet("/api/products", getProducts);

// POST product (dono path support karega)
var addProduct = async (ProductInput input) => {
    if (string.IsNullOrWhiteSpace(input.Name) || input.Price <= 0) {
        return Results.BadRequest(new { error = "Invalid input" });
    }
    await using var conn = new NpgsqlConnection(connStr);
    await conn.OpenAsync();
    await using var cmd = new NpgsqlCommand("INSERT INTO products (name, price) VALUES (@n, @p) RETURNING id", conn);
    cmd.Parameters.AddWithValue("n", input.Name);
    cmd.Parameters.AddWithValue("p", input.Price);
    var newId = await cmd.ExecuteScalarAsync();
    return Results.Ok(new { id = newId, message = "Saved" });
};
app.MapPost("/products", addProduct);
app.MapPost("/api/products", addProduct);

app.Run();

record ProductInput(string Name, decimal Price);
