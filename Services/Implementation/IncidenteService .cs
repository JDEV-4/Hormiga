using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Interface;
using Microsoft.Extensions.Configuration;
using WebApi.Model;
using WebApi.Model.DTO;

namespace Implementation
{
    public class IncidenteService : IIncidenteService
    {
        private readonly string _connectionString;
        public IncidenteService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

      public async Task<int> CrearAsync(IncidenteCrearDto dto)
{

    if (dto == null)
        throw new ArgumentNullException(nameof(dto), "El DTO no puede ser nulo.");

    await using var conn = new SqlConnection(_connectionString);
    await conn.OpenAsync();

    using var transaction = conn.BeginTransaction();

    try
    {
        // 1️⃣ Insertar el incidente
        const string sqlIncidente = @"
            INSERT INTO Incidentes
            (usuario_id, tipo_incidente_id, descripcion, latitud, longitud, departamento, municipio, comunidad, estado, fecha_reporte)
            VALUES (@usuario_id, @tipo_incidente_id, @descripcion, @latitud, @longitud, @departamento, @municipio, @comunidad, 'Reportado', GETDATE());
            SELECT SCOPE_IDENTITY();";

        using var cmdIncidente = new SqlCommand(sqlIncidente, conn, transaction);
        cmdIncidente.Parameters.AddWithValue("@usuario_id", dto.UsuarioId);
        cmdIncidente.Parameters.AddWithValue("@tipo_incidente_id", dto.TipoIncidenteId);
        cmdIncidente.Parameters.AddWithValue("@descripcion", dto.Descripcion);
        cmdIncidente.Parameters.AddWithValue("@latitud", dto.Latitud);
        cmdIncidente.Parameters.AddWithValue("@longitud", dto.Longitud);
        cmdIncidente.Parameters.AddWithValue("@departamento", dto.Departamento);
        cmdIncidente.Parameters.AddWithValue("@municipio", dto.Municipio);
        cmdIncidente.Parameters.AddWithValue("@comunidad", dto.Comunidad);

        var incidenteId = Convert.ToInt32(await cmdIncidente.ExecuteScalarAsync());

        // 2️⃣ Insertar las fotos (detalle)
        if (dto.Fotos != null && dto.Fotos.Any())
        {
            const string sqlFoto = @"
                INSERT INTO Fotos_Incidente (incidente_id, url_foto)
                VALUES (@incidente_id, @url_foto);";

            foreach (var foto in dto.Fotos)
            {
                using var cmdFoto = new SqlCommand(sqlFoto, conn, transaction);
                cmdFoto.Parameters.AddWithValue("@incidente_id", incidenteId);
                cmdFoto.Parameters.AddWithValue("@url_foto", foto.UrlFoto);
                await cmdFoto.ExecuteNonQueryAsync();
            }
        }

        // 3️⃣ Confirmar la transacción
        transaction.Commit();
        return incidenteId;
    }
    catch (Exception)
    {
        transaction.Rollback();
        throw;
    }}
        public async Task<Incidente> ObtenerPorIdAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "SELECT * FROM Incidentes WHERE incidente_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                return MapIncidente(reader);
            }
            return null;
        }

        public async Task<IEnumerable<IncidenteReporteDto>> ObtenerTodosConTipoAsync()
        {
            var lista = new List<IncidenteReporteDto>();
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                SELECT i.*, t.nombre, t.icono_mapa, t.color_hex
                FROM Incidentes i
                INNER JOIN Tipos_Incidente t ON i.tipo_incidente_id = t.tipo_incidente_id
                ORDER BY i.fecha_reporte DESC";
            using var cmd = new SqlCommand(sql, conn);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(MapReporte(reader));
            }
            return lista;
        }

        public async Task<IEnumerable<IncidenteReporteDto>> ObtenerPorRangoFechaAsync(DateTime? desde, DateTime? hasta)
        {
            var lista = new List<IncidenteReporteDto>();
            using var conn = new SqlConnection(_connectionString);
            var sb = new StringBuilder();
            sb.Append(@"
                SELECT i.*, t.nombre, t.icono_mapa, t.color_hex
                FROM Incidentes i
                INNER JOIN Tipos_Incidente t ON i.tipo_incidente_id = t.tipo_incidente_id
                WHERE 1=1");

            if (desde.HasValue) sb.Append(" AND i.fecha_reporte >= @desde");
            if (hasta.HasValue) sb.Append(" AND i.fecha_reporte <= @hasta");

            sb.Append(" ORDER BY i.fecha_reporte DESC");

            using var cmd = new SqlCommand(sb.ToString(), conn);
            if (desde.HasValue) cmd.Parameters.AddWithValue("@desde", desde.Value);
            if (hasta.HasValue) cmd.Parameters.AddWithValue("@hasta", hasta.Value);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(MapReporte(reader));
            }
            return lista;
        }

        public async Task<IEnumerable<IncidenteReporteDto>> ObtenerPorEstadoAsync(string estado)
        {
            var lista = new List<IncidenteReporteDto>();
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                SELECT i.*, t.nombre, t.icono_mapa, t.color_hex
                FROM Incidentes i
                INNER JOIN Tipos_Incidente t ON i.tipo_incidente_id = t.tipo_incidente_id
                WHERE i.estado = @estado
                ORDER BY i.fecha_reporte DESC";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@estado", estado);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(MapReporte(reader));
            }
            return lista;
        }

        public async Task<IEnumerable<IncidenteReporteDto>> ObtenerPorDepartamentoAsync(string departamento)
        {
            var lista = new List<IncidenteReporteDto>();
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                SELECT i.*, t.nombre, t.icono_mapa, t.color_hex
                FROM Incidentes i
                INNER JOIN Tipos_Incidente t ON i.tipo_incidente_id = t.tipo_incidente_id
                WHERE i.departamento = @departamento
                ORDER BY i.fecha_reporte DESC";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@departamento", departamento);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(MapReporte(reader));
            }
            return lista;
        }

        public async Task<bool> ActualizarEstadoAsync(int incidenteId, string nuevoEstado, DateTime? fechaCierre)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = @"
                UPDATE Incidentes
                SET estado = @estado, fecha_cierre = @fecha_cierre
                WHERE incidente_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", incidenteId);
            cmd.Parameters.AddWithValue("@estado", nuevoEstado);
            cmd.Parameters.AddWithValue("@fecha_cierre", (object)fechaCierre ?? DBNull.Value);
            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }

        public async Task<bool> EliminarAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            const string sql = "DELETE FROM Incidentes WHERE incidente_id = @id";
            using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            await conn.OpenAsync();
            var rows = await cmd.ExecuteNonQueryAsync();
            return rows > 0;
        }

        public async Task<IEnumerable<ConteoTipoDto>> ConteoPorTipoAsync(DateTime? desde, DateTime? hasta)
        {
            var lista = new List<ConteoTipoDto>();
            using var conn = new SqlConnection(_connectionString);
            var sb = new StringBuilder();
            sb.Append(@"
                SELECT t.tipo_incidente_id, t.nombre, COUNT(*) AS conteo
                FROM Incidentes i
                INNER JOIN Tipos_Incidente t ON i.tipo_incidente_id = t.tipo_incidente_id
                WHERE 1=1");
            if (desde.HasValue) sb.Append(" AND i.fecha_reporte >= @desde");
            if (hasta.HasValue) sb.Append(" AND i.fecha_reporte <= @hasta");
            sb.Append(" GROUP BY t.tipo_incidente_id, t.nombre ORDER BY conteo DESC");

            using var cmd = new SqlCommand(sb.ToString(), conn);
            if (desde.HasValue) cmd.Parameters.AddWithValue("@desde", desde.Value);
            if (hasta.HasValue) cmd.Parameters.AddWithValue("@hasta", hasta.Value);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new ConteoTipoDto
                {
                    TipoIncidenteId = (int)reader["tipo_incidente_id"],
                    TipoNombre = reader["nombre"].ToString(),
                    Conteo = Convert.ToInt32(reader["conteo"])
                });
            }
            return lista;
        }

        private Incidente MapIncidente(SqlDataReader r)
        {
            return new Incidente
            {
                IncidenteId = (int)r["incidente_id"],
                UsuarioId = (int)r["usuario_id"],
                TipoIncidenteId = (int)r["tipo_incidente_id"],
                Descripcion = r["descripcion"].ToString(),
                Latitud = Convert.ToDecimal(r["latitud"]),
                Longitud = Convert.ToDecimal(r["longitud"]),
                Departamento = r["departamento"].ToString(),
                Municipio = r["municipio"].ToString(),
                Comunidad = r["comunidad"].ToString(),
                Estado = r["estado"].ToString(),
                FechaReporte = Convert.ToDateTime(r["fecha_reporte"]),
                FechaCierre = r["fecha_cierre"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(r["fecha_cierre"])
            };
        }

        private IncidenteReporteDto MapReporte(SqlDataReader r)
        {
            return new IncidenteReporteDto
            {
                IncidenteId = (int)r["incidente_id"],
                UsuarioId = (int)r["usuario_id"],
                TipoIncidenteId = (int)r["tipo_incidente_id"],
                TipoNombre = r["nombre"].ToString(),
                IconoMapa = r["icono_mapa"]?.ToString(),
                ColorHex = r["color_hex"]?.ToString(),
                Descripcion = r["descripcion"].ToString(),
                Latitud = Convert.ToDecimal(r["latitud"]),
                Longitud = Convert.ToDecimal(r["longitud"]),
                Departamento = r["departamento"].ToString(),
                Municipio = r["municipio"].ToString(),
                Comunidad = r["comunidad"].ToString(),
                Estado = r["estado"].ToString(),
                FechaReporte = Convert.ToDateTime(r["fecha_reporte"]),
                FechaCierre = r["fecha_cierre"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(r["fecha_cierre"])
            };
        }

        Task<Incidentes.Incidente> IIncidenteService.ObtenerPorIdAsync(int id)
        {
            throw new NotImplementedException();
        }
    }
}