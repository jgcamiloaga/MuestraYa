package servicios;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
      // FLAG DE DESARROLLO: Cambiar a true para producción
    private static final boolean ENABLE_HASHING = false;
    
    // Método para generar un hash de la contraseña
    public static String hashPassword(String plainTextPassword) {
        if (ENABLE_HASHING) {
            // El parámetro 12 es el "work factor" - cuanto más alto, más seguro pero más lento
            return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(12));
        } else {
            // Retorna la contraseña en texto plano
            return plainTextPassword;
        }    }
    
    // Método para verificar si una contraseña coincide con su hash
    public static boolean checkPassword(String plainTextPassword, String hashedPassword) {
        if (ENABLE_HASHING) {
            return BCrypt.checkpw(plainTextPassword, hashedPassword);
        } else {
            // Comparación directa de texto
            return plainTextPassword.equals(hashedPassword);
        }
    }
}