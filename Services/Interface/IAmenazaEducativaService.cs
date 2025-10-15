using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;
using WebApi.Model.DTO;

namespace Interface
{
    public interface IAmenazaEducativaService
    {
         Task<IEnumerable<AmenazaEducativa>> ListarAmenazasAsync();
        Task<AmenazaEducativa> ObtenerAmenazaPorIdAsync(int id);
        Task<AmenazaEducativa> CrearAmenazaAsync(AmenazaEducativaDTO dto);
        Task<bool> ActualizarAmenazaAsync(int id, AmenazaEducativaDTO dto);
        Task<bool> EliminarAmenazaAsync(int id);
    }
}