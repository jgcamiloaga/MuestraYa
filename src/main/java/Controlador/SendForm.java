package controlador;

import modelo.dao.MaterialDAO;
import modelo.dto.Material;
import java.math.BigDecimal;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SendForm", urlPatterns = {"/SendForm"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class SendForm extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SendForm.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("Iniciando procesamiento de formulario de registro de material");
        
        // Obtener los parámetros del formulario
        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String precioStr = request.getParameter("precio");
        String categoria = request.getParameter("categoria");

        LOGGER.log(Level.INFO, "Datos recibidos: codigo={0}, nombre={1}, precio={2}, categoria={3}", 
                new Object[]{codigo, nombre, precioStr, categoria});

        // Convertir precio a double
        double precio;
        try {
            precio = Double.parseDouble(precioStr);
            if (precio < 0) {
                throw new NumberFormatException("El precio no puede ser negativo");
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Error en formato de precio: {0}", e.getMessage());
            request.setAttribute("errorMessage", "El precio debe ser un número válido");
            request.getRequestDispatcher("/vista/registerMaterial.jsp").forward(request, response);
            return;
        }

        // Directorio para guardar las imágenes
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            LOGGER.info("Creando directorio de uploads");
            uploadDir.mkdirs();
        }
        
        LOGGER.log(Level.INFO, "Directorio de uploads: {0}", uploadPath);

        // Procesar la imagen
        String fileName = "default.jpg"; // Valor por defecto
        
        try {
            LOGGER.info("Procesando archivo subido");
            Part filePart = request.getPart("imagen");
            
            if (filePart != null) {
                LOGGER.log(Level.INFO, "Parte de archivo obtenida: nombre={0}, tamaño={1}", 
                        new Object[]{filePart.getSubmittedFileName(), filePart.getSize()});
            } else {
                LOGGER.warning("filePart es null");
            }

            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && 
                    !filePart.getSubmittedFileName().isEmpty()) {
                // Generar un nombre único para la imagen
                String originalFileName = filePart.getSubmittedFileName();
                LOGGER.log(Level.INFO, "Nombre de archivo original: {0}", originalFileName);
                
                String fileExtension = "";
                int lastDot = originalFileName.lastIndexOf(".");
                if (lastDot > 0) {
                    fileExtension = originalFileName.substring(lastDot);
                }
                fileName = UUID.randomUUID().toString() + fileExtension;
                
                // Ruta completa del archivo
                String filePath = uploadPath + File.separator + fileName;
                LOGGER.log(Level.INFO, "Guardando imagen en: {0}", filePath);
                
                // Guardar el archivo
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    LOGGER.info("Imagen guardada exitosamente");
                } catch (IOException e) {
                    LOGGER.log(Level.SEVERE, "Error al guardar la imagen: {0}", e.getMessage());
                    fileName = "default.jpg"; // Si hay error, usar imagen por defecto
                }
            } else {
                LOGGER.info("No se recibió imagen o está vacía, usando imagen por defecto");
            }        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al procesar la parte del archivo: {0}", e.getMessage());
            fileName = "default.jpg"; // Si hay excepción, usar imagen por defecto
        }        
        
        // Crear instancia del DAO
        MaterialDAO materialDAO = new MaterialDAO();
        // Crear objeto Material con los datos del formulario
        Material material = new Material(codigo, nombre, new BigDecimal(precio));
        material.setIdCategoria(categoria);
        material.setImagen(fileName);
        LOGGER.log(Level.INFO, "Creando material con codigo={0}, nombre={1}, categoria={2}, imagen={3}",
                new Object[]{codigo, nombre, categoria, fileName});
        // Insertar el material usando el DAO
        boolean insertado = materialDAO.insertar(material);
        if (insertado) {
            // Registro exitoso
            LOGGER.info("Material registrado exitosamente en la base de datos");
            response.sendRedirect(request.getContextPath() + "/materiales?success=true");
        } else {
            // Error al insertar
            LOGGER.warning("No se insertaron filas en la base de datos");
            request.setAttribute("errorMessage", "Error al registrar el material");
            request.getRequestDispatcher("/vista/registerMaterial.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/vista/registerMaterial.jsp");
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet para procesar el formulario de registro de materiales";
    }
}
