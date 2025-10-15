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
    public class QuizService: IQuizService
    {
        

          private readonly string _connectionString;
        public QuizService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<IEnumerable<Quiz>> ObtenerTodos()
        {
            var lista = new List<Quiz>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "SELECT * FROM Quizzes";
                SqlCommand cmd = new SqlCommand(query, conn);
                await conn.OpenAsync();
                var reader = await cmd.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    lista.Add(Map(reader));
                }
            }
            return lista;
        }

        public async Task<Quiz> ObtenerPorId(int id)
        {
            Quiz quiz = null;
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "SELECT * FROM Quizzes WHERE quiz_id=@id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);
                await conn.OpenAsync();
                var reader = await cmd.ExecuteReaderAsync();
                if (await reader.ReadAsync())
                {
                    quiz = Map(reader);
                }
            }
            return quiz;
        }

        public async Task<IEnumerable<Quiz>> ObtenerPorAmenaza(int amenazaId)
        {
            var lista = new List<Quiz>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "SELECT * FROM Quizzes WHERE amenaza_id=@amenazaId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@amenazaId", amenazaId);
                await conn.OpenAsync();
                var reader = await cmd.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    lista.Add(Map(reader));
                }
            }
            return lista;
        }

        public async Task<int> Crear(Quiz quiz)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"INSERT INTO Quizzes (amenaza_id, titulo, descripcion)
                                 VALUES (@amenaza_id, @titulo, @descripcion);
                                 SELECT SCOPE_IDENTITY();";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@amenaza_id", quiz.AmenazaId);
                cmd.Parameters.AddWithValue("@titulo", quiz.Titulo);
                cmd.Parameters.AddWithValue("@descripcion", (object)quiz.Descripcion ?? DBNull.Value);
                await conn.OpenAsync();
                var result = await cmd.ExecuteScalarAsync();
                return Convert.ToInt32(result);
            }
        }

        public async Task<bool> Actualizar(Quiz quiz)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"UPDATE Quizzes SET 
                                 amenaza_id=@amenaza_id, 
                                 titulo=@titulo, 
                                 descripcion=@descripcion 
                                 WHERE quiz_id=@id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", quiz.QuizId);
                cmd.Parameters.AddWithValue("@amenaza_id", quiz.AmenazaId);
                cmd.Parameters.AddWithValue("@titulo", quiz.Titulo);
                cmd.Parameters.AddWithValue("@descripcion", (object)quiz.Descripcion ?? DBNull.Value);
                await conn.OpenAsync();
                int rows = await cmd.ExecuteNonQueryAsync();
                return rows > 0;
            }
        }

        public async Task<bool> Eliminar(int id)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "DELETE FROM Quizzes WHERE quiz_id=@id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);
                await conn.OpenAsync();
                int rows = await cmd.ExecuteNonQueryAsync();
                return rows > 0;
            }
        }

        private Quiz Map(SqlDataReader reader)
        {
            return new Quiz
            {
                QuizId = (int)reader["quiz_id"],
                AmenazaId = (int)reader["amenaza_id"],
                Titulo = reader["titulo"].ToString(),
                Descripcion = reader["descripcion"]?.ToString()
            };
        }
    }
}