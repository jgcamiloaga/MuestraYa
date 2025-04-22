package Util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    
    // Método para generar un hash de la contraseña
    public static String hashPassword(String plainTextPassword) {
        // El parámetro 12 es el "work factor" - cuanto más alto, más seguro pero más lento
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(12));
    }
    
    // Método para verificar si una contraseña coincide con su hash
    public static boolean checkPassword(String plainTextPassword, String hashedPassword) {
        return BCrypt.checkpw(plainTextPassword, hashedPassword);
    }
}