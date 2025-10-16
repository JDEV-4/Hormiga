using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.Extensions.Configuration;
using static WebApi.Model.Incidentes;

namespace Implementation
{
    public class FotoIncidenteService : IFotoIncidenteService
    {
        


        private readonly string _connectionString;
        public FotoIncidenteService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<int> AgregarFotoAsync(FotoIncidente foto)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                INSERT INTO Fotos_Incidente (incidente_id, url_foto, fecha_subida)
                VALUES (@incidente_id, @url_foto, GETDATE());
                SELECT SCOPE_IDENTITY();";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@incidente_id", foto.IncidenteId);
            cmd.Parameters.AddWithValue("@url_foto", foto.UrlFoto);
            await conn.OpenAsync();
            var res = await cmd.ExecuteScalarAsync();
            return Convert.ToInt32(res);
        }

        public async Task<IEnumerable<FotoIncidente>> ObtenerPorIncidenteAsync(int incidenteId)
        {
            var lista = new List<FotoIncidente>();
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Fotos_Incidente WHERE incidente_id = @incidenteId ORDER BY fecha_subida";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@incidenteId", incidenteId);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new FotoIncidente
                {
                    FotoId = (int)reader["foto_id"],
                    IncidenteId = (int)reader["incidente_id"],
                    UrlFoto = reader["url_foto"].ToString(),
                    FechaSubida = Convert.ToDateTime(reader["fecha_subida"])
                });
            }
            return lista;
        }

        public async Task<bool> EliminarAsync(int fotoId)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "DELETE FROM Fotos_Incidente WHERE foto_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", fotoId);
            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }
    }
}