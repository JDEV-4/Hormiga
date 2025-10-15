using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class Incidentes
    {
        public class TipoIncidente
    {
        public int TipoIncidenteId { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string IconoMapa { get; set; } = string.Empty;
        public string ColorHex { get; set; } = string.Empty;
    }

    // Mapea la tabla Fotos_Incidente
    public class FotoIncidente
    {
        public int FotoId { get; set; }
        public int IncidenteId { get; set; }
        public string UrlFoto { get; set; } = string.Empty;
        public DateTime FechaSubida { get; set; }
    }

    // Mapea la tabla Incidentes
    public class Incidente
    {
        public int IncidenteId { get; set; }
        public int UsuarioId { get; set; }
        public int TipoIncidenteId { get; set; }
        public string Descripcion { get; set; } = string.Empty;
        public decimal Latitud { get; set; }
        public decimal Longitud { get; set; }
        public string Estado { get; set; } = "Reportado"; // Default
        public DateTime FechaReporte { get; set; }
        public DateTime? FechaCierre { get; set; } // Puede ser nulo

        // Propiedad de navegación (no mapeada a DB, solo para guardar fotos)
        public List<FotoIncidente> Fotos { get; set; } = new List<FotoIncidente>();
    }
    }
}