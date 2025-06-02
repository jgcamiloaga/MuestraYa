package modelo.dao;

import modelo.dto.Material;
import servicios.ConexionDB;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase de acceso a datos para la entidad Material
 */
public class MaterialDAO {
    
    /**
     * Lista todos los materiales disponibles
     * @return Lista de materiales
     */
    public List<Material> listarTodos() {
        List<Material> materiales = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();            String sql = "SELECT m.idMaterial, m.nombre, m.precio, m.idCategoria, m.imagen, " +
                    "m.descripcion, m.stock, m.destacado, m.especificaciones, m.fecha_creacion, " +
                    "m.unidad_medida, m.peso, m.dimension, m.color, " +
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
                Material material = crearMaterialDesdeResultSet(rs);
                materiales.add(material);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener materiales: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return materiales;
    }
    
    /**
     * Busca materiales por categoría
     * @param categoriaId ID de la categoría
     * @return Lista de materiales que pertenecen a la categoría
     */
    public List<Material> buscarPorCategoria(String categoriaId) {
        List<Material> materiales = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();            String sql = "SELECT m.idMaterial, m.nombre, m.precio, m.idCategoria, m.imagen, " +
                    "m.descripcion, m.stock, m.destacado, m.especificaciones, m.fecha_creacion, " +
                    "m.unidad_medida, m.peso, m.dimension, m.color, " +
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
                Material material = crearMaterialDesdeResultSet(rs);
                materiales.add(material);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener materiales por categoría: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return materiales;
    }
    
    /**
     * Busca materiales por texto en nombre o ID
     * @param query Texto a buscar
     * @return Lista de materiales que coinciden con la búsqueda
     */
    public List<Material> buscarPorTexto(String query) {
        List<Material> materiales = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();            String sql = "SELECT m.idMaterial, m.nombre, m.precio, m.idCategoria, m.imagen, " +
                    "m.descripcion, m.stock, m.destacado, m.especificaciones, m.fecha_creacion, " +
                    "m.unidad_medida, m.peso, m.dimension, m.color, " +
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
                    "WHERE m.nombre LIKE ? OR m.idMaterial LIKE ? OR m.descripcion LIKE ? " +
                    "ORDER BY m.nombre ASC";
            
            stmt = conn.prepareStatement(sql);            String searchParam = "%" + query + "%";
            stmt.setString(1, searchParam);
            stmt.setString(2, searchParam);
            stmt.setString(3, searchParam);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Material material = crearMaterialDesdeResultSet(rs);
                materiales.add(material);
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar materiales: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return materiales;
    }
    
    /**
     * Busca materiales por nombre o ID
     * @param query Texto a buscar
     * @return Lista de materiales que coinciden con la búsqueda
     */
    public List<Material> buscarPorNombreOId(String query) {
        return buscarPorTexto(query);
    }
      /**
     * Inserta un nuevo material en la base de datos
     * @param material Material a insertar
     * @return true si la inserción fue exitosa
     */
    public boolean insertar(Material material) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "INSERT INTO material (idMaterial, nombre, precio, idCategoria, imagen, descripcion, stock, " +
                    "destacado, especificaciones, unidad_medida, peso, dimension, color) VALUES " +
                    "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, material.getIdMaterial());
            stmt.setString(2, material.getNombre());
            stmt.setBigDecimal(3, material.getPrecio());
            stmt.setString(4, material.getIdCategoria());
            stmt.setString(5, material.getImagen());
            stmt.setString(6, material.getDescripcion());
            stmt.setInt(7, material.getStock());
            stmt.setBoolean(8, material.isDestacado());
            stmt.setString(9, material.getEspecificaciones());
            stmt.setString(10, material.getUnidadMedida());
            
            // Manejo de valores nulos
            if (material.getPeso() != null) {
                stmt.setBigDecimal(11, material.getPeso());
            } else {
                stmt.setNull(11, java.sql.Types.DECIMAL);
            }
            
            stmt.setString(12, material.getDimension());
            stmt.setString(13, material.getColor());
            
            int filasAfectadas = stmt.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al insertar material: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(null, stmt, conn);
        }
        
        return resultado;
    }
      /**
     * Actualiza un material existente
     * @param material Material con los datos actualizados
     * @return true si la actualización fue exitosa
     */
    public boolean actualizar(Material material) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "UPDATE material SET nombre = ?, precio = ?, idCategoria = ?, imagen = ?, " +
                    "descripcion = ?, stock = ?, destacado = ?, especificaciones = ?, " +
                    "unidad_medida = ?, peso = ?, dimension = ?, color = ? WHERE idMaterial = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, material.getNombre());
            stmt.setBigDecimal(2, material.getPrecio());
            stmt.setString(3, material.getIdCategoria());
            stmt.setString(4, material.getImagen());
            stmt.setString(5, material.getDescripcion());
            stmt.setInt(6, material.getStock());
            stmt.setBoolean(7, material.isDestacado());
            stmt.setString(8, material.getEspecificaciones());
            stmt.setString(9, material.getUnidadMedida());
            
            // Manejo de valores nulos
            if (material.getPeso() != null) {
                stmt.setBigDecimal(10, material.getPeso());
            } else {
                stmt.setNull(10, java.sql.Types.DECIMAL);
            }
            
            stmt.setString(11, material.getDimension());
            stmt.setString(12, material.getColor());
            stmt.setString(13, material.getIdMaterial());
            
            int filasAfectadas = stmt.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar material: " + e.getMessage());
        } finally {
            cerrarRecursos(null, stmt, conn);
        }
        
        return resultado;
    }
    
    /**
     * Obtiene un material por su ID
     * @param materialId ID del material a buscar
     * @return Material encontrado o null si no existe
     */
    public Material obtenerPorId(String materialId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Material material = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT m.idMaterial, m.nombre, m.precio, m.idCategoria, m.imagen, " +
                    "m.descripcion, m.stock, m.destacado, m.especificaciones, m.fecha_creacion, " +
                    "m.unidad_medida, m.peso, m.dimension, m.color, " +
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
                    "WHERE m.idMaterial = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, materialId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                material = crearMaterialDesdeResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener material por ID: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return material;
    }
    
    /**
     * Elimina un material por su ID
     * @param idMaterial ID del material a eliminar
     * @return true si la eliminación fue exitosa
     */
    public boolean eliminar(String idMaterial) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "DELETE FROM material WHERE idMaterial = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, idMaterial);
            
            int filasAfectadas = stmt.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar material: " + e.getMessage());
        } finally {
            cerrarRecursos(null, stmt, conn);
        }
        
        return resultado;
    }
      /**
     * Busca un material por su ID
     * @param idMaterial ID del material
     * @return El material encontrado o null
     */
    public Material buscarPorId(String idMaterial) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Material material = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT m.idMaterial, m.nombre, m.precio, m.idCategoria, m.imagen, " +
                    "m.descripcion, m.stock, m.destacado, m.especificaciones, m.fecha_creacion, " +
                    "m.unidad_medida, m.peso, m.dimension, m.color, " +
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
                    "WHERE m.idMaterial = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, idMaterial);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                material = crearMaterialDesdeResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar material por ID: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return material;
    }
      /**
     * Crea un objeto Material desde un ResultSet
     * @param rs ResultSet con datos del material
     * @return Objeto Material
     * @throws SQLException si ocurre un error al acceder a los datos
     */
    private Material crearMaterialDesdeResultSet(ResultSet rs) throws SQLException {
        BigDecimal precio = rs.getBigDecimal("precio");
        Material material = new Material(
                rs.getString("idMaterial"),
                rs.getString("nombre"),
                precio
        );
        material.setIdCategoria(rs.getString("idCategoria"));
        material.setNombreCategoria(rs.getString("nombreCategoria"));
        material.setImagen(rs.getString("imagen"));
        
        // Obtener los nuevos campos si están disponibles en el ResultSet
        try {
            material.setDescripcion(rs.getString("descripcion"));
            material.setStock(rs.getInt("stock"));
            material.setDestacado(rs.getBoolean("destacado"));
            material.setEspecificaciones(rs.getString("especificaciones"));
            material.setUnidadMedida(rs.getString("unidad_medida"));
            material.setPeso(rs.getBigDecimal("peso"));
            material.setDimension(rs.getString("dimension"));
            material.setColor(rs.getString("color"));
            
            // Intentar obtener fecha_creacion (manejo seguro para bases de datos antiguas)
            if (rs.getTimestamp("fecha_creacion") != null) {
                material.setFechaCreacion(rs.getTimestamp("fecha_creacion").toLocalDateTime());
            }
        } catch (SQLException e) {
            // Ignorar errores por columnas no existentes
            // Esto permite que el código funcione con la estructura antigua y nueva de la tabla
            System.out.println("Aviso: Algunas columnas nuevas no están disponibles. " + e.getMessage());
        }
        
        return material;
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
