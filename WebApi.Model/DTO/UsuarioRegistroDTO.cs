


namespace WebApi.Model.DTO
{
    public class UsuarioRegistroDTO
    {
        public string NombreCompleto { get; set; }
        public string Correo { get; set; }
        public string Telefono { get; set; }
        public string Contrasena { get; set; }
        public int RolId { get; set; } = 1;
    }
}

