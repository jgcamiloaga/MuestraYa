<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>
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
    
    // Si no hay materiales en el request, redirigir al servlet para cargarlos
    if (request.getAttribute("materiales") == null) {
        response.sendRedirect(request.getContextPath() + "/materiales");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MuestraYa - Listado de Materiales</title>
        <!-- CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/css/listado-style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/css/cards-style.css">
        
        <!-- JavaScript -->
        <script>
            // Variable global para el path del contexto
            const contextPath = "${pageContext.request.contextPath}";            // Función para confirmar eliminación de un material - Modal personalizado
            function confirmarEliminar(id, nombre) {
                mostrarModalConfirmacion(
                    '¿Eliminar Material?',
                    '¿Estás seguro de que deseas eliminar el material <strong>"' + nombre + '"</strong>?',
                    'Esta acción no se puede deshacer.',
                    function() {
                        window.location.href = contextPath + "/DeleteMaterial?id=" + id;
                    }
                );
            }
              // Función para mostrar modal de confirmación personalizado
            function mostrarModalConfirmacion(titulo, mensaje, descripcion, callback) {
                // Limpiar modales existentes
                const existingModals = document.querySelectorAll('.modal-overlay');
                existingModals.forEach(function(modal) {
                    if (document.body.contains(modal)) {
                        document.body.removeChild(modal);
                    }
                });
                
                // Crear el modal
                const modal = document.createElement('div');
                modal.className = 'modal-overlay';
                
                let descripcionHtml = '';
                if (descripcion && descripcion.trim() !== '') {
                    descripcionHtml = '<small class="modal-description">' + descripcion + '</small>';
                }
                
                modal.innerHTML = 
                    '<div class="modal-content">' +
                        '<div class="modal-header">' +
                            '<i class="fas fa-exclamation-triangle"></i>' +
                            '<h3>' + titulo + '</h3>' +
                        '</div>' +
                        '<div class="modal-body">' +
                            '<p>' + mensaje + '</p>' +
                            descripcionHtml +
                        '</div>' +
                        '<div class="modal-footer">' +
                            '<button class="btn-cancelar" onclick="cerrarModal()">' +
                                '<i class="fas fa-times"></i> Cancelar' +
                            '</button>' +
                            '<button class="btn-confirmar" onclick="confirmarAccion()">' +
                                '<i class="fas fa-trash"></i> Eliminar' +
                            '</button>' +
                        '</div>' +
                    '</div>';
                
                document.body.appendChild(modal);
                
                // Mostrar modal con animación
                setTimeout(function() {
                    modal.classList.add('show');
                }, 10);
                  // Funciones globales para el modal
                window.cerrarModal = function() {
                    modal.classList.remove('show');
                    setTimeout(function() {
                        if (document.body.contains(modal)) {
                            document.body.removeChild(modal);
                        }
                        delete window.cerrarModal;
                        delete window.confirmarAccion;
                    }, 300);
                };
                
                window.confirmarAccion = function() {
                    window.cerrarModal();
                    if (callback && typeof callback === 'function') {
                        callback();
                    }
                };
                
                // Cerrar con ESC
                function handleEsc(e) {
                    if (e.key === 'Escape') {
                        window.cerrarModal();
                        document.removeEventListener('keydown', handleEsc);
                    }
                }
                document.addEventListener('keydown', handleEsc);
                
                // Cerrar al hacer click fuera del modal
                modal.addEventListener('click', function(e) {
                    if (e.target === modal) {
                        window.cerrarModal();
                    }
                });
            }
            
            // Función para cambiar entre vista de tabla y tarjetas
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
              // Código que se ejecuta al cargar la página
            window.onload = function() {
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
                }                // Cargar la vista preferida al iniciar
                const vistaPreferida = localStorage.getItem('vistaPreferida') || 'cards';
                cambiarVista(vistaPreferida);            };
        </script>
          <!-- Estilos adicionales para asegurar compatibilidad con FontAwesome -->
        <style>
            .material-card .default-image i,
            .category-badge i {
                display: inline-block !important;
                margin-right: 5px;
                font-size: 14px;
            }
              /* Asegurar que las categorías tengan los colores correctos */
            .category-badge.cat001 { background-color: var(--cat001-color); }
            .category-badge.cat002 { background-color: var(--cat002-color); }
            .category-badge.cat003 { background-color: var(--cat003-color); }
            .category-badge.cat004 { background-color: var(--cat004-color); }
            .category-badge.cat005 { background-color: var(--cat005-color); }
            .category-badge.cat006 { background-color: var(--cat006-color); }
              /* Material cards clases para categorías */
            .material-card.cat001 { border-top: 4px solid var(--cat001-color); }
            .material-card.cat002 { border-top: 4px solid var(--cat002-color); }
            .material-card.cat003 { border-top: 4px solid var(--cat003-color); }
            .material-card.cat004 { border-top: 4px solid var(--cat004-color); }
            .material-card.cat005 { border-top: 4px solid var(--cat005-color); }
            .material-card.cat006 { border-top: 4px solid var(--cat006-color); }
            
            /* Corregir posicionamiento y evitar overlaps */
            .material-card {
                position: relative;
                overflow: hidden;
                z-index: 1;
            }
            
            .card-content {
                position: relative;
                z-index: 2;
            }
            
            .card-details {
                position: relative;
                z-index: 2;
                background-color: #f9fafc;
                padding: 12px 15px;
                border-radius: 10px;
                margin-top: 15px;
            }
              .card-id .detail-value {
                word-break: break-all;
                max-width: 120px;
                overflow: hidden;
                text-overflow: ellipsis;
            }
              /* Fixes responsivos adicionales */
            @media (max-width: 768px) {
                .card-details {
                    flex-direction: column;
                    gap: 8px;
                    text-align: center;
                }
                
                .card-id .detail-value {
                    max-width: none;
                }
                
                .card-actions {
                    padding: 0.75rem;
                    gap: 0.75rem;
                }
                
                .delete-btn {
                    width: 36px;
                    height: 36px;
                    font-size: 1rem;
                }
            }/* Estilos para botones de acción */
            .card-actions {
                display: flex;
                gap: 0.5rem;
                justify-content: center;
                padding: 1rem;
                border-top: 1px solid #f0f0f0;
                background-color: #fafbfd;
                margin-top: auto;
            }
            
            .delete-btn {
                padding: 0.5rem;
                border: none;
                border-radius: 50%;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 1.1rem;
                position: relative;
                z-index: 1;
            }            
            .delete-btn {
                background: #fff;
                color: #dc3545;
                border: 2px solid #dc3545;
            }
            
            .delete-btn:hover {
                background: #dc3545;
                color: white;
                transform: scale(1.1);
            }
            
            /* Estilos para botones en tabla */
            .table-btn {
                width: 35px;
                height: 35px;
                margin: 0 0.25rem;
                font-size: 0.9rem;
            }
            
            .col-actions {
                text-align: center;
                white-space: nowrap;
            }
            
            /* Estilos para modal de confirmación personalizado */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.6);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 10000;
                opacity: 0;
                visibility: hidden;
                transition: all 0.3s ease;
            }
            
            .modal-overlay.show {
                opacity: 1;
                visibility: visible;
            }
            
            .modal-content {
                background: white;
                border-radius: 12px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                max-width: 450px;
                width: 90%;
                max-height: 90vh;
                overflow: hidden;
                transform: scale(0.8) translateY(-20px);
                transition: all 0.3s ease;
            }
            
            .modal-overlay.show .modal-content {
                transform: scale(1) translateY(0);
            }
            
            .modal-header {
                background: linear-gradient(135deg, #ff6b6b, #ee5a52);
                color: white;
                padding: 20px;
                text-align: center;
                position: relative;
            }
            
            .modal-header i {
                font-size: 2.5rem;
                margin-bottom: 10px;
                display: block;
                animation: pulse 2s infinite;
            }
            
            .modal-header h3 {
                margin: 0;
                font-size: 1.3rem;
                font-weight: 600;
            }
            
            .modal-body {
                padding: 25px;
                text-align: center;
            }
            
            .modal-body p {
                margin: 0 0 15px 0;
                font-size: 1.1rem;
                color: #333;
                line-height: 1.5;
            }
            
            .modal-description {
                color: #666;
                font-style: italic;
                display: block;
                margin-top: 10px;
            }
            
            .modal-footer {
                padding: 20px;
                display: flex;
                gap: 15px;
                justify-content: center;
                background: #f8f9fa;
            }
            
            .modal-footer button {
                padding: 12px 25px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease;
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 0.95rem;
                min-width: 120px;
                justify-content: center;
            }
            
            .btn-cancelar {
                background: #6c757d;
                color: white;
            }
            
            .btn-cancelar:hover {
                background: #5a6268;
                transform: translateY(-1px);
            }
            
            .btn-confirmar {
                background: #dc3545;
                color: white;
            }
            
            .btn-confirmar:hover {
                background: #c82333;
                transform: translateY(-1px);
            }
            
            @keyframes pulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.1); }
            }
            
            /* Responsivo */
            @media (max-width: 480px) {
                .modal-content {
                    width: 95%;
                    margin: 20px;
                }
                
                .modal-footer {
                    flex-direction: column;
                }
                
                .modal-footer button {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>Sistema de Gestión de Materiales</h1>
            <div class="user-info">
                <span class="welcome-text">Bienvenido, ${sessionScope.usuario.nombre}</span>                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/products?from=listado" class="nav-link home-link">
                        <i class="fas fa-home"></i> Página Principal
                    </a>
                    
                    <% if ("admin".equals(((modelo.dto.Usuario)session.getAttribute("usuario")).getRol())) { %>
                    <a href="${pageContext.request.contextPath}/vista/registerMaterial.jsp" class="nav-link">
                        <i class="fas fa-plus-circle"></i> Nuevo Material
                    </a>
                    <a href="${pageContext.request.contextPath}/registerAdmin" class="nav-link">
                        <i class="fas fa-user-shield"></i> Registrar Admin
                    </a>
                    <% } %>
                    
                    <a href="${pageContext.request.contextPath}/logout" class="nav-link logout-link">
                        <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                    </a>
                </div>
            </div>
        </div>

        <div class="container">
            <div class="title-bar">
                <h2>Listado de Materiales</h2>
                <div class="view-toggle">
                    <button id="btn-tabla" class="view-btn" onclick="cambiarVista('tabla')">
                        <i class="fas fa-list"></i> Lista
                    </button>
                    <button id="btn-cards" class="view-btn active" onclick="cambiarVista('cards')">
                        <i class="fas fa-th-large"></i> Tarjetas
                    </button>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty materiales}">
                    <!-- Vista de tabla -->
                    <div id="tabla-container" class="table-container">
                        <table class="materials-table">
                            <thead>
                                <tr>
                                    <th class="col-id">ID</th>
                                    <th class="col-name">Nombre</th>
                                    <th class="col-category">Categoría</th>
                                    <th class="col-price">Precio</th>
                                    <th class="col-actions">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${materiales}" var="material">
                                    <c:set var="categoryClass" value="cat${fn:substring(material.idCategoria, 3, 6)}"/>
                                    <tr>
                                        <td class="col-id">${material.idMaterial}</td>
                                        <td class="col-name">${material.nombre}</td>
                                        <td class="col-category">
                                            <span class="category-badge ${categoryClass}">
                                                <i class="<c:out value="${
                                                    material.idCategoria eq 'CAT001' ? 'fas fa-tools' :
                                                    material.idCategoria eq 'CAT002' ? 'fas fa-tshirt' :
                                                    material.idCategoria eq 'CAT003' ? 'fas fa-utensils' :
                                                    material.idCategoria eq 'CAT004' ? 'fas fa-laptop' :
                                                    material.idCategoria eq 'CAT005' ? 'fas fa-hard-hat' :
                                                    material.idCategoria eq 'CAT006' ? 'fas fa-briefcase' : 'fas fa-tag'
                                                }"/>"></i>
                                                ${material.nombreCategoria}
                                            </span>
                                        </td>
                                        <td class="col-price">
                                            <span class="price">$${material.precio}</span>                                        </td>                                        <td class="col-actions">
                                            <% if ("admin".equals(((modelo.dto.Usuario)session.getAttribute("usuario")).getRol())) { %>
                                            <button class="delete-btn table-btn" onclick="confirmarEliminar('${material.idMaterial}', '${material.nombre}')"
                                                    title="Eliminar material">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                            <% } %>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Vista de tarjetas -->
                    <div id="cards-container" class="cards-container">
                        <c:forEach items="${materiales}" var="material">
                            <c:set var="categoryClass" value="cat${fn:substring(material.idCategoria, 3, 6)}"/>
                            <div class="material-card ${categoryClass}">
                                <div class="card-image">
                                    <c:choose>
                                        <c:when test="${not empty material.imagen and material.imagen ne 'default.jpg'}">
                                            <img src="${pageContext.request.contextPath}/image/${material.imagen}" 
                                                 alt="${material.nombre}" 
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/image/default.jpg';">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="default-image">
                                                <i class="<c:out value="${
                                                    material.idCategoria eq 'CAT001' ? 'fas fa-tools' :
                                                    material.idCategoria eq 'CAT002' ? 'fas fa-tshirt' :
                                                    material.idCategoria eq 'CAT003' ? 'fas fa-utensils' :
                                                    material.idCategoria eq 'CAT004' ? 'fas fa-laptop' :
                                                    material.idCategoria eq 'CAT005' ? 'fas fa-hard-hat' :
                                                    material.idCategoria eq 'CAT006' ? 'fas fa-briefcase' : 'fas fa-tag'
                                                }"/>"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-category">
                                        <span class="category-badge ${categoryClass}">
                                            <i class="<c:out value="${
                                                material.idCategoria eq 'CAT001' ? 'fas fa-tools' :
                                                material.idCategoria eq 'CAT002' ? 'fas fa-tshirt' :
                                                material.idCategoria eq 'CAT003' ? 'fas fa-utensils' :
                                                material.idCategoria eq 'CAT004' ? 'fas fa-laptop' :
                                                material.idCategoria eq 'CAT005' ? 'fas fa-hard-hat' :
                                                material.idCategoria eq 'CAT006' ? 'fas fa-briefcase' : 'fas fa-tag'
                                            }"/>"></i>
                                            ${material.nombreCategoria}
                                        </span>
                                    </div>
                                </div>
                <div class="card-content">
                    <h3 class="card-title">${material.nombre}</h3>
                    <div class="card-details">
                        <div class="card-id">
                            <span class="detail-label">ID:</span>
                            <span class="detail-value">${material.idMaterial}</span>
                        </div>
                        <div class="card-price">
                            <span class="price">$${material.precio}</span>
                        </div>
                    </div>                </div>                <div class="card-actions">
                                    <% if ("admin".equals(((modelo.dto.Usuario)session.getAttribute("usuario")).getRol())) { %>
                                    <button class="delete-btn" onclick="confirmarEliminar('${material.idMaterial}', '${material.nombre}')"
                                            title="Eliminar material">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                    <% } %>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <i class="fas fa-database"></i>
                        <p>No hay materiales disponibles.</p>
                    </div>                </c:otherwise>
            </c:choose>        </div>
        
        <!-- Contenedor para notificaciones toast -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3"></div>
        
        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/recursos/js/navbar.js"></script>
    </body>
</html>
