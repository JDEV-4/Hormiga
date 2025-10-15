using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class ResultadoUsuarioQuizDto
    {
        public int ResultadoId { get; set; }
        public int UsuarioId { get; set; }
        public string NombreUsuario { get; set; }   // opcional, si haces join con Usuario
        public int QuizId { get; set; }
        public string TituloQuiz { get; set; }      // opcional, si haces join con Quiz
        public int PuntajeObtenido { get; set; }
        public DateTime FechaRealizacion { get; set; }
    }
}