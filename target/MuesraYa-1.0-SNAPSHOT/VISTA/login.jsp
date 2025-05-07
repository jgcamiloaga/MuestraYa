<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MuestraYa - Iniciar Sesión</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/css/login-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
        <div class="page-container">
            <div class="form-card">
                <div class="header">
                    <h1>Iniciar Sesión</h1>
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
                            <i class="fas fa-eye toggle-password" id="togglePassword"></i>
                        </div>
                    </div>

                    <button type="submit" class="submit-btn">
                        <span>INICIAR SESIÓN</span>
                        <i class="fas fa-sign-in-alt"></i>
                    </button>

                    <div class="register-link">
                        ¿No tienes una cuenta? <a href="${pageContext.request.contextPath}/vista/registerUser.jsp">Registrarse</a>
                    </div>
                </form>
            </div>
        </div>
        <script>
            // Mostrar/ocultar contraseña
            document.addEventListener('DOMContentLoaded', function () {
                const togglePassword = document.querySelector('.toggle-password');
                const passwordInput = document.getElementById('password');

                if (togglePassword && passwordInput) {
                    togglePassword.addEventListener('click', function () {
                        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                        passwordInput.setAttribute('type', type);
                        this.classList.toggle('fa-eye');
                        this.classList.toggle('fa-eye-slash');
                    });
                }
            });
        </script>
    </body>
</html>
