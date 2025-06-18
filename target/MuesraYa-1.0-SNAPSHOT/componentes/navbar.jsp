<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                                <input type="search" class="form-control" name="query" placeholder="Buscar" value="${searchQuery}" required>
                                <button class="btn" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Iconos de acción rápida -->
                <div class="mobile-menu-section">
                    <h6 class="mobile-menu-section-title">Acciones rápidas</h6>                    <div class="mobile-action-icons">
                        <a href="${pageContext.request.contextPath}/favoritos" class="mobile-action-icon">
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
            <ul class="navbar-nav nav-icons d-none d-lg-flex">                <!-- Favoritos con contador -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/favoritos" title="Favoritos" aria-label="Ver favoritos" style="position:relative;">
                        <div class="icon-container">
                            <i class="far fa-heart"></i>
                            <span class="icon-badge" id="favorites-count" style="display: none;">0</span>
                        </div>
                    </a>
                </li>                <!-- Carrito de compras con contador - Implementación directa -->
                <li class="nav-item">
                    <a class="nav-link cart-icon-container" href="#" title="Carrito de compras" aria-label="Ver carrito de compras">
                        <i class="fas fa-shopping-cart"></i>
                        <span class="cart-badge-visible">0</span>
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
                                <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user-circle me-1"></i>
                                    <span class="d-none d-xl-inline">${sessionScope.usuario.nombre}</span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                    <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Mi Perfil</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="fas fa-history me-2"></i>Mis Pedidos</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión</a></li>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </li>
            </ul>
        </div>    </div>
</nav>

<!-- CSS para el carrito badge -->
<style>
.cart-icon-container {
    position: relative !important;
}

.cart-badge-visible {
    position: absolute !important;
    top: -8px !important;
    right: -8px !important;
    background-color: #ff3b30 !important;
    color: white !important;
    border-radius: 50% !important;
    min-width: 20px !important;
    height: 20px !important;
    font-size: 11px !important;
    font-weight: bold !important;
    display: flex !important;
    justify-content: center !important;
    align-items: center !important;
    box-shadow: 0 0 0 2px white !important;
    z-index: 1000 !important;
    line-height: 1 !important;
}
</style>
