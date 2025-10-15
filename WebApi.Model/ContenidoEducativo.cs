using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class ContenidoEducativo
    {
         public int ContenidoId { get; set; }
        public int AmenazaId { get; set; }
        public string Titulo { get; set; }
        public string Fase { get; set; }
        public string TextoSeccion { get; set; }
        public int? Orden { get; set; }
        public string TipoRecurso { get; set; }
    }
}