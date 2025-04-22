package Controlador;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet(name = "SendForm", urlPatterns = {"/SendForm"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class SendForm extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SendForm</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SendForm at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener los parámetros del formulario
        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String precioStr = request.getParameter("precio");
        String categoria = request.getParameter("categoria");

        // Convertir precio a double
        double precio;
        try {
            precio = Double.parseDouble(precioStr);
            if (precio < 0) {
                throw new NumberFormatException("El precio no puede ser negativo");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "El precio debe ser un número válido");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        // Directorio para guardar las imágenes
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        // Procesar la imagen
        String fileName = "default.jpg"; // Valor por defecto
        Part filePart = request.getPart("imagen");

        if (filePart != null && filePart.getSize() > 0) {
            // Generar un nombre único para la imagen
            String originalFileName = filePart.getSubmittedFileName();
            String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            fileName = UUID.randomUUID().toString() + fileExtension;

            // Guardar la imagen
            filePart.write(uploadPath + File.separator + fileName);
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Obtener conexión usando la clase ConexionDB
            conn = ConexionDB.getConnection();

            if (conn == null) {
                request.setAttribute("errorMessage", "No se pudo establecer conexión con la base de datos");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            // Preparar la consulta SQL para insertar el material con imagen
            String sql = "INSERT INTO material (idMaterial, nombre, precio, idCategoria, imagen) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);

            // Establecer los parámetros
            pstmt.setString(1, codigo);
            pstmt.setString(2, nombre);
            pstmt.setDouble(3, precio);
            pstmt.setString(4, categoria);
            pstmt.setString(5, fileName);

            // Ejecutar la consulta
            int filasAfectadas = pstmt.executeUpdate();

            if (filasAfectadas > 0) {
                // Registro exitoso
                request.setAttribute("successMessage", "Material registrado correctamente");
                response.sendRedirect(request.getContextPath() + "/listado.jsp?success=true");

            } else {
                // Error al insertar
                request.setAttribute("errorMessage", "Error al registrar el material");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            // Error de SQL
            String errorMsg = "Error de base de datos: " + e.getMessage();

            // Verificar si es un error de duplicado (código ya existe)
            if (e.getMessage().contains("Duplicate entry")) {
                errorMsg = "El código ya existe en la base de datos";
            }

            request.setAttribute("errorMessage", errorMsg);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } finally {
            // Cerrar recursos
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Error al cerrar recursos: " + e.getMessage());
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
