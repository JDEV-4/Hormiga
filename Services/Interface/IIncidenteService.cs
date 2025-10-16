using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model.DTO;
using static WebApi.Model.Incidentes;

namespace Interface
{
    public interface IIncidenteService
    {
       Task<int> CrearAsync(IncidenteCrearDto dto);
        Task<Incidente> ObtenerPorIdAsync(int id);
        Task<IEnumerable<IncidenteReporteDto>> ObtenerPorRangoFechaAsync(DateTime? desde, DateTime? hasta);
        Task<IEnumerable<IncidenteReporteDto>> ObtenerPorEstadoAsync(string estado);
        Task<IEnumerable<IncidenteReporteDto>> ObtenerPorDepartamentoAsync(string departamento);
        Task<bool> ActualizarEstadoAsync(int incidenteId, string nuevoEstado, DateTime? fechaCierre);
        Task<bool> EliminarAsync(int id);
        Task<IEnumerable<IncidenteReporteDto>> ObtenerTodosConTipoAsync();
        Task<IEnumerable<ConteoTipoDto>> ConteoPorTipoAsync(DateTime? desde, DateTime? hasta);
    }
}