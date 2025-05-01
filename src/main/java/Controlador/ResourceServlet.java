package Controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Servlet para manejar recursos estáticos (CSS, JS, imágenes)
 * Este servlet garantiza que los archivos estáticos se sirvan correctamente
 * independientemente de la URL desde donde se soliciten.
 */
@WebServlet(name = "ResourceServlet", urlPatterns = {"/resources/*"})
public class ResourceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtener la ruta solicitada
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.isEmpty() || "/".equals(pathInfo)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Eliminar la barra inicial si existe
        if (pathInfo.startsWith("/")) {
            pathInfo = pathInfo.substring(1);
        }
        
        // Construir la ruta real al recurso dentro de la aplicación web
        String realPath = getServletContext().getRealPath(pathInfo);
        Path resourcePath = Paths.get(realPath);
        
        // Verificar si el archivo existe
        if (!Files.exists(resourcePath) || Files.isDirectory(resourcePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Establecer el tipo MIME
        String contentType = getServletContext().getMimeType(pathInfo);
        if (contentType == null) {
            // Si no se puede determinar el tipo MIME, usar el binario genérico
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        
        // Establecer cabeceras de caché para mejorar el rendimiento
        response.setHeader("Cache-Control", "public, max-age=86400"); // Caché por 1 día
        
        // Enviar el archivo
        try (InputStream in = Files.newInputStream(resourcePath);
             OutputStream out = response.getOutputStream()) {
            
            // Copiar el contenido del archivo al flujo de salida
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet para manejar recursos estáticos como CSS, JavaScript e imágenes";
    }
}