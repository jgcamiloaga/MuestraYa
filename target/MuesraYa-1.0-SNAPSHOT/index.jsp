<%-- 
    Document   : Index
    Created on : 8 abr. 2025, 2:02:58 p. m.
    Author     : Johann
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Verificar si estamos accediendo directamente a index.jsp (sin pasar por el servlet)
    // y si no existe alguna señal de que ya hemos sido redirigidos
    if (request.getAttribute("materiales") == null && 
        request.getAttribute("categorias") == null && 
        request.getSession().getAttribute("redirected") == null) {
        
        // Marcar que hemos redirigido para evitar bucles infinitos
        request.getSession().setAttribute("redirected", Boolean.TRUE);
        
        // Redireccionar al servlet ProductsServlet
        response.sendRedirect(request.getContextPath() + "/products");
        return; // Importante: detener la ejecución aquí
    }
    
    // Limpiar el atributo de redirección para futuros cambios de página
    request.getSession().removeAttribute("redirected");
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
        <style>
            :root {
                --primary-color: #3a86ff;
                --primary-light: #4895ef;
                --primary-dark: #2667ff;
                --accent-color: #ff006e;
                --text-color: #2b2d42;
                --text-light: #8d99ae;
                --bg-color: #f8f9fa;
                --card-color: #ffffff;
                --success-color: #4cc9f0;
                --error-color: #e53935;
                --border-radius: 12px;
                --box-shadow: 0 10px 30px rgba(58, 134, 255, 0.1);
                --transition: all 0.3s ease;
            }

            * {
                font-family: "Poppins", sans-serif;
            }

            body {
                color: var(--text-color);
                background-color: var(--bg-color);
            }

            /* Navbar Styles */
            .navbar {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%) !important;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                padding: 12px 0;
            }

            .navbar-brand {
                font-weight: 700;
                font-size: 1.5rem;
                letter-spacing: 0.5px;
            }

            .nav-link {
                font-weight: 500;
                transition: var(--transition);
                position: relative;
                padding: 8px 15px !important;
            }

            .nav-link:hover {
                color: #fff !important;
            }

            .nav-link::after {
                content: '';
                position: absolute;
                width: 0;
                height: 2px;
                bottom: 0;
                left: 50%;
                background-color: #fff;
                transition: all 0.3s ease;
                transform: translateX(-50%);
            }

            .nav-link:hover::after {
                width: 70%;
            }

            .dropdown-menu {
                border-radius: var(--border-radius);
                box-shadow: var(--box-shadow);
                border: none;
                padding: 10px;
            }

            .dropdown-item {
                padding: 8px 15px;
                border-radius: 6px;
                transition: var(--transition);
            }

            .dropdown-item:hover {
                background-color: rgba(58, 134, 255, 0.1);
                color: var(--primary-color);
            }

            .form-control {
                border-radius: 30px;
                padding: 10px 20px;
                border: none;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .btn {
                border-radius: 30px;
                padding: 10px 20px;
                font-weight: 500;
                transition: var(--transition);
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
                border: none;
                box-shadow: 0 4px 15px rgba(58, 134, 255, 0.3);
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-color) 100%);
                transform: translateY(-2px);
                box-shadow: 0 6px 18px rgba(58, 134, 255, 0.4);
            }

            .btn-outline-light {
                border-width: 2px;
            }

            .btn-outline-light:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(255, 255, 255, 0.2);
            }

            /* Hero Section */
            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80');
                background-size: cover;
                background-position: center;
                color: white;
                padding: 150px 0;
                margin-bottom: 60px;
                position: relative;
                overflow: hidden;
            }

            .hero-section::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, rgba(58, 134, 255, 0.4) 0%, rgba(255, 0, 110, 0.4) 100%);
                z-index: 1;
            }

            .hero-section .container {
                position: relative;
                z-index: 2;
            }

            .hero-section h1 {
                font-size: 3.5rem;
                font-weight: 700;
                margin-bottom: 20px;
                text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
                animation: fadeInDown 1s ease-out;
            }

            .hero-section p {
                font-size: 1.2rem;
                margin-bottom: 30px;
                max-width: 700px;
                margin-left: auto;
                margin-right: auto;
                animation: fadeInUp 1s ease-out;
            }

            .hero-section .btn-lg {
                padding: 15px 30px;
                font-size: 1.1rem;
                border-radius: 50px;
                animation: fadeInUp 1.2s ease-out;
                position: relative;
                overflow: hidden;
            }

            .hero-section .btn-lg::before {
                content: "";
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: 0.5s;
            }

            .hero-section .btn-lg:hover::before {
                left: 100%;
            }

            /* Category Section */
            .category-section {
                margin-bottom: 40px;
                animation: fadeIn 1s ease-out;
            }

            .category-section h2 {
                font-weight: 600;
                margin-bottom: 25px;
                position: relative;
                display: inline-block;
            }

            .category-section h2::after {
                content: '';
                position: absolute;
                width: 50px;
                height: 3px;
                background-color: var(--primary-color);
                bottom: -10px;
                left: 0;
            }

            .category-btn {
                border-radius: var(--border-radius);
                padding: 8px 16px;
                margin-right: 8px;
                margin-bottom: 8px;
                transition: var(--transition);
                font-weight: 500;
            }

            .btn-outline-primary {
                color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .btn-outline-primary:hover {
                background-color: var(--primary-color);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(58, 134, 255, 0.2);
            }

            /* Product Cards */
            .product-card {
                border-radius: var(--border-radius);
                border: none;
                box-shadow: var(--box-shadow);
                transition: var(--transition);
                overflow: hidden;
                height: 100%;
                animation: fadeIn 1s ease-out;
            }

            .product-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 30px rgba(58, 134, 255, 0.15);
            }

            .product-img {
                height: 220px;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

            .product-card:hover .product-img {
                transform: scale(1.05);
            }

            .card-body {
                padding: 20px;
            }

            .card-title {
                font-weight: 600;
                margin-bottom: 10px;
                color: var(--text-color);
            }

            .card-text {
                font-size: 1.2rem;
                font-weight: 700;
                color: var(--primary-color) !important;
            }

            .category-badge {
                position: absolute;
                top: 15px;
                right: 15px;
                z-index: 2;
                border-radius: 30px;
                padding: 6px 14px;
                font-weight: 500;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }
            
            /* Estilos para los colores de categorías */
            .badge.cat001 { background-color: var(--primary-color) !important; } /* Herramienta */
            .badge.cat002 { background-color: var(--accent-color) !important; } /* Ropa */
            .badge.cat003 { background-color: #fb5607 !important; } /* Cocina */
            .badge.cat004 { background-color: #8338ec !important; } /* Electrónica */
            .badge.cat005 { background-color: #ffbe0b !important; color: #212529 !important; } /* Construcción */
            .badge.cat006 { background-color: #06d6a0 !important; } /* Oficina */

            .btn-outline-secondary {
                border-radius: 30px;
                transition: var(--transition);
            }

            .btn-outline-secondary:hover {
                background-color: var(--text-color);
                transform: translateY(-2px);
            }

            /* Features Section */
            .features-section {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                padding: 80px 0;
                margin-top: 60px;
            }

            .features-section h2 {
                font-weight: 600;
                margin-bottom: 50px;
                position: relative;
                display: inline-block;
            }

            .features-section h2::after {
                content: '';
                position: absolute;
                width: 50px;
                height: 3px;
                background-color: var(--primary-color);
                bottom: -15px;
                left: 50%;
                transform: translateX(-50%);
            }

            .feature-card {
                background-color: white;
                border-radius: var(--border-radius);
                padding: 40px 30px;
                box-shadow: var(--box-shadow);
                transition: var(--transition);
                height: 100%;
            }

            .feature-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 30px rgba(58, 134, 255, 0.15);
            }

            .feature-icon {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 25px;
                color: white;
                box-shadow: 0 10px 20px rgba(58, 134, 255, 0.2);
            }

            .feature-card h4 {
                font-weight: 600;
                margin-bottom: 15px;
                color: var(--text-color);
            }

            .feature-card p {
                color: var(--text-light);
                margin-bottom: 0;
            }

            /* Newsletter Section */
            .newsletter-section {
                padding: 80px 0;
                background-color: white;
            }

            .newsletter-card {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
                border-radius: var(--border-radius);
                padding: 50px;
                color: white;
                box-shadow: var(--box-shadow);
                position: relative;
                overflow: hidden;
            }

            .newsletter-card::before {
                content: '';
                position: absolute;
                width: 300px;
                height: 300px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
                top: -150px;
                right: -150px;
            }

            .newsletter-card::after {
                content: '';
                position: absolute;
                width: 200px;
                height: 200px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
                bottom: -100px;
                left: -100px;
            }

            .newsletter-card h2 {
                font-weight: 600;
                margin-bottom: 20px;
                position: relative;
            }

            .newsletter-card p {
                margin-bottom: 30px;
                max-width: 600px;
                opacity: 0.9;
            }

            .newsletter-form {
                position: relative;
                z-index: 1;
                max-width: 500px;
            }

            .newsletter-form .form-control {
                height: 60px;
                border-radius: 30px;
                padding-right: 160px;
                font-size: 1rem;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }

            .newsletter-form .btn {
                position: absolute;
                right: 5px;
                top: 5px;
                height: 50px;
                border-radius: 25px;
                background: linear-gradient(135deg, var(--accent-color) 0%, #ff4d8d 100%);
                border: none;
                font-weight: 500;
                padding: 0 30px;
                box-shadow: 0 5px 15px rgba(255, 0, 110, 0.3);
                transition: var(--transition);
            }

            .newsletter-form .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(255, 0, 110, 0.4);
            }

            /* Footer */
            .footer {
                background-color: #1a1c23;
                color: #fff;
                padding: 80px 0 30px;
            }

            .footer h5 {
                color: white;
                font-weight: 600;
                margin-bottom: 25px;
                position: relative;
                display: inline-block;
            }

            .footer h5::after {
                content: '';
                position: absolute;
                width: 30px;
                height: 2px;
                background-color: var(--primary-color);
                bottom: -10px;
                left: 0;
            }

            .footer p, .footer address {
                color: rgba(255, 255, 255, 0.7);
                margin-bottom: 15px;
                font-size: 0.95rem;
            }

            .footer ul li {
                margin-bottom: 12px;
            }

            .footer a {
                color: rgba(255, 255, 255, 0.7);
                text-decoration: none;
                transition: var(--transition);
            }

            .footer a:hover {
                color: var(--primary-color);
                text-decoration: none;
            }

            .social-links {
                display: flex;
                gap: 15px;
                margin-top: 20px;
            }

            .social-link {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: rgba(255, 255, 255, 0.1);
                display: flex;
                align-items: center;
                justify-content: center;
                transition: var(--transition);
            }

            .social-link:hover {
                background-color: var(--primary-color);
                transform: translateY(-5px);
            }

            .footer hr {
                margin: 40px 0 30px;
                border-color: rgba(255, 255, 255, 0.1);
            }

            .copyright {
                color: rgba(255, 255, 255, 0.5);
                font-size: 0.9rem;
            }

            /* Animations */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Responsive */
            @media (max-width: 991px) {
                .hero-section {
                    padding: 100px 0;
                }
                
                .hero-section h1 {
                    font-size: 2.5rem;
                }
                
                .newsletter-card {
                    padding: 30px;
                }
            }

            @media (max-width: 767px) {
                .hero-section h1 {
                    font-size: 2rem;
                }
                
                .feature-card {
                    margin-bottom: 30px;
                }
                
                .newsletter-form .form-control {
                    padding-right: 30px;
                }
                
                .newsletter-form .btn {
                    position: static;
                    width: 100%;
                    margin-top: 15px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
            <div class="container">
                <a class="navbar-brand" href="index.jsp">MuestraYa</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="index.jsp">Inicio</a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                Categorías
                            </a>
                            <ul class="dropdown-menu">
                                <c:forEach var="categoria" items="${categorias}">
                                    <li><a class="dropdown-item" href="products?action=category&id=${categoria.idCategoria}">${categoria.nombre}</a></li>
                                </c:forEach>
                            </ul>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="VISTA/registerMaterial.jsp">Registrar Material</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="VISTA/listado.jsp">Administrar</a>
                        </li>
                    </ul>
                    <form class="d-flex me-2" action="products" method="get">
                        <input type="hidden" name="action" value="search">
                        <input class="form-control me-2" type="search" name="query" placeholder="Buscar productos..." value="${searchQuery}">
                        <button class="btn btn-outline-light" type="submit">Buscar</button>
                    </form>
                    <div class="d-flex">
                        <c:choose>
                            <c:when test="${empty sessionScope.usuario}">
                                <a href="VISTA/login.jsp" class="btn btn-primary">Iniciar Sesión</a>
                            </c:when>
                            <c:otherwise>
                                <div class="dropdown">
                                    <button class="btn btn-primary dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown">
                                        ${sessionScope.usuario.nombre}
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><a class="dropdown-item" href="VISTA/listado.jsp">Administrar Productos</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="logout">Cerrar Sesión</a></li>
                                    </ul>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
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
                        <a href="products" class="btn category-btn ${empty selectedCategoria ? 'btn-primary' : 'btn-outline-primary'}">Todos</a>
                        <c:forEach var="categoria" items="${categorias}">
                            <a href="products?action=category&id=${categoria.idCategoria}" 
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
                                <div class="card product-card h-100">
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
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="badge bg-secondary">${material.idMaterial}</span>
                                                <a href="VISTA/listado.jsp" class="btn btn-sm btn-outline-secondary">
                                                    <i class="fas fa-eye"></i> Ver Detalles
                                                </a>
                                            </div>
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
                            <li><a href="index.jsp"><i class="fas fa-chevron-right me-2"></i>Inicio</a></li>
                            <li><a href="products"><i class="fas fa-chevron-right me-2"></i>Productos</a></li>
                            <li><a href="VISTA/registerMaterial.jsp"><i class="fas fa-chevron-right me-2"></i>Registrar Material</a></li>
                            <li><a href="VISTA/listado.jsp"><i class="fas fa-chevron-right me-2"></i>Administrar</a></li>
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
    </body>
</html>