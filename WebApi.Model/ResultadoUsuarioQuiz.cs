using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class ResultadoUsuarioQuiz
    {
        public int ResultadoId { get; set; }
        public int UsuarioId { get; set; }
        public int QuizId { get; set; }
        public int PuntajeObtenido { get; set; }
        public DateTime FechaRealizacion { get; set; }

    }
}