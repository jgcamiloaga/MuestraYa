import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;

/**
 * Utilidad para crear una imagen por defecto para productos sin imagen
 */
public class CreateDefaultImage {
    
    public static void main(String[] args) {
        try {
            System.out.println("Creando imagen por defecto...");
            
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
            String basePath = "c:\\Users\\johan\\OneDrive\\Documentos\\NetBeansProjects\\MuestraYa";
            
            // Directorio de uploads en el proyecto fuente
            String sourceUploadPath = basePath + "\\src\\main\\webapp\\uploads";
            File sourceUploadDir = new File(sourceUploadPath);
            if (!sourceUploadDir.exists()) {
                sourceUploadDir.mkdirs();
                System.out.println("Directorio creado: " + sourceUploadPath);
            }
            
            // Guardar en el proyecto fuente
            File sourceOutputFile = new File(sourceUploadDir, "default.jpg");
            ImageIO.write(img, "jpg", sourceOutputFile);
            System.out.println("Imagen creada en: " + sourceOutputFile.getAbsolutePath());
            
            // Directorio de uploads en el target (si existe)
            String targetUploadPath = basePath + "\\target\\MuesraYa-1.0-SNAPSHOT\\uploads";
            File targetUploadDir = new File(targetUploadPath);
            if (targetUploadDir.exists()) {
                File targetOutputFile = new File(targetUploadDir, "default.jpg");
                ImageIO.write(img, "jpg", targetOutputFile);
                System.out.println("Imagen creada en: " + targetOutputFile.getAbsolutePath());
            } else {
                System.out.println("El directorio target no existe: " + targetUploadPath);
            }
            
            System.out.println("Proceso completado.");
            
        } catch (Exception e) {
            System.err.println("Error al crear la imagen por defecto: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
