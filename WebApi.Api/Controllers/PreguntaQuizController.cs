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

namespace WebApi.Api.Controllers
{[ApiController]
    [Route("api/[controller]")]
    [Authorize]
    
    public class  PreguntaQuizController : Controller
    {
           private readonly IPreguntaQuizService _service;

        public PreguntaQuizController(IPreguntaQuizService service)
        {
            _service = service;
        }

        [HttpGet("quiz/{quizId}")]
        public async Task<IActionResult> GetByQuiz(int quizId)
        {
            var res = await _service.ObtenerPorQuiz(quizId);
            return Ok(res);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var p = await _service.ObtenerPorId(id);
            if (p == null) return NotFound();
            return Ok(p);
        }

        [HttpPost]
        public async Task<IActionResult> Crear([FromBody] PreguntaQuiz pregunta)
        {
            var id = await _service.Crear(pregunta);
            pregunta.PreguntaId = id;
            return CreatedAtAction(nameof(GetById), new { id }, pregunta);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Actualizar(int id, [FromBody] PreguntaQuiz pregunta)
        {
            if (id != pregunta.PreguntaId) return BadRequest();
            var ok = await _service.Actualizar(pregunta);
            if (!ok) return NotFound();
            return NoContent();
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