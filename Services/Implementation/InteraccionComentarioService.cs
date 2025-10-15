using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.Extensions.Configuration;
using WebApi.Model;

namespace Implementation
{
    public class InteraccionComentarioService: IInteraccionComentarioService
    {
        

        private readonly string _connectionString;

        public InteraccionComentarioService(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("DefaultConnection")!;
        }

        // ==========================================================
        // Interacciones (Likes/Shares)
        // ==========================================================

        public async Task<InteraccionPublicacion> CrearInteraccionAsync(InteraccionPublicacion interaccion)
        {
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            // Intentamos insertar. Si la combinación ya existe (UNIQUE constraint), 
            // la DB arrojará una excepción, que el Controller debe manejar.
            var sql = @"
                INSERT INTO InteraccionPublicacion (PublicacionId, UsuarioId, TipoInteraccion)
                OUTPUT INSERTED.InteraccionId, INSERTED.FechaInteraccion
                VALUES (@pId, @uId, @tipo)";
            
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@pId", interaccion.PublicacionId);
            command.Parameters.AddWithValue("@uId", interaccion.UsuarioId);
            command.Parameters.AddWithValue("@tipo", interaccion.TipoInteraccion);

            try
            {
                using var reader = await command.ExecuteReaderAsync();
                if (await reader.ReadAsync())
                {
                    interaccion.InteraccionId = reader.GetInt32(0);
                    interaccion.FechaInteraccion = reader.GetDateTime(1);
                    return interaccion;
                }
                return null!; // No debería pasar si hay OUTPUT
            }
            catch (SqlException ex) when (ex.Number == 2627) // Error de clave única
            {
                // Devolver un objeto especial o lanzar una excepción para que el controlador sepa
                throw new InvalidOperationException("El usuario ya ha realizado esta interacción en esta publicación.");
            }
        }

        public async Task<bool> EliminarInteraccionAsync(int publicacionId, int usuarioId, string tipoInteraccion)
        {
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            var sql = @"
                DELETE FROM InteraccionPublicacion 
                WHERE PublicacionId = @pId AND UsuarioId = @uId AND TipoInteraccion = @tipo";
            
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@pId", publicacionId);
            command.Parameters.AddWithValue("@uId", usuarioId);
            command.Parameters.AddWithValue("@tipo", tipoInteraccion);

            return await command.ExecuteNonQueryAsync() > 0;
        }

        public async Task<int> ContarInteraccionesPorPublicacionAsync(int publicacionId, string tipoInteraccion)
        {
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            var sql = "SELECT COUNT(*) FROM InteraccionPublicacion WHERE PublicacionId = @pId AND TipoInteraccion = @tipo";
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@pId", publicacionId);
            command.Parameters.AddWithValue("@tipo", tipoInteraccion);

            return (int)await command.ExecuteScalarAsync();
        }

        public async Task<bool> VerificarInteraccionAsync(int publicacionId, int usuarioId, string tipoInteraccion)
        {
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            var sql = @"
                SELECT 1 FROM InteraccionPublicacion 
                WHERE PublicacionId = @pId AND UsuarioId = @uId AND TipoInteraccion = @tipo";
            
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@pId", publicacionId);
            command.Parameters.AddWithValue("@uId", usuarioId);
            command.Parameters.AddWithValue("@tipo", tipoInteraccion);

            return await command.ExecuteScalarAsync() != null;
        }

        // ==========================================================
        // Comentarios
        // ==========================================================

   public async Task<Comentario> CrearComentarioAsync(Comentario comentario)
        {
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            // CAMBIO: Usamos el procedimiento almacenado 'sp_AddComentario'
            var sql = "sp_AddComentario"; 
            
            using var command = new SqlCommand(sql, connection);
            // ESENCIAL: Indicar que el comando es un procedimiento almacenado
            command.CommandType = CommandType.StoredProcedure; 
            
            // Asignamos los parámetros usando los nombres definidos en el SP
            command.Parameters.AddWithValue("@PublicacionId", comentario.PublicacionId); 
            command.Parameters.AddWithValue("@UsuarioId", comentario.UsuarioId);         
            command.Parameters.AddWithValue("@TextoComentario", comentario.TextoComentario); 

            using var reader = await command.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                // El SP usa OUTPUT, por lo que el reader nos devuelve el nuevo ID y la fecha
                comentario.ComentarioId = reader.GetInt32(0);
                comentario.FechaComentario = reader.GetDateTime(1);
                return comentario;
            }
            return null!;
        }


        public async Task<IEnumerable<Comentario>> ObtenerComentariosPorPublicacionAsync(int publicacionId)
        {
            var comentarios = new List<Comentario>();
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            // Unimos con Usuario para obtener el nombre del autor
            var sql = @"
                SELECT 
                    c.ComentarioId, c.PublicacionId, c.UsuarioId, c.TextoComentario, c.FechaComentario, 
                    u.NombreCompleto 
                FROM Comentario c
                INNER JOIN Usuario u ON c.UsuarioId = u.Usuario_Id
                WHERE c.PublicacionId = @pId
                ORDER BY c.FechaComentario ASC"; 

            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@pId", publicacionId);
            
            using var rdr = await command.ExecuteReaderAsync();
            while (await rdr.ReadAsync())
            {
                comentarios.Add(new Comentario
                {
                    ComentarioId = rdr.GetInt32(0),
                    PublicacionId = rdr.GetInt32(1),
                    UsuarioId = rdr.GetInt32(2),
                    TextoComentario = rdr.GetString(3),
                    FechaComentario = rdr.GetDateTime(4),
                    NombreUsuario = rdr.GetString(5) // Nombre del usuario
                });
            }
            return comentarios;
        }

        public async Task<bool> EliminarComentarioAsync(int comentarioId, int usuarioId)
        {
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            // Eliminación solo si el usuario logueado es el autor del comentario.
            var sql = "DELETE FROM Comentario WHERE ComentarioId = @cId AND UsuarioId = @uId";
            
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@cId", comentarioId);
            command.Parameters.AddWithValue("@uId", usuarioId);

            return await command.ExecuteNonQueryAsync() > 0;
        }
    }
}