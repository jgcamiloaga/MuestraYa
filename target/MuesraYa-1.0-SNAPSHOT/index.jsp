<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Verificar si estamos accediendo directamente a index.jsp (sin pasar por el servlet)
    // y si no existe alguna señal de que ya hemos sido redirigidos
    String fromParam = request.getParameter("from");
    
    if (request.getAttribute("materiales") == null && 
        request.getAttribute("categorias") == null) {
        
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
        <link href="${pageContext.request.contextPath}/CSS/index-style.css" rel="stylesheet">
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