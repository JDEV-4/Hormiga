using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Mvc;
using WebApi.Api.DTO;
using Microsoft.AspNetCore.Authorization;
using Interface;
using WebApi.Model;
using WebApi.Model.DTO;
namespace WebApi.Api.Controllers
{
   [ApiController]
    [Route("api/[controller]")]
     public class ComunicacionController : Controller
    {
       private readonly IComunicacionService _comunicacionService;

        public ComunicacionController(IComunicacionService comunicacionService)
        {
            _comunicacionService = comunicacionService;
        }
        

      [HttpPost("fuentes")]
public async Task<IActionResult> CrearFuente([FromBody] FuenteOficialCrearDTO dto)
{
    // Mapear DTO a un modelo parcial o pasar directamente al servicio.
    // En este caso, el servicio usa el DTO.
    var nuevaFuente = await _comunicacionService.CrearFuenteAsync(dto);
    return CreatedAtAction(nameof(GetFuenteById), new { fuenteOficialId = nuevaFuente.FuenteOficialId }, nuevaFuente);
}

// GET: api/comunicacion/fuentes
[HttpGet("fuentes")]
public async Task<ActionResult<IEnumerable<FuenteOficial>>> GetFuentes()
{
    var fuentes = await _comunicacionService.ListarFuentesActivasAsync();
    return Ok(fuentes);
}

// GET: api/comunicacion/fuentes/5
[HttpGet("fuentes/{fuenteOficialId}")]
public async Task<ActionResult<FuenteOficial>> GetFuenteById(int fuenteOficialId)
{
    var fuente = await _comunicacionService.MostrarFuenteAsync(fuenteOficialId);
    if (fuente == null) return NotFound();
    return Ok(fuente);
}

// PUT: api/comunicacion/fuentes/5
[HttpPut("fuentes/{fuenteOficialId}")]
public async Task<IActionResult> ActualizarFuente(int fuenteOficialId, [FromBody] FuenteOficial fuente)
{
    if (fuenteOficialId != fuente.FuenteOficialId) return BadRequest("El ID de la ruta no coincide con el ID del cuerpo.");

    var success = await _comunicacionService.ActualizarFuenteAsync(fuente);
    if (!success) return NotFound();
    return NoContent(); // 204 No Content
}

// DELETE (Eliminación Lógica): api/comunicacion/fuentes/5
[HttpDelete("fuentes/{fuenteOficialId}")]
public async Task<IActionResult> EliminarFuente(int fuenteOficialId)
{
    var success = await _comunicacionService.EliminarFuenteAsync(fuenteOficialId);
    if (!success) return NotFound();
    return NoContent(); // 204 No Content
}

    }
}