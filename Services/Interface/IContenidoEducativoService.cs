using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IContenidoEducativoService
    {
        Task<IEnumerable<ContenidoEducativo>> ObtenerTodos();
        Task<ContenidoEducativo> ObtenerPorId(int id);
        Task<IEnumerable<ContenidoEducativo>> ObtenerPorAmenaza(int amenazaId);
        Task<int> Crear(ContenidoEducativo contenido);
        Task<bool> Actualizar(ContenidoEducativo contenido);
        Task<bool> Eliminar(int id);
    }
}