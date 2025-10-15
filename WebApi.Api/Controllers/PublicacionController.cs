using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Security.Claims;
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
    public class PublicacionController : ControllerBase
    {
        private readonly IPublicacionService _publicacionService;

        public PublicacionController(IPublicacionService publicacionService)
        {
            _publicacionService = publicacionService;
        }

        // GET: api/Publicacion/feed (READ ALL con paginación y joins)
        [HttpGet("feed")]
        public async Task<IActionResult> GetFeed(int pagina = 1, int tamañoPagina = 10)
        {
            var feed = await _publicacionService.GetFeedAsync(pagina, tamañoPagina);
            return Ok(feed);
        }
    [HttpPost]
    public async Task<IActionResult> CrearPublicacion([FromBody] PublicacionCrearDTO dto)
    {
        // 1. OBTENER Y VALIDAR EL ID DEL USUARIO LOGUEADO
        var userIdClaim = User.Claims
            .FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;

        if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int usuarioLogueadoId))
        {
            // Falla si el token no tiene el ID o es inválido.
            return Unauthorized("Usuario no autenticado o ID de usuario no válido en el token.");
        }

        // 2. ASIGNACIÓN FORZADA PARA PRUEBA DE COMUNIDAD
        // **IGNORAMOS dto.FuenteOficialId** y siempre usamos el ID del usuario logueado.
        // Si esta prueba funciona, significa que la lógica condicional del IF/ELSE es la que fallaba con tu JSON anterior.
        
        int? usuarioParaGuardar = usuarioLogueadoId;
        int? fuenteParaGuardar = null;

        if (dto.FuenteOficialId.HasValue)
        {
             // Si el frontend insiste en mandar un FuenteOficialId, 
             // forzaremos el UsuarioId, pero guardamos la FuenteOficialId si es importante.
             // Para esta PRUEBA DE DIAGNÓSTICO, vamos a darle prioridad al UsuarioId.
             fuenteParaGuardar = null; // Lo anulamos para forzar la comunidad
        }
        
        // ***************************************************************
        // NOTA: Si necesitas que el UsuarioId aparezca cuando envías un 
        // FuenteOficialId, DEBES añadir una columna ModeradorId a tu DB.
        // ***************************************************************


        // 3. CONSTRUIR EL MODELO COMPLETO PARA EL SERVICIO
        var publicacionData = new Publicacion
        {
            FuenteOficialId = fuenteParaGuardar, 
            UsuarioId = usuarioParaGuardar,     // <-- ¡Aquí está tu ID!
            
            TipoPublicacionId = dto.TipoPublicacionId,
            Titulo = dto.Titulo,
            Cuerpo = dto.Cuerpo,
            ImagenUrl = dto.ImagenUrl
        };
        
        // 4. Llamar al servicio
        var nuevaPublicacion = await _publicacionService.CrearPublicacionAsync(publicacionData);
        
        // 5. Retornar el objeto.
        return CreatedAtAction(nameof(GetPublicacionById), 
            new { publicacionId = nuevaPublicacion.PublicacionId }, 
            nuevaPublicacion);
    }

    
        // GET: api/Publicacion/5 (READ BY ID)
        [HttpGet("{publicacionId}")]
        public async Task<IActionResult> GetPublicacionById(int publicacionId)
        {
            var publicacion = await _publicacionService.GetPublicacionByIdAsync(publicacionId);
            if (publicacion == null) return NotFound();
            return Ok(publicacion);
        }

        // PUT: api/Publicacion/5 (UPDATE)
        [HttpPut("{publicacionId}")]
        public async Task<IActionResult> ActualizarPublicacion(int publicacionId, [FromBody] Publicacion publicacion)
        {
            if (publicacionId != publicacion.PublicacionId) return BadRequest("El ID de la ruta no coincide con el ID del cuerpo.");

            // Opcional: Cargar la publicación existente para verificar permisos antes de actualizar.
            var success = await _publicacionService.ActualizarPublicacionAsync(publicacion);

            if (!success) return NotFound();
            return NoContent(); // 204 No Content
        }

        // DELETE: api/Publicacion/5 (DELETE Lógico)
        [HttpDelete("{publicacionId}")]
        public async Task<IActionResult> EliminarPublicacion(int publicacionId)
        {
            var success = await _publicacionService.EliminarPublicacionAsync(publicacionId);
            if (!success) return NotFound();
            return NoContent(); // 204 No Content
        }
    }
}