using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IPreguntaQuizService
    {
         Task<IEnumerable<PreguntaQuiz>> ObtenerPorQuiz(int quizId);
        Task<PreguntaQuiz> ObtenerPorId(int id);
        Task<int> Crear(PreguntaQuiz pregunta);
        Task<bool> Actualizar(PreguntaQuiz pregunta);
        Task<bool> Eliminar(int id);
    }
}