using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class AmenazaEducativa
    {
         public int AmenazaId { get; set; }
        public string Nombre { get; set; }
        public string DescripcionCorta { get; set; }
        public string IconoUrl { get; set; }
    }
}