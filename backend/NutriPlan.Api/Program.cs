// API mínima de NutriPlan.
// Expone el mismo cálculo que la app (Mifflin-St Jeor) para demostrar
// la comunicación entre Flutter y un backend que corre en Docker.

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Factores de actividad (los mismos que usa la app en models/perfil.dart).
var factores = new Dictionary<string, double>
{
    ["sedentario"] = 1.2,
    ["ligero"] = 1.375,
    ["moderado"] = 1.55,
    ["intenso"] = 1.725,
};

// GET /api/salud → sirve para comprobar que el servidor está vivo.
app.MapGet("/api/salud", () => Results.Ok(new
{
    estado = "ok",
    servidor = "NutriPlan.Api en Docker",
    horaUtc = DateTime.UtcNow,
}));

// POST /api/energia → recibe los datos del perfil y devuelve GER y GET.
app.MapPost("/api/energia", (SolicitudEnergia s) =>
{
    // Validación en el servidor: nunca confiar solo en la validación de la app.
    if (s.Edad < 18 || s.Edad > 100)
        return Results.BadRequest(new { error = "La edad debe estar entre 18 y 100." });
    if (s.PesoKg < 30 || s.PesoKg > 300)
        return Results.BadRequest(new { error = "El peso debe estar entre 30 y 300 kg." });
    if (s.EstaturaCm < 120 || s.EstaturaCm > 230)
        return Results.BadRequest(new { error = "La estatura debe estar entre 120 y 230 cm." });
    if (s.Sexo != "masculino" && s.Sexo != "femenino")
        return Results.BadRequest(new { error = "Sexo no válido." });
    if (!factores.TryGetValue(s.Actividad, out var factor))
        return Results.BadRequest(new { error = "Nivel de actividad no válido." });

    // Mifflin-St Jeor.
    var baseCalculo = 10 * s.PesoKg + 6.25 * s.EstaturaCm - 5 * s.Edad;
    var ger = s.Sexo == "masculino" ? baseCalculo + 5 : baseCalculo - 161;

    // AwayFromZero: 1617,5 → 1618 (igual que round() en Dart).
    // Sin este parámetro, C# usa "redondeo bancario" y podría dar otro valor.
    var gastoReposo = (int)Math.Round(ger, MidpointRounding.AwayFromZero);
    var gastoTotal = (int)Math.Round(ger * factor, MidpointRounding.AwayFromZero);

    return Results.Ok(new RespuestaEnergia(gastoReposo, gastoTotal, factor, "Mifflin-St Jeor"));
});

app.Run();

// Datos que envía la app (el JSON usa camelCase: edad, pesoKg, ...).
record SolicitudEnergia(int Edad, double PesoKg, double EstaturaCm, string Sexo, string Actividad);

// Datos que devuelve la API.
record RespuestaEnergia(int GastoReposo, int GastoTotal, double FactorActividad, string Formula);