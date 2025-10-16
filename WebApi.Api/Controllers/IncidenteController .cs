using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using WebApi.Model.DTO;

namespace WebApi.Api.Controllers
{
    [Route("[controller]")]
    public class IncidenteController  : Controller
    {
         private readonly IIncidenteService _service;
        public IncidenteController(IIncidenteService service) { _service = service; }

    [HttpPost("crear")]
    public async Task<IActionResult> Crear([FromBody] IncidenteCrearDto dto)
    {
        if (dto == null)
            return BadRequest("El cuerpo de la solicitud no puede ser nulo.");

        try
        {
            var id = await _service.CrearAsync(dto);
            return Ok(new
            {
                mensaje = "Incidente y fotos registradas correctamente.",
                incidenteId = id
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { mensaje = "Error al crear incidente", detalle = ex.Message });
        }
    }


        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerPorId(int id)
        {
            var inc = await _service.ObtenerPorIdAsync(id);
            if (inc == null) return NotFound();
            return Ok(inc);
        }

        [HttpGet("todos-con-tipo")]
        public async Task<IActionResult> ObtenerTodosConTipo() => Ok(await _service.ObtenerTodosConTipoAsync());

        [HttpGet("por-fecha")]
        public async Task<IActionResult> ObtenerPorRangoFecha([FromQuery] DateTime? desde, [FromQuery] DateTime? hasta)
        {
            return Ok(await _service.ObtenerPorRangoFechaAsync(desde, hasta));
        }

        [HttpGet("por-estado")]
        public async Task<IActionResult> ObtenerPorEstado([FromQuery] string estado)
        {
            return Ok(await _service.ObtenerPorEstadoAsync(estado));
        }

        [HttpGet("por-departamento/{departamento}")]
        public async Task<IActionResult> ObtenerPorDepartamento(string departamento)
        {
            return Ok(await _service.ObtenerPorDepartamentoAsync(departamento));
        }

        [HttpPut("{id}/estado")]
        public async Task<IActionResult> ActualizarEstado(int id, [FromQuery] string nuevoEstado, [FromQuery] DateTime? fechaCierre)
        {
            var ok = await _service.ActualizarEstadoAsync(id, nuevoEstado, fechaCierre);
            if (!ok) return NotFound();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Eliminar(int id)
        {
            var ok = await _service.EliminarAsync(id);
            if (!ok) return NotFound();
            return NoContent();
        }

        // Reporte: conteo por tipo en rango de fechas
        [HttpGet("report/conteo-por-tipo")]
        public async Task<IActionResult> ConteoPorTipo([FromQuery] DateTime? desde, [FromQuery] DateTime? hasta)
        {
            var res = await _service.ConteoPorTipoAsync(desde, hasta);
            return Ok(res);
        }
    }
}