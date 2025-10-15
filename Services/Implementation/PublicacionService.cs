using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Threading.Tasks;

using Microsoft.Extensions.Configuration;
using WebApi.Model;
using Interface;
using System.Data;
using WebApi.Model.DTO;
namespace Implementation
{
    public class PublicacionService : IPublicacionService
    {
        private readonly string _connectionString;

        public PublicacionService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection")!;
        }

         public async Task<Publicacion> CrearPublicacionAsync(Publicacion publicacion) 
        {
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            SqlCommand command = new SqlCommand("sp_AddPublicacion", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            
            // 1. Manejo de NULLs para las claves foráneas (Si no tienen valor, se envía DBNull)
            command.Parameters.AddWithValue("@FuenteOficialId", publicacion.FuenteOficialId ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("@UsuarioId", publicacion.UsuarioId ?? (object)DBNull.Value); 
            
            // 2. Otros parámetros
            command.Parameters.AddWithValue("@TipoPublicacionId", publicacion.TipoPublicacionId);
            command.Parameters.AddWithValue("@Titulo", publicacion.Titulo);
            command.Parameters.AddWithValue("@Cuerpo", publicacion.Cuerpo);
            command.Parameters.AddWithValue("@ImagenUrl", string.IsNullOrEmpty(publicacion.ImagenUrl) ? (object)DBNull.Value : publicacion.ImagenUrl); 

            // 3. Ejecutar y obtener el ID
            var newId = Convert.ToInt32(await command.ExecuteScalarAsync());

            // 4. Actualizar y retornar
            publicacion.PublicacionId = newId;
            publicacion.FechaPublicacion = DateTime.Now; 
            publicacion.Estado = true;
            
            return publicacion;
        }
        
        // 3.2 READ By ID
        public async Task<Publicacion> GetPublicacionByIdAsync(int publicacionId)
        {
            Publicacion publicacion = null;
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            SqlCommand command = new SqlCommand("sp_MostrarPublicacion", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@PublicacionId", publicacionId);

            using (var reader = await command.ExecuteReaderAsync())
            {
                if (await reader.ReadAsync())
                {
                    publicacion = new Publicacion
                    {
                        PublicacionId = (int)reader["PublicacionId"],
                        Titulo = reader["Titulo"].ToString()!,
                        Cuerpo = reader["Cuerpo"].ToString()!,
                        // Manejo de NULLs para IDs y URL
                        FuenteOficialId = reader.IsDBNull(reader.GetOrdinal("FuenteOficialId")) ? null : (int?)reader["FuenteOficialId"],
                        UsuarioId = reader.IsDBNull(reader.GetOrdinal("UsuarioId")) ? null : (int?)reader["UsuarioId"],
                        ImagenUrl = reader.IsDBNull(reader.GetOrdinal("ImagenUrl")) ? null : reader["ImagenUrl"].ToString(),
                        FechaPublicacion = (DateTime)reader["FechaPublicacion"],
                        TipoPublicacionId = (int)reader["TipoPublicacionId"],
                        Estado = (bool)reader["Estado"]
                    };
                }
            }
            return publicacion;
        }

        // 3.3 UPDATE
        public async Task<bool> ActualizarPublicacionAsync(Publicacion publicacion)
        {
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            SqlCommand command = new SqlCommand("sp_UpdatePublicacion", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@PublicacionId", publicacion.PublicacionId);
            command.Parameters.AddWithValue("@FuenteOficialId", publicacion.FuenteOficialId ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("@UsuarioId", publicacion.UsuarioId ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("@TipoPublicacionId", publicacion.TipoPublicacionId);
            command.Parameters.AddWithValue("@Titulo", publicacion.Titulo);
            command.Parameters.AddWithValue("@Cuerpo", publicacion.Cuerpo);
            command.Parameters.AddWithValue("@ImagenUrl", string.IsNullOrEmpty(publicacion.ImagenUrl) ? (object)DBNull.Value : publicacion.ImagenUrl);
            command.Parameters.AddWithValue("@Estado", publicacion.Estado);
            
            return (await command.ExecuteNonQueryAsync()) > 0;
        }

        // 3.4 DELETE (Lógico)
        public async Task<bool> EliminarPublicacionAsync(int publicacionId)
        {
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            SqlCommand command = new SqlCommand("sp_EliminarPublicacion", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@PublicacionId", publicacionId);

            return (await command.ExecuteNonQueryAsync()) > 0;
        }

        public Task<IEnumerable<PublicacionFeedDTO>> GetFeedAsync(int pagina, int tamañoPagina)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Publicacion>> ListarPublicacionesActivasAsync()
        {
            throw new NotImplementedException();
        }
    }
}