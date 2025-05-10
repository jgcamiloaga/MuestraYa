package modelo.dao;

import modelo.dto.Usuario;
import servicios.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase de acceso a datos para la entidad Usuario
 */
public class UsuarioDAO {
    
    /**
     * Busca un usuario por su email
     * @param email Email del usuario
     * @return El usuario encontrado o null
     */
    public Usuario buscarPorEmail(String email) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Usuario usuario = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT * FROM usuario WHERE email = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("idUsuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setEmail(rs.getString("email"));
                usuario.setPassword(rs.getString("password"));
                usuario.setRol(rs.getString("rol"));
                usuario.setFechaCreacion(rs.getTimestamp("fechaCreacion"));
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar usuario por email: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return usuario;
    }
    
    /**
     * Verifica si ya existe un email registrado
     * @param email Email a verificar
     * @return true si el email ya existe en la base de datos
     */
    public boolean existeEmail(String email) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean existe = false;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT COUNT(*) FROM usuario WHERE email = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                existe = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error al verificar existencia de email: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return existe;
    }
    
    /**
     * Busca un usuario por su ID
     * @param idUsuario ID del usuario
     * @return El usuario encontrado o null
     */
    public Usuario buscarPorId(int idUsuario) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Usuario usuario = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT * FROM usuario WHERE idUsuario = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idUsuario);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("idUsuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setEmail(rs.getString("email"));
                usuario.setPassword(rs.getString("password"));
                usuario.setRol(rs.getString("rol"));
                usuario.setFechaCreacion(rs.getTimestamp("fechaCreacion"));
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar usuario por ID: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return usuario;
    }
    
    /**
     * Lista todos los usuarios
     * @return Lista de usuarios
     */
    public List<Usuario> listarTodos() {
        List<Usuario> usuarios = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM usuario ORDER BY nombre";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("idUsuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setEmail(rs.getString("email"));
                usuario.setPassword(rs.getString("password"));
                usuario.setRol(rs.getString("rol"));
                usuario.setFechaCreacion(rs.getTimestamp("fechaCreacion"));
                usuarios.add(usuario);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar usuarios: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn);
        }
        
        return usuarios;
    }
    
    /**
     * Inserta un nuevo usuario en la base de datos
     * @param usuario Usuario a insertar
     * @return true si la inserción fue exitosa
     */
    public boolean insertar(Usuario usuario) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "INSERT INTO usuario (nombre, email, password, rol) VALUES (?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getPassword());
            stmt.setString(4, usuario.getRol());
            
            int filasAfectadas = stmt.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al insertar usuario: " + e.getMessage());
        } finally {
            cerrarRecursos(null, stmt, conn);
        }
        
        return resultado;
    }
    
    /**
     * Actualiza un usuario existente
     * @param usuario Usuario con los datos actualizados
     * @return true si la actualización fue exitosa
     */
    public boolean actualizar(Usuario usuario) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "UPDATE usuario SET nombre = ?, email = ?, rol = ? WHERE idUsuario = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getRol());
            stmt.setInt(4, usuario.getIdUsuario());
            
            int filasAfectadas = stmt.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar usuario: " + e.getMessage());
        } finally {
            cerrarRecursos(null, stmt, conn);
        }
        
        return resultado;
    }
    
    /**
     * Actualiza la contraseña de un usuario
     * @param idUsuario ID del usuario
     * @param newHashedPassword Nueva contraseña hasheada
     * @return true si la actualización fue exitosa
     */
    public boolean actualizarPassword(int idUsuario, String newHashedPassword) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "UPDATE usuario SET password = ? WHERE idUsuario = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newHashedPassword);
            stmt.setInt(2, idUsuario);
            
            int filasAfectadas = stmt.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar contraseña: " + e.getMessage());
        } finally {
            cerrarRecursos(null, stmt, conn);
        }
        
        return resultado;
    }
    
    /**
     * Elimina un usuario por su ID
     * @param idUsuario ID del usuario a eliminar
     * @return true si la eliminación fue exitosa
     */
    public boolean eliminar(int idUsuario) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "DELETE FROM usuario WHERE idUsuario = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idUsuario);
            
            int filasAfectadas = stmt.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar usuario: " + e.getMessage());
        } finally {
            cerrarRecursos(null, stmt, conn);
        }
        
        return resultado;
    }
    
    /**
     * Cierra recursos de base de datos
     * @param rs ResultSet
     * @param stmt Statement o PreparedStatement
     * @param conn Connection
     */
    private void cerrarRecursos(ResultSet rs, Object stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) {
                if (stmt instanceof PreparedStatement) {
                    ((PreparedStatement) stmt).close();
                } else if (stmt instanceof Statement) {
                    ((Statement) stmt).close();
                }
            }
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
}
