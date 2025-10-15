using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class Comentario
    {
         public int ComentarioId { get; set; }
        public int PublicacionId { get; set; }
        public int UsuarioId { get; set; }
        public string TextoComentario { get; set; }
        public DateTime FechaComentario { get; set; }
        
        // Propiedad opcional para mostrar el nombre del usuario en el frontend
        [JsonIgnore]
        public string NombreUsuario { get; set; }
    }
}