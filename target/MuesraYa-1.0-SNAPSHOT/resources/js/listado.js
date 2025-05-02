/**
 * Funciones JavaScript para la página de listado de materiales
 */

// Confirmar eliminación de un material
function confirmarEliminar(id, nombre) {
    if (confirm("¿Estás seguro de que deseas eliminar el material '" + nombre + "'?")) {
        window.location.href = contextPath + "/DeleteMaterial?id=" + id;
    }
}

// Función que se ejecuta al cargar la página
document.addEventListener('DOMContentLoaded', function() {
    // Verificar si hay mensajes de notificación en la URL
    const urlParams = new URLSearchParams(window.location.search);
    const successParam = urlParams.get('success');
    const deleteParam = urlParams.get('delete');

    if (successParam === 'true') {
        mostrarNotificacion('Material registrado correctamente', 'success');
    }

    if (deleteParam === 'true') {
        mostrarNotificacion('Material eliminado correctamente', 'success');
    }

    if (urlParams.get('error') === 'true') {
        mostrarNotificacion('Ha ocurrido un error en la operación', 'error');
    }

    // Cargar la vista preferida al iniciar
    const vistaPreferida = localStorage.getItem('vistaPreferida') || 'cards';
    cambiarVista(vistaPreferida);
});

// Mostrar notificación temporal
function mostrarNotificacion(mensaje, tipo) {
    const notificacion = document.createElement('div');
    notificacion.className = 'notificacion ' + tipo;
    notificacion.innerHTML = '<i class="fas fa-' + (tipo === 'success' ? 'check-circle' : 'exclamation-circle') + '"></i> ' + mensaje;

    document.body.appendChild(notificacion);

    // Mostrar notificación
    setTimeout(function() {
        notificacion.classList.add('mostrar');
    }, 100);

    // Ocultar luego de 3 segundos
    setTimeout(function() {
        notificacion.classList.remove('mostrar');
        setTimeout(function() {
            document.body.removeChild(notificacion);
        }, 300);
    }, 3000);
}

// Cambiar entre vista de tabla y tarjetas
function cambiarVista(tipo) {
    const tablaContainer = document.getElementById('tabla-container');
    const cardsContainer = document.getElementById('cards-container');
    const btnTabla = document.getElementById('btn-tabla');
    const btnCards = document.getElementById('btn-cards');

    if (tablaContainer && cardsContainer && btnTabla && btnCards) {
        if (tipo === 'tabla') {
            tablaContainer.style.display = 'block';
            cardsContainer.style.display = 'none';
            btnTabla.classList.add('active');
            btnCards.classList.remove('active');
            localStorage.setItem('vistaPreferida', 'tabla');
        } else {
            tablaContainer.style.display = 'none';
            cardsContainer.style.display = 'grid';
            btnTabla.classList.remove('active');
            btnCards.classList.add('active');
            localStorage.setItem('vistaPreferida', 'cards');
        }
    }
}