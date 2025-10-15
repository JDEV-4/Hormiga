using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IComentarioService
    {
         Task<Comentario> CrearComentarioAsync(Comentario comentario);
        Task<IEnumerable<Comentario>> ObtenerComentariosPorPublicacionAsync(int publicacionId);
        Task<bool> EliminarComentarioAsync(int comentarioId, int usuarioId); // Requiere ser el dueño
    }
}