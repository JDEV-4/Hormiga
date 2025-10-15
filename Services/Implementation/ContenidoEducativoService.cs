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
    public class ContenidoEducativoService: IContenidoEducativoService
    {
        

         private readonly string _connectionString;

        public ContenidoEducativoService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<IEnumerable<ContenidoEducativo>> ObtenerTodos()
        {
            var lista = new List<ContenidoEducativo>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "SELECT * FROM Contenido_Educativo";
                SqlCommand cmd = new SqlCommand(query, conn);
                await conn.OpenAsync();
                SqlDataReader reader = await cmd.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    lista.Add(Map(reader));
                }
            }
            return lista;
        }

        public async Task<ContenidoEducativo> ObtenerPorId(int id)
        {
            ContenidoEducativo contenido = null;
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "SELECT * FROM Contenido_Educativo WHERE contenido_id = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);
                await conn.OpenAsync();
                SqlDataReader reader = await cmd.ExecuteReaderAsync();
                if (await reader.ReadAsync())
                {
                    contenido = Map(reader);
                }
            }
            return contenido;
        }

        public async Task<IEnumerable<ContenidoEducativo>> ObtenerPorAmenaza(int amenazaId)
        {
            var lista = new List<ContenidoEducativo>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "SELECT * FROM Contenido_Educativo WHERE amenaza_id = @amenazaId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@amenazaId", amenazaId);
                await conn.OpenAsync();
                SqlDataReader reader = await cmd.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    lista.Add(Map(reader));
                }
            }
            return lista;
        }

        public async Task<int> Crear(ContenidoEducativo contenido)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"INSERT INTO Contenido_Educativo 
                                 (amenaza_id, titulo, fase, texto_seccion, orden, tipo_recurso)
                                 VALUES (@amenaza_id, @titulo, @fase, @texto_seccion, @orden, @tipo_recurso);
                                 SELECT SCOPE_IDENTITY();";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@amenaza_id", contenido.AmenazaId);
                cmd.Parameters.AddWithValue("@titulo", contenido.Titulo);
                cmd.Parameters.AddWithValue("@fase", contenido.Fase);
                cmd.Parameters.AddWithValue("@texto_seccion", (object)contenido.TextoSeccion ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@orden", (object)contenido.Orden ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@tipo_recurso", (object)contenido.TipoRecurso ?? DBNull.Value);

                await conn.OpenAsync();
                var result = await cmd.ExecuteScalarAsync();
                return Convert.ToInt32(result);
            }
        }

        public async Task<bool> Actualizar(ContenidoEducativo contenido)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"UPDATE Contenido_Educativo 
                                 SET amenaza_id = @amenaza_id,
                                     titulo = @titulo,
                                     fase = @fase,
                                     texto_seccion = @texto_seccion,
                                     orden = @orden,
                                     tipo_recurso = @tipo_recurso
                                 WHERE contenido_id = @id";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", contenido.ContenidoId);
                cmd.Parameters.AddWithValue("@amenaza_id", contenido.AmenazaId);
                cmd.Parameters.AddWithValue("@titulo", contenido.Titulo);
                cmd.Parameters.AddWithValue("@fase", contenido.Fase);
                cmd.Parameters.AddWithValue("@texto_seccion", (object)contenido.TextoSeccion ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@orden", (object)contenido.Orden ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@tipo_recurso", (object)contenido.TipoRecurso ?? DBNull.Value);

                await conn.OpenAsync();
                int rows = await cmd.ExecuteNonQueryAsync();
                return rows > 0;
            }
        }

        public async Task<bool> Eliminar(int id)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "DELETE FROM Contenido_Educativo WHERE contenido_id = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);
                await conn.OpenAsync();
                int rows = await cmd.ExecuteNonQueryAsync();
                return rows > 0;
            }
        }

        private ContenidoEducativo Map(SqlDataReader reader)
        {
            return new ContenidoEducativo
            {
                ContenidoId = (int)reader["contenido_id"],
                AmenazaId = (int)reader["amenaza_id"],
                Titulo = reader["titulo"].ToString(),
                Fase = reader["fase"].ToString(),
                TextoSeccion = reader["texto_seccion"]?.ToString(),
                Orden = reader["orden"] == DBNull.Value ? null : (int?)reader["orden"],
                TipoRecurso = reader["tipo_recurso"]?.ToString()
            };
        }
    }
}