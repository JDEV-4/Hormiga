using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using WebApi.Model;

namespace WebApi.Api.Controllers
{
       [ApiController]
    [Route("api/[controller]")]
    public class ContenidoEducativoController : Controller
    {
        private readonly IContenidoEducativoService _service;

        public ContenidoEducativoController(IContenidoEducativoService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var lista = await _service.ObtenerTodos();
            return Ok(lista);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var contenido = await _service.ObtenerPorId(id);
            if (contenido == null)
                return NotFound();
            return Ok(contenido);
        }

        [HttpGet("amenaza/{amenazaId}")]
        public async Task<IActionResult> GetByAmenaza(int amenazaId)
        {
            var lista = await _service.ObtenerPorAmenaza(amenazaId);
            return Ok(lista);
        }

        [HttpPost]
        public async Task<IActionResult> Crear([FromBody] ContenidoEducativo contenido)
        {
            var id = await _service.Crear(contenido);
            return CreatedAtAction(nameof(GetById), new { id }, contenido);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Actualizar(int id, [FromBody] ContenidoEducativo contenido)
        {
            if (id != contenido.ContenidoId)
                return BadRequest();

            var result = await _service.Actualizar(contenido);
            if (!result)
                return NotFound();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Eliminar(int id)
        {
            var result = await _service.Eliminar(id);
            if (!result)
                return NotFound();

            return NoContent();
        }
    }
}