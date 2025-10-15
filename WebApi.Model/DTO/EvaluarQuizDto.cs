using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class EvaluarQuizDto
    {
        public int UsuarioId { get; set; }
        public int QuizId { get; set; }
        public List<RespuestaDto> Respuestas { get; set; }
    }

    public class RespuestaDto
    {
        public int PreguntaId { get; set; }
        public int OpcionId { get; set; }
    }
    }
