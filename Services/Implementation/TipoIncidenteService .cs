using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.Extensions.Configuration;
using WebApi.Model;

namespace Implementation
{
    public class TipoIncidenteService : ITipoIncidenteService
    {
         private readonly string _connectionString;
        public TipoIncidenteService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<int> CrearAsync(TipoIncidente tipo)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                INSERT INTO Tipos_Incidente (nombre, icono_mapa, color_hex)
                VALUES (@nombre, @icono_mapa, @color_hex);
                SELECT SCOPE_IDENTITY();";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@nombre", tipo.Nombre);
            cmd.Parameters.AddWithValue("@icono_mapa", (object)tipo.IconoMapa ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@color_hex", (object)tipo.ColorHex ?? DBNull.Value);
            await conn.OpenAsync();
            var res = await cmd.ExecuteScalarAsync();
            return Convert.ToInt32(res);
        }

        public async Task<bool> ActualizarAsync(TipoIncidente tipo)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                UPDATE Tipos_Incidente
                SET nombre = @nombre, icono_mapa = @icono_mapa, color_hex = @color_hex
                WHERE tipo_incidente_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", tipo.TipoIncidenteId);
            cmd.Parameters.AddWithValue("@nombre", tipo.Nombre);
            cmd.Parameters.AddWithValue("@icono_mapa", (object)tipo.IconoMapa ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@color_hex", (object)tipo.ColorHex ?? DBNull.Value);
            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }

        public async Task<bool> EliminarAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "DELETE FROM Tipos_Incidente WHERE tipo_incidente_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }

        public async Task<IEnumerable<TipoIncidente>> ObtenerTodosAsync()
        {
            var lista = new List<TipoIncidente>();
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Tipos_Incidente ORDER BY nombre";
            using var cmd = new SqlCommand(sql, conn);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new TipoIncidente
                {
                    TipoIncidenteId = (int)reader["tipo_incidente_id"],
                    Nombre = reader["nombre"].ToString(),
                    IconoMapa = reader["icono_mapa"]?.ToString(),
                    ColorHex = reader["color_hex"]?.ToString()
                });
            }
            return lista;
        }

        public async Task<TipoIncidente> ObtenerPorIdAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Tipos_Incidente WHERE tipo_incidente_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                return new TipoIncidente
                {
                    TipoIncidenteId = (int)reader["tipo_incidente_id"],
                    Nombre = reader["nombre"].ToString(),
                    IconoMapa = reader["icono_mapa"]?.ToString(),
                    ColorHex = reader["color_hex"]?.ToString()
                };
            }
            return null;
        }
    }
}