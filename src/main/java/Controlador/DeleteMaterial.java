package Controlador;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "DeleteMaterial", urlPatterns = {"/DeleteMaterial"})
public class DeleteMaterial extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DeleteMaterial</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteMaterial at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener el ID del material a eliminar
        String idMaterial = request.getParameter("id");

        if (idMaterial == null || idMaterial.trim().isEmpty()) {
            // Si no se proporciona un ID válido, redirigir con un mensaje de error
            response.sendRedirect(request.getContextPath() + "/listado.jsp?error=true");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Obtener conexión usando la clase ConexionDB
            conn = ConexionDB.getConnection();

            if (conn == null) {
                // Si no se puede establecer la conexión, redirigir con un mensaje de error
                response.sendRedirect(request.getContextPath() + "/listado.jsp?error=true");
                return;
            }

            // Preparar la consulta SQL para eliminar el material
            String sql = "DELETE FROM material WHERE idMaterial = ?";
            pstmt = conn.prepareStatement(sql);

            // Establecer el parámetro
            pstmt.setString(1, idMaterial);

            // Ejecutar la consulta
            int filasAfectadas = pstmt.executeUpdate();

            if (filasAfectadas > 0) {
                // Eliminación exitosa
                response.sendRedirect(request.getContextPath() + "/listado.jsp?delete=true");
            } else {
                // No se encontró el material o no se pudo eliminar
                response.sendRedirect(request.getContextPath() + "/listado.jsp?error=true");
            }

        } catch (SQLException e) {
            // Error de SQL
            System.err.println("Error al eliminar material: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/listado.jsp?error=true");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
