using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;
using WebApi.Model.DTO;

namespace Interface
{
    public interface IResultadoUsuarioQuizService
    {
        Task<int> Crear(ResultadoUsuarioQuiz resultado);
        Task<bool> Actualizar(ResultadoUsuarioQuiz resultado);
        Task<bool> Eliminar(int id);
        Task<ResultadoUsuarioQuiz> ObtenerPorId(int id);
        Task<IEnumerable<ResultadoUsuarioQuiz>> ObtenerPorUsuario(int usuarioId);
        Task<IEnumerable<ResultadoUsuarioQuiz>> ObtenerPorQuiz(int quizId);
        Task<IEnumerable<ResultadoUsuarioQuiz>> ObtenerTodos();
         Task<ResultadoUsuarioQuiz> EvaluarQuizAsync(EvaluarQuizDto dto);
    }
}