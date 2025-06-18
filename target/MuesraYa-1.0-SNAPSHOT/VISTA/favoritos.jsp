<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>
<%
    // Verificar si el usuario está autenticado
    if (session == null || session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MuestraYa - Mis Favoritos</title>
    
    <!-- CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/css/listado-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/css/cards-style.css">
    
    <style>
        .favorites-header {
            background: linear-gradient(135deg, #e91e63, #c2185b);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            text-align: center;
            box-shadow: 0 8px 32px rgba(233, 30, 99, 0.3);
        }
        
        .favorites-header h1 {
            margin: 0 0 0.5rem 0;
            font-size: 2.5rem;
            font-weight: 700;
        }
        
        .favorites-header .subtitle {
            opacity: 0.9;
            font-size: 1.1rem;
        }
        
        .favorites-stats {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin: 1.5rem 0 0 0;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 25px;
            backdrop-filter: blur(10px);
        }
        
        .empty-favorites {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        
        .empty-favorites i {
            font-size: 4rem;
            color: #e91e63;
            margin-bottom: 1rem;
        }
        
        .empty-favorites h3 {
            color: #333;
            margin-bottom: 1rem;
        }
        
        .empty-favorites p {
            color: #666;
            margin-bottom: 2rem;
        }
        
        .btn-explore {
            background: linear-gradient(135deg, #e91e63, #c2185b);
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 25px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-explore:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(233, 30, 99, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .favorite-card {
            position: relative;
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 2px solid #e91e63;
        }
        
        .favorite-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(233, 30, 99, 0.2);
        }
        
        .favorite-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #e91e63;
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            z-index: 2;
        }
        
        .remove-favorite {
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(244, 67, 54, 0.9);
            color: white;
            border: none;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 2;
        }
        
        .remove-favorite:hover {
            background: #f44336;
            transform: scale(1.1);
        }
        
        .favorites-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding: 1rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .btn-clear-all {
            background: #f44336;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-clear-all:hover {
            background: #d32f2f;
            transform: translateY(-1px);
        }
        
        @media (max-width: 768px) {
            .favorites-stats {
                flex-direction: column;
                gap: 1rem;
            }
            
            .favorites-actions {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Incluir navbar -->
    <%@ include file="../componentes/navbar.jsp" %>
    
    <div class="container">
        <div class="favorites-header">
            <h1><i class="fas fa-heart"></i> Mis Favoritos</h1>
            <p class="subtitle">Todos tus productos favoritos en un solo lugar</p>
            <div class="favorites-stats">
                <div class="stat-item">
                    <i class="fas fa-heart"></i>
                    <span id="favorites-count">${fn:length(favoritos)}</span>
                    <span>favoritos</span>
                </div>
                <div class="stat-item">
                    <i class="fas fa-clock"></i>
                    <span>Actualizado</span>
                </div>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${not empty favoritos}">
                <div class="favorites-actions">
                    <div class="view-toggle">
                        <button id="btn-cards" class="view-btn active" onclick="cambiarVista('cards')">
                            <i class="fas fa-th-large"></i> Tarjetas
                        </button>
                        <button id="btn-tabla" class="view-btn" onclick="cambiarVista('tabla')">
                            <i class="fas fa-list"></i> Lista
                        </button>
                    </div>
                    <button class="btn-clear-all" onclick="limpiarTodosFavoritos()">
                        <i class="fas fa-trash-alt"></i>
                        Limpiar Todo
                    </button>
                </div>
                
                <!-- Vista de tarjetas -->
                <div id="cards-container" class="cards-container">
                    <c:forEach items="${favoritos}" var="favorito">
                        <c:set var="categoryClass" value="cat${fn:substring(favorito.idMaterial, 1, 4)}"/>
                        <div class="favorite-card material-card ${categoryClass}" data-id="${favorito.idMaterial}">
                            <span class="favorite-badge">
                                <i class="fas fa-heart"></i> Favorito
                            </span>
                            <button class="remove-favorite" onclick="toggleFavorito('${favorito.idMaterial}', this)">
                                <i class="fas fa-times"></i>
                            </button>
                            
                            <div class="card-image">
                                <c:choose>
                                    <c:when test="${not empty favorito.imagenMaterial and favorito.imagenMaterial ne 'default.jpg'}">
                                        <img src="${pageContext.request.contextPath}/image/${favorito.imagenMaterial}" 
                                             alt="${favorito.nombreMaterial}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="default-image">
                                            <i class="fas fa-heart"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-category">
                                    <span class="category-badge ${categoryClass}">
                                        <i class="fas fa-tag"></i>
                                        ${favorito.nombreCategoria}
                                    </span>
                                </div>
                            </div>
                            
                            <div class="card-content">
                                <h3 class="card-title">${favorito.nombreMaterial}</h3>
                                <div class="card-details">
                                    <div class="card-id">
                                        <span class="detail-label">ID:</span>
                                        <span class="detail-value">${favorito.idMaterial}</span>
                                    </div>
                                    <div class="card-price">
                                        <span class="price">$${favorito.precioMaterial}</span>
                                    </div>
                                </div>
                                <div class="card-date">
                                    <small class="text-muted">
                                        <i class="fas fa-calendar-plus"></i>
                                        Agregado: ${favorito.fechaAgregado.toLocalDate()}
                                    </small>
                                </div>
                            </div>
                              <div class="card-actions">
                                <button class="btn-add-cart" onclick="agregarAlCarrito('${favorito.idMaterial}', '${favorito.nombreMaterial}', '${favorito.precioMaterial}')">
                                    <i class="fas fa-shopping-cart"></i>
                                    Agregar al Carrito
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <!-- Vista de tabla -->
                <div id="tabla-container" class="table-container" style="display: none;">
                    <table class="materials-table">
                        <thead>
                            <tr>
                                <th>Material</th>
                                <th>Categoría</th>
                                <th>Precio</th>
                                <th>Fecha Agregado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${favoritos}" var="favorito">
                                <tr data-id="${favorito.idMaterial}">
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 1rem;">
                                            <img src="${pageContext.request.contextPath}/image/${favorito.imagenMaterial}" 
                                                 alt="${favorito.nombreMaterial}" 
                                                 style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px;">
                                            <div>
                                                <strong>${favorito.nombreMaterial}</strong>
                                                <br>
                                                <small class="text-muted">ID: ${favorito.idMaterial}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="category-badge">
                                            <i class="fas fa-tag"></i>
                                            ${favorito.nombreCategoria}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="price">$${favorito.precioMaterial}</span>
                                    </td>
                                    <td>
                                        <small>${favorito.fechaAgregado.toLocalDate()}</small>
                                    </td>                                    <td>
                                        <button class="btn-add-cart" onclick="agregarAlCarrito('${favorito.idMaterial}', '${favorito.nombreMaterial}', '${favorito.precioMaterial}')" style="margin-right: 0.5rem;">
                                            <i class="fas fa-shopping-cart"></i>
                                        </button>
                                        <button class="remove-favorite" onclick="toggleFavorito('${favorito.idMaterial}', this)">
                                            <i class="fas fa-heart-broken"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-favorites">
                    <i class="fas fa-heart-broken"></i>
                    <h3>No tienes favoritos aún</h3>
                    <p>Explora nuestros productos y agrega los que más te gusten a tu lista de favoritos.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn-explore">
                        <i class="fas fa-search"></i>
                        Explorar Productos
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/recursos/js/navbar.js"></script>
    
    <script>
        const contextPath = "${pageContext.request.contextPath}";
        
        // Función para cambiar vista
        function cambiarVista(tipo) {
            const tablaContainer = document.getElementById('tabla-container');
            const cardsContainer = document.getElementById('cards-container');
            const btnTabla = document.getElementById('btn-tabla');
            const btnCards = document.getElementById('btn-cards');

            if (tipo === 'tabla') {
                tablaContainer.style.display = 'block';
                cardsContainer.style.display = 'none';
                btnTabla.classList.add('active');
                btnCards.classList.remove('active');
            } else {
                tablaContainer.style.display = 'none';
                cardsContainer.style.display = 'grid';
                btnTabla.classList.remove('active');
                btnCards.classList.add('active');
            }
        }
        
        // Función para toggle favorito
        function toggleFavorito(idMaterial, button) {
            fetch(contextPath + '/favoritos?action=toggle&idMaterial=' + idMaterial, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Eliminar la tarjeta/fila del favorito
                    const card = button.closest('.favorite-card, tr');
                    if (card) {
                        card.style.transition = 'all 0.3s ease';
                        card.style.opacity = '0';
                        card.style.transform = 'scale(0.8)';
                        
                        setTimeout(() => {
                            card.remove();
                            actualizarContadorFavoritos();
                            
                            // Verificar si ya no hay favoritos
                            const remainingCards = document.querySelectorAll('.favorite-card, tbody tr');
                            if (remainingCards.length === 0) {
                                location.reload();
                            }
                        }, 300);
                    }
                    
                    mostrarNotificacion(data.message, 'success');
                    
                    // Actualizar contador global si existe
                    if (window.carrito && window.carrito.actualizarContadorFavoritos) {
                        window.carrito.actualizarContadorFavoritos();
                    }
                } else {
                    mostrarNotificacion(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                mostrarNotificacion('Error al actualizar favoritos', 'error');
            });
        }
        
        // Función para limpiar todos los favoritos
        function limpiarTodosFavoritos() {
            if (confirm('¿Estás seguro de que deseas eliminar todos tus favoritos? Esta acción no se puede deshacer.')) {
                const favoritos = document.querySelectorAll('.favorite-card, tbody tr');
                const promises = [];
                
                favoritos.forEach(item => {
                    const idMaterial = item.dataset.id || item.getAttribute('data-id');
                    if (idMaterial) {
                        promises.push(
                            fetch(contextPath + '/favoritos?action=toggle&idMaterial=' + idMaterial, {
                                method: 'POST'
                            })
                        );
                    }
                });
                
                Promise.all(promises)
                .then(() => {
                    mostrarNotificacion('Todos los favoritos han sido eliminados', 'success');
                    setTimeout(() => location.reload(), 1000);
                })
                .catch(error => {
                    console.error('Error:', error);
                    mostrarNotificacion('Error al limpiar favoritos', 'error');
                });
            }
        }
          // Función para agregar al carrito
        function agregarAlCarrito(idMaterial, nombre, precio) {
            // Convertir precio string a número
            const precioNumerico = parseFloat(precio);
            
            if (window.carrito) {
                window.carrito.agregarItem(idMaterial, nombre, precioNumerico, 1, 'default.jpg');
                mostrarNotificacion('Producto agregado al carrito', 'success');
            } else {
                mostrarNotificacion('Error al agregar al carrito', 'error');
            }
        }
        
        // Función para actualizar contador de favoritos
        function actualizarContadorFavoritos() {
            const contador = document.getElementById('favorites-count');
            if (contador) {
                const currentCount = parseInt(contador.textContent) - 1;
                contador.textContent = Math.max(0, currentCount);
            }
        }
        
        // Función para mostrar notificaciones
        function mostrarNotificacion(mensaje, tipo) {
            const notificacion = document.createElement('div');
            notificacion.className = 'notificacion ' + tipo;
            notificacion.innerHTML = '<i class="fas fa-' + (tipo === 'success' ? 'check-circle' : 'exclamation-circle') + '"></i> ' + mensaje;

            document.body.appendChild(notificacion);

            setTimeout(function() {
                notificacion.classList.add('mostrar');
            }, 100);

            setTimeout(function() {
                notificacion.classList.remove('mostrar');
                setTimeout(function() {
                    if (document.body.contains(notificacion)) {
                        document.body.removeChild(notificacion);
                    }
                }, 300);
            }, 3000);
        }
        
        // Estilos para notificaciones
        if (!document.getElementById('notification-styles')) {
            const style = document.createElement('style');
            style.id = 'notification-styles';
            style.textContent = `
                .notificacion {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    padding: 15px 20px;
                    border-radius: 8px;
                    color: white;
                    font-weight: 600;
                    z-index: 10000;
                    transform: translateX(100%);
                    transition: all 0.3s ease;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
                }
                
                .notificacion.success {
                    background: linear-gradient(135deg, #4caf50, #45a049);
                }
                
                .notificacion.error {
                    background: linear-gradient(135deg, #f44336, #d32f2f);
                }
                
                .notificacion.mostrar {
                    transform: translateX(0);
                }
                
                .notificacion i {
                    margin-right: 8px;
                }
            `;
            document.head.appendChild(style);
        }
    </script>
</body>
</html>
