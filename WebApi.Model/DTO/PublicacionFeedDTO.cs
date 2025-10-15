using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class PublicacionFeedDTO
    {
        public int PublicacionId { get; set; }
        
        // Información de la Fuente
        public string NombreFuente { get; set; } // Ej: SINAPRED o Nombre de Usuario
        public string LogoUrlFuente { get; set; } // URL del logo
        
        // Contenido
        public string Titulo { get; set; }
        public string Cuerpo { get; set; }
        public string ImagenUrl { get; set; } 
        public DateTime FechaPublicacion { get; set; }

        // Contadores
        public int ConteoLikes { get; set; } 
        public int ConteoComentarios { get; set; } 
        
        // Estado del usuario actual
        public bool UsuarioActualDioLike { get; set; }
    }
}