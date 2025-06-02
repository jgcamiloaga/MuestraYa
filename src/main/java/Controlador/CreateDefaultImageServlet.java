package controlador;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet para crear una imagen por defecto para productos sin imagen
 */
@WebServlet(name = "CreateDefaultImageServlet", urlPatterns = {"/createDefaultImage"})
public class CreateDefaultImageServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CreateDefaultImageServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Crear imagen por defecto
        BufferedImage img = new BufferedImage(400, 400, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = img.createGraphics();
        
        // Rellenar fondo con un color suave
        g2d.setColor(new Color(240, 240, 240));
        g2d.fillRect(0, 0, 400, 400);
        
        // Dibujar un borde
        g2d.setColor(new Color(200, 200, 200));
        g2d.drawRect(5, 5, 390, 390);
        
        // Escribir texto
        g2d.setColor(new Color(100, 100, 100));
        g2d.setFont(new Font("Arial", Font.BOLD, 30));
        g2d.drawString("Imagen no", 120, 180);
        g2d.drawString("disponible", 120, 220);
        
        // Dibujar icono simple
        g2d.setColor(new Color(150, 150, 150));
        g2d.fillRect(150, 90, 100, 80);
        g2d.setColor(new Color(240, 240, 240));
        g2d.fillRect(160, 100, 80, 60);
        
        g2d.dispose();
        
        // Guardar imagen en el directorio uploads
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        File outputFile = new File(uploadPath, "default.jpg");
        
        try {
            ImageIO.write(img, "jpg", outputFile);
            LOGGER.log(Level.INFO, "Imagen por defecto creada en: {0}", outputFile.getAbsolutePath());
            response.getWriter().println("Imagen por defecto creada correctamente en: " + outputFile.getAbsolutePath());
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error al crear imagen por defecto: {0}", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Error al crear imagen por defecto: " + e.getMessage());
        }
    }
}
