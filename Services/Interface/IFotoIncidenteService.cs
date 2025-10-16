using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static WebApi.Model.Incidentes;

namespace Interface
{
    public interface IFotoIncidenteService
    {
        Task<int> AgregarFotoAsync(FotoIncidente foto);
        Task<IEnumerable<FotoIncidente>> ObtenerPorIncidenteAsync(int incidenteId);
        Task<bool> EliminarAsync(int fotoId);
    }
}