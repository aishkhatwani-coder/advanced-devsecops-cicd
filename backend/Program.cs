using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Npgsql;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddHealthChecks();
builder.Services.AddEndpointsApiExplorer();

var app = builder.Build();

var dbConnectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING") 
    ?? "Host=localhost;Database=appdb;Username=postgres;Password=postgres";

app.MapGet("/", () => new { Status = "Online", Environment = Environment.GetEnvironmentVariable("APP_COLOR") ?? "Blue", Version = "1.0.0" });

app.MapGet("/health", async () => {
    try {
        await using var conn = new NpgsqlConnection(dbConnectionString);
        await conn.OpenAsync();
        return Results.Ok(new { status = "Healthy", database = "Connected" });
    } catch (Exception ex) {
        return Results.Problem(detail: ex.Message, statusCode: 503);
    }
});

app.Run();
