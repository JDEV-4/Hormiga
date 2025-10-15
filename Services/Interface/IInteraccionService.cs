using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IInteraccionService
    {
         // Interacciones (Likes)
        Task<InteraccionPublicacion> CrearInteraccionAsync(InteraccionPublicacion interaccion);
        Task<bool> EliminarInteraccionAsync(int publicacionId, int usuarioId, string tipoInteraccion);
        Task<int> ContarInteraccionesPorPublicacionAsync(int publicacionId, string tipoInteraccion);
        Task<bool> VerificarInteraccionAsync(int publicacionId, int usuarioId, string tipoInteraccion);
    }
}