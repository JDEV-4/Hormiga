using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class  InteraccionDTO
    {
         public int PublicacionId { get; set; }
        // El UsuarioId será inyectado por el Controller.
        // Asumimos que sólo manejaremos 'LIKE' por ahora, 
        // pero el campo permite otras interacciones.
        public string TipoInteraccion { get; set; } = "LIKE"; 
    }
}