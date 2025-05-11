package controlador;

import modelo.dao.UsuarioDAO;
import modelo.dto.Usuario;
import servicios.PasswordUtil;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/registerUser"})
public class RegisterServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Si ya hay una sesión activa, redirigir al listado a través del servlet correspondiente
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            response.sendRedirect(request.getContextPath() + "/materiales");
            return;
        }

        // Establecer cabeceras para evitar caché
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Si no hay sesión, mostrar la página de registro
        request.getRequestDispatcher("/vista/registerUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {        // Obtener parámetros del formulario
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Asignar rol "usuario" por defecto para registros desde la tienda
        String rol = "usuario";

        // Validar que los campos no estén vacíos
        if (nombre == null || nombre.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()
                || rol == null || rol.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Por favor, complete todos los campos");
            request.getRequestDispatcher("/vista/registerUser.jsp").forward(request, response);
            return;
        }        // Validar que las contraseñas coincidan
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Las contraseñas no coinciden");
            request.getRequestDispatcher("/vista/registerUser.jsp").forward(request, response);
            return;
        }
        
        // Validar fortaleza de la contraseña
        if (password.length() < 8 || !password.matches(".*[A-Z].*")
                || !password.matches(".*[a-z].*") || !password.matches(".*[0-9].*")) {

            request.setAttribute("errorMessage", "La contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas y números");
            request.getRequestDispatcher("/vista/registerUser.jsp").forward(request, response);
            return;
        }

        // Crear instancia del DAO de usuario
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        
        try {
            // Verificar si el email ya está registrado
            if (usuarioDAO.existeEmail(email)) {
                request.setAttribute("errorMessage", "El correo electrónico ya está registrado");
                request.getRequestDispatcher("/vista/registerUser.jsp").forward(request, response);
                return;
            }
            
            // Hashear la contraseña
            String hashedPassword = PasswordUtil.hashPassword(password);
            
            // Crear objeto Usuario
            Usuario nuevoUsuario = new Usuario();
            nuevoUsuario.setNombre(nombre);
            nuevoUsuario.setEmail(email);
            nuevoUsuario.setPassword(hashedPassword);
            nuevoUsuario.setRol(rol);
              // Guardar el usuario
            boolean registroExitoso = usuarioDAO.insertar(nuevoUsuario);
            
            if (registroExitoso) {
                // Registro exitoso
                request.setAttribute("successMessage", "Registro exitoso. Ahora puede iniciar sesión.");
                request.getRequestDispatcher("/vista/login.jsp").forward(request, response);
            } else {
                // Error al registrar
                request.setAttribute("errorMessage", "Error al registrar el usuario. Inténtelo de nuevo.");
                request.getRequestDispatcher("/vista/registerUser.jsp").forward(request, response);
            }
            
        } catch (ServletException | IOException e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/vista/registerUser.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
