using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using static WebApi.Model.Incidentes;

namespace WebApi.Api.Controllers
{
    [Route("[controller]")]
    public class FotoIncidenteController  : Controller
    {
        private readonly IFotoIncidenteService _service;
        public FotoIncidenteController(IFotoIncidenteService service) { _service = service; }

        [HttpPost]
        public async Task<IActionResult> Agregar([FromBody] FotoIncidente foto)
        {
            var id = await _service.AgregarFotoAsync(foto);
            foto.FotoId = id;
            return CreatedAtAction(nameof(GetByIncidente), new { incidenteId = foto.IncidenteId }, foto);
        }

        [HttpGet("incidente/{incidenteId}")]
        public async Task<IActionResult> GetByIncidente(int incidenteId)
        {
            var res = await _service.ObtenerPorIncidenteAsync(incidenteId);
            return Ok(res);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Eliminar(int id)
        {
            var ok = await _service.EliminarAsync(id);
            if (!ok) return NotFound();
            return NoContent();
        }
    }
}