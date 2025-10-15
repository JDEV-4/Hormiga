using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class Publicacion
    {
       public int PublicacionId { get; set; }
        public int? FuenteOficialId { get; set; } // Opcional (si es oficial)
        public int? UsuarioId { get; set; } // Opcional (si es de comunidad)
        public int TipoPublicacionId { get; set; }
        public string Titulo { get; set; }
        public string Cuerpo { get; set; }
        public string ImagenUrl { get; set; }
        public DateTime FechaPublicacion { get; set; }
        public bool Estado { get; set; } = true; // Agregamos Estado
    }
}