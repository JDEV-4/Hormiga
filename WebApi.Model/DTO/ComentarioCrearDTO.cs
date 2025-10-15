using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class ComentarioCrearDTO
    {
                public int PublicacionId { get; set; }
        public string TextoComentario { get; set; }
    }
}