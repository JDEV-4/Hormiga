using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.Extensions.Configuration;
using WebApi.Model;
using WebApi.Model.DTO;

namespace Implementation
{
    public class AmenazaEducativaService: IAmenazaEducativaService
    {



         private readonly string _connectionString;

        public AmenazaEducativaService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection")!;
        }

        public async Task<IEnumerable<AmenazaEducativa>> ListarAmenazasAsync()
        {
            var lista = new List<AmenazaEducativa>();
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand("sp_ListarAmenazasEducativas", connection)
            { CommandType = CommandType.StoredProcedure };
            await connection.OpenAsync();

            using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new AmenazaEducativa
                {
                    AmenazaId = (int)reader["amenaza_id"],
                    Nombre = reader["nombre"].ToString(),
                    DescripcionCorta = reader["descripcion_corta"]?.ToString(),
                    IconoUrl = reader["icono_url"]?.ToString()
                });
            }
            return lista;
        }

        public async Task<AmenazaEducativa> ObtenerAmenazaPorIdAsync(int id)
        {
            AmenazaEducativa amenaza = null;
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand("sp_GetAmenazaEducativa", connection)
            { CommandType = CommandType.StoredProcedure };
            command.Parameters.AddWithValue("@amenaza_id", id);
            await connection.OpenAsync();

            using var reader = await command.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                amenaza = new AmenazaEducativa
                {
                    AmenazaId = (int)reader["amenaza_id"],
                    Nombre = reader["nombre"].ToString(),
                    DescripcionCorta = reader["descripcion_corta"]?.ToString(),
                    IconoUrl = reader["icono_url"]?.ToString()
                };
            }
            return amenaza;
        }

        public async Task<AmenazaEducativa> CrearAmenazaAsync(AmenazaEducativaDTO dto)
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand("sp_AddAmenazaEducativa", connection)
            { CommandType = CommandType.StoredProcedure };
            command.Parameters.AddWithValue("@nombre", dto.Nombre);
            command.Parameters.AddWithValue("@descripcion_corta", (object?)dto.DescripcionCorta ?? DBNull.Value);
            command.Parameters.AddWithValue("@icono_url", (object?)dto.IconoUrl ?? DBNull.Value);
            await connection.OpenAsync();
            int id = Convert.ToInt32(await command.ExecuteScalarAsync());
            return new AmenazaEducativa
            {
                AmenazaId = id,
                Nombre = dto.Nombre,
                DescripcionCorta = dto.DescripcionCorta,
                IconoUrl = dto.IconoUrl
            };
        }

        public async Task<bool> ActualizarAmenazaAsync(int id, AmenazaEducativaDTO dto)
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand("sp_UpdateAmenazaEducativa", connection)
            { CommandType = CommandType.StoredProcedure };
            command.Parameters.AddWithValue("@amenaza_id", id);
            command.Parameters.AddWithValue("@nombre", dto.Nombre);
            command.Parameters.AddWithValue("@descripcion_corta", (object?)dto.DescripcionCorta ?? DBNull.Value);
            command.Parameters.AddWithValue("@icono_url", (object?)dto.IconoUrl ?? DBNull.Value);
            await connection.OpenAsync();
            return (await command.ExecuteNonQueryAsync()) > 0;
        }

        public async Task<bool> EliminarAmenazaAsync(int id)
        {
            using var connection = new SqlConnection(_connectionString);
            using var command = new SqlCommand("sp_DeleteAmenazaEducativa", connection)
            { CommandType = CommandType.StoredProcedure };
            command.Parameters.AddWithValue("@amenaza_id", id);
            await connection.OpenAsync();
            return (await command.ExecuteNonQueryAsync()) > 0;
        }
    }
        
    }
