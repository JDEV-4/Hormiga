using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class UsuarioBasicoDTO
    {
        public int Id { get; set; }
        public string NombreCompleto { get; set; }
        public string Correo { get; set; }
        public string Telefono { get; set; }
    }
}