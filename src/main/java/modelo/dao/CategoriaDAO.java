package modelo.dao;

import modelo.dto.Categoria;
import servicios.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase de acceso a datos para la entidad Categoria
 */
public class CategoriaDAO {
    
    /**
     * Lista todas las categorías disponibles
     * @return Lista de categorías
     */
    public List<Categoria> listarTodas() {
        List<Categoria> categorias = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT idCategoria, "
                    + "CASE "
                    + "    WHEN idCategoria = 'CAT001' THEN 'Herramienta' "
                    + "    WHEN idCategoria = 'CAT002' THEN 'Ropa' "
                    + "    WHEN idCategoria = 'CAT003' THEN 'Cocina' "
                    + "    WHEN idCategoria = 'CAT004' THEN 'Electrónica' "
                    + "    WHEN idCategoria = 'CAT005' THEN 'Construcción' "
                    + "    WHEN idCategoria = 'CAT006' THEN 'Oficina' "
                    + "    ELSE 'Sin categoría' "
                    + "END AS nombre "
                    + "FROM categoria "
                    + "ORDER BY nombre ASC";
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Categoria categoria = new Categoria(
                        rs.getString("idCategoria"),
                        rs.getString("nombre")
                );
                categorias.add(categoria);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener categorías: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return categorias;
    }
    
    /**
     * Busca una categoría por su ID
     * @param id ID de la categoría
     * @return La categoría encontrada o null
     */
    public Categoria buscarPorId(String id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Categoria categoria = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT idCategoria, "
                    + "CASE "
                    + "    WHEN idCategoria = 'CAT001' THEN 'Herramienta' "
                    + "    WHEN idCategoria = 'CAT002' THEN 'Ropa' "
                    + "    WHEN idCategoria = 'CAT003' THEN 'Cocina' "
                    + "    WHEN idCategoria = 'CAT004' THEN 'Electrónica' "
                    + "    WHEN idCategoria = 'CAT005' THEN 'Construcción' "
                    + "    WHEN idCategoria = 'CAT006' THEN 'Oficina' "
                    + "    ELSE 'Sin categoría' "
                    + "END AS nombre "
                    + "FROM categoria "
                    + "WHERE idCategoria = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                categoria = new Categoria(
                        rs.getString("idCategoria"),
                        rs.getString("nombre")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar categoría por ID: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return categoria;
    }
    
    /**
     * Busca una categoría por su nombre
     * @param nombre Nombre de la categoría
     * @return La categoría encontrada o null
     */
    public Categoria buscarPorNombre(String nombre) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Categoria categoria = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT idCategoria FROM categoria WHERE "
                    + "CASE "
                    + "    WHEN idCategoria = 'CAT001' THEN 'Herramienta' "
                    + "    WHEN idCategoria = 'CAT002' THEN 'Ropa' "
                    + "    WHEN idCategoria = 'CAT003' THEN 'Cocina' "
                    + "    WHEN idCategoria = 'CAT004' THEN 'Electrónica' "
                    + "    WHEN idCategoria = 'CAT005' THEN 'Construcción' "
                    + "    WHEN idCategoria = 'CAT006' THEN 'Oficina' "
                    + "    ELSE 'Sin categoría' "
                    + "END = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, nombre);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                String idCategoria = rs.getString("idCategoria");
                categoria = new Categoria(idCategoria, nombre);
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar categoría por nombre: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return categoria;
    }
    
    /**
     * Cierra recursos de base de datos
     * @param rs ResultSet
     * @param stmt PreparedStatement
     * @param conn Connection
     */
    private void cerrarRecursos(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
}
