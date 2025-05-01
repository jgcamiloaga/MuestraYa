package Controlador;

import Modelo.Categoria;
import Modelo.Material;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProductsServlet", urlPatterns = {"/products", "/"})
public class ProductsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verificar si ya procesamos esta solicitud para evitar bucles (usando atributos de sesión)
        HttpSession session = request.getSession();
        String requestURI = request.getRequestURI();
        String queryString = request.getQueryString();
        String fullPath = requestURI + (queryString != null ? "?" + queryString : "");
        
        // Verificar si hay atributos en la solicitud para evitar bucles de redirección
        Object prevRequestAttr = session.getAttribute("lastProductRequest");
        if (prevRequestAttr != null && prevRequestAttr.equals(fullPath)) {
            // Estamos en un bucle de redirección, establecer atributos de seguridad
            if (request.getAttribute("materiales") == null) {
                request.setAttribute("materiales", new ArrayList<Material>());
            }
            if (request.getAttribute("categorias") == null) {
                request.setAttribute("categorias", new ArrayList<Categoria>());
            }
            
            // Log para depuración
            System.out.println("Detectado posible bucle de redirección en: " + fullPath);
            
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
            materiales = getMaterialesByCategoria(categoryId);
            // Obtener la categoría seleccionada para resaltarla en el UI
            Categoria selectedCategoria = getCategoriaById(categorias, categoryId);
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
    }

    private List<Material> getAllMateriales() {
        List<Material> materiales = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT m.idMaterial, m.nombre, m.precio, m.idCategoria, m.imagen, " +
                    "CASE " +
                    "    WHEN m.idCategoria = 'CAT001' THEN 'Herramienta' " +
                    "    WHEN m.idCategoria = 'CAT002' THEN 'Ropa' " +
                    "    WHEN m.idCategoria = 'CAT003' THEN 'Cocina' " +
                    "    WHEN m.idCategoria = 'CAT004' THEN 'Electrónica' " +
                    "    WHEN m.idCategoria = 'CAT005' THEN 'Construcción' " +
                    "    WHEN m.idCategoria = 'CAT006' THEN 'Oficina' " +
                    "    ELSE 'Sin categoría' " +
                    "END AS nombreCategoria " +
                    "FROM material m " +
                    "ORDER BY m.nombre ASC";
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Material material = createMaterialFromResultSet(rs);
                materiales.add(material);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener materiales: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return materiales;
    }
    
    private List<Material> getMaterialesByCategoria(String categoriaId) {
        List<Material> materiales = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT m.idMaterial, m.nombre, m.precio, m.idCategoria, m.imagen, " +
                    "CASE " +
                    "    WHEN m.idCategoria = 'CAT001' THEN 'Herramienta' " +
                    "    WHEN m.idCategoria = 'CAT002' THEN 'Ropa' " +
                    "    WHEN m.idCategoria = 'CAT003' THEN 'Cocina' " +
                    "    WHEN m.idCategoria = 'CAT004' THEN 'Electrónica' " +
                    "    WHEN m.idCategoria = 'CAT005' THEN 'Construcción' " +
                    "    WHEN m.idCategoria = 'CAT006' THEN 'Oficina' " +
                    "    ELSE 'Sin categoría' " +
                    "END AS nombreCategoria " +
                    "FROM material m " +
                    "WHERE m.idCategoria = ? " +
                    "ORDER BY m.nombre ASC";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, categoriaId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Material material = createMaterialFromResultSet(rs);
                materiales.add(material);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener materiales por categoría: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return materiales;
    }
    
    private List<Material> searchMateriales(String query) {
        List<Material> materiales = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT m.idMaterial, m.nombre, m.precio, m.idCategoria, m.imagen, " +
                    "CASE " +
                    "    WHEN m.idCategoria = 'CAT001' THEN 'Herramienta' " +
                    "    WHEN m.idCategoria = 'CAT002' THEN 'Ropa' " +
                    "    WHEN m.idCategoria = 'CAT003' THEN 'Cocina' " +
                    "    WHEN m.idCategoria = 'CAT004' THEN 'Electrónica' " +
                    "    WHEN m.idCategoria = 'CAT005' THEN 'Construcción' " +
                    "    WHEN m.idCategoria = 'CAT006' THEN 'Oficina' " +
                    "    ELSE 'Sin categoría' " +
                    "END AS nombreCategoria " +
                    "FROM material m " +
                    "WHERE m.nombre LIKE ? OR m.idMaterial LIKE ? " +
                    "ORDER BY m.nombre ASC";
            
            stmt = conn.prepareStatement(sql);
            String searchParam = "%" + query + "%";
            stmt.setString(1, searchParam);
            stmt.setString(2, searchParam);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Material material = createMaterialFromResultSet(rs);
                materiales.add(material);
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar materiales: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return materiales;
    }
    
    private List<Categoria> getCategorias() {
        List<Categoria> categorias = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            
            // Utilizamos una consulta UNION para tener todas las categorías disponibles
            String sql = "SELECT 'CAT001' as idCategoria, 'Herramienta' as nombre UNION " +
                        "SELECT 'CAT002' as idCategoria, 'Ropa' as nombre UNION " +
                        "SELECT 'CAT003' as idCategoria, 'Cocina' as nombre UNION " +
                        "SELECT 'CAT004' as idCategoria, 'Electrónica' as nombre UNION " +
                        "SELECT 'CAT005' as idCategoria, 'Construcción' as nombre UNION " +
                        "SELECT 'CAT006' as idCategoria, 'Oficina' as nombre";
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Categoria categoria = new Categoria();
                categoria.setIdCategoria(rs.getString("idCategoria"));
                categoria.setNombre(rs.getString("nombre"));
                categorias.add(categoria);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener categorías: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return categorias;
    }
    
    private Categoria getCategoriaById(List<Categoria> categorias, String id) {
        for (Categoria categoria : categorias) {
            if (categoria.getIdCategoria().equals(id)) {
                return categoria;
            }
        }
        return null;
    }
    
    private Material createMaterialFromResultSet(ResultSet rs) throws SQLException {
        BigDecimal precio = rs.getBigDecimal("precio");
        Material material = new Material(
                rs.getString("idMaterial"),
                rs.getString("nombre"),
                precio
        );
        material.setIdCategoria(rs.getString("idCategoria"));
        material.setNombreCategoria(rs.getString("nombreCategoria"));
        material.setImagen(rs.getString("imagen"));
        return material;
    }
    
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
    
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