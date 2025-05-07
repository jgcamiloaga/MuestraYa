package controlador;

import servicios.ConexionDB;
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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Si ya hay una sesión activa, redirigir al listado
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            // Redirigir al servlet de materiales en lugar de directamente al JSP
            response.sendRedirect(request.getContextPath() + "/materiales"); 
            return;
        }

        // Si no hay sesión, mostrar la página de login
        request.getRequestDispatcher("/vista/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validar que los campos no estén vacíos
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Por favor, complete todos los campos");
            request.getRequestDispatcher("/vista/login.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConexionDB.getConnection();

            if (conn == null) {
                request.setAttribute("errorMessage", "Error de conexión a la base de datos");
                request.getRequestDispatcher("/vista/login.jsp").forward(request, response);
                return;
            }

            // Consulta SQL para obtener el usuario por email (ya no verificamos la contraseña en la consulta)
            String sql = "SELECT * FROM usuario WHERE email = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Obtener la contraseña hasheada de la base de datos
                String hashedPasswordFromDB = rs.getString("password");

                // Verificar si la contraseña ingresada coincide con el hash almacenado
                if (PasswordUtil.checkPassword(password, hashedPasswordFromDB)) {
                    // Contraseña correcta, crear objeto Usuario
                    Usuario usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("idUsuario"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setRol(rs.getString("rol"));

                    // Crear sesión y guardar el usuario
                    HttpSession session = request.getSession();
                    session.setAttribute("usuario", usuario);
                    session.setAttribute("isLoggedIn", true);
                    session.setMaxInactiveInterval(30 * 60); // 30 minutos

                    // Redirigir al servlet de materiales después del login exitoso
                    response.sendRedirect(request.getContextPath() + "/materiales");
                } else {
                    // Contraseña incorrecta
                    request.setAttribute("errorMessage", "Email o contraseña incorrectos");
                    request.getRequestDispatcher("/vista/login.jsp").forward(request, response);
                }
            } else {
                // Usuario no encontrado
                request.setAttribute("errorMessage", "Email o contraseña incorrectos");
                request.getRequestDispatcher("/vista/login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/vista/login.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
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
