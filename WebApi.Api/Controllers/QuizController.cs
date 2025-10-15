using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using WebApi.Model;
using WebApi.Model.DTO;

namespace WebApi.Api.Controllers
{
   [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class QuizController : Controller
    {
 private readonly IQuizService _quizService;
        private readonly IPreguntaQuizService _preguntaService;
        private readonly IOpcionPreguntaService _opcionService;

        public QuizController(IQuizService quizService,
                              IPreguntaQuizService preguntaService,
                              IOpcionPreguntaService opcionService)
        {
            _quizService = quizService;
            _preguntaService = preguntaService;
            _opcionService = opcionService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var res = await _quizService.ObtenerTodos();
            return Ok(res);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var quiz = await _quizService.ObtenerPorId(id);
            if (quiz == null) return NotFound();
            return Ok(quiz);
        }

        // Endpoint compuesto que devuelve Quiz con Preguntas y Opciones (para frontend)
        [HttpGet("{id}/con-preguntas")]
        public async Task<IActionResult> GetQuizConPreguntas(int id)
        {
            var quiz = await _quizService.ObtenerPorId(id);
            if (quiz == null) return NotFound();

            var preguntas = (await _preguntaService.ObtenerPorQuiz(id)).ToList();
            var preguntasDto = new List<PreguntaQuizDto>();

            foreach (var p in preguntas)
            {
                var opciones = (await _opcionService.ObtenerPorPregunta(p.PreguntaId)).ToList();
                var opcDto = opciones.Select(o => new OpcionPreguntaDto
                {
                    OpcionId = o.OpcionId,
                    PreguntaId = o.PreguntaId,
                    TextoOpcion = o.TextoOpcion,
                    EsCorrecta = o.EsCorrecta
                }).ToList();

                preguntasDto.Add(new PreguntaQuizDto
                {
                    PreguntaId = p.PreguntaId,
                    QuizId = p.QuizId,
                    TextoPregunta = p.TextoPregunta,
                    Puntos = p.Puntos,
                    Opciones = opcDto
                });
            }

            var quizDto = new QuizDto
            {
                QuizId = quiz.QuizId,
                AmenazaId = quiz.AmenazaId,
                Titulo = quiz.Titulo,
                Descripcion = quiz.Descripcion,
                Preguntas = preguntasDto
            };

            return Ok(quizDto);
        }

        [HttpPost]
        public async Task<IActionResult> Crear([FromBody] Quiz quiz)
        {
            var id = await _quizService.Crear(quiz);
            quiz.QuizId = id;
            return CreatedAtAction(nameof(GetById), new { id }, quiz);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Actualizar(int id, [FromBody] Quiz quiz)
        {
            if (id != quiz.QuizId) return BadRequest();
            var ok = await _quizService.Actualizar(quiz);
            if (!ok) return NotFound();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Eliminar(int id)
        {
            var ok = await _quizService.Eliminar(id);
            if (!ok) return NotFound();
            return NoContent();
        }
    }
}