package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.dao.FavoritoDAO;
import modelo.dto.Favorito;
import modelo.dto.Usuario;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/favoritos")
public class FavoritosServlet extends HttpServlet {
    
    private FavoritoDAO favoritoDAO;
    
    @Override
    public void init() throws ServletException {
        favoritoDAO = new FavoritoDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String action = request.getParameter("action");
        
        if (action == null) {
            // Mostrar página de favoritos
            mostrarFavoritos(request, response, usuario.getIdUsuario());
        } else {
            switch (action) {
                case "toggle":
                    toggleFavorito(request, response, usuario.getIdUsuario());
                    break;
                case "check":
                    verificarFavorito(request, response, usuario.getIdUsuario());
                    break;
                case "count":
                    contarFavoritos(request, response, usuario.getIdUsuario());
                    break;
                default:
                    mostrarFavoritos(request, response, usuario.getIdUsuario());
                    break;
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void mostrarFavoritos(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws ServletException, IOException {
        
        List<Favorito> favoritos = favoritoDAO.obtenerFavoritosPorUsuario(idUsuario);
        request.setAttribute("favoritos", favoritos);
        request.getRequestDispatcher("/vista/favoritos.jsp").forward(request, response);
    }
    
    private void toggleFavorito(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws IOException {
        
        String idMaterial = request.getParameter("idMaterial");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        if (idMaterial == null || idMaterial.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"ID de material requerido\"}");
            return;
        }
        
        boolean esFavorito = favoritoDAO.esFavorito(idUsuario, idMaterial);
        boolean resultado;
        String mensaje;
        
        if (esFavorito) {
            // Eliminar de favoritos
            resultado = favoritoDAO.eliminarFavorito(idUsuario, idMaterial);
            mensaje = resultado ? "Eliminado de favoritos" : "Error al eliminar de favoritos";
        } else {
            // Agregar a favoritos
            resultado = favoritoDAO.agregarFavorito(idUsuario, idMaterial);
            mensaje = resultado ? "Agregado a favoritos" : "Error al agregar a favoritos";
        }
        
        int totalFavoritos = favoritoDAO.contarFavoritos(idUsuario);
        
        out.print(String.format(
            "{\"success\": %b, \"message\": \"%s\", \"isFavorite\": %b, \"totalFavorites\": %d}",
            resultado, mensaje, !esFavorito && resultado, totalFavoritos
        ));
    }
    
    private void verificarFavorito(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws IOException {
        
        String idMaterial = request.getParameter("idMaterial");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        if (idMaterial == null || idMaterial.trim().isEmpty()) {
            out.print("{\"isFavorite\": false}");
            return;
        }
        
        boolean esFavorito = favoritoDAO.esFavorito(idUsuario, idMaterial);
        out.print(String.format("{\"isFavorite\": %b}", esFavorito));
    }
    
    private void contarFavoritos(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        int totalFavoritos = favoritoDAO.contarFavoritos(idUsuario);
        
        PrintWriter out = response.getWriter();
        out.print(String.format("{\"totalFavorites\": %d}", totalFavoritos));
    }
}
