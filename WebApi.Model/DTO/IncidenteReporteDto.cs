using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class IncidenteReporteDto
    {
        public int IncidenteId { get; set; }
        public int UsuarioId { get; set; }
        public int TipoIncidenteId { get; set; }
        public string TipoNombre { get; set; }
        public string IconoMapa { get; set; }
        public string ColorHex { get; set; }
        public string Descripcion { get; set; }
        public decimal Latitud { get; set; }
        public decimal Longitud { get; set; }
        public string Departamento { get; set; }
        public string Municipio { get; set; }
        public string Comunidad { get; set; }
        public string Estado { get; set; }
        public DateTime FechaReporte { get; set; }
        public DateTime? FechaCierre { get; set; }
    }
}