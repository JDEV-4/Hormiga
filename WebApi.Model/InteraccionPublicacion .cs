
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class InteraccionPublicacion 
    {
         public int InteraccionId { get; set; }
        public int PublicacionId { get; set; }
        public int UsuarioId { get; set; }
        
        // Define el tipo de acción: 'LIKE', 'SHARE', 'FAVORITE', etc.
        public string TipoInteraccion { get; set; } 
        public DateTime FechaInteraccion { get; set; }
    }
}