using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IOpcionPreguntaService
    {
         Task<IEnumerable<OpcionPregunta>> ObtenerPorPregunta(int preguntaId);
        Task<OpcionPregunta> ObtenerPorId(int id);
        Task<int> Crear(OpcionPregunta opcion);
        Task<bool> Actualizar(OpcionPregunta opcion);
        Task<bool> Eliminar(int id);
    }
}