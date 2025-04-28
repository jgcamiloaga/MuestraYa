package Controlador;

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

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/VISTA/registerMaterial.jsp", "/VISTA/listado.jsp", "/SendForm", "/DeleteMaterial"})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = session != null && session.getAttribute("isLoggedIn") != null;
        
        if (isLoggedIn) {
            // El usuario está autenticado, continuar con la solicitud
            chain.doFilter(request, response);
        } else {
            // El usuario no está autenticado, redirigir a la página de login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/VISTA/login.jsp");
        }
    }
    
    @Override
    public void destroy() {
    }
}