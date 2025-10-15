SET IDENTITY_INSERT [dbo].[Rol] ON; -- Necesario para SQL Server si deseas especificar los Rol_Id manualmente

INSERT INTO [dbo].[Rol] ([Rol_Id], [Nombre_rol], [Descripcion]) VALUES
(1, 'Administrador', 'Control total del sistema, gestión de usuarios y publicaciones oficiales.'),
(2, 'Brigadista', 'Usuario autorizado para atender y actualizar el estado de los incidentes.'),
(3, 'Ciudadano', 'Usuario estándar de la aplicación para reportar incidentes, acceder a educación y usar el chatbot.');

SET IDENTITY_INSERT [dbo].[Rol] OFF;
GO

 -- Necesario si deseas especificar los Usuario_Id

INSERT INTO [dbo].[Usuario] ([NombreCompleto], [Correo], [Contrasena], [UsuarioSalt], [Telefono]) VALUES
( 'Carlos Administradora', 'admin@app.com', 'hashed_admin_pass', NULL, '55512345'),
( 'Maria Brigadistaa', 'maria@brigada.com', 'hashed_brigada_pass', NULL, '55554321'),
( 'Juan Ciudadanos', 'juan@ciudadano.com', 'hashed_user_pass', NULL, '55598465');



INSERT INTO [dbo].[Rol] ([Nombre_rol], [Descripcion]) VALUES
('Administrador', 'Control total del sistema, gestión de usuarios y publicaciones oficiales.'),
('Brigadista', 'Usuario autorizado para atender y actualizar el estado de los incidentes.'),
('Ciudadano', 'Usuario estándar de la aplicación para reportar incidentes, acceder a educación y usar el chatbot.');
GO





INSERT INTO [dbo].[Usuario] ([NombreCompleto], [Correo], [Contrasena], [UsuarioSalt], [Telefono]) VALUES
('Carlos Administrador', 'admin@apsp.com', 'hashed_admin_pass', NULL, '55512345'),
('Maria Brigadista', 'maria@brigadda.com', 'hashed_brigada_pass', NULL, '55554321'),
('Juan Ciudadano', 'juan@ciudadadno.com', 'hashed_user_pass', NULL, '55598765');
GO
select * from usuario
select * from rol
delete from usuario
select * from UserRol


INSERT INTO [dbo].[UserRol] ([Usuario_Id], [Rol_Id]) VALUES
(309, 1), -- Carlos (ID 1) es Administrador (ID 1)
(310, 2), -- Maria (ID 2) es Brigadista (ID 2)
(311, 3) -- Juan (ID 3) es Ciudadano (ID 3)
GO




-----------------------------------------------------
-- 1. Tablas de Catálogo (para estandarizar datos) --
-----------------------------------------------------

-- Mejora: Se estandariza el tipo de publicación (Oficial vs Comunidad)
CREATE TABLE [dbo].[TipoPublicacion] (
    [TipoPublicacionId] INT PRIMARY KEY IDENTITY(1,1),
    [Nombre] VARCHAR(50) NOT NULL UNIQUE, -- Ej: 'Oficial', 'Comunidad', 'Alerta'
    [Descripcion] VARCHAR(255) NULL
);

-- Insertar datos iniciales
INSERT INTO [dbo].[TipoPublicacion] (Nombre) VALUES ('Oficial'), ('Comunidad');







-- Fuentes Oficiales (Ej: SINAPRED, Alcaldía). La estructura original es buena.
CREATE TABLE [dbo].[FuenteOficial] (
    [FuenteOficialId] INT PRIMARY KEY IDENTITY(1,1),
    [Nombre] NVARCHAR(100) UNIQUE NOT NULL, 
    [LogoUrl] NVARCHAR(255) NULL
);


ALTER TABLE [dbo].[FuenteOficial] ADD [Estado] BIT NOT NULL DEFAULT 1;

-- Procedimiento para Agregar Fuente Oficial
CREATE PROCEDURE sp_AddFuenteOficial
    @Nombre NVARCHAR(100),
    @LogoUrl NVARCHAR(255)
AS
BEGIN
    INSERT INTO [dbo].[FuenteOficial] (Nombre, LogoUrl, Estado)
    VALUES (@Nombre, @LogoUrl, 1);
    SELECT SCOPE_IDENTITY();
END;

-- Procedimiento para Actualizar Fuente Oficial
CREATE PROCEDURE sp_UpdateFuenteOficial
    @FuenteOficialId INT,
    @Nombre NVARCHAR(100),
    @LogoUrl NVARCHAR(255),
    @Estado BIT
AS
BEGIN
    UPDATE [dbo].[FuenteOficial]
    SET Nombre = @Nombre,
        LogoUrl = @LogoUrl,
        Estado = @Estado
    WHERE FuenteOficialId = @FuenteOficialId;
END;

-- Procedimiento para Listar Fuentes Oficiales Activas
CREATE PROCEDURE sp_ListarFuentesActivas
AS
BEGIN
    SELECT * FROM [dbo].[FuenteOficial] WHERE Estado = 1 ORDER BY Nombre;
END;

-- Procedimiento para Mostrar Fuente Oficial por ID (si está activa)
CREATE PROCEDURE sp_MostrarFuenteOficial
    @FuenteOficialId INT
AS
BEGIN
    SELECT * FROM [dbo].[FuenteOficial] WHERE FuenteOficialId = @FuenteOficialId AND Estado = 1;
END;

-- Procedimiento para Eliminar (Desactivar) Fuente Oficial
CREATE PROCEDURE sp_EliminarFuenteOficial
    @FuenteOficialId INT
AS
BEGIN
    UPDATE [dbo].[FuenteOficial]
    SET Estado = 0
    WHERE FuenteOficialId = @FuenteOficialId;
END;












------------------------------------------
-- 2. Tablas de Contenido (Publicaciones) --
------------------------------------------

CREATE TABLE [dbo].[Publicacion] (
    [PublicacionId] INT PRIMARY KEY IDENTITY(1,1),
    [FuenteOficialId] INT NULL REFERENCES [dbo].[FuenteOficial]([FuenteOficialId]), 
    [UsuarioId] INT NULL REFERENCES [dbo].[Usuario]([Usuario_Id]), 
    [TipoPublicacionId] INT NOT NULL REFERENCES [dbo].[TipoPublicacion]([TipoPublicacionId]),
    [Titulo] NVARCHAR(200) NOT NULL,
    [Cuerpo] NVARCHAR(MAX) NOT NULL,
    [ImagenUrl] NVARCHAR(255) NULL,
    [FechaPublicacion] DATETIME DEFAULT GETDATE(),
    [Activo] BIT DEFAULT 1
);

------------------------------------------------
-- 3. Tablas de Interacción (Comentarios y Likes) --
------------------------------------------------

-- Mejora: Simplificamos a solo dos tipos de interacción (Like/Dislike o Reacciones)
CREATE TABLE [dbo].[InteraccionPublicacion] (
    [InteraccionId] INT PRIMARY KEY IDENTITY(1,1),
    [PublicacionId] INT NOT NULL REFERENCES [dbo].[Publicacion]([PublicacionId]),
    [UsuarioId] INT NOT NULL REFERENCES [dbo].[Usuario]([Usuario_Id]),
    
    -- Ej: 'Like', 'Share', 'Saved' (si es necesario un catálogo, creamos TipoInteraccion)
    [TipoInteraccion] VARCHAR(20) NOT NULL, 
    
    -- Una interacción por usuario por publicación. Ideal para "Me Gusta"
    CONSTRAINT UQ_Usuario_Publicacion_Interaccion UNIQUE ([PublicacionId], [UsuarioId], [TipoInteraccion]), 
    
    [FechaInteraccion] DATETIME DEFAULT GETDATE()
);

ALTER TABLE [dbo].[Publicacion] ADD [Estado] BIT NOT NULL DEFAULT 1;



-- Procedimiento para Agregar Publicación
CREATE PROCEDURE sp_AddPublicacion
    @FuenteOficialId INT,
    @UsuarioId INT,
    @TipoPublicacionId INT,
    @Titulo NVARCHAR(200),
    @Cuerpo NVARCHAR(MAX),
    @ImagenUrl NVARCHAR(255)
AS
BEGIN
    INSERT INTO [dbo].[Publicacion] (FuenteOficialId, UsuarioId, TipoPublicacionId, Titulo, Cuerpo, ImagenUrl, Estado)
    VALUES (@FuenteOficialId, @UsuarioId, @TipoPublicacionId, @Titulo, @Cuerpo, @ImagenUrl, 1);
    SELECT SCOPE_IDENTITY();
END;
GO

-- Procedimiento para Actualizar Publicación
CREATE PROCEDURE sp_UpdatePublicacion
    @PublicacionId INT,
    @FuenteOficialId INT,
    @UsuarioId INT,
    @TipoPublicacionId INT,
    @Titulo NVARCHAR(200),
    @Cuerpo NVARCHAR(MAX),
    @ImagenUrl NVARCHAR(255),
    @Estado BIT
AS
BEGIN
    UPDATE [dbo].[Publicacion]
    SET FuenteOficialId = @FuenteOficialId,
        UsuarioId = @UsuarioId,
        TipoPublicacionId = @TipoPublicacionId,
        Titulo = @Titulo,
        Cuerpo = @Cuerpo,
        ImagenUrl = @ImagenUrl,
        Estado = @Estado
    WHERE PublicacionId = @PublicacionId;
END;
GO

-- Procedimiento para Listar Publicaciones Activas
-- Nota: La lógica del Feed (con LEFT JOINs y CONTEOS) se maneja mejor directamente en el servicio o en un SP dedicado al Feed.
CREATE PROCEDURE sp_ListarPublicacionesActivas
AS
BEGIN
    SELECT * FROM [dbo].[Publicacion] WHERE Estado = 1 ORDER BY FechaPublicacion DESC;
END;
GO

-- Procedimiento para Mostrar Publicación por ID (si está activa)
CREATE PROCEDURE sp_MostrarPublicacion
    @PublicacionId INT
AS
BEGIN
    SELECT * FROM [dbo].[Publicacion] WHERE PublicacionId = @PublicacionId AND Estado = 1;
END;
GO

-- Procedimiento para Eliminar (Desactivar) Publicación
CREATE PROCEDURE sp_EliminarPublicacion
    @PublicacionId INT
AS
BEGIN
    UPDATE [dbo].[Publicacion]
    SET Estado = 0
    WHERE PublicacionId = @PublicacionId;
END;
GO

select *from Usuario
select * from TipoPublicacion
select * from publicacion


















CREATE TABLE [dbo].[InteraccionPublicacion] (
    [InteraccionId] INT PRIMARY KEY IDENTITY(1,1),
    [PublicacionId] INT NOT NULL REFERENCES [dbo].[Publicacion]([PublicacionId]),
    [UsuarioId] INT NOT NULL REFERENCES [dbo].[Usuario]([Usuario_Id]),
    
    -- Ej: 'Like', 'Share', 'Saved' (si es necesario un catálogo, creamos TipoInteraccion)
    [TipoInteraccion] VARCHAR(20) NOT NULL, 
    
    -- Una interacción por usuario por publicación. Ideal para "Me Gusta"
    CONSTRAINT UQ_Usuario_Publicacion_Interaccion UNIQUE ([PublicacionId], [UsuarioId], [TipoInteraccion]), 
    
    [FechaInteraccion] DATETIME DEFAULT GETDATE()
);



-- Interacciones (Likes, Shares, etc.)
CREATE TABLE [dbo].[InteraccionPublicacion] (
    [InteraccionId] INT PRIMARY KEY IDENTITY(1,1),
    [PublicacionId] INT NOT NULL REFERENCES [dbo].[Publicacion]([PublicacionId]),
    [UsuarioId] INT NOT NULL REFERENCES [dbo].[Usuario]([Usuario_Id]),
    [TipoInteraccion] VARCHAR(20) NOT NULL, 
    CONSTRAINT UQ_Usuario_Publicacion_Interaccion UNIQUE ([PublicacionId], [UsuarioId], [TipoInteraccion]), 
    [FechaInteraccion] DATETIME DEFAULT GETDATE()
);

-- Comentarios
CREATE TABLE [dbo].[Comentario] (
    [ComentarioId] INT PRIMARY KEY IDENTITY(1,1),
    [PublicacionId] INT NOT NULL REFERENCES [dbo].[Publicacion]([PublicacionId]),
    [UsuarioId] INT NOT NULL REFERENCES [dbo].[Usuario]([Usuario_Id]),
    [TextoComentario] NVARCHAR(MAX) NOT NULL,
    [FechaComentario] DATETIME DEFAULT GETDATE()
);




CREATE TABLE [dbo].[Comentario] (
    [ComentarioId] INT PRIMARY KEY IDENTITY(1,1),
    [PublicacionId] INT NOT NULL REFERENCES [dbo].[Publicacion]([PublicacionId]),
    [UsuarioId] INT NOT NULL REFERENCES [dbo].[Usuario]([Usuario_Id]),
    [TextoComentario] NVARCHAR(MAX) NOT NULL,
    [FechaComentario] DATETIME DEFAULT GETDATE(),
    [ComentarioPadreId] INT NULL REFERENCES [dbo].[Comentario]([ComentarioId]) -- Para anidar respuestas
);

------------------------------------------------
-- 4. Tablas de Notificaciones (Notificaciones) --
------------------------------------------------

CREATE TABLE [dbo].[Notificacion] (
    [NotificacionId] INT PRIMARY KEY IDENTITY(1,1),
    
    -- Relaciones
    [UsuarioId] INT NULL REFERENCES [dbo].[Usuario]([Usuario_Id]),             -- Receptor (NULL para todos)
    [PublicacionId] INT NULL REFERENCES [dbo].[Publicacion]([PublicacionId]), -- Si notifica sobre una publicación
    -- [IncidenteId] INT NULL REFERENCES [dbo].[Incidente]([IncidenteId]),    -- Si aplica, asumiendo que tienes una tabla Incidente
    
    -- Contenido
    [Titulo] NVARCHAR(100) NOT NULL,
    [Mensaje] NVARCHAR(MAX) NOT NULL,
    [UrlDestino] NVARCHAR(255) NULL, -- URL o ruta a la que debe llevar la notificación
    
    -- Metadata
    [Tipo] NVARCHAR(50) NOT NULL,    -- Ej: 'Alerta', 'Nuevo Comentario', 'Sistema'
    [FechaEnvio] DATETIME DEFAULT GETDATE(),
    [Leida] BIT DEFAULT 0
);




-- ==========================================================
-- Interacciones (Likes)
-- ==========================================================

-- No necesitamos un SP para INSERTAR Likes porque la lógica 
-- la manejamos directamente con SQL + OUTPUT en el servicio, 
-- lo que nos permite capturar el error UNIQUE (2627) en C#.
-- Si prefieres usar SPs para todo, aquí está el INSERT:

IF OBJECT_ID('sp_AddInteraccion') IS NOT NULL DROP PROCEDURE sp_AddInteraccion;
GO

CREATE PROCEDURE sp_AddInteraccion
    @PublicacionId INT,
    @UsuarioId INT,
    @TipoInteraccion VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO InteraccionPublicacion (PublicacionId, UsuarioId, TipoInteraccion)
    OUTPUT INSERTED.InteraccionId, INSERTED.FechaInteraccion
    VALUES (@PublicacionId, @UsuarioId, @TipoInteraccion);
END
GO

-- ==========================================================
-- Comentarios
-- ==========================================================

IF OBJECT_ID('sp_AddComentario') IS NOT NULL DROP PROCEDURE sp_AddComentario;
GO

CREATE PROCEDURE sp_AddComentario
    @PublicacionId INT,
    @UsuarioId INT,
    @TextoComentario NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Comentario (PublicacionId, UsuarioId, TextoComentario)
    OUTPUT INSERTED.ComentarioId, INSERTED.FechaComentario
    VALUES (@PublicacionId, @UsuarioId, @TextoComentario);
END
GO



-- GESTIÓN DE INCIDENTES
CREATE TABLE Tipos_Incidente (
    tipo_incidente_id INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) UNIQUE NOT NULL, -- Ej: 'Sismo', 'Deslave', 'Incendio'
    icono_mapa VARCHAR(50), -- Código o URL del ícono
    color_hex CHAR(7) -- Color asociado para visualización (ej: '#FF0000')
);

CREATE TABLE Incidentes (
    incidente_id INT PRIMARY KEY IDENTITY(1,1),
    usuario_id INT NOT NULL REFERENCES Usuarios(usuario_id), -- Quién lo reportó
    tipo_incidente_id INT NOT NULL REFERENCES Tipos_Incidente(tipo_incidente_id),
    descripcion TEXT NOT NULL,
    latitud DECIMAL(10, 7) NOT NULL, -- Precisión de 7 decimales
    longitud DECIMAL(10, 7) NOT NULL, -- Precisión de 7 decimales
    estado VARCHAR(20) NOT NULL DEFAULT 'Reportado', -- Ej: 'Reportado', 'En Atención', 'Resuelto'
    fecha_reporte DATETIME DEFAULT GETDATE(),
    fecha_cierre DATETIME
);

CREATE TABLE Fotos_Incidente (
    foto_id INT PRIMARY KEY IDENTITY(1,1),
    incidente_id INT NOT NULL REFERENCES Incidentes(incidente_id),
    url_foto VARCHAR(255) NOT NULL,
    fecha_subida DATETIME DEFAULT GETDATE()
);













-- MÓDULO EDUCATIVO Y GAMIFICACIÓN
CREATE TABLE Amenazas_Educativas (
    amenaza_id INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) UNIQUE NOT NULL, -- Ej: 'Sismos', 'Deslaves', 'Huracanes'
    descripcion_corta TEXT,
    icono_url VARCHAR(255)
);

CREATE TABLE Contenido_Educativo (
    contenido_id INT PRIMARY KEY IDENTITY(1,1),
    amenaza_id INT NOT NULL REFERENCES Amenazas_Educativas(amenaza_id),
    titulo VARCHAR(100) NOT NULL,
    fase VARCHAR(50) NOT NULL, -- Ej: 'Antes', 'Durante', 'Después'
    texto_seccion TEXT,
    orden INT,
    tipo_recurso VARCHAR(50) -- Ej: 'Texto', 'Video', 'Infografía'
);

CREATE TABLE Quizzes (
    quiz_id INT PRIMARY KEY IDENTITY(1,1),
    amenaza_id INT NOT NULL REFERENCES Amenazas_Educativas(amenaza_id),
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE Preguntas_Quiz (
    pregunta_id INT PRIMARY KEY IDENTITY(1,1),
    quiz_id INT NOT NULL REFERENCES Quizzes(quiz_id),
    texto_pregunta TEXT NOT NULL,
    puntos INT DEFAULT 1
);

CREATE TABLE Opciones_Pregunta (
    opcion_id INT PRIMARY KEY IDENTITY(1,1),
    pregunta_id INT NOT NULL REFERENCES Preguntas_Quiz(pregunta_id),
    texto_opcion VARCHAR(255) NOT NULL,
    es_correcta BIT NOT NULL DEFAULT 0 -- BIT es el booleano estándar (0=Falso, 1=Verdadero)
);

CREATE TABLE Resultados_Usuario_Quiz (
    resultado_id INT PRIMARY KEY IDENTITY(1,1),
    usuario_id INT NOT NULL REFERENCES Usuario(usuario_id),
    quiz_id INT NOT NULL REFERENCES Quizzes(quiz_id),
    puntaje_obtenido INT,
    fecha_realizacion DATETIME DEFAULT GETDATE()
);



-- AGREGAR AMENAZA
CREATE PROCEDURE sp_AddAmenazaEducativa
    @nombre VARCHAR(50),
    @descripcion_corta TEXT,
    @icono_url VARCHAR(255)
AS
BEGIN
    INSERT INTO Amenazas_Educativas (nombre, descripcion_corta, icono_url)
    VALUES (@nombre, @descripcion_corta, @icono_url);
    SELECT SCOPE_IDENTITY();
END;
GO

-- ACTUALIZAR AMENAZA
CREATE PROCEDURE sp_UpdateAmenazaEducativa
    @amenaza_id INT,
    @nombre VARCHAR(50),
    @descripcion_corta TEXT,
    @icono_url VARCHAR(255)
AS
BEGIN
    UPDATE Amenazas_Educativas
    SET nombre = @nombre,
        descripcion_corta = @descripcion_corta,
        icono_url = @icono_url
    WHERE amenaza_id = @amenaza_id;
END;
GO

-- LISTAR AMENAZAS
CREATE PROCEDURE sp_ListarAmenazasEducativas
AS
BEGIN
    SELECT * FROM Amenazas_Educativas ORDER BY nombre;
END;
GO

-- OBTENER POR ID
CREATE PROCEDURE sp_GetAmenazaEducativa
    @amenaza_id INT
AS
BEGIN
    SELECT * FROM Amenazas_Educativas WHERE amenaza_id = @amenaza_id;
END;
GO

-- ELIMINAR (físico)
CREATE PROCEDURE sp_DeleteAmenazaEducativa
    @amenaza_id INT
AS
BEGIN
    DELETE FROM Amenazas_Educativas WHERE amenaza_id = @amenaza_id;
END;
GO

