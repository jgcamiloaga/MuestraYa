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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/listado-style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/cards-style.css">
        
        <!-- JavaScript -->
        <script>
            // Variable global para el path del contexto
            const contextPath = "${pageContext.request.contextPath}";
            
            // Función para confirmar eliminación de un material - INCORPORADA AQUÍ PARA GARANTIZAR FUNCIONAMIENTO
            function confirmarEliminar(id, nombre) {
                if (confirm("¿Estás seguro de que deseas eliminar el material '" + nombre + "'?")) {
                    window.location.href = contextPath + "/DeleteMaterial?id=" + id;
                }
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
                }

                // Cargar la vista preferida al iniciar
                const vistaPreferida = localStorage.getItem('vistaPreferida') || 'cards';
                cambiarVista(vistaPreferida);
            };
        </script>
    </head>
    <body>
        <div class="header">
            <h1>Sistema de Gestión de Materiales</h1>
            <div class="user-info">
                <span class="welcome-text">Bienvenido, ${sessionScope.usuario.nombre}</span>
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/VISTA/registerMaterial.jsp" class="nav-link">
                        <i class="fas fa-plus-circle"></i> Nuevo Material
                    </a>
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
                                    <c:set var="categoryClass" value="${fn:toLowerCase(material.idCategoria)}"/>
                                    <tr>
                                        <td class="col-id">${material.idMaterial}</td>
                                        <td class="col-name">${material.nombre}</td>
                                        <td class="col-category">
                                            <span class="category-badge ${categoryClass}">
                                                <i class="${Controlador.MaterialesServlet.getCategoryIcon(material.idCategoria)}"></i>
                                                ${material.nombreCategoria}
                                            </span>
                                        </td>
                                        <td class="col-price">
                                            <span class="price">$${material.precio}</span>
                                        </td>
                                        <td class="col-actions">
                                            <button class="delete-btn" onclick="confirmarEliminar('${material.idMaterial}', '${material.nombre}')">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Vista de tarjetas -->
                    <div id="cards-container" class="cards-container">
                        <c:forEach items="${materiales}" var="material">
                            <c:set var="categoryClass" value="${fn:toLowerCase(material.idCategoria)}"/>
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
                                                <i class="${Controlador.MaterialesServlet.getCategoryIcon(material.idCategoria)}"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-category">
                                        <span class="category-badge ${categoryClass}">
                                            <i class="${Controlador.MaterialesServlet.getCategoryIcon(material.idCategoria)}"></i>
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
                                    </div>
                                </div>
                                <div class="card-actions">
                                    <button class="delete-btn" onclick="confirmarEliminar('${material.idMaterial}', '${material.nombre}')">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <i class="fas fa-database"></i>
                        <p>No hay materiales disponibles.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>
