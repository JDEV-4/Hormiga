using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.Extensions.Configuration;
using WebApi.Model;
using WebApi.Model.DTO;

namespace Implementation
{
    public class ResultadoUsuarioQuizService: IResultadoUsuarioQuizService
    {
                private readonly string _connectionString;

        public ResultadoUsuarioQuizService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        
        public async Task<ResultadoUsuarioQuiz> EvaluarQuizAsync(EvaluarQuizDto dto)
        {
            int puntajeTotal = 0;

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                await conn.OpenAsync();

                foreach (var respuesta in dto.Respuestas)
                {
                    using (SqlCommand cmd = new SqlCommand(@"
                        SELECT es_correcta 
                        FROM Opciones_Pregunta 
                        WHERE opcion_id = @OpcionId AND pregunta_id = @PreguntaId", conn))
                    {
                        cmd.Parameters.AddWithValue("@OpcionId", respuesta.OpcionId);
                        cmd.Parameters.AddWithValue("@PreguntaId", respuesta.PreguntaId);

                        var esCorrecta = (bool?)await cmd.ExecuteScalarAsync();

                        if (esCorrecta == true)
                        {
                            using (SqlCommand puntosCmd = new SqlCommand(@"
                                SELECT puntos 
                                FROM Preguntas_Quiz 
                                WHERE pregunta_id = @PreguntaId", conn))
                            {
                                puntosCmd.Parameters.AddWithValue("@PreguntaId", respuesta.PreguntaId);
                                var puntos = (int?)await puntosCmd.ExecuteScalarAsync() ?? 0;
                                puntajeTotal += puntos;
                            }
                        }
                    }
                }

                // Guardar el resultado
                using (SqlCommand insertCmd = new SqlCommand(@"
                    INSERT INTO Resultados_Usuario_Quiz (usuario_id, quiz_id, puntaje_obtenido, fecha_realizacion)
                    OUTPUT INSERTED.resultado_id, INSERTED.usuario_id, INSERTED.quiz_id, INSERTED.puntaje_obtenido, INSERTED.fecha_realizacion
                    VALUES (@UsuarioId, @QuizId, @Puntaje, GETDATE())", conn))
                {
                    insertCmd.Parameters.AddWithValue("@UsuarioId", dto.UsuarioId);
                    insertCmd.Parameters.AddWithValue("@QuizId", dto.QuizId);
                    insertCmd.Parameters.AddWithValue("@Puntaje", puntajeTotal);

                    using (var reader = await insertCmd.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            return new ResultadoUsuarioQuiz
                            {
                                ResultadoId = reader.GetInt32(0),
                                UsuarioId = reader.GetInt32(1),
                                QuizId = reader.GetInt32(2),
                                PuntajeObtenido = reader.GetInt32(3),
                                FechaRealizacion = reader.GetDateTime(4)
                            };
                        }
                    }
                }
            }

            return null;
        }

        public async Task<int> Crear(ResultadoUsuarioQuiz resultado)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                INSERT INTO Resultados_Usuario_Quiz (usuario_id, quiz_id, puntaje_obtenido, fecha_realizacion)
                VALUES (@usuario_id, @quiz_id, @puntaje_obtenido, @fecha_realizacion);
                SELECT SCOPE_IDENTITY();";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@usuario_id", resultado.UsuarioId);
            cmd.Parameters.AddWithValue("@quiz_id", resultado.QuizId);
            cmd.Parameters.AddWithValue("@puntaje_obtenido", resultado.PuntajeObtenido);
            cmd.Parameters.AddWithValue("@fecha_realizacion", resultado.FechaRealizacion);

            await conn.OpenAsync();
            var res = await cmd.ExecuteScalarAsync();
            return Convert.ToInt32(res);
        }

        public async Task<bool> Actualizar(ResultadoUsuarioQuiz resultado)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                UPDATE Resultados_Usuario_Quiz
                SET usuario_id = @usuario_id,
                    quiz_id = @quiz_id,
                    puntaje_obtenido = @puntaje_obtenido,
                    fecha_realizacion = @fecha_realizacion
                WHERE resultado_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", resultado.ResultadoId);
            cmd.Parameters.AddWithValue("@usuario_id", resultado.UsuarioId);
            cmd.Parameters.AddWithValue("@quiz_id", resultado.QuizId);
            cmd.Parameters.AddWithValue("@puntaje_obtenido", resultado.PuntajeObtenido);
            cmd.Parameters.AddWithValue("@fecha_realizacion", resultado.FechaRealizacion);

            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }

        public async Task<bool> Eliminar(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "DELETE FROM Resultados_Usuario_Quiz WHERE resultado_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }

        public async Task<ResultadoUsuarioQuiz> ObtenerPorId(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Resultados_Usuario_Quiz WHERE resultado_id = @id";
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

        public async Task<IEnumerable<ResultadoUsuarioQuiz>> ObtenerPorUsuario(int usuarioId)
        {
            var lista = new List<ResultadoUsuarioQuiz>();
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Resultados_Usuario_Quiz WHERE usuario_id = @usuarioId ORDER BY fecha_realizacion DESC";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@usuarioId", usuarioId);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(Map(reader));
            }
            return lista;
        }

        public async Task<IEnumerable<ResultadoUsuarioQuiz>> ObtenerPorQuiz(int quizId)
        {
            var lista = new List<ResultadoUsuarioQuiz>();
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Resultados_Usuario_Quiz WHERE quiz_id = @quizId";
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

        public async Task<IEnumerable<ResultadoUsuarioQuiz>> ObtenerTodos()
        {
            var lista = new List<ResultadoUsuarioQuiz>();
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Resultados_Usuario_Quiz ORDER BY fecha_realizacion DESC";
            using var cmd = new SqlCommand(sql, conn);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(Map(reader));
            }
            return lista;
        }

        private ResultadoUsuarioQuiz Map(SqlDataReader reader)
        {
            return new ResultadoUsuarioQuiz
            {
                ResultadoId = (int)reader["resultado_id"],
                UsuarioId = (int)reader["usuario_id"],
                QuizId = (int)reader["quiz_id"],
                PuntajeObtenido = reader["puntaje_obtenido"] == DBNull.Value ? 0 : Convert.ToInt32(reader["puntaje_obtenido"]),
                FechaRealizacion = Convert.ToDateTime(reader["fecha_realizacion"])
            };
        }

        
    }
}