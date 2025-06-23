package controlador;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Filtro para controlar la caché del navegador y prevenir el acceso 
 * a páginas protegidas mediante el botón "atrás" después del logout.
 */
@WebFilter(filterName = "NoCacheFilter", urlPatterns = {
    "/vista/registerMaterial.jsp", 
    "/vista/listado.jsp", 
    "/vista/registerAdmin.jsp",
    "/vista/favoritos.jsp",
    "/vista/detalleProducto.jsp"
})
public class NoCacheFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización del filtro
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Verificar si el usuario tiene sesión activa
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = session != null && session.getAttribute("isLoggedIn") != null;
        
        if (isLoggedIn) {
            // Usuario autenticado: configurar headers para evitar caché de páginas sensibles
            setNoCacheHeaders(httpResponse);
            chain.doFilter(request, response);
        } else {
            // Usuario no autenticado: configurar headers y redirigir
            setNoCacheHeaders(httpResponse);
            
            // Verificar si es una petición AJAX
            String requestedWith = httpRequest.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                // Para peticiones AJAX, enviar código de estado 401
                httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                httpResponse.getWriter().write("{\"error\":\"Session expired\",\"redirect\":\"/login\"}");
            } else {
                // Para peticiones normales, redirigir al login
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/vista/login.jsp");
            }
            return;
        }
    }
    
    /**
     * Configura headers HTTP para prevenir el almacenamiento en caché
     */
    private void setNoCacheHeaders(HttpServletResponse response) {
        // Prevenir caché en el navegador
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate, private");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        // Headers adicionales de seguridad
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-XSS-Protection", "1; mode=block");
    }

    @Override
    public void destroy() {
        // Limpieza del filtro
    }
}
