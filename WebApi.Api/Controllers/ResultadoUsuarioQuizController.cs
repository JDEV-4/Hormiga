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
{ [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ResultadoUsuarioQuizController : Controller
    {
         private readonly IResultadoUsuarioQuizService _service;

        public ResultadoUsuarioQuizController(IResultadoUsuarioQuizService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var resultados = await _service.ObtenerTodos();
            return Ok(resultados);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var resultado = await _service.ObtenerPorId(id);
            if (resultado == null) return NotFound();
            return Ok(resultado);
        }

        [HttpGet("usuario/{usuarioId}")]
        public async Task<IActionResult> GetByUsuario(int usuarioId)
        {
            var res = await _service.ObtenerPorUsuario(usuarioId);
            return Ok(res);
        }

        [HttpGet("quiz/{quizId}")]
        public async Task<IActionResult> GetByQuiz(int quizId)
        {
            var res = await _service.ObtenerPorQuiz(quizId);
            return Ok(res);
        }

        [HttpPost]
        public async Task<IActionResult> Crear([FromBody] ResultadoUsuarioQuiz resultado)
        {
            resultado.FechaRealizacion = DateTime.Now;
            var id = await _service.Crear(resultado);
            resultado.ResultadoId = id;
            return CreatedAtAction(nameof(GetById), new { id }, resultado);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Actualizar(int id, [FromBody] ResultadoUsuarioQuiz resultado)
        {
            if (id != resultado.ResultadoId) return BadRequest();
            var ok = await _service.Actualizar(resultado);
            if (!ok) return NotFound();
            return NoContent();
        }
  [HttpPost("evaluar")]
        public async Task<ActionResult<ResultadoUsuarioQuiz>> EvaluarQuiz([FromBody] EvaluarQuizDto dto)
        {
            if (dto == null || dto.Respuestas == null || dto.Respuestas.Count == 0)
                return BadRequest("Debe enviar las respuestas del usuario.");

            var resultado = await _service.EvaluarQuizAsync(dto);

            if (resultado == null)
                return BadRequest("No se pudo evaluar el quiz.");

            return Ok(resultado);
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Eliminar(int id)
        {
            var ok = await _service.Eliminar(id);
            if (!ok) return NotFound();
            return NoContent();
        }
    }
}