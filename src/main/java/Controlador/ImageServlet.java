package Controlador;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet dedicado para servir imágenes desde el directorio uploads
 */
@WebServlet(name = "ImageServlet", urlPatterns = {"/image/*"})
public class ImageServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ImageServlet.class.getName());
    private static final String DEFAULT_IMAGE = "default.jpg";
    
    /**
     * Maneja solicitudes GET para obtener imágenes
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String requestedImage = request.getPathInfo();
        LOGGER.log(Level.INFO, "Imagen solicitada: {0}", requestedImage);
        
        if (requestedImage == null || requestedImage.equals("/")) {
            requestedImage = "/" + DEFAULT_IMAGE;
        }
        
        // Eliminar cualquier '/' inicial si existe
        if (requestedImage.startsWith("/")) {
            requestedImage = requestedImage.substring(1);
        }
        
        // Construir la ruta real al archivo de imagen
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File imageFile = new File(uploadPath + File.separator + requestedImage);
        
        LOGGER.log(Level.INFO, "Buscando imagen en: {0}", imageFile.getAbsolutePath());
        
        // Si la imagen no existe, usar la imagen por defecto
        if (!imageFile.exists() || imageFile.isDirectory()) {
            LOGGER.log(Level.WARNING, "Imagen no encontrada, usando imagen por defecto");
            imageFile = new File(uploadPath + File.separator + DEFAULT_IMAGE);
            
            // Si ni siquiera existe la imagen por defecto, crear una
            if (!imageFile.exists()) {
                LOGGER.log(Level.WARNING, "Imagen por defecto no encontrada, enviando imagen no disponible");
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Imagen no disponible");
                return;
            }
        }
        
        // Determinar el tipo MIME
        String contentType = getServletContext().getMimeType(imageFile.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        
        response.setContentType(contentType);
        response.setContentLength((int) imageFile.length());
        
        // Enviar la imagen como respuesta
        try (FileInputStream in = new FileInputStream(imageFile);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error al servir la imagen: {0}", e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la imagen");
        }
    }
}