package controlador;

import modelo.dao.CategoriaDAO;
import modelo.dao.MaterialDAO;
import modelo.dto.Categoria;
import modelo.dto.Material;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProductsServlet", urlPatterns = {"/products", "/"})
public class ProductsServlet extends HttpServlet {    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtener el parámetro 'from' para determinar si venimos de listado.jsp
        String fromPage = request.getParameter("from");
        
        // Verificar si ya procesamos esta solicitud para evitar bucles (usando atributos de sesión)
        HttpSession session = request.getSession();
          // Si venimos de listado.jsp o registerMaterial.jsp, limpiar cualquier caché previa para forzar recarga
        if (fromPage != null && ("listado".equals(fromPage) || "register".equals(fromPage))) {
            session.removeAttribute("lastProductRequest");
            session.removeAttribute("cachedMaterials");
            // Configurar cabeceras para evitar caché en el navegador
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            
            // Log para depuración
            System.out.println("Limpiando caché para fromPage: " + fromPage);
        }
        
        String requestURI = request.getRequestURI();
        String queryString = request.getQueryString();
        String fullPath = requestURI + (queryString != null ? "?" + queryString : "");        // Verificar si hay atributos en la solicitud para evitar bucles de redirección
        Object prevRequestAttr = session.getAttribute("lastProductRequest");
        if (prevRequestAttr != null && prevRequestAttr.equals(fullPath) && 
            !(fromPage != null && ("listado".equals(fromPage) || "register".equals(fromPage)))) {
            // Estamos en un bucle de redirección, establecer atributos de seguridad
            if (request.getAttribute("materiales") == null) {
                request.setAttribute("materiales", new ArrayList<Material>());
            }
            if (request.getAttribute("categorias") == null) {
                request.setAttribute("categorias", new ArrayList<Categoria>());
            }
            
            // Log para depuración
            System.out.println("Detectado posible bucle de redirección en: " + fullPath + " (fromPage: " + fromPage + ")");
            
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }
        
        // Guardar esta solicitud para detectar bucles
        session.setAttribute("lastProductRequest", fullPath);
        
        String action = request.getParameter("action");
        String categoryId = request.getParameter("id");
        String searchQuery = request.getParameter("query");
        
        // Cargar categorías para el filtro
        List<Categoria> categorias = getCategorias();
        request.setAttribute("categorias", categorias);
        
        // Filtrar por categoría o búsqueda, o obtener todos los productos
        List<Material> materiales;
        if (action != null && action.equals("category") && categoryId != null && !categoryId.trim().isEmpty()) {
            materiales = getMaterialesByCategoria(categoryId);            // Obtener la categoría seleccionada para resaltarla en el UI
            CategoriaDAO categoriaDAO = new CategoriaDAO();
            Categoria selectedCategoria = categoriaDAO.buscarPorId(categoryId);
            request.setAttribute("selectedCategoria", selectedCategoria);
        } else if (action != null && action.equals("search") && searchQuery != null && !searchQuery.trim().isEmpty()) {
            materiales = searchMateriales(searchQuery);
            request.setAttribute("searchQuery", searchQuery);
        } else {
            materiales = getAllMateriales();
        }
        
        request.setAttribute("materiales", materiales);
        
        // Usar request.getRequestDispatcher() con forward() en lugar de sendRedirect 
        // para evitar cambiar la URL y crear un bucle de redirección
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }    private List<Material> getAllMateriales() {
        // Utilizar directamente el DAO
        MaterialDAO materialDAO = new MaterialDAO();
        return materialDAO.listarTodos();
    }
      private List<Material> getMaterialesByCategoria(String categoriaId) {
        // Utilizar directamente el DAO
        MaterialDAO materialDAO = new MaterialDAO();
        return materialDAO.buscarPorCategoria(categoriaId);
    }
      private List<Material> searchMateriales(String query) {
        // Utilizar directamente el DAO
        MaterialDAO materialDAO = new MaterialDAO();
        return materialDAO.buscarPorNombreOId(query);
    }
      private List<Categoria> getCategorias() {
        // Utilizar directamente el DAO
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        return categoriaDAO.listarTodas();
    }
      // Este método ya no es necesario ya que usamos el DAO
      // Estos métodos ya no son necesarios ya que estamos usando DAOs
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet para gestionar productos y categorías";
    }
}