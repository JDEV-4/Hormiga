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
{
     [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class TipoIncidenteController  : Controller
    {
        private readonly ITipoIncidenteService _service;
        public TipoIncidenteController(ITipoIncidenteService service) { _service = service; }

        [HttpGet]
        public async Task<IActionResult> GetAll() => Ok(await _service.ObtenerTodosAsync());

        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var t = await _service.ObtenerPorIdAsync(id);
            if (t == null) return NotFound();
            return Ok(t);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] TipoIncidente tipo)
        {
            var id = await _service.CrearAsync(tipo);
            tipo.TipoIncidenteId = id;
            return CreatedAtAction(nameof(Get), new { id }, tipo);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] TipoIncidente tipo)
        {
            if (id != tipo.TipoIncidenteId) return BadRequest();
            var ok = await _service.ActualizarAsync(tipo);
            if (!ok) return NotFound();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var ok = await _service.EliminarAsync(id);
            if (!ok) return NotFound();
            return NoContent();
        }
    }
}