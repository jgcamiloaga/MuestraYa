<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sesión Expirada - MuestraYa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .error-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            padding: 40px;
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        .error-icon {
            font-size: 4rem;
            color: #f39c12;
            margin-bottom: 20px;
        }
        .error-title {
            color: #2c3e50;
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .error-message {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .btn-return {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 25px;
            color: white;
            font-weight: 600;
            padding: 12px 30px;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .btn-return:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            color: white;
        }
        .security-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 25px;
            border-left: 4px solid #3498db;
        }
        .security-info h5 {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .security-info p {
            color: #6c757d;
            margin-bottom: 0;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">
            <i class="fas fa-clock"></i>
        </div>
        
        <h1 class="error-title">Sesión Expirada</h1>
        
        <p class="error-message">
            Su sesión ha expirado por motivos de seguridad. 
            Por favor, inicie sesión nuevamente para continuar.
        </p>
        
        <a href="<%= request.getContextPath() %>/vista/login.jsp" class="btn-return">
            <i class="fas fa-sign-in-alt me-2"></i>
            Iniciar Sesión
        </a>
        
        <div class="security-info">
            <h5><i class="fas fa-shield-alt me-2"></i>Información de Seguridad</h5>
            <p>
                Por su seguridad, las sesiones expiran automáticamente después de 30 minutos de inactividad. 
                Esto ayuda a proteger su cuenta y datos personales.
            </p>
        </div>
    </div>

    <script>
        // Prevenir navegación hacia atrás
        history.pushState(null, null, location.href);
        window.onpopstate = function () {
            history.go(1);
        };
        
        // Limpiar caché del navegador
        if ('caches' in window) {
            caches.keys().then(function(names) {
                names.forEach(function(name) {
                    caches.delete(name);
                });
            });
        }
        
        // Limpiar localStorage relacionado con la sesión
        if (typeof Storage !== "undefined") {
            const keysToRemove = [];
            for (let i = 0; i < localStorage.length; i++) {
                const key = localStorage.key(i);
                if (key && key.startsWith('session_')) {
                    keysToRemove.push(key);
                }
            }
            keysToRemove.forEach(key => localStorage.removeItem(key));
        }
    </script>
</body>
</html>
