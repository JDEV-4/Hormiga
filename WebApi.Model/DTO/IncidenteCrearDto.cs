using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class FotoIncidenteCrearDto
    {
        public string UrlFoto { get; set; }
    }

    public class IncidenteCrearDto
    {
        public int UsuarioId { get; set; }
        public int TipoIncidenteId { get; set; }
        public string Descripcion { get; set; }
        public decimal Latitud { get; set; }
        public decimal Longitud { get; set; }
        public string Departamento { get; set; }
        public string Municipio { get; set; }
        public string Comunidad { get; set; }

        // 👇 lista de fotos asociadas al incidente
        public List<FotoIncidenteCrearDto> Fotos { get; set; } = new();
    }
}