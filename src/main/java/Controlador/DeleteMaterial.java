package controlador;

import modelo.dao.MaterialDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
    }    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener el ID del material a eliminar
        String idMaterial = request.getParameter("id");

        if (idMaterial == null || idMaterial.trim().isEmpty()) {
            // Si no se proporciona un ID válido, redirigir con un mensaje de error
            response.sendRedirect(request.getContextPath() + "/materiales?error=true");
            return;
        }
        
        // Crear instancia del DAO
        MaterialDAO materialDAO = new MaterialDAO();
        
        // Intentar eliminar el material usando el DAO
        boolean eliminado = materialDAO.eliminar(idMaterial);
          if (eliminado) {
            // Eliminación exitosa - redireccionar con mensaje de éxito
            response.sendRedirect(request.getContextPath() + "/materiales?delete=true");
        } else {
            // No se encontró el material o no se pudo eliminar
            response.sendRedirect(request.getContextPath() + "/materiales?error=true");
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
