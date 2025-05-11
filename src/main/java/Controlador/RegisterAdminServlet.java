package controlador;

import modelo.dao.UsuarioDAO;
import modelo.dto.Usuario;
import servicios.PasswordUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "RegisterAdminServlet", urlPatterns = {"/registerAdmin"})
public class RegisterAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verificar si el usuario está autenticado y es administrador
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Establecer cabeceras para evitar caché
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Mostrar la página de registro de administradores
        request.getRequestDispatcher("/vista/registerAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verificar si el usuario está autenticado y es administrador
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Obtener parámetros del formulario
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Asignar rol "admin" siempre para este servlet
        String rol = "admin";

        // Validar que los campos no estén vacíos
        if (nombre == null || nombre.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Por favor, complete todos los campos");
            request.getRequestDispatcher("/vista/registerAdmin.jsp").forward(request, response);
            return;
        }
        
        // Validar que las contraseñas coincidan
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Las contraseñas no coinciden");
            request.getRequestDispatcher("/vista/registerAdmin.jsp").forward(request, response);
            return;
        }
        
        // Validar fortaleza de la contraseña
        if (password.length() < 8 || !password.matches(".*[A-Z].*")
                || !password.matches(".*[a-z].*") || !password.matches(".*[0-9].*")) {

            request.setAttribute("errorMessage", "La contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas y números");
            request.getRequestDispatcher("/vista/registerAdmin.jsp").forward(request, response);
            return;
        }

        // Crear instancia del DAO de usuario
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        
        try {
            // Verificar si el email ya está registrado
            if (usuarioDAO.existeEmail(email)) {
                request.setAttribute("errorMessage", "El correo electrónico ya está registrado");
                request.getRequestDispatcher("/vista/registerAdmin.jsp").forward(request, response);
                return;
            }
            
            // Hashear la contraseña
            String hashedPassword = PasswordUtil.hashPassword(password);
            
            // Crear objeto Usuario con rol "admin"
            Usuario nuevoAdmin = new Usuario();
            nuevoAdmin.setNombre(nombre);
            nuevoAdmin.setEmail(email);
            nuevoAdmin.setPassword(hashedPassword);
            nuevoAdmin.setRol(rol);
            
            // Guardar el usuario
            boolean registroExitoso = usuarioDAO.insertar(nuevoAdmin);
            
            if (registroExitoso) {
                // Registro exitoso - redireccionar al listado de materiales con mensaje de éxito
                request.setAttribute("successMessage", "Administrador registrado correctamente");
                request.getRequestDispatcher("/materiales").forward(request, response);
            } else {
                // Error al registrar
                request.setAttribute("errorMessage", "Error al registrar el administrador. Inténtelo de nuevo.");
                request.getRequestDispatcher("/vista/registerAdmin.jsp").forward(request, response);
            }
            
        } catch (ServletException | IOException e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/vista/registerAdmin.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para registrar nuevos administradores";
    }
}
