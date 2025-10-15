using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class OpcionPreguntaDto
    {
           public int OpcionId { get; set; }
        public int PreguntaId { get; set; }
        public string TextoOpcion { get; set; }
        public bool EsCorrecta { get; set; }
    }
}