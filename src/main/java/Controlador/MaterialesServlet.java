package controlador;

import modelo.dto.Material;
import modelo.dao.MaterialDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "MaterialesServlet", urlPatterns = {"/materiales"})
public class MaterialesServlet extends HttpServlet {
    
    private final MaterialDAO materialDAO;
    
    public MaterialesServlet() {
        this.materialDAO = new MaterialDAO();
    }    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verificar si el usuario está autenticado
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            // Redirigir al servlet de login
            response.sendRedirect(request.getContextPath() + "/login"); 
            return;
        }
        
        // Verificar si el usuario es administrador
        modelo.dto.Usuario usuario = (modelo.dto.Usuario) session.getAttribute("usuario");
        if (!"admin".equals(usuario.getRol())) {
            // No es administrador, redirigir a la tienda
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        
        // Cargar los materiales desde la base de datos utilizando el DAO
        List<Material> materiales = materialDAO.listarTodos();
        request.setAttribute("materiales", materiales);
        
        // Obtener los parámetros de la solicitud para mensajes de éxito o error
        String deleteParam = request.getParameter("delete");
        String errorParam = request.getParameter("error");
        String successParam = request.getParameter("success");
        String fromParam = request.getParameter("from");
        
        // Mantener estos parámetros para la vista
        if (deleteParam != null) {
            request.setAttribute("delete", deleteParam);
        }
        if (errorParam != null) {
            request.setAttribute("error", errorParam);
        }
        if (successParam != null) {
            request.setAttribute("success", successParam);
        }
        if (fromParam != null) {
            request.setAttribute("fromPage", fromParam);
        }
        
        // Reenviar a la vista
        request.getRequestDispatcher("/vista/listado.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}