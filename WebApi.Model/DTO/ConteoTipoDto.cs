using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class ConteoTipoDto
    {
                public int TipoIncidenteId { get; set; }
        public string TipoNombre { get; set; }
        public int Conteo { get; set; }

    }
}