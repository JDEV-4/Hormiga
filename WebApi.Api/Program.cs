using WebApi.Api;
using WebApi.Model;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.OpenApi.Models;

using Interface;
using Implementation;



var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

builder.Services.AddScoped<IUsuarioService, UsuarioService>();
builder.Services.AddScoped<IRolService, RolService>();

builder.Services.AddScoped<IComunicacionService, ComunicacionService>();
builder.Services.AddScoped<IInteraccionComentarioService, InteraccionComentarioService>();
builder.Services.AddScoped<IAmenazaEducativaService, AmenazaEducativaService>();
builder.Services.AddScoped<IContenidoEducativoService, ContenidoEducativoService>();

builder.Services.AddScoped<IPublicacionService, PublicacionService>();
builder.Services.AddScoped<IUsuarioService, UsuarioService>();
builder.Services.AddScoped<IResultadoUsuarioQuizService, ResultadoUsuarioQuizService>();

builder.Services.AddScoped<IQuizService, QuizService>();
builder.Services.AddScoped<IPreguntaQuizService, PreguntaQuizService>();
builder.Services.AddScoped<IOpcionPreguntaService, OpcionPreguntaService>();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(builder.Configuration["Jwt:Key"])),
            ValidateIssuer = false,
            ValidateAudience = false
        };
    });

builder.Services.AddAuthorization();
builder.Services.AddControllers();
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins("http://localhost") // Cambia si usas otro host o puerto
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials();
    });
     options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Sistema_cellshopcenter", Version = "v1" });
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

var app = builder.Build();
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
// 👇 Usar CORS (DEBE ir antes de UseAuthorization y UseRouting si los usas)
//app.UseCors("AllowAll"); // o "AllowFlutterApp" si prefieres ser más restrictivo

app.UseCors(policy => policy
    .AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader()
);

app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.UseCors("AllowFrontend");
app.MapControllers();
app.UseSwagger();
app.UseSwaggerUI();
app.Run();