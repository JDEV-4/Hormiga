using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using WebApi.Model.DTO;

namespace WebApi.Api.Controllers
{
[ApiController]
    [Route("api/[controller]")]
    [Authorize]

    public class AmenazaEducativaController : Controller
    {
                private readonly IAmenazaEducativaService _service;

        public AmenazaEducativaController(IAmenazaEducativaService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> Listar()
        {
            var data = await _service.ListarAmenazasAsync();
            return Ok(data);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerPorId(int id)
        {
            var data = await _service.ObtenerAmenazaPorIdAsync(id);
            if (data == null) return NotFound();
            return Ok(data);
        }

        [HttpPost]
        public async Task<IActionResult> Crear([FromBody] AmenazaEducativaDTO dto)
        {
            var nueva = await _service.CrearAmenazaAsync(dto);
            return CreatedAtAction(nameof(ObtenerPorId), new { id = nueva.AmenazaId }, nueva);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Actualizar(int id, [FromBody] AmenazaEducativaDTO dto)
        {
            var ok = await _service.ActualizarAmenazaAsync(id, dto);
            if (!ok) return NotFound();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Eliminar(int id)
        {
            var ok = await _service.EliminarAmenazaAsync(id);
            if (!ok) return NotFound();
            return NoContent();
        }
    }

}