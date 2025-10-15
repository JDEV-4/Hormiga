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
{ [ApiController]
    [Route("api/[controller]")]
    [Authorize]
        public class OpcionPreguntaController : Controller
    {
          private readonly IOpcionPreguntaService _service;

        public OpcionPreguntaController(IOpcionPreguntaService service)
        {
            _service = service;
        }

        [HttpGet("pregunta/{preguntaId}")]
        public async Task<IActionResult> GetByPregunta(int preguntaId)
        {
            var res = await _service.ObtenerPorPregunta(preguntaId);
            return Ok(res);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var o = await _service.ObtenerPorId(id);
            if (o == null) return NotFound();
            return Ok(o);
        }

        [HttpPost]
        public async Task<IActionResult> Crear([FromBody] OpcionPregunta opcion)
        {
            var id = await _service.Crear(opcion);
            opcion.OpcionId = id;
            return CreatedAtAction(nameof(GetById), new { id }, opcion);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Actualizar(int id, [FromBody] OpcionPregunta opcion)
        {
            if (id != opcion.OpcionId) return BadRequest();
            var ok = await _service.Actualizar(opcion);
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
