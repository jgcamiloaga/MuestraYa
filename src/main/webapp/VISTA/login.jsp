<%-- 
    Document   : Login
    Created on : 17 abr. 2025, 6:54:50 p. m.
    Author     : Johann
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MuestraYa - Iniciar Sesión</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Usar el ResourceServlet para cargar el CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/CSS/login-style.css">
        <!-- Estilo de respaldo en caso de que falle la carga del CSS -->
        <style>
            /* Estilos base de respaldo para asegurar funcionalidad mínima
            @import url("https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap");
            
            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: "Poppins", sans-serif;
                padding: 20px;
                margin: 0;
            }
            
            .page-container {
                width: 100%;
                max-width: 450px;
            }
            
            .form-card {
                background-color: white;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(58, 134, 255, 0.1);
                overflow: hidden;
            }
            
            .header {
                background: linear-gradient(135deg, #3a86ff 0%, #4895ef 100%);
                color: white;
                padding: 30px;
                text-align: center;
            }
            
            .form-container {
                padding: 30px;
            }
            
            .form-group {
                margin-bottom: 25px;
            }
            
            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                font-size: 14px;
            }
            
            input {
                width: 100%;
                padding: 14px 14px 14px 45px;
                border: 1px solid #e1e5ee;
                border-radius: 8px;
                font-size: 15px;
                margin-bottom: 10px;
            }
            
            .input-container {
                position: relative;
            }
            
            .icon {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #8d99ae;
            }
            
            .submit-btn {
                width: 100%;
                background: linear-gradient(135deg, #3a86ff 0%, #4895ef 100%);
                color: white;
                border: none;
                border-radius: 8px;
                padding: 16px;
                font-weight: 600;
                font-size: 16px;
                cursor: pointer;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px;
            }
            
            .alert {
                padding: 15px;
                margin: 0 30px 20px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 14px;
            }
            
            .alert-error {
                background-color: #ffe5e5;
                color: #e53935;
                border-left: 4px solid #e53935;
            }
            
            .alert-success {
                background-color: #e8f5e9;
                color: #43a047;
                border-left: 4px solid #43a047;
            } */
        </style>
    </head>
    <body>
        <div class="page-container">
            <div class="form-card">
                <div class="header">
                    <h1>Iniciar Sesión</h1>
                    <p class="subtitle">MuestraYa</p>
                </div>

                <% if (request.getAttribute("errorMessage") != null) {%>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("errorMessage")%>
                </div>
                <% } %>

                <% if (request.getAttribute("successMessage") != null) {%>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("successMessage")%>
                </div>
                <% }%>

                <form action="<%= request.getContextPath() %>/login" method="post" class="form-container">
                    <div class="form-group">
                        <label for="email">Correo Electrónico</label>
                        <div class="input-container">
                            <i class="fas fa-envelope icon"></i>
                            <input type="email" id="email" name="email" placeholder="Ingrese su correo electrónico" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Contraseña</label>
                        <div class="input-container">
                            <i class="fas fa-lock icon"></i>
                            <input type="password" id="password" name="password" placeholder="Ingrese su contraseña" required>
                        </div>
                    </div>

                    <button type="submit" class="submit-btn">
                        <span>INICIAR SESIÓN</span>
                        <i class="fas fa-sign-in-alt"></i>
                    </button>

                    <div class="register-link" style="text-align: center; margin-top: 20px; font-size: 14px;">
                        ¿No tienes una cuenta? <a href="<%= request.getContextPath() %>/VISTA/registerUser.jsp" style="color: #3a86ff; text-decoration: none; font-weight: 500;">Registrarse</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
