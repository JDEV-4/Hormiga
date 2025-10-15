using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class OpcionPregunta
    {
        public int OpcionId { get; set; }
        public int PreguntaId { get; set; }
        public string TextoOpcion { get; set; }
        public bool EsCorrecta { get; set; }
    }
}