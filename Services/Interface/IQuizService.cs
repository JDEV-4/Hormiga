using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IQuizService
    {
        Task<IEnumerable<Quiz>> ObtenerTodos();
        Task<Quiz> ObtenerPorId(int id);
        Task<IEnumerable<Quiz>> ObtenerPorAmenaza(int amenazaId);
        Task<int> Crear(Quiz quiz);
        Task<bool> Actualizar(Quiz quiz);
        Task<bool> Eliminar(int id);
    }
}