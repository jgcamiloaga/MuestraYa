<%-- 
    Document   : Login
    Created on : 17 abr. 2025, 6:54:50 p. m.
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
        <link rel="stylesheet" href="../CSS/login-style.css"/>
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

                <form action="${pageContext.request.contextPath}/login" method="post" class="form-container">
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
                        ¿No tienes una cuenta? <a href="../VISTA/registerUser.jsp" style="color: var(--primary-color); text-decoration: none; font-weight: 500;">Registrarse</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
