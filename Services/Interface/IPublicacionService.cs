using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;
using WebApi.Model.DTO; 
namespace Interface
{
    public interface IPublicacionService
    {
         Task<IEnumerable<PublicacionFeedDTO>> GetFeedAsync(int pagina, int tamañoPagina);
        
        // 2. Obtener una publicación específica por ID
        Task<Publicacion> GetPublicacionByIdAsync(int publicacionId);

        // 3. (Opcional) Obtener una lista simple de todas las publicaciones activas
        Task<IEnumerable<Publicacion>> ListarPublicacionesActivasAsync();


        // ================== CREATE (Creación) ==================
        
        // 4. Crear una nueva publicación a partir de un DTO
        Task<Publicacion> CrearPublicacionAsync(Publicacion publicacion); 


        // ================== UPDATE (Actualización) ==================
        
        // 5. Actualizar completamente una publicación existente
        Task<bool> ActualizarPublicacionAsync(Publicacion publicacion);


        // ================== DELETE (Eliminación Lógica) ==================
        
        // 6. Eliminar lógicamente (cambiar Estado a 0)
        Task<bool> EliminarPublicacionAsync(int publicacionId);
    }
}