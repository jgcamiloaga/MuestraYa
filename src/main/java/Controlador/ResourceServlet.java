package controlador;

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
@WebServlet(name = "ResourceServlet", urlPatterns = {"/js/*", "/css/*", "/resources/*"})
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
        
        String resourcePath;
        String contentType;
        
        // Determine resource path based on URL pattern
        if (request.getServletPath().equals("/js")) {
            resourcePath = "/recursos/js" + pathInfo;
            contentType = "text/javascript";
        } else if (request.getServletPath().equals("/css")) {
            resourcePath = "/recursos/css" + pathInfo;
            contentType = "text/css";
        } else {
            // Eliminar la barra inicial si existe
            if (pathInfo.startsWith("/")) {
                pathInfo = pathInfo.substring(1);
            }
            
            // Construir la ruta real al recurso dentro de la aplicación web
            String realPath = getServletContext().getRealPath(pathInfo);
            Path resourcePathObj = Paths.get(realPath);
            
            // Verificar si el archivo existe
            if (!Files.exists(resourcePathObj) || Files.isDirectory(resourcePathObj)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // Establecer el tipo MIME
            contentType = getServletContext().getMimeType(pathInfo);
            if (contentType == null) {
                // Si no se puede determinar el tipo MIME, usar el binario genérico
                contentType = "application/octet-stream";
            }
            resourcePath = realPath;
        }
        
        // Get resource as stream
        InputStream inputStream = getServletContext().getResourceAsStream(resourcePath);
        if (inputStream == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Set content type
        response.setContentType(contentType);
        
        // Establecer cabeceras de caché para mejorar el rendimiento
        response.setHeader("Cache-Control", "public, max-age=86400"); // Caché por 1 día
        
        // Copy resource to output stream
        try (OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        } finally {
            inputStream.close();
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet para manejar recursos estáticos como CSS, JavaScript e imágenes";
    }
}