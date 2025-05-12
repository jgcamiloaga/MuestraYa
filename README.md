# MuestraYa - Sistema de Gestión de Materiales

MuestraYa es un sistema web desarrollado en Java que permite la gestión completa de materiales y productos con control de usuarios, categorías y gestión de imágenes.

## 📋 Descripción

MuestraYa es una aplicación web que permite a los usuarios registrar, visualizar, editar y eliminar materiales clasificados por categorías. El sistema incluye control de acceso mediante inicio de sesión, validación de seguridad en contraseñas y funcionalidades específicas según el rol del usuario.

## 🚀 Características principales

- **Gestión de usuarios**: Registro de usuarios, autenticación, perfiles administrativos
- **Gestión de materiales**: Creación, visualización, edición y eliminación de productos
- **Categorización**: Organización de productos por categorías (Herramientas, Ropa, Cocina, Electrónica, Construcción, Oficina)
- **Gestión de imágenes**: Subida y visualización de imágenes de los productos
- **Interfaz responsive**: Diseñada con Bootstrap y FontAwesome para una experiencia de usuario óptima
- **Múltiples vistas**: Visualización en formato de tablas o tarjetas
- **Seguridad**: Filtros de autenticación, validación de datos, encriptación de contraseñas

## 🛠️ Tecnologías utilizadas

- **Backend**: Java EE, Servlets, JSP, JSTL
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap, FontAwesome
- **Persistencia**: Base de datos relacional
- **Seguridad**: Filtros de autenticación, encriptación de contraseñas
- **Servidor**: Apache Tomcat
- **Build**: Maven

## 📦 Estructura del proyecto

El proyecto sigue una arquitectura MVC (Modelo-Vista-Controlador):

- **Modelo**: Clases DTO (Data Transfer Object) y DAO (Data Access Object)
- **Vista**: Archivos JSP para la interfaz de usuario
- **Controlador**: Servlets que manejan las peticiones HTTP

## 🔧 Instalación y configuración

1. Clona el repositorio
2. Configura una base de datos compatible
3. Actualiza la configuración de conexión en `src/main/java/servicios/ConexionDB.java`
4. Compila el proyecto usando Maven: `mvn clean package`
5. Despliega el archivo WAR generado en tu servidor Tomcat

## 📝 Funcionalidades

- Registro e inicio de sesión de usuarios
- Validación de seguridad de contraseñas
- Listado de materiales (vista de tabla y tarjetas)
- Registro de nuevos materiales con imágenes
- Eliminación de materiales
- Administración de usuarios (creación de administradores)

## 👥 Autenticación y autorización

El sistema cuenta con diferentes roles de usuario:

- **Usuario normal**: Puede visualizar materiales
- **Administrador**: Puede gestionar materiales y otros usuarios

## 🖼️ Capturas de pantalla

(Aquí se podrían incluir capturas de pantalla de la aplicación)

## 👨‍💻 Desarrollador

- **Johann Camiloaga Cuenca** - Desarrollador Full Stack
  - [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/jgcamiloaga)
  - [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/jgcamiloaga)
  - [![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/jgcamiloaga)

## 📄 Licencia

Copyright © 2025 MuestraYa. Todos los derechos reservados.
