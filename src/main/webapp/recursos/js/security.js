/**
 * Script de seguridad para prevenir navegación hacia atrás 
 * después del logout y manejar expiración de sesión
 */

// Función para prevenir navegación hacia atrás
function preventBackAfterLogout() {
    // Verificar si el usuario acaba de hacer logout
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('logout') === 'success') {
        // Reemplazar el historial del navegador
        history.replaceState(null, null, window.location.pathname);
        
        // Prevenir navegación hacia atrás
        window.addEventListener('popstate', function(event) {
            history.pushState(null, null, window.location.pathname);
            showLogoutMessage();
        });
        
        // Mostrar mensaje de logout exitoso
        showLogoutMessage();
    }
}

// Función para mostrar mensaje de logout
function showLogoutMessage() {
    // Crear y mostrar un mensaje temporal
    const message = document.createElement('div');
    message.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #4CAF50;
        color: white;
        padding: 15px 20px;
        border-radius: 5px;
        z-index: 10000;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        font-family: Arial, sans-serif;
    `;
    message.textContent = 'Sesión cerrada exitosamente';
    document.body.appendChild(message);
    
    // Remover el mensaje después de 3 segundos
    setTimeout(() => {
        if (message.parentNode) {
            message.parentNode.removeChild(message);
        }
    }, 3000);
}

// Función para verificar estado de sesión periódicamente
function checkSessionStatus() {
    // Solo verificar en páginas protegidas
    const protectedPages = ['/vista/registerMaterial.jsp', '/vista/listado.jsp', 
                           '/vista/registerAdmin.jsp', '/vista/favoritos.jsp'];
    
    const currentPath = window.location.pathname;
    const isProtectedPage = protectedPages.some(page => currentPath.includes(page));
    
    if (isProtectedPage) {
        // Verificar cada 5 minutos
        setInterval(() => {
            fetch(window.location.href, {
                method: 'HEAD',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (response.status === 401) {
                    // Sesión expirada
                    alert('Su sesión ha expirado. Será redirigido al login.');
                    window.location.href = '/vista/login.jsp';
                }
            })
            .catch(error => {
                console.warn('Error checking session status:', error);
            });
        }, 5 * 60 * 1000); // 5 minutos
    }
}

// Función para manejar el evento beforeunload en páginas protegidas
function handlePageUnload() {
    const protectedPages = ['/vista/registerMaterial.jsp', '/vista/listado.jsp', 
                           '/vista/registerAdmin.jsp', '/vista/favoritos.jsp'];
    
    const currentPath = window.location.pathname;
    const isProtectedPage = protectedPages.some(page => currentPath.includes(page));
    
    if (isProtectedPage) {
        window.addEventListener('beforeunload', function(e) {
            // Limpiar cualquier caché local si es necesario
            if (typeof Storage !== "undefined") {
                // Ejemplo: limpiar localStorage específico de la sesión
                const keysToRemove = [];
                for (let i = 0; i < localStorage.length; i++) {
                    const key = localStorage.key(i);
                    if (key && key.startsWith('session_')) {
                        keysToRemove.push(key);
                    }
                }
                keysToRemove.forEach(key => localStorage.removeItem(key));
            }
        });
    }
}

// Función para configurar headers de seguridad en peticiones AJAX
function setupSecureAjax() {
    // Interceptar todas las peticiones fetch
    const originalFetch = window.fetch;
    window.fetch = function(url, options = {}) {
        // Agregar headers de seguridad
        options.headers = options.headers || {};
        options.headers['X-Requested-With'] = 'XMLHttpRequest';
        
        return originalFetch(url, options)
            .then(response => {
                // Verificar si la respuesta indica sesión expirada
                if (response.status === 401) {
                    alert('Su sesión ha expirado. Será redirigido al login.');
                    window.location.href = '/vista/login.jsp';
                    return Promise.reject('Session expired');
                }
                return response;
            });
    };
    
    // Para jQuery si se usa
    if (typeof $ !== 'undefined') {
        $.ajaxSetup({
            beforeSend: function(xhr) {
                xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
            },
            error: function(xhr) {
                if (xhr.status === 401) {
                    alert('Su sesión ha expirado. Será redirigido al login.');
                    window.location.href = '/vista/login.jsp';
                }
            }
        });
    }
}

// Inicializar todas las funciones de seguridad cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function() {
    preventBackAfterLogout();
    checkSessionStatus();
    handlePageUnload();
    setupSecureAjax();
});

// También ejecutar al cargar la página completamente
window.addEventListener('load', function() {
    preventBackAfterLogout();
});
