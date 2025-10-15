using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class Quiz
    {
         public int QuizId { get; set; }
        public int AmenazaId { get; set; }
        public string Titulo { get; set; }
        public string Descripcion { get; set; }
    }
}