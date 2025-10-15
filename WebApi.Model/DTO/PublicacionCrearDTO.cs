using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class PublicacionCrearDTO
    {
        public int? FuenteOficialId { get; set; } 
        //public int? UsuarioId { get; set; } 
        public int TipoPublicacionId { get; set; }
        public string Titulo { get; set; }
        public string Cuerpo { get; set; }
        public string ImagenUrl { get; set; } 
    }
}