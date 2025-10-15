using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class FuenteOficial
    {
           public int FuenteOficialId { get; set; }
        public string Nombre { get; set; }
        public string LogoUrl { get; set; }
        public bool Estado { get; set; } = true; 
    }
}