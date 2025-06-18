package modelo.dao;

import modelo.dto.CarritoItem;
import servicios.ConexionDB;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CarritoDAO {
    
    // Agregar producto al carrito o actualizar cantidad si ya existe
    public boolean agregarAlCarrito(int idUsuario, String idMaterial, int cantidad, BigDecimal precioUnitario) {
        // Primero verificar si el producto ya está en el carrito
        if (existeEnCarrito(idUsuario, idMaterial)) {
            return actualizarCantidad(idUsuario, idMaterial, cantidad);
        } else {
            return insertarNuevoItem(idUsuario, idMaterial, cantidad, precioUnitario);
        }
    }    
    // Insertar nuevo item en el carrito
    private boolean insertarNuevoItem(int idUsuario, String idMaterial, int cantidad, BigDecimal precioUnitario) {
        String sql = "INSERT INTO carrito (id_usuario, id_material, cantidad, precio_unitario, fecha_agregado) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setString(2, idMaterial);
            stmt.setInt(3, cantidad);
            stmt.setBigDecimal(4, precioUnitario);
            stmt.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al insertar item en carrito: " + e.getMessage());
            return false;
        }
    }
    
    // Verificar si un producto ya existe en el carrito
    private boolean existeEnCarrito(int idUsuario, String idMaterial) {
        String sql = "SELECT COUNT(*) FROM carrito WHERE id_usuario = ? AND id_material = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setString(2, idMaterial);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error al verificar existencia en carrito: " + e.getMessage());
        }
        
        return false;
    }
    
    // Actualizar cantidad de un producto en el carrito
    public boolean actualizarCantidad(int idUsuario, String idMaterial, int cantidad) {
        String sql = "UPDATE carrito SET cantidad = cantidad + ? WHERE id_usuario = ? AND id_material = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cantidad);
            stmt.setInt(2, idUsuario);
            stmt.setString(3, idMaterial);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar cantidad en carrito: " + e.getMessage());
            return false;
        }
    }
    
    // Establecer cantidad específica de un producto
    public boolean establecerCantidad(int idUsuario, String idMaterial, int cantidad) {
        if (cantidad <= 0) {
            return eliminarDelCarrito(idUsuario, idMaterial);
        }
        
        String sql = "UPDATE carrito SET cantidad = ? WHERE id_usuario = ? AND id_material = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cantidad);
            stmt.setInt(2, idUsuario);
            stmt.setString(3, idMaterial);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al establecer cantidad en carrito: " + e.getMessage());
            return false;
        }
    }
    
    // Eliminar producto del carrito
    public boolean eliminarDelCarrito(int idUsuario, String idMaterial) {
        String sql = "DELETE FROM carrito WHERE id_usuario = ? AND id_material = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setString(2, idMaterial);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar del carrito: " + e.getMessage());
            return false;
        }
    }
      // Obtener todos los items del carrito de un usuario
    public List<CarritoItem> obtenerCarritoPorUsuario(int idUsuario) {
        List<CarritoItem> items = new ArrayList<>();
        String sql = "SELECT c.id_carrito, c.id_usuario, c.id_material, c.cantidad, " +
                     "c.precio_unitario, c.fecha_agregado, " +
                     "m.nombre as nombre_material, m.imagen as imagen_material, " +
                     "cat.nombre as nombre_categoria " +
                     "FROM carrito c " +
                     "INNER JOIN material m ON c.id_material = m.idMaterial " +
                     "INNER JOIN categoria cat ON m.idCategoria = cat.idCategoria " +
                     "WHERE c.id_usuario = ? " +
                     "ORDER BY c.fecha_agregado DESC";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                CarritoItem item = new CarritoItem();
                item.setIdCarrito(rs.getInt("id_carrito"));
                item.setIdUsuario(rs.getInt("id_usuario"));
                item.setIdMaterial(rs.getString("id_material"));
                item.setCantidad(rs.getInt("cantidad"));
                item.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
                item.setFechaAgregado(rs.getTimestamp("fecha_agregado").toLocalDateTime());
                item.setNombreMaterial(rs.getString("nombre_material"));
                item.setImagenMaterial(rs.getString("imagen_material"));
                item.setNombreCategoria(rs.getString("nombre_categoria"));
                
                items.add(item);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener carrito: " + e.getMessage());
        }
        
        return items;
    }
    
    // Vaciar carrito de un usuario
    public boolean vaciarCarrito(int idUsuario) {
        String sql = "DELETE FROM carrito WHERE id_usuario = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected >= 0; // Puede ser 0 si el carrito estaba vacío
            
        } catch (SQLException e) {
            System.err.println("Error al vaciar carrito: " + e.getMessage());
            return false;
        }
    }
    
    // Contar items en el carrito
    public int contarItemsCarrito(int idUsuario) {
        String sql = "SELECT SUM(cantidad) FROM carrito WHERE id_usuario = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al contar items del carrito: " + e.getMessage());
        }
        
        return 0;
    }
    
    // Calcular total del carrito
    public BigDecimal calcularTotal(int idUsuario) {
        String sql = "SELECT SUM(cantidad * precio_unitario) as total FROM carrito WHERE id_usuario = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                return total != null ? total : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error al calcular total del carrito: " + e.getMessage());
        }
        
        return BigDecimal.ZERO;
    }
}
