using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

using Microsoft.Extensions.Configuration;
using WebApi.Model;
using Interface;

using System.Threading.Tasks;
using WebApi.Model.DTO;
namespace Implementation
{
    public class ComunicacionService: IComunicacionService
    {
        private readonly string _connectionString;

        public ComunicacionService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }


   public async Task<FuenteOficial> CrearFuenteAsync(FuenteOficialCrearDTO dto)
        {
            using var connection = new SqlConnection(_connectionString); // USANDO _connectionString
            await connection.OpenAsync();
            SqlCommand command = new SqlCommand("sp_AddFuenteOficial", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@Nombre", dto.Nombre);
            command.Parameters.AddWithValue("@LogoUrl", string.IsNullOrEmpty(dto.LogoUrl) ? (object)DBNull.Value : dto.LogoUrl); 

            var newId = Convert.ToInt32(await command.ExecuteScalarAsync());

            return new FuenteOficial { FuenteOficialId = newId, Nombre = dto.Nombre, LogoUrl = dto.LogoUrl, Estado = true };
        }

        public async Task<IEnumerable<FuenteOficial>> ListarFuentesActivasAsync()
        {
            var fuentes = new List<FuenteOficial>();
            using var connection = new SqlConnection(_connectionString); // USANDO _connectionString
            await connection.OpenAsync();
            SqlCommand command = new SqlCommand("sp_ListarFuentesActivas", connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            using (var reader = await command.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                {
                    fuentes.Add(new FuenteOficial
                    {
                        FuenteOficialId = (int)reader["FuenteOficialId"],
                        Nombre = reader["Nombre"].ToString()!,
                        LogoUrl = reader.IsDBNull(reader.GetOrdinal("LogoUrl")) ? null : reader["LogoUrl"].ToString(),
                        Estado = (bool)reader["Estado"]
                    });
                }
            }
            return fuentes;
        }

        public async Task<FuenteOficial> MostrarFuenteAsync(int fuenteOficialId)
        {
            FuenteOficial fuente = null;
            using var connection = new SqlConnection(_connectionString); // USANDO _connectionString
            await connection.OpenAsync();
            SqlCommand command = new SqlCommand("sp_MostrarFuenteOficial", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@FuenteOficialId", fuenteOficialId);

            using (var reader = await command.ExecuteReaderAsync())
            {
                if (await reader.ReadAsync())
                {
                    fuente = new FuenteOficial
                    {
                        FuenteOficialId = (int)reader["FuenteOficialId"],
                        Nombre = reader["Nombre"].ToString()!,
                        LogoUrl = reader.IsDBNull(reader.GetOrdinal("LogoUrl")) ? null : reader["LogoUrl"].ToString(),
                        Estado = (bool)reader["Estado"]
                    };
                }
            }
            return fuente;
        }

        public async Task<bool> ActualizarFuenteAsync(FuenteOficial fuente)
        {
            using var connection = new SqlConnection(_connectionString); // USANDO _connectionString
            await connection.OpenAsync();
            SqlCommand command = new SqlCommand("sp_UpdateFuenteOficial", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@FuenteOficialId", fuente.FuenteOficialId);
            command.Parameters.AddWithValue("@Nombre", fuente.Nombre);
            command.Parameters.AddWithValue("@LogoUrl", string.IsNullOrEmpty(fuente.LogoUrl) ? (object)DBNull.Value : fuente.LogoUrl);
            command.Parameters.AddWithValue("@Estado", fuente.Estado);
            
            return (await command.ExecuteNonQueryAsync()) > 0;
        }

        public async Task<bool> EliminarFuenteAsync(int fuenteOficialId)
        {
            using var connection = new SqlConnection(_connectionString); // USANDO _connectionString
            await connection.OpenAsync();
            SqlCommand command = new SqlCommand("sp_EliminarFuenteOficial", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@FuenteOficialId", fuenteOficialId);

            return (await command.ExecuteNonQueryAsync()) > 0;
        }
        
        // ... (Implementaciones de Interacciones y Comentarios - usa _connectionString aquí también)
    }
}