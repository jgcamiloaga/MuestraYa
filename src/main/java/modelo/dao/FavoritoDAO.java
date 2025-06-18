package modelo.dao;

import modelo.dto.Favorito;
import servicios.ConexionDB;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class FavoritoDAO {
    
    // Agregar producto a favoritos
    public boolean agregarFavorito(int idUsuario, String idMaterial) {
        String sql = "INSERT INTO favoritos (id_usuario, id_material, fecha_agregado) VALUES (?, ?, ?)";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setString(2, idMaterial);
            stmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al agregar favorito: " + e.getMessage());
            return false;
        }
    }
    
    // Eliminar producto de favoritos
    public boolean eliminarFavorito(int idUsuario, String idMaterial) {
        String sql = "DELETE FROM favoritos WHERE id_usuario = ? AND id_material = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setString(2, idMaterial);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar favorito: " + e.getMessage());
            return false;
        }
    }
    
    // Verificar si un producto está en favoritos
    public boolean esFavorito(int idUsuario, String idMaterial) {
        String sql = "SELECT COUNT(*) FROM favoritos WHERE id_usuario = ? AND id_material = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setString(2, idMaterial);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error al verificar favorito: " + e.getMessage());
        }
        
        return false;
    }
      // Obtener todos los favoritos de un usuario
    public List<Favorito> obtenerFavoritosPorUsuario(int idUsuario) {
        List<Favorito> favoritos = new ArrayList<>();
        String sql = "SELECT f.id_favorito, f.id_usuario, f.id_material, f.fecha_agregado, " +
                     "m.nombre as nombre_material, m.precio as precio_material, " +
                     "m.imagen as imagen_material, c.nombre as nombre_categoria " +
                     "FROM favoritos f " +
                     "INNER JOIN material m ON f.id_material = m.idMaterial " +
                     "INNER JOIN categoria c ON m.idCategoria = c.idCategoria " +
                     "WHERE f.id_usuario = ? " +
                     "ORDER BY f.fecha_agregado DESC";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Favorito favorito = new Favorito();
                favorito.setIdFavorito(rs.getInt("id_favorito"));
                favorito.setIdUsuario(rs.getInt("id_usuario"));
                favorito.setIdMaterial(rs.getString("id_material"));
                favorito.setFechaAgregado(rs.getTimestamp("fecha_agregado").toLocalDateTime());
                favorito.setNombreMaterial(rs.getString("nombre_material"));
                favorito.setPrecioMaterial(rs.getString("precio_material"));
                favorito.setImagenMaterial(rs.getString("imagen_material"));
                favorito.setNombreCategoria(rs.getString("nombre_categoria"));
                
                favoritos.add(favorito);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener favoritos: " + e.getMessage());
        }
        
        return favoritos;
    }
    
    // Obtener cantidad de favoritos de un usuario
    public int contarFavoritos(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM favoritos WHERE id_usuario = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al contar favoritos: " + e.getMessage());
        }
        
        return 0;
    }
    
    // Limpiar todos los favoritos de un usuario
    public boolean limpiarFavoritos(int idUsuario) {
        String sql = "DELETE FROM favoritos WHERE id_usuario = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected >= 0; // Puede ser 0 si no había favoritos
            
        } catch (SQLException e) {
            System.err.println("Error al limpiar favoritos: " + e.getMessage());
            return false;
        }
    }
}
