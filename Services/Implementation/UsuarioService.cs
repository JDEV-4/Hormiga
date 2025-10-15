using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.Extensions.Configuration;
using WebApi.Model;
using Interface;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using System.Security.Cryptography;
using System.Data;
using WebApi.Model.DTO;

namespace Implementation
{
    public class UsuarioService : IUsuarioService
    {
        private readonly string _cs;
        private readonly IRolService _rolService;
        private readonly IConfiguration _config;

        public UsuarioService(IConfiguration config, IRolService rolService)
        {
            _config = config;
            _cs = config.GetConnectionString("DefaultConnection")!;
            _rolService = rolService;
        }

        public async Task<Usuario> Registrar(string nombreCompleto, string correo,string telefono, string password, int rolId)
        {
            // 1) Generar salt y hash
            byte[] salt;
            string hash = CreatePasswordHash(password, out salt);

            using var cn = new SqlConnection(_cs);
            await cn.OpenAsync();

            // 2) Insertar el usuario
            var sqlUsuario = @"
    INSERT INTO Usuario (NombreCompleto, Correo, Telefono, Contrasena, UsuarioSalt)
    OUTPUT INSERTED.Usuario_Id
    VALUES (@n, @c, @t, @h, @s)";
            using var cmdUsuario = new SqlCommand(sqlUsuario, cn);
            cmdUsuario.Parameters.AddWithValue("@n", nombreCompleto);
            cmdUsuario.Parameters.AddWithValue("@c", correo);
             cmdUsuario.Parameters.AddWithValue("@t", telefono);
            cmdUsuario.Parameters.AddWithValue("@h", hash);
            cmdUsuario.Parameters.AddWithValue("@s", salt);
            int usuarioId = (int)await cmdUsuario.ExecuteScalarAsync();

            // 3) Insertar relación Usuario-Rol (usa el nombre correcto de la tabla)
            var sqlRol = "INSERT INTO UserRol (Usuario_Id, Rol_Id) VALUES (@u, @r)";
            using var cmdRol = new SqlCommand(sqlRol, cn);
            cmdRol.Parameters.AddWithValue("@u", usuarioId);
            cmdRol.Parameters.AddWithValue("@r", rolId);
            await cmdRol.ExecuteNonQueryAsync();

            return new Usuario
            {
                Usuario_Id = usuarioId,
                NombreCompleto = nombreCompleto,
                Correo = correo,
                Telefono = telefono,
                Contrasena = hash,
                UsuarioSalt = salt
            };
        }



        public async Task<Usuario?> Autenticar(string nombreCompleto, string contrasena)
        {
            using var cn = new SqlConnection(_cs);
            var sql = "SELECT * FROM Usuario WHERE NombreCompleto = @n";
            using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@n", nombreCompleto);
            await cn.OpenAsync();
            using var rdr = await cmd.ExecuteReaderAsync();
            if (!rdr.Read()) return null;

            string storedHash = rdr.GetString(rdr.GetOrdinal("Contrasena"));
            byte[] salt = (byte[])rdr["UsuarioSalt"];
            if (!VerifyPasswordHash(contrasena, storedHash, salt))
                return null;

            return new Usuario
            {
                Usuario_Id = rdr.GetInt32(rdr.GetOrdinal("Usuario_Id")),
                NombreCompleto = nombreCompleto,
                Correo = rdr.GetString(rdr.GetOrdinal("Correo")),
                Contrasena = storedHash,
                UsuarioSalt = salt
            };
        }

        public async Task<IEnumerable<UsuarioConRolDTO>> GetAllAsync()
        {
            var lista = new List<UsuarioConRolDTO>();

            using var cn = new SqlConnection(_cs);
            using var cmd = new SqlCommand("SELECT Usuario_Id, NombreCompleto, Correo,Telefono FROM Usuario", cn);
            await cn.OpenAsync();
            using var rdr = await cmd.ExecuteReaderAsync();

            var usuariosTemporales = new List<(int Id, string Nombre, string Correo, string Telefono)>();

            while (await rdr.ReadAsync())
            {
                usuariosTemporales.Add((
                    rdr.GetInt32(0),
                    rdr.GetString(1),
                    rdr.GetString(2),
                    rdr.GetString(3) 

                ));
            }

            foreach (var (id, nombre, correo,telefono) in usuariosTemporales)
            {
                var roles = await _rolService.ObtenerRolesPorUsuarioAsync(id);
                var primerRol = roles.FirstOrDefault()?.Nombre_rol ?? "N/A";

                lista.Add(new UsuarioConRolDTO
                {
                    Id = id,
                    NombreCompleto = nombre,
                    Correo = correo,
                    Telefono = telefono,
                    RolNombre = primerRol
                });
            }

            return lista;
        }




        public async Task<UsuarioDto> GetByIdAsync(int usuarioId)
        {
            using var cn = new SqlConnection(_cs);
            var sql = "SELECT Usuario_Id, NombreCompleto, Correo, Telefono, Estado, FechaCreacion FROM Usuario WHERE Usuario_Id = @id";
            using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@id", usuarioId);
            await cn.OpenAsync();
            using var rdr = await cmd.ExecuteReaderAsync();
            if (!await rdr.ReadAsync()) return null;

            var usuarioDto = new UsuarioDto
            {
                Usuario_Id = rdr.GetInt32(rdr.GetOrdinal("Usuario_Id")),
                NombreCompleto = rdr.GetString(rdr.GetOrdinal("NombreCompleto")),
                Correo = rdr.GetString(rdr.GetOrdinal("Correo")),
Telefono = rdr.GetString(rdr.GetOrdinal("Telefono")),
                Roles = new List<string>()
            };

            rdr.Close();
            cn.Close();

            // Obtener roles (string)
            var roles = await _rolService.ObtenerRolesPorUsuarioAsync(usuarioId);
            usuarioDto.Roles = roles.Select(r => r.Nombre_rol).ToList();

            return usuarioDto;
        }




        // Implementation.UsuarioService
public async Task<IEnumerable<UsuarioBasicoDTO>> GetBasicAllAsync()
{
    var lista = new List<UsuarioBasicoDTO>();
    using var cn = new SqlConnection(_cs);
    using var cmd = new SqlCommand("SELECT Usuario_Id, NombreCompleto, Correo, Telefono FROM Usuario", cn);
    await cn.OpenAsync();
    using var rdr = await cmd.ExecuteReaderAsync();

    // Cachear los índices (Ordinal) para mayor claridad y rendimiento
    var idOrdinal = rdr.GetOrdinal("Usuario_Id");
    var nombreOrdinal = rdr.GetOrdinal("NombreCompleto");
    var correoOrdinal = rdr.GetOrdinal("Correo");
    var telefonoOrdinal = rdr.GetOrdinal("Telefono"); 

    while (await rdr.ReadAsync())
    {
        lista.Add(new UsuarioBasicoDTO
        {
            // Asumo que ID es NOT NULL
            Id = rdr.GetInt32(idOrdinal), 
            
            // Usar la verificación de NULL para todos los campos de texto, por seguridad
            NombreCompleto = rdr.IsDBNull(nombreOrdinal) ? string.Empty : rdr.GetString(nombreOrdinal),
            Correo = rdr.IsDBNull(correoOrdinal) ? string.Empty : rdr.GetString(correoOrdinal), // Corregido: si Correo puede ser NULL, esto lo maneja.
         
            // Esto ya lo tenías correctamente: manejo de NULL para Telefono
            Telefono = rdr.IsDBNull(telefonoOrdinal) ? null : rdr.GetString(telefonoOrdinal) 
        });
    }

    return lista;
}




        public string GenerateJwtToken(Usuario usuario)
        {
            var key = Encoding.ASCII.GetBytes(_config["Jwt:Key"]!);
            var roles = _rolService.ObtenerRolesPorUsuarioAsync(usuario.Usuario_Id)
                                    .GetAwaiter().GetResult();
            var claims = new List<Claim> {
                new Claim(ClaimTypes.NameIdentifier, usuario.Usuario_Id.ToString()),
                new Claim(ClaimTypes.Email, usuario.Correo),
                new Claim("nombre", usuario.NombreCompleto),
            };
            claims.AddRange(roles.Select(r => new Claim(ClaimTypes.Role, r.Nombre_rol)));

            var tokenDesc = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddHours(2),
                SigningCredentials = new SigningCredentials(
                    new SymmetricSecurityKey(key),
                    SecurityAlgorithms.HmacSha256Signature
                )
            };
            var handler = new JwtSecurityTokenHandler();
            var token = handler.CreateToken(tokenDesc);
            return handler.WriteToken(token);
        }

        // Helpers
        private string CreatePasswordHash(string pw, out byte[] salt)
        {
            using var hmac = new HMACSHA256();
            salt = hmac.Key;
            var bytes = Encoding.UTF8.GetBytes(pw).Concat(salt).ToArray();
            return Convert.ToBase64String(hmac.ComputeHash(bytes));
        }

        private bool VerifyPasswordHash(string pw, string hash, byte[] salt)
        {
            using var hmac = new HMACSHA256(salt);
            var bytes = Encoding.UTF8.GetBytes(pw).Concat(salt).ToArray();
            return Convert.ToBase64String(hmac.ComputeHash(bytes)) == hash;
        }

        public async Task<bool> Actualizar(Usuario usuario)
        {
            using var cn = new SqlConnection(_cs);
            var sql = @"
        UPDATE Usuario
        SET NombreCompleto = @nombre, Correo = @correo,Telefono = @telefono
        WHERE Usuario_Id = @id";

            using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@nombre", usuario.NombreCompleto);
            cmd.Parameters.AddWithValue("@correo", usuario.Correo);
            cmd.Parameters.AddWithValue("@telefono", usuario.Telefono);
            cmd.Parameters.AddWithValue("@id", usuario.Usuario_Id);

            await cn.OpenAsync();
            int filasAfectadas = await cmd.ExecuteNonQueryAsync();

            return filasAfectadas > 0;
        }



        public async Task<bool> Eliminar(int usuarioId)
        {
            using var cn = new SqlConnection(_cs);
            var sql = "DELETE FROM Usuario WHERE Usuario_Id = @id";
            using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@id", usuarioId);
            await cn.OpenAsync();
            int filas = await cmd.ExecuteNonQueryAsync();
            return filas > 0;
        }

        public Task<IEnumerable<Usuario>> GetAllWithRolesAsync()
        {
            throw new NotImplementedException();
        }
    }
}