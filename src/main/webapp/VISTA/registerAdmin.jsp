<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%
    // Configurar cabeceras para evitar caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Verificar si el usuario está autenticado
    if (session == null || session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MuestraYa - Registro de Administrador</title>        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/css/registerUser-style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/css/registerAdmin-style.css">
    </head>
    <body>
        <div class="page-container">            <div class="form-card">
                <div class="header">
                    <h1>Registro de Administrador</h1>
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

                <form action="${pageContext.request.contextPath}/registerAdmin" method="POST" class="form-container" id="registerForm">
                    <div class="form-group">
                        <label for="nombre">Nombre Completo</label>
                        <div class="input-container">
                            <i class="fas fa-user icon"></i>
                            <input type="text" id="nombre" name="nombre" placeholder="Ingrese nombre completo del administrador" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <div class="input-container">
                            <i class="fas fa-envelope icon"></i>
                            <input type="email" id="email" name="email" placeholder="Ingrese correo electrónico" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Contraseña</label>
                        <div class="input-container">
                            <i class="fas fa-lock icon"></i>
                            <input type="password" id="password" name="password" placeholder="Ingrese contraseña" required>
                            <i class="fas fa-eye toggle-password" id="togglePassword"></i>
                        </div>
                        <div class="password-strength">
                            <div class="strength-meter">
                                <div class="strength-meter-fill" id="strengthMeter"></div>
                            </div>
                            <div class="strength-text" id="strengthText">Seguridad de la contraseña</div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirmar Contraseña</label>
                        <div class="input-container">
                            <i class="fas fa-lock icon"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirme contraseña" required>
                            <i class="fas fa-eye toggle-password" id="toggleConfirmPassword"></i>
                        </div>
                        <div class="password-match" id="passwordMatch"></div>
                    </div>                    <button type="submit" class="submit-btn" id="submitBtn">
                        <span>REGISTRAR ADMINISTRADOR</span>
                        <i class="fas fa-user-shield"></i>
                    </button>

                    <a href="${pageContext.request.contextPath}/materiales" class="back-link">
                        <i class="fas fa-arrow-left"></i> Volver al listado de materiales
                    </a>
                </form>
            </div>
        </div>        <script>
            // Mostrar/ocultar contraseña
            document.getElementById('togglePassword').addEventListener('click', function () {
                const passwordInput = document.getElementById('password');
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });

            document.getElementById('toggleConfirmPassword').addEventListener('click', function () {
                const confirmPasswordInput = document.getElementById('confirmPassword');
                const type = confirmPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                confirmPasswordInput.setAttribute('type', type);
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });

            // Validar fortaleza de la contraseña
            document.getElementById('password').addEventListener('input', function () {
                const password = this.value;
                const strengthMeter = document.getElementById('strengthMeter');
                const strengthText = document.getElementById('strengthText');
                
                // Criterios de fortaleza
                const hasLowerCase = /[a-z]/.test(password);
                const hasUpperCase = /[A-Z]/.test(password);
                const hasNumber = /[0-9]/.test(password);
                const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
                const isLongEnough = password.length >= 8;
                
                // Calcular puntuación (0-100)
                let score = 0;
                if (hasLowerCase)
                    score += 20;
                if (hasUpperCase)
                    score += 20;
                if (hasNumber)
                    score += 20;
                if (hasSpecialChar)
                    score += 20;
                if (isLongEnough)
                    score += 20;
                
                // Actualizar medidor visual
                strengthMeter.style.width = score + '%';
                
                // Actualizar texto según la fortaleza (usando las variables CSS del sitio)
                if (score === 0) {
                    strengthText.textContent = 'Seguridad de la contraseña';
                    strengthMeter.style.backgroundColor = '#e1e1e1';
                } else if (score <= 20) {
                    strengthText.textContent = 'Muy débil';
                    strengthMeter.style.backgroundColor = '#ff4d4d';
                } else if (score <= 40) {
                    strengthText.textContent = 'Débil';
                    strengthMeter.style.backgroundColor = '#ffa64d';
                } else if (score <= 60) {
                    strengthText.textContent = 'Media';
                    strengthMeter.style.backgroundColor = '#ffff4d';
                } else if (score <= 80) {
                    strengthText.textContent = 'Fuerte';
                    strengthMeter.style.backgroundColor = '#4dff4d';
                } else {
                    strengthText.textContent = 'Muy fuerte';
                    strengthMeter.style.backgroundColor = 'var(--primary-color)';
                }
            });

            // Verificar que las contraseñas coincidan
            document.getElementById('confirmPassword').addEventListener('input', function () {
                const password = document.getElementById('password').value;
                const confirmPassword = this.value;
                const passwordMatch = document.getElementById('passwordMatch');
                
                if (confirmPassword === '') {
                    passwordMatch.textContent = '';
                    passwordMatch.className = 'password-match';
                } else if (password === confirmPassword) {
                    passwordMatch.textContent = 'Las contraseñas coinciden';
                    passwordMatch.className = 'password-match match';
                } else {
                    passwordMatch.textContent = 'Las contraseñas no coinciden';
                    passwordMatch.className = 'password-match no-match';
                }
            });

            // Validación del formulario antes de enviar
            document.getElementById('registerForm').addEventListener('submit', function (e) {
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                
                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Las contraseñas no coinciden. Por favor, inténtelo de nuevo.');
                    return false;
                }
                
                // Validar fortaleza mínima de la contraseña
                const hasLowerCase = /[a-z]/.test(password);
                const hasUpperCase = /[A-Z]/.test(password);
                const hasNumber = /[0-9]/.test(password);
                const isLongEnough = password.length >= 8;
                
                if (!(hasLowerCase && hasUpperCase && hasNumber && isLongEnough)) {
                    e.preventDefault();
                    alert('La contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas y números.');
                    return false;
                }
                
                return true;
            });
        </script>
    </body>
</html>
