using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class PreguntaQuiz
    {
         public int PreguntaId { get; set; }
        public int QuizId { get; set; }
        public string TextoPregunta { get; set; }
        public int Puntos { get; set; }
    }
}