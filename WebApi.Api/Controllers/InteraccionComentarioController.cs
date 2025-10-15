using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
    [Route("api/publicacion")]
    [Authorize]
    public class InteraccionComentarioController : Controller
    {
        private readonly IInteraccionComentarioService _service;

        public InteraccionComentarioController(IInteraccionComentarioService service)
        {
            _service = service;
        }

        // Helper para obtener el ID del usuario
        private int? GetUsuarioId()
        {
            var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;
            if (int.TryParse(userIdClaim, out int usuarioId))
            {
                return usuarioId;
            }
            return null;
        }

        // ==========================================================
        // INTERACCIONES (LIKES/DISLIKES/ETC.)
        // ==========================================================

        // POST: api/publicacion/{publicacionId}/interaccion
        // El frontend envía solo el PublicacionId y el TipoInteraccion
        [HttpPost("{publicacionId}/interaccion")]
        public async Task<IActionResult> RegistrarInteraccion(int publicacionId, [FromBody] InteraccionDTO dto)
        {
            var usuarioId = GetUsuarioId();
            if (!usuarioId.HasValue) return Unauthorized("Usuario no autenticado.");

            var interaccion = new InteraccionPublicacion
            {
                PublicacionId = publicacionId,
                UsuarioId = usuarioId.Value,
                TipoInteraccion = dto.TipoInteraccion.ToUpper() // 'LIKE', 'SHARE', etc.
            };

            try
            {
                var nuevaInteraccion = await _service.CrearInteraccionAsync(interaccion);
                // 201 Created
                return Created($"/api/publicacion/{publicacionId}/interaccion", nuevaInteraccion);
            }
            catch (InvalidOperationException ex) when (ex.Message.Contains("El usuario ya ha realizado esta interacción"))
            {
                // Error de clave única, ya dio like.
                return Conflict("El usuario ya ha registrado esta interacción para esta publicación.");
            }
            catch (SqlException ex) when (ex.Number == 547)
            {
                // Error de clave foránea (PublicacionId no existe)
                return NotFound("La publicación especificada no existe.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Error al registrar la interacción: " + ex.Message);
            }
        }

        // DELETE: api/publicacion/{publicacionId}/interaccion/{tipoInteraccion}
        // Para quitar un Like o una interacción
        [HttpDelete("{publicacionId}/interaccion/{tipoInteraccion}")]
        public async Task<IActionResult> EliminarInteraccion(int publicacionId, string tipoInteraccion)
        {
            var usuarioId = GetUsuarioId();
            if (!usuarioId.HasValue) return Unauthorized("Usuario no autenticado.");

            var success = await _service.EliminarInteraccionAsync(publicacionId, usuarioId.Value, tipoInteraccion.ToUpper());

            if (success)
            {
                return NoContent(); // 204 Success, no content
            }
            return NotFound("Interacción no encontrada o no fue creada por este usuario.");
        }

        // GET: api/publicacion/{publicacionId}/likes/count
        [HttpGet("{publicacionId}/likes/count")]
        [AllowAnonymous] // El conteo es público
        public async Task<IActionResult> ContarLikes(int publicacionId)
        {
            var count = await _service.ContarInteraccionesPorPublicacionAsync(publicacionId, "LIKE");
            return Ok(new { PublicacionId = publicacionId, Likes = count });
        }


        // ==========================================================
        // COMENTARIOS
        // ==========================================================

        // POST: api/publicacion/{publicacionId}/comentario
        [HttpPost("{publicacionId}/comentario")]
        public async Task<IActionResult> CrearComentario(int publicacionId, [FromBody] ComentarioCrearDTO dto)
        {
            var usuarioId = GetUsuarioId();
            if (!usuarioId.HasValue) return Unauthorized("Usuario no autenticado.");

            var comentario = new Comentario
            {
                PublicacionId = publicacionId,
                UsuarioId = usuarioId.Value,
                TextoComentario = dto.TextoComentario
            };

            try
            {
                var nuevoComentario = await _service.CrearComentarioAsync(comentario);
                return Created($"/api/publicacion/{publicacionId}/comentarios", nuevoComentario);
            }
            catch (Exception ex)
            {
                // Manejar error de clave foránea si la PublicacionId no existe
                return StatusCode(500, "Error al crear el comentario: " + ex.Message);
            }
        }

        // GET: api/publicacion/{publicacionId}/comentarios
        [HttpGet("{publicacionId}/comentarios")]
        [AllowAnonymous] // Los comentarios deben ser visibles para todos.
        public async Task<IActionResult> ObtenerComentarios(int publicacionId)
        {
            var comentarios = await _service.ObtenerComentariosPorPublicacionAsync(publicacionId);
            return Ok(comentarios);
        }

        // DELETE: api/publicacion/comentario/{comentarioId}
        [HttpDelete("comentario/{comentarioId}")]
        public async Task<IActionResult> EliminarComentario(int comentarioId)
        {
            var usuarioId = GetUsuarioId();
            if (!usuarioId.HasValue) return Unauthorized("Usuario no autenticado.");

            // Intentamos eliminar el comentario, verificando que el usuario logueado sea el autor.
            var success = await _service.EliminarComentarioAsync(comentarioId, usuarioId.Value);

            if (success)
            {
                return NoContent(); // 204 Success
            }
            // No se encontró el comentario O el usuario no es el dueño.
            return Forbid("No tienes permiso para eliminar este comentario.");
        }
    }
}