using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface ITipoIncidenteService
    {
        Task<IEnumerable<TipoIncidente>> ObtenerTodosAsync();
        Task<TipoIncidente> ObtenerPorIdAsync(int id);
        Task<int> CrearAsync(TipoIncidente tipo);
        Task<bool> ActualizarAsync(TipoIncidente tipo);
        Task<bool> EliminarAsync(int id);
    }
}