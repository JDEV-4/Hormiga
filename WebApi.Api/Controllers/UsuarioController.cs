using Microsoft.AspNetCore.Mvc;
using WebApi.Model;
using Interface;
using WebApi.Model.DTO;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsuarioController : ControllerBase
    {
        private readonly IUsuarioService _usuarioService;
        private readonly IRolService _rolService;

        public UsuarioController(IUsuarioService usuarioService, IRolService rolService)
        {
            _usuarioService = usuarioService ?? throw new ArgumentNullException(nameof(usuarioService));
            _rolService = rolService ?? throw new ArgumentNullException(nameof(rolService));
        }


        // POST: api/Usuario/registrar
        [HttpPost("registrar")]
        public async Task<IActionResult> Registrar([FromBody] UsuarioRegistroDTO dto)
        {
            try
            {
                var nuevoUsuario = await _usuarioService.Registrar(
                    dto.NombreCompleto,
                    dto.Correo,
 dto.Telefono,
                    dto.Contrasena,
                    dto.RolId
                );
                return Ok(nuevoUsuario);
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = "Error al registrar", detalle = ex.Message });
            }
        }


        // POST: api/Usuario/autenticar
        [HttpPost("autenticar")]
        public async Task<IActionResult> Autenticar([FromBody] UsuarioLoginDTO loginDto)
        {
            var user = await _usuarioService.Autenticar(loginDto.NombreCompleto, loginDto.Contrasena);
            if (user == null)
                return Unauthorized(new { mensaje = "Credenciales inválidas" });

            var token = _usuarioService.GenerateJwtToken(user);
            return Ok(new { token });
        }



        // WebApi.Api/Controllers/UsuarioController.cs

     // WebApi.Api/Controllers/UsuarioController.cs

 [HttpGet]
    // Debe ser async y retornar Task<IActionResult>
    public async Task<IActionResult> GetAll() 
    {
        try
        {
            // ¡Llama al método básico y espera su resultado!
            var usuarios = await _usuarioService.GetBasicAllAsync(); 
            
            return Ok(usuarios);
        }
        catch (Exception ex)
        {
            // En caso de fallo (aunque ya corregimos los errores de NULL y Task)
            return StatusCode(500, new { mensaje = "Error al obtener usuarios básicos", detalle = ex.Message });
        }
    }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var usuarioDto = await _usuarioService.GetByIdAsync(id);

            if (usuarioDto == null)
                return NotFound(new { mensaje = "Empleado no encontrado" });

            return Ok(usuarioDto);
        }




        [HttpGet("con-roles")]
        public async Task<IActionResult> GetUsuariosConRoles()
        {
            var usuarios = await _usuarioService.GetAllAsync();
            return Ok(usuarios);
        }

        [HttpPut("editar/{id}")]
        public async Task<IActionResult> Editar(int id, [FromBody] UsuarioEditarDTO dto)
        {
            if (dto == null)
                return BadRequest(new { mensaje = "Datos inválidos" });

            try
            {
                if (_usuarioService == null)
                    return StatusCode(500, new { mensaje = "_usuarioService no está inyectado" });

                if (_rolService == null)
                    return StatusCode(500, new { mensaje = "_rolService no está inyectado" });

                var usuario = new Usuario
                {
                    Usuario_Id = id,
                    NombreCompleto = dto.NombreCompleto,
Telefono = dto.Telefono,
                    Correo = dto.Correo,
                };

                bool actualizado = await _usuarioService.Actualizar(usuario);

                if (!actualizado)
                    return NotFound(new { mensaje = "No se pudo actualizar el usuario" });

                if (dto.Roles != null && dto.Roles.Count > 0)
                {
                    await _rolService.ActualizarRolesUsuario(id, dto.Roles);
                }

                return Ok(new { mensaje = "Usuario actualizado correctamente" });
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = "Error al actualizar", detalle = ex.Message });
            }
        }


        [HttpDelete("eliminar/{id}")]
        public async Task<IActionResult> Eliminar(int id)
        {
            try
            {
                var eliminado = await _usuarioService.Eliminar(id);

                if (!eliminado)
                    return NotFound(new { mensaje = "No se pudo eliminar el usuario" });

                return Ok(new { mensaje = "Usuario eliminado correctamente" });
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = "Error al eliminar", detalle = ex.Message });
            }
        }

    }
} 