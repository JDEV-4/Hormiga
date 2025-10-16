using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class TipoIncidente
    {
         public int TipoIncidenteId { get; set; }
        public string Nombre { get; set; }
        public string IconoMapa { get; set; }
        public string ColorHex { get; set; }
    }
}