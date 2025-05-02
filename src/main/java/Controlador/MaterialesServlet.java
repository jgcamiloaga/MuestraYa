package Controlador;

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

@WebServlet(name = "MaterialesServlet", urlPatterns = {"/materiales"})
public class MaterialesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verificar si el usuario está autenticado
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Cargar los materiales desde la base de datos
        List<Material> materiales = cargarMateriales();
        request.setAttribute("materiales", materiales);
        
        // Reenviar a la vista
        request.getRequestDispatcher("/VISTA/listado.jsp").forward(request, response);
    }

    /**
     * Carga todos los materiales desde la base de datos
     * @return Lista de materiales
     */
    private List<Material> cargarMateriales() {
        List<Material> lista = new ArrayList<>();
        Connection cxn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // SQL para obtener materiales con sus categorías
        String sql = "SELECT m.idMaterial, m.nombre, m.precio, m.idCategoria, m.imagen, "
                + "CASE "
                + "    WHEN m.idCategoria = 'CAT001' THEN 'Herramienta' "
                + "    WHEN m.idCategoria = 'CAT002' THEN 'Ropa' "
                + "    WHEN m.idCategoria = 'CAT003' THEN 'Cocina' "
                + "    WHEN m.idCategoria = 'CAT004' THEN 'Electrónica' "
                + "    WHEN m.idCategoria = 'CAT005' THEN 'Construcción' "
                + "    WHEN m.idCategoria = 'CAT006' THEN 'Oficina' "
                + "    ELSE 'Sin categoría' "
                + "END AS nombreCategoria "
                + "FROM material m "
                + "ORDER BY m.nombre ASC";

        try {
            // Obtener la conexión de la base de datos
            cxn = ConexionDB.getConnection();

            // Preparar y ejecutar la consulta SQL
            ps = cxn.prepareStatement(sql);
            rs = ps.executeQuery();

            // Procesar los resultados de la consulta
            while (rs.next()) {
                BigDecimal precio = rs.getBigDecimal("precio");
                Material m = new Material(
                        rs.getString("idMaterial"),
                        rs.getString("nombre"),
                        precio
                );
                // Añadir la categoría al objeto Material
                m.setIdCategoria(rs.getString("idCategoria"));
                m.setNombreCategoria(rs.getString("nombreCategoria"));
                // Añadir la imagen al objeto Material
                m.setImagen(rs.getString("imagen"));
                lista.add(m);
            }

        } catch (SQLException e) {
            System.err.println("Error al cargar materiales: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, ps, cxn);
        }
        
        return lista;
    }
    
    /**
     * Cierra recursos de base de datos
     */
    private void cerrarRecursos(ResultSet rs, PreparedStatement ps, Connection cxn) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (cxn != null) cxn.close();
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
    
    /**
     * Obtiene el icono correspondiente a cada categoría
     */
    public static String getCategoryIcon(String categoryId) {
        switch (categoryId) {
            case "CAT001":
                return "fas fa-tools";          // Herramienta
            case "CAT002":
                return "fas fa-tshirt";         // Ropa
            case "CAT003":
                return "fas fa-utensils";       // Cocina
            case "CAT004":
                return "fas fa-laptop";         // Electrónica
            case "CAT005":
                return "fas fa-hard-hat";       // Construcción
            case "CAT006":
                return "fas fa-briefcase";      // Oficina
            default:
                return "fas fa-tag";            // Por defecto
        }
    }

    /**
     * Obtiene el color correspondiente a cada categoría
     */
    public static String getCategoryColor(String categoryId) {
        switch (categoryId) {
            case "CAT001":
                return "#3a86ff";          // Herramienta
            case "CAT002":
                return "#ff006e";         // Ropa
            case "CAT003":
                return "#fb5607";       // Cocina
            case "CAT004":
                return "#8338ec";         // Electrónica
            case "CAT005":
                return "#ffbe0b";       // Construcción
            case "CAT006":
                return "#06d6a0";      // Oficina
            default:
                return "#8d99ae";                  // Por defecto
        }
    }
}