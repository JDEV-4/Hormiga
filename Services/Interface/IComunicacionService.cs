using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;
using WebApi.Model.DTO;

namespace Interface
{
    public interface IComunicacionService
    {
        Task<FuenteOficial> CrearFuenteAsync(FuenteOficialCrearDTO dto); // Usamos DTO para Crear
Task<bool> ActualizarFuenteAsync(FuenteOficial fuente);
Task<IEnumerable<FuenteOficial>> ListarFuentesActivasAsync(); // READ ALL
Task<FuenteOficial> MostrarFuenteAsync(int fuenteOficialId); // READ BY ID
Task<bool> EliminarFuenteAsync(int fuenteOficialId); // DELETE (Lógico)

    }
}