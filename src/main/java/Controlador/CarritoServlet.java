package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.dao.CarritoDAO;
import modelo.dto.CarritoItem;
import modelo.dto.Usuario;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/carrito-server")
public class CarritoServlet extends HttpServlet {
    
    private CarritoDAO carritoDAO;
    
    @Override
    public void init() throws ServletException {
        carritoDAO = new CarritoDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print("{\"success\": false, \"message\": \"Usuario no autenticado\"}");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "listar";
        }
        
        switch (action) {
            case "listar":
                listarCarrito(request, response, usuario.getIdUsuario());
                break;
            case "contar":
                contarItems(request, response, usuario.getIdUsuario());
                break;
            case "total":
                calcularTotal(request, response, usuario.getIdUsuario());
                break;
            case "vaciar":
                vaciarCarrito(request, response, usuario.getIdUsuario());
                break;
            default:
                listarCarrito(request, response, usuario.getIdUsuario());
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print("{\"success\": false, \"message\": \"Usuario no autenticado\"}");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "agregar";
        }
        
        switch (action) {
            case "agregar":
                agregarAlCarrito(request, response, usuario.getIdUsuario());
                break;
            case "actualizar":
                actualizarCantidad(request, response, usuario.getIdUsuario());
                break;
            case "eliminar":
                eliminarDelCarrito(request, response, usuario.getIdUsuario());
                break;
            case "vaciar":
                vaciarCarrito(request, response, usuario.getIdUsuario());
                break;
            default:
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().print("{\"success\": false, \"message\": \"Acción no válida\"}");
                break;
        }
    }
    
    private void agregarAlCarrito(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws IOException {
        
        String idMaterial = request.getParameter("idMaterial");
        String cantidadStr = request.getParameter("cantidad");
        String precioStr = request.getParameter("precio");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if (idMaterial == null || cantidadStr == null || precioStr == null) {
                out.print("{\"success\": false, \"message\": \"Parámetros requeridos faltantes\"}");
                return;
            }
            
            int cantidad = Integer.parseInt(cantidadStr);
            BigDecimal precio = new BigDecimal(precioStr);
            
            if (cantidad <= 0 || precio.compareTo(BigDecimal.ZERO) <= 0) {
                out.print("{\"success\": false, \"message\": \"Cantidad y precio deben ser positivos\"}");
                return;
            }
            
            boolean resultado = carritoDAO.agregarAlCarrito(idUsuario, idMaterial, cantidad, precio);
            
            if (resultado) {
                int totalItems = carritoDAO.contarItemsCarrito(idUsuario);
                BigDecimal total = carritoDAO.calcularTotal(idUsuario);
                
                out.print(String.format(
                    "{\"success\": true, \"message\": \"Producto agregado al carrito\", \"totalItems\": %d, \"total\": %.2f}",
                    totalItems, total
                ));
            } else {
                out.print("{\"success\": false, \"message\": \"Error al agregar producto al carrito\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Formato de número inválido\"}");
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Error interno del servidor\"}");
        }
    }
    
    private void actualizarCantidad(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws IOException {
        
        String idMaterial = request.getParameter("idMaterial");
        String cantidadStr = request.getParameter("cantidad");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if (idMaterial == null || cantidadStr == null) {
                out.print("{\"success\": false, \"message\": \"Parámetros requeridos faltantes\"}");
                return;
            }
            
            int cantidad = Integer.parseInt(cantidadStr);
            boolean resultado = carritoDAO.establecerCantidad(idUsuario, idMaterial, cantidad);
            
            if (resultado) {
                int totalItems = carritoDAO.contarItemsCarrito(idUsuario);
                BigDecimal total = carritoDAO.calcularTotal(idUsuario);
                
                out.print(String.format(
                    "{\"success\": true, \"message\": \"Cantidad actualizada\", \"totalItems\": %d, \"total\": %.2f}",
                    totalItems, total
                ));
            } else {
                out.print("{\"success\": false, \"message\": \"Error al actualizar cantidad\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Formato de número inválido\"}");
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Error interno del servidor\"}");
        }
    }
    
    private void eliminarDelCarrito(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws IOException {
        
        String idMaterial = request.getParameter("idMaterial");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        if (idMaterial == null) {
            out.print("{\"success\": false, \"message\": \"ID de material requerido\"}");
            return;
        }
        
        boolean resultado = carritoDAO.eliminarDelCarrito(idUsuario, idMaterial);
        
        if (resultado) {
            int totalItems = carritoDAO.contarItemsCarrito(idUsuario);
            BigDecimal total = carritoDAO.calcularTotal(idUsuario);
            
            out.print(String.format(
                "{\"success\": true, \"message\": \"Producto eliminado del carrito\", \"totalItems\": %d, \"total\": %.2f}",
                totalItems, total
            ));
        } else {
            out.print("{\"success\": false, \"message\": \"Error al eliminar producto del carrito\"}");
        }
    }
    
    private void vaciarCarrito(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        boolean resultado = carritoDAO.vaciarCarrito(idUsuario);
        
        if (resultado) {
            out.print("{\"success\": true, \"message\": \"Carrito vaciado correctamente\", \"totalItems\": 0, \"total\": 0.00}");
        } else {
            out.print("{\"success\": false, \"message\": \"Error al vaciar carrito\"}");
        }
    }
    
    private void listarCarrito(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws IOException, ServletException {
        
        List<CarritoItem> items = carritoDAO.obtenerCarritoPorUsuario(idUsuario);
        
        // Si es una petición AJAX, devolver JSON
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            StringBuilder json = new StringBuilder();
            json.append("{\"items\": [");
            
            for (int i = 0; i < items.size(); i++) {
                CarritoItem item = items.get(i);
                if (i > 0) json.append(",");
                json.append(String.format(
                    "{\"idMaterial\": \"%s\", \"nombre\": \"%s\", \"cantidad\": %d, \"precio\": %.2f, \"subtotal\": %.2f}",
                    item.getIdMaterial(), 
                    item.getNombreMaterial().replace("\"", "\\\""), 
                    item.getCantidad(), 
                    item.getPrecioUnitario(), 
                    item.getSubtotal()
                ));
            }
            
            int totalItems = carritoDAO.contarItemsCarrito(idUsuario);
            BigDecimal total = carritoDAO.calcularTotal(idUsuario);
            
            json.append(String.format("], \"totalItems\": %d, \"total\": %.2f}", totalItems, total));
            
            response.getWriter().print(json.toString());
        } else {
            // Devolver página JSP
            request.setAttribute("carritoItems", items);
            request.getRequestDispatcher("/vista/carrito.jsp").forward(request, response);
        }
    }
    
    private void contarItems(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        int totalItems = carritoDAO.contarItemsCarrito(idUsuario);
        response.getWriter().print(String.format("{\"totalItems\": %d}", totalItems));
    }
    
    private void calcularTotal(HttpServletRequest request, HttpServletResponse response, int idUsuario) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        BigDecimal total = carritoDAO.calcularTotal(idUsuario);
        response.getWriter().print(String.format("{\"total\": %.2f}", total));
    }
}
