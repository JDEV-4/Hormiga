using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IInteraccionComentarioService
    {
          Task<InteraccionPublicacion> CrearInteraccionAsync(InteraccionPublicacion interaccion);
        Task<bool> EliminarInteraccionAsync(int publicacionId, int usuarioId, string tipoInteraccion);
        Task<int> ContarInteraccionesPorPublicacionAsync(int publicacionId, string tipoInteraccion);
        Task<bool> VerificarInteraccionAsync(int publicacionId, int usuarioId, string tipoInteraccion);

        // Comentarios
        Task<Comentario> CrearComentarioAsync(Comentario comentario);
        Task<IEnumerable<Comentario>> ObtenerComentariosPorPublicacionAsync(int publicacionId);
        Task<bool> EliminarComentarioAsync(int comentarioId, int usuarioId); // Requiere ser el dueño
    }
}