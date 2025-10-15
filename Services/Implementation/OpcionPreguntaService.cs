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
    public class OpcionPreguntaService: IOpcionPreguntaService
    {
          private readonly string _connectionString;

        public OpcionPreguntaService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<int> Crear(OpcionPregunta opcion)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                INSERT INTO Opciones_Pregunta (pregunta_id, texto_opcion, es_correcta)
                VALUES (@pregunta_id, @texto_opcion, @es_correcta);
                SELECT SCOPE_IDENTITY();";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@pregunta_id", opcion.PreguntaId);
            cmd.Parameters.AddWithValue("@texto_opcion", opcion.TextoOpcion);
            cmd.Parameters.AddWithValue("@es_correcta", opcion.EsCorrecta);

            await conn.OpenAsync();
            var res = await cmd.ExecuteScalarAsync();
            return Convert.ToInt32(res);
        }

        public async Task<bool> Actualizar(OpcionPregunta opcion)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                UPDATE Opciones_Pregunta
                SET pregunta_id = @pregunta_id,
                    texto_opcion = @texto_opcion,
                    es_correcta = @es_correcta
                WHERE opcion_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", opcion.OpcionId);
            cmd.Parameters.AddWithValue("@pregunta_id", opcion.PreguntaId);
            cmd.Parameters.AddWithValue("@texto_opcion", opcion.TextoOpcion);
            cmd.Parameters.AddWithValue("@es_correcta", opcion.EsCorrecta);

            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }

        public async Task<bool> Eliminar(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "DELETE FROM Opciones_Pregunta WHERE opcion_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }

        public async Task<OpcionPregunta> ObtenerPorId(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Opciones_Pregunta WHERE opcion_id = @id";
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

        public async Task<IEnumerable<OpcionPregunta>> ObtenerPorPregunta(int preguntaId)
        {
            var lista = new List<OpcionPregunta>();
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Opciones_Pregunta WHERE pregunta_id = @preguntaId ORDER BY opcion_id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@preguntaId", preguntaId);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(Map(reader));
            }
            return lista;
        }

        private OpcionPregunta Map(SqlDataReader reader)
        {
            return new OpcionPregunta
            {
                OpcionId = (int)reader["opcion_id"],
                PreguntaId = (int)reader["pregunta_id"],
                TextoOpcion = reader["texto_opcion"]?.ToString(),
                EsCorrecta = Convert.ToBoolean(reader["es_correcta"])
            };
        }
    }
}