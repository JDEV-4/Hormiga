using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static WebApi.Model.Incidentes;

namespace Interface
{
    public interface IIncidenteService
    {
         Task<IEnumerable<TipoIncidente>> ObtenerTiposIncidenteAsync();
        
        // Crear incidente y fotos asociadas (lógica transaccional)
        Task<Incidente> CrearIncidenteAsync(Incidente incidente);
        
        // Obtener incidentes para el mapa/listado
        Task<IEnumerable<Incidente>> ObtenerIncidentesRecientesAsync(int limit);
        
        // Actualizar estado
        Task<bool> ActualizarEstadoIncidenteAsync(int incidenteId, string nuevoEstado, int usuarioLogueadoId);
    }
}