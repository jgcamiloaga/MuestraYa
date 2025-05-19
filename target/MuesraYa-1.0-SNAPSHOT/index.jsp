<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Verificar si estamos accediendo directamente a index.jsp (sin pasar por el servlet)
    // y si no existe alguna señal de que ya hemos sido redirigidos
    String fromParam = request.getParameter("from");

    if (request.getAttribute("materiales") == null
            && request.getAttribute("categorias") == null) {

        // Redireccionar al servlet ProductsServlet con un parámetro para evitar bucles
        response.sendRedirect(request.getContextPath() + "/products?direct=true");
        return; // Importante: detener la ejecución aquí
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MuestraYa - Tienda Online</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Estilos críticos para el badge del carrito -->
        <style>
            /* Prioridad máxima para el badge del carrito */
            .cart-badge-visible {
                position: absolute !important;
                top: -6px !important;
                right: -6px !important;
                min-width: 18px !important;
                height: 18px !important;
                border-radius: 50% !important;
                background-color: #ff3b30 !important;
                color: white !important;
                font-size: 12px !important;
                font-weight: bold !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                z-index: 99999 !important;
                box-shadow: 0 0 0 2px white !important;
                visibility: visible !important;
                opacity: 1 !important;
            }
        </style>
        <!-- CSS Consolidado - Incluye todos los estilos del navbar, iconos, menú hamburguesa y cart badge -->
        <link href="${pageContext.request.contextPath}/recursos/css/index-style.css" rel="stylesheet">
        
        <!-- Script para forzar recarga de estilos y evitar problemas de caché -->
        <script>
            // Añadir timestamp a los enlaces CSS para forzar recarga
            document.addEventListener('DOMContentLoaded', function() {
                var timestamp = new Date().getTime();
                var cssLinks = document.querySelectorAll('link[rel="stylesheet"]');
                
                cssLinks.forEach(function(link) {
                    if (link.href.includes('recursos/css')) {
                        link.href = link.href + '?v=' + timestamp;
                    }
                });
            });
        </script>
        <!-- Estilos críticos solo para ajustes de búsqueda -->
        <style>
            /* Asegurar que el botón de búsqueda esté al lado del input */
            .search-bar-container .input-group {
                display: flex !important;
                flex-direction: row !important;
            }
            
            .search-bar-container .input-group-append {
                display: flex !important;
            }
            
            /* Estilos críticos para el badge del carrito */
            .cart-badge-visible {
                position: absolute !important;
                top: -6px !important;
                right: -6px !important;
                min-width: 18px !important;
                height: 18px !important;
                background-color: #ff3b30 !important;
                color: white !important;
                border-radius: 50% !important;
                font-size: 12px !important;
                font-weight: bold !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                box-shadow: 0 0 0 2px white !important;
                z-index: 9999 !important;
                visibility: visible !important;
                opacity: 1 !important;
            }
            
            .nav-item a[title="Carrito de compras"] {
                position: relative !important;
            }
        </style>
    </head>
    <body>
        <!-- Overlay para el menú móvil -->
        <div class="menu-overlay" id="menuOverlay"></div>

        <!-- Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark">
            <div class="container">
                <!-- Logo con ícono -->
                <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
                    <i class="fas fa-store-alt me-2"></i>
                    <span>MuestraYa</span>
                </a>

                <!-- Hamburger Menu Button (Moderno) -->
                <button class="navbar-toggler hamburger-button" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <div class="hamburger-icon">
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <!-- Encabezado del menú móvil -->
                    <div class="mobile-menu-header d-lg-none">
                        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-store-alt me-2"></i>
                            <span>MuestraYa</span>
                        </a>
                        <button class="mobile-menu-close" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="true" aria-label="Close menu">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>

                    <!-- Contenido del menú móvil -->
                    <div class="mobile-menu-content d-lg-none">
                        <!-- Buscador para móviles -->
                        <div class="mobile-menu-section">
                            <h6 class="mobile-menu-section-title">Buscar</h6>
                            <div class="mobile-search">
                                <form action="${pageContext.request.contextPath}/products" method="get" class="d-flex">
                                    <input type="hidden" name="action" value="search">
                                    <div class="input-group">
                                        <input type="search" class="form-control" name="query" placeholder="Buscar productos..." value="${searchQuery}" required>
                                        <button class="btn" type="submit">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Iconos de acción rápida -->
                        <div class="mobile-menu-section">
                            <h6 class="mobile-menu-section-title">Acciones rápidas</h6>
                            <div class="mobile-action-icons">
                                <a href="#" class="mobile-action-icon">
                                    <i class="far fa-heart"></i>
                                    <span>Favoritos</span>
                                </a>
                                <a href="#" class="mobile-action-icon">
                                    <i class="fas fa-shopping-cart"></i>
                                    <span>Carrito</span>
                                </a>
                                <a href="#" class="mobile-action-icon">
                                    <i class="fas fa-tag"></i>
                                    <span>Ofertas</span>
                                </a>
                            </div>
                        </div>

                        <!-- Navegación principal -->
                        <div class="mobile-menu-section">
                            <h6 class="mobile-menu-section-title">Navegación</h6>
                            <ul class="navbar-nav">
                                <li class="nav-item">
                                    <a class="nav-link active" href="${pageContext.request.contextPath}/">
                                        <i class="fas fa-home"></i>
                                        Inicio
                                    </a>
                                </li>
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="#" id="categoriasDropdownMobile" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fas fa-th-large"></i>
                                        Categorías
                                    </a>
                                    <ul class="dropdown-menu" aria-labelledby="categoriasDropdownMobile">
                                        <c:forEach var="categoria" items="${categorias}">
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/products?action=category&id=${categoria.idCategoria}">
                                                    <i class="fas fa-circle"></i>
                                                    ${categoria.nombre}
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="#">
                                        <i class="fas fa-fire"></i>
                                        Populares
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="#">
                                        <i class="fas fa-percentage"></i>
                                        Ofertas
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="#">
                                        <i class="fas fa-headset"></i>
                                        Contacto
                                    </a>
                                </li>
                                <c:if test="${not empty sessionScope.usuario && sessionScope.usuario.rol eq 'admin'}">
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/materiales">
                                            <i class="fas fa-cogs"></i>
                                            Administrar
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </div>

                    <!-- Pie del menú móvil -->
                    <div class="mobile-menu-footer d-lg-none">
                        <c:choose>
                            <c:when test="${empty sessionScope.usuario}">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                    <i class="fas fa-sign-in-alt me-2"></i> Iniciar Sesión
                                </a>
                            </c:when>
                            <c:otherwise>
                                <div class="mobile-user-section">
                                    <div class="mobile-user-avatar">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div class="mobile-user-info">
                                        <div class="mobile-user-name">${sessionScope.usuario.nombre}</div>
                                        <div class="mobile-user-email">${sessionScope.usuario.email}</div>
                                    </div>
                                </div>
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light">
                                    <i class="fas fa-sign-out-alt me-2"></i> Cerrar Sesión
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Menú para desktop -->
                    <ul class="navbar-nav me-auto d-none d-lg-flex">
                        <!-- Categorías con Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="categoriasDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-th-large me-1"></i> Categorías
                            </a>
                            <ul class="dropdown-menu animated-dropdown" aria-labelledby="categoriasDropdown">
                                <c:forEach var="categoria" items="${categorias}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?action=category&id=${categoria.idCategoria}">${categoria.nombre}</a></li>
                                    </c:forEach>
                            </ul>
                        </li>

                        <!-- Panel de administrador (solo visible para admins) -->
                        <c:if test="${not empty sessionScope.usuario && sessionScope.usuario.rol eq 'admin'}">
                            <li class="nav-item admin-nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/materiales">
                                    <i class="fas fa-cogs me-1"></i> Administrar
                                </a>
                            </li>
                        </c:if>
                    </ul>

                    <!-- Buscador siempre visible en desktop -->
                    <div class="search-bar-container d-none d-lg-flex justify-content-center align-items-center">
                        <form action="${pageContext.request.contextPath}/products" method="get" class="w-100 d-flex justify-content-center">
                            <input type="hidden" name="action" value="search">
                            <div class="input-group d-flex flex-row mx-auto" style="max-width: 90%;">
                                <input type="search" class="form-control" name="query" placeholder="Buscar productos..." value="${searchQuery}" required>
                                <div class="input-group-append">
                                    <button class="btn btn-primary d-flex justify-content-center align-items-center" type="submit">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Iconos y acciones para desktop -->
                    <ul class="navbar-nav nav-icons d-none d-lg-flex">
                        <!-- Favoritos (sin contador) -->
                        <li class="nav-item">
                            <a class="nav-link" href="#" title="Favoritos" aria-label="Ver favoritos">
                                <div class="icon-container">
                                    <i class="far fa-heart"></i>
                                </div>
                            </a>
                        </li>

                        <!-- Carrito de compras con contador - Implementación directa -->
                        <li class="nav-item">
                            <a class="nav-link" href="#" title="Carrito de compras" aria-label="Ver carrito de compras" style="position:relative;">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="cart-badge-visible" style="position:absolute; top:-6px; right:-6px; background-color:#ff3b30; color:white; border-radius:50%; min-width:18px; height:18px; font-size:12px; font-weight:bold; display:flex; justify-content:center; align-items:center; box-shadow:0 0 0 2px white; z-index:9999;">0</span>
                            </a>
                        </li>

                        <!-- Usuario/Iniciar sesión -->
                        <li class="nav-item">
                            <c:choose>
                                <c:when test="${empty sessionScope.usuario}">
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm">
                                        <i class="fas fa-sign-in-alt me-1"></i> Iniciar Sesión
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <div class="dropdown">
                                        <button class="btn btn-primary btn-sm dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="fas fa-user-circle me-1"></i> ${sessionScope.usuario.nombre}
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end animated-dropdown" aria-labelledby="userDropdown">
                                            <li>
                                                <a class="dropdown-item" href="#">
                                                    <i class="fas fa-shopping-bag me-2"></i> Mis Compras
                                                </a>
                                            </li>
                                            <li>
                                                <a class="dropdown-item" href="#">
                                                    <i class="fas fa-heart me-2"></i> Mis Favoritos
                                                </a>
                                            </li>
                                            <li>
                                                <a class="dropdown-item" href="#">
                                                    <i class="fas fa-user me-2"></i> Mi Perfil
                                                </a>
                                            </li>
                                            <c:if test="${sessionScope.usuario.rol eq 'admin'}">
                                                <li><hr class="dropdown-divider"></li>
                                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/vista/registerMaterial.jsp"><i class="fas fa-plus-circle me-2"></i> Registrar Material</a></li>
                                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/materiales"><i class="fas fa-tasks me-2"></i> Administrar Productos</a></li>
                                                </c:if>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i> Cerrar Sesión</a></li>
                                        </ul>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <section class="hero-section text-center">
            <div class="container">
                <h1>Descubre Productos Excepcionales</h1>
                <p>Encuentra los mejores materiales y productos con los precios más competitivos del mercado. Calidad garantizada en cada compra.</p>
                <a href="#productos" class="btn btn-primary btn-lg">Explorar Productos</a>
            </div>
        </section>

        <!-- Main Content -->
        <div class="container" id="productos">
            <!-- Category Filter -->
            <div class="row mb-5 category-section">
                <div class="col-md-12">
                    <h2>
                        <c:choose>
                            <c:when test="${not empty searchQuery}">
                                Resultados para: "${searchQuery}"
                            </c:when>
                            <c:when test="${not empty selectedCategoria}">
                                Categoría: ${selectedCategoria.nombre}
                            </c:when>
                            <c:otherwise>
                                Nuestros Productos
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <div class="d-flex flex-wrap gap-2 mt-4">
                        <a href="${pageContext.request.contextPath}/products" class="btn category-btn ${empty selectedCategoria ? 'btn-primary' : 'btn-outline-primary'}">Todos</a>
                        <c:forEach var="categoria" items="${categorias}">
                            <a href="${pageContext.request.contextPath}/products?action=category&id=${categoria.idCategoria}" 
                               class="btn category-btn ${selectedCategoria.idCategoria eq categoria.idCategoria ? 'btn-primary' : 'btn-outline-primary'}">
                                ${categoria.nombre}
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mb-5">
                <c:choose>
                    <c:when test="${empty materiales}">
                        <div class="col-12 text-center">
                            <div class="alert alert-info p-5 rounded-3">
                                <i class="fas fa-info-circle fa-2x mb-3"></i>
                                <h4>No se encontraron productos</h4>
                                <p class="mb-0">Intenta con otra búsqueda o categoría.</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="material" items="${materiales}">
                            <div class="col">
                                <div class="card product-card h-100" data-id="${material.idMaterial}">
                                    <span class="badge category-badge ${material.idCategoria.toLowerCase()}">
                                        ${material.nombreCategoria}
                                    </span>
                                    <c:choose>
                                        <c:when test="${not empty material.imagen && material.imagen ne 'default.jpg'}">
                                            <img src="${pageContext.request.contextPath}/image/${material.imagen}" class="card-img-top product-img" alt="${material.nombre}" onerror="this.src='${pageContext.request.contextPath}/image/default.jpg'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/image/default.jpg" class="card-img-top product-img" alt="${material.nombre}">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title">${material.nombre}</h5>
                                        <p class="card-text">$${material.precio}</p>
                                        <div class="mt-auto">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <span class="badge bg-secondary">${material.idMaterial}</span>
                                                <a href="${pageContext.request.contextPath}/materiales?from=index" class="btn btn-sm btn-outline-secondary">
                                                    <i class="fas fa-eye"></i> Ver Detalles
                                                </a>
                                            </div>
                                            <button class="btn btn-sm btn-primary w-100 btn-add-to-cart" data-id="${material.idMaterial}">
                                                <i class="fas fa-shopping-cart me-1"></i> Añadir al carrito
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Features Section -->
        <section class="features-section">
            <div class="container">
                <h2 class="text-center">¿Por qué elegirnos?</h2>
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="feature-card text-center">
                            <div class="feature-icon">
                                <i class="fas fa-truck fa-2x"></i>
                            </div>
                            <h4>Envío Rápido</h4>
                            <p>Entregamos tus productos en tiempo récord para que los disfrutes cuanto antes. Servicio garantizado en todo el país.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-card text-center">
                            <div class="feature-icon">
                                <i class="fas fa-shield-alt fa-2x"></i>
                            </div>
                            <h4>Productos de Calidad</h4>
                            <p>Garantizamos la calidad de todos nuestros productos. Trabajamos con los mejores proveedores del mercado.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-card text-center">
                            <div class="feature-icon">
                                <i class="fas fa-headset fa-2x"></i>
                            </div>
                            <h4>Soporte 24/7</h4>
                            <p>Nuestro equipo está disponible para ayudarte en cualquier momento que lo necesites. Atención personalizada.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Newsletter Section -->
        <section class="newsletter-section">
            <div class="container">
                <div class="newsletter-card">
                    <div class="row align-items-center">
                        <div class="col-lg-6">
                            <h2>Suscríbete a nuestro boletín</h2>
                            <p>Recibe las últimas novedades, ofertas exclusivas y consejos directamente en tu correo electrónico.</p>
                        </div>
                        <div class="col-lg-6">
                            <form class="newsletter-form">
                                <div class="position-relative">
                                    <input type="email" class="form-control" placeholder="Tu correo electrónico" required>
                                    <button type="submit" class="btn">Suscribirse</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-4 mb-4 mb-md-0">
                        <h5>MuestraYa</h5>
                        <p>Tu tienda de confianza para encontrar los mejores productos al mejor precio. Calidad y servicio garantizado en cada compra.</p>
                        <div class="social-links">
                            <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4 mb-md-0">
                        <h5>Enlaces Rápidos</h5>
                        <ul class="list-unstyled">
                            <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-chevron-right me-2"></i>Inicio</a></li>
                            <li><a href="${pageContext.request.contextPath}/products"><i class="fas fa-chevron-right me-2"></i>Productos</a></li>
                                <c:if test="${not empty sessionScope.usuario && sessionScope.usuario.rol eq 'admin'}">
                                <li><a href="${pageContext.request.contextPath}/vista/registerMaterial.jsp"><i class="fas fa-chevron-right me-2"></i>Registrar Material</a></li>
                                <li><a href="${pageContext.request.contextPath}/materiales"><i class="fas fa-chevron-right me-2"></i>Administrar</a></li>
                                </c:if>
                            <li><a href="#"><i class="fas fa-chevron-right me-2"></i>Términos y Condiciones</a></li>
                            <li><a href="#"><i class="fas fa-chevron-right me-2"></i>Política de Privacidad</a></li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <h5>Contáctanos</h5>
                        <address>
                            <p><i class="fas fa-map-marker-alt me-2"></i> Calle Principal #123, Ciudad</p>
                            <p><i class="fas fa-phone me-2"></i> (123) 456-7890</p>
                            <p><i class="fas fa-envelope me-2"></i> info@muestraya.com</p>
                            <p><i class="fas fa-clock me-2"></i> Lun - Vie: 9:00 AM - 6:00 PM</p>
                        </address>
                    </div>
                </div>
                <hr>
                <div class="text-center">
                    <p class="copyright mb-0">&copy; 2025 MuestraYa. Todos los derechos reservados.</p>
                </div>
            </div>
        </footer>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Scripts personalizados -->
        <script src="${pageContext.request.contextPath}/recursos/js/navbar.js"></script>
        
        <!-- Contenedor para notificaciones toast -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3"></div>
        
        <!-- Script de depuración para el badge del carrito -->
        <script>
            // Esperar a que el DOM esté completamente cargado
            document.addEventListener('DOMContentLoaded', function() {
                console.log('===== INICIO DEPURACIÓN BADGE CARRITO =====');
                
                // Verificar estructura HTML inicial
                const cartLinks = document.querySelectorAll('a[title="Carrito de compras"]');
                console.log('Elementos de carrito encontrados:', cartLinks.length);
                
                if (cartLinks.length > 0) {
                    // Examinar el primer enlace de carrito
                    const cartLink = cartLinks[0];
                    console.log('Contenido del enlace del carrito:', cartLink.innerHTML);
                    
                    // Verificar si tiene el ícono correcto
                    const cartIcon = cartLink.querySelector('.fa-shopping-cart');
                    console.log('Ícono del carrito:', cartIcon ? 'Encontrado' : 'No encontrado');
                    
                    // Verificar si ya tiene un badge
                    const existingBadge = cartLink.querySelector('span.cart-badge-visible');
                    console.log('Badge inicial:', existingBadge ? 'Encontrado' : 'No encontrado');
                    
                    if (existingBadge) {
                        console.log('Contenido del badge:', existingBadge.textContent);
                        console.log('Estilos aplicados:', existingBadge.getAttribute('style'));
                    }
                }
                
                // Esperar un momento para comprobar después de la inicialización de navbar-fixed.js
                setTimeout(function() {
                    console.log('===== VERIFICACIÓN DESPUÉS DE INICIALIZACIÓN =====');
                    
                    // Verificar el badge nuevamente
                    const badge = document.querySelector('.fa-shopping-cart + span.cart-badge-visible');
                    console.log('Badge después de inicialización:', badge ? 'Encontrado' : 'No encontrado');
                    
                    if (badge) {
                        console.log('Contenido del badge:', badge.textContent);
                        console.log('Estilos computados:', window.getComputedStyle(badge).cssText);
                        
                        // Verificar la visibilidad real
                        const rect = badge.getBoundingClientRect();
                        console.log('Dimensiones del badge:', {
                            width: rect.width,
                            height: rect.height,
                            top: rect.top,
                            right: rect.right
                        });
                        
                        // NO modificar el valor inicial
                        console.log('Manteniendo el valor inicial del badge: ' + badge.textContent);
                    } else {
                        console.error('El badge no fue creado por navbar-fixed.js');
                        
                        // Última esperanza: crear un badge de emergencia
                        const icon = document.querySelector('.fa-shopping-cart');
                        if (icon) {
                            const container = icon.parentNode;
                            
                            // Crear un nuevo badge de emergencia
                            const emergencyBadge = document.createElement('span');
                            emergencyBadge.textContent = '99';
                            emergencyBadge.setAttribute('style', 'position:absolute; top:-8px; right:-8px; min-width:20px; height:20px; background-color:#ff0000; color:white; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:bold; box-shadow:0 0 0 2px white; z-index:10000;');
                            
                            if (container) {
                                container.style.position = 'relative';
                                container.appendChild(emergencyBadge);
                                console.log('Badge de emergencia creado');
                            }
                        }
                    }
                }, 1500);
            });
        </script>
    </body>
</html>