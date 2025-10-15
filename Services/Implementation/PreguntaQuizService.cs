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
    public class PreguntaQuizService: IPreguntaQuizService
    {
         private readonly string _connectionString;

        public PreguntaQuizService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<int> Crear(PreguntaQuiz pregunta)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                INSERT INTO Preguntas_Quiz (quiz_id, texto_pregunta, puntos)
                VALUES (@quiz_id, @texto_pregunta, @puntos);
                SELECT SCOPE_IDENTITY();";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@quiz_id", pregunta.QuizId);
            cmd.Parameters.AddWithValue("@texto_pregunta", pregunta.TextoPregunta);
            cmd.Parameters.AddWithValue("@puntos", pregunta.Puntos);

            await conn.OpenAsync();
            var res = await cmd.ExecuteScalarAsync();
            return Convert.ToInt32(res);
        }

        public async Task<bool> Actualizar(PreguntaQuiz pregunta)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                UPDATE Preguntas_Quiz
                SET quiz_id = @quiz_id,
                    texto_pregunta = @texto_pregunta,
                    puntos = @puntos
                WHERE pregunta_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", pregunta.PreguntaId);
            cmd.Parameters.AddWithValue("@quiz_id", pregunta.QuizId);
            cmd.Parameters.AddWithValue("@texto_pregunta", pregunta.TextoPregunta);
            cmd.Parameters.AddWithValue("@puntos", pregunta.Puntos);

            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }

        public async Task<bool> Eliminar(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "DELETE FROM Preguntas_Quiz WHERE pregunta_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }

        public async Task<PreguntaQuiz> ObtenerPorId(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Preguntas_Quiz WHERE pregunta_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                return Map(reader);
            }
            return null;
        }

        public async Task<IEnumerable<PreguntaQuiz>> ObtenerPorQuiz(int quizId)
        {
            var lista = new List<PreguntaQuiz>();
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Preguntas_Quiz WHERE quiz_id = @quizId ORDER BY pregunta_id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@quizId", quizId);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(Map(reader));
            }
            return lista;
        }

        private PreguntaQuiz Map(SqlDataReader reader)
        {
            return new PreguntaQuiz
            {
                PreguntaId = (int)reader["pregunta_id"],
                QuizId = (int)reader["quiz_id"],
                TextoPregunta = reader["texto_pregunta"]?.ToString(),
                Puntos = reader["puntos"] == DBNull.Value ? 1 : Convert.ToInt32(reader["puntos"])
            };
        }
    }
}