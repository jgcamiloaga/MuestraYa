<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${material.nombre} - MuestraYa</title>        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/recursos/css/index-style.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/recursos/css/product-cards.css" rel="stylesheet">
        
        <style>
            /* Estilos específicos para la página de detalles */
            .product-details {
                padding: 50px 0;
            }
            
            .product-image-container {
                position: relative;
                overflow: hidden;
                border-radius: 12px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            
            .product-image {
                width: 100%;
                height: auto;
                object-fit: cover;
                transition: transform 0.3s ease;
            }
            
            .product-image:hover {
                transform: scale(1.03);
            }
            
            .product-badges {
                position: absolute;
                top: 15px;
                left: 15px;
                display: flex;
                flex-direction: column;
                gap: 5px;
            }
            
            .product-badge {
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
            }
            
            .badge-destacado {
                background-color: #ff9f1a;
                color: white;
            }
            
            .badge-stock {
                background-color: #28a745;
                color: white;
            }
            
            .badge-stock.low {
                background-color: #dc3545;
            }
            
            .product-price {
                font-size: 2.5rem;
                font-weight: 700;
                color: #333;
                margin: 15px 0;
            }
            
            .product-title {
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 10px;
                color: #333;
            }
            
            .product-category {
                font-size: 1rem;
                color: #6c757d;
                margin-bottom: 20px;
                display: inline-block;
                padding: 5px 10px;
                background-color: #f8f9fa;
                border-radius: 20px;
            }
            
            .product-description {
                font-size: 1.1rem;
                line-height: 1.6;
                color: #555;
                margin-bottom: 30px;
            }
            
            .product-specs {
                background-color: #f8f9fa;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 30px;
            }
            
            .product-specs h3 {
                font-size: 1.3rem;
                margin-bottom: 15px;
                color: #333;
                border-bottom: 1px solid #dee2e6;
                padding-bottom: 10px;
            }
            
            .spec-item {
                margin-bottom: 12px;
                display: flex;
                align-items: center;
            }
            
            .spec-icon {
                width: 30px;
                color: #007bff;
                margin-right: 10px;
                text-align: center;
            }
            
            .spec-label {
                font-weight: 600;
                color: #6c757d;
                width: 120px;
            }
            
            .spec-value {
                flex: 1;
                color: #333;
            }
            
            .add-to-cart-section {
                background-color: #f8f9fa;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 30px;
            }
            
            .quantity-selector {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .quantity-btn {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: #e9ecef;
                border: none;
                font-size: 18px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            
            .quantity-btn:hover {
                background-color: #dee2e6;
            }
            
            .quantity-input {
                width: 60px;
                height: 40px;
                text-align: center;
                border: 1px solid #ced4da;
                border-radius: 5px;
                margin: 0 10px;
                font-size: 1.1rem;
            }
            
            .add-to-cart-btn {
                width: 100%;
                padding: 15px;
                border-radius: 30px;
                background-color: #007bff;
                color: white;
                font-weight: 600;
                font-size: 1.1rem;
                border: none;
                cursor: pointer;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            
            .add-to-cart-btn:hover {
                background-color: #0069d9;
            }
            
            .add-to-cart-btn i {
                margin-right: 10px;
            }
            
            .related-products {
                padding: 50px 0;
                background-color: #f8f9fa;
            }
            
            .related-title {
                font-size: 1.8rem;
                font-weight: 700;
                margin-bottom: 30px;
                text-align: center;
            }
            
            .back-link {
                margin-bottom: 20px;
                display: inline-block;
                color: #6c757d;
                text-decoration: none;
                transition: color 0.2s;
            }
            
            .back-link:hover {
                color: #007bff;
            }
            
            .back-link i {
                margin-right: 5px;
            }
            
            @media (max-width: 767px) {
                .product-image-container {
                    margin-bottom: 30px;
                }
                
                .product-title {
                    font-size: 1.5rem;
                }
                
                .product-price {
                    font-size: 2rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navigation Bar -->
        <jsp:include page="../componentes/navbar.jsp" />

        <div class="container product-details">
            <!-- Enlace para volver -->
            <a href="${pageContext.request.contextPath}/" class="back-link">
                <i class="fas fa-arrow-left"></i> Volver a productos
            </a>
            
            <div class="row">                <!-- Imagen del producto -->
                <div class="col-md-6">
                    <div class="product-image-container">
                        <img src="${pageContext.request.contextPath}/image/${material.imagen}" alt="${material.nombre}" class="product-image">
                        <div class="product-badges">
                            <c:if test="${material.destacado}">
                                <span class="product-badge badge-destacado">Destacado</span>
                            </c:if>
                            <c:choose>
                                <c:when test="${material.stock > 10}">
                                    <span class="product-badge badge-stock">En Stock</span>
                                </c:when>
                                <c:when test="${material.stock > 0}">
                                    <span class="product-badge badge-stock low">¡Últimas unidades!</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="product-badge badge-stock low">Agotado</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <!-- Información del producto -->
                <div class="col-md-6">
                    <span class="product-category">
                        <i class="fas fa-tag me-1"></i> ${material.nombreCategoria}
                    </span>
                    <h1 class="product-title">${material.nombre}</h1>
                    <h2 class="product-price">
                        <fmt:formatNumber value="${material.precio}" type="currency" currencySymbol="$" />
                    </h2>
                    
                    <div class="product-description">
                        ${material.descripcion}
                    </div>
                    
                    <!-- Especificaciones -->
                    <div class="product-specs">
                        <h3><i class="fas fa-clipboard-list me-2"></i>Especificaciones</h3>
                        
                        <c:if test="${not empty material.unidadMedida}">
                            <div class="spec-item">
                                <div class="spec-icon"><i class="fas fa-ruler"></i></div>
                                <div class="spec-label">Unidad</div>
                                <div class="spec-value">${material.unidadMedida}</div>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty material.dimension}">
                            <div class="spec-item">
                                <div class="spec-icon"><i class="fas fa-ruler-combined"></i></div>
                                <div class="spec-label">Dimensiones</div>
                                <div class="spec-value">${material.dimension}</div>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty material.peso}">
                            <div class="spec-item">
                                <div class="spec-icon"><i class="fas fa-weight-hanging"></i></div>
                                <div class="spec-label">Peso</div>
                                <div class="spec-value">${material.peso} kg</div>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty material.color}">
                            <div class="spec-item">
                                <div class="spec-icon"><i class="fas fa-palette"></i></div>
                                <div class="spec-label">Color</div>
                                <div class="spec-value">${material.color}</div>
                            </div>
                        </c:if>
                        
                        <div class="spec-item">
                            <div class="spec-icon"><i class="fas fa-boxes"></i></div>
                            <div class="spec-label">Stock</div>
                            <div class="spec-value">${material.stock} unidades disponibles</div>
                        </div>
                        
                        <c:if test="${not empty material.especificaciones}">
                            <div class="mt-3">
                                <h4 class="h6">Detalles adicionales</h4>
                                <p>${material.especificaciones}</p>
                            </div>
                        </c:if>
                    </div>
                    
                    <!-- Sección de agregar al carrito -->
                    <div class="add-to-cart-section">
                        <div class="quantity-selector">
                            <span>Cantidad:</span>
                            <button class="quantity-btn" id="decrease">-</button>
                            <input type="number" class="quantity-input" id="quantity" value="1" min="1" max="${material.stock}">
                            <button class="quantity-btn" id="increase">+</button>
                        </div>
                        
                        <button class="add-to-cart-btn" id="addToCart" ${material.stock <= 0 ? 'disabled' : ''}>
                            <i class="fas fa-shopping-cart"></i> Agregar al carrito
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Productos relacionados -->
        <section class="related-products">
            <div class="container">
                <h2 class="related-title">Productos relacionados</h2>
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">                    <c:forEach var="relacionado" items="${productosRelacionados}" varStatus="status">
                        <div class="col">
                            <div class="card h-100 product-card">
                                <div class="position-relative">
                                    <img src="${pageContext.request.contextPath}/image/${relacionado.imagen}" class="card-img-top" alt="${relacionado.nombre}">
                                    <c:if test="${relacionado.destacado}">
                                        <span class="position-absolute top-0 start-0 translate-middle-y badge bg-warning text-dark m-2">Destacado</span>
                                    </c:if>
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <span class="badge bg-light text-dark mb-2">${relacionado.nombreCategoria}</span>
                                    <h5 class="card-title">${relacionado.nombre}</h5>
                                    <p class="card-text flex-grow-1">
                                        <c:if test="${not empty relacionado.descripcion}">
                                            ${relacionado.descripcion.length() > 60 ? relacionado.descripcion.substring(0, 60).concat('...') : relacionado.descripcion}
                                        </c:if>
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center mt-3">
                                        <span class="price">
                                            <fmt:formatNumber value="${relacionado.precio}" type="currency" currencySymbol="$" />
                                        </span>
                                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${relacionado.idMaterial}" class="btn btn-outline-primary btn-sm">Ver detalles</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {                const quantityInput = document.getElementById('quantity');
                const decreaseBtn = document.getElementById('decrease');
                const increaseBtn = document.getElementById('increase');
                const addToCartBtn = document.getElementById('addToCart');
                const maxStock = <c:out value="${material.stock}"/>;
                
                // Manejar disminución de cantidad
                decreaseBtn.addEventListener('click', function() {
                    let currentValue = parseInt(quantityInput.value);
                    if (currentValue > 1) {
                        quantityInput.value = currentValue - 1;
                    }
                });
                
                // Manejar aumento de cantidad
                increaseBtn.addEventListener('click', function() {
                    let currentValue = parseInt(quantityInput.value);
                    if (currentValue < maxStock) {
                        quantityInput.value = currentValue + 1;
                    }
                });
                
                // Validar entrada manual
                quantityInput.addEventListener('change', function() {
                    let currentValue = parseInt(quantityInput.value);
                    if (isNaN(currentValue) || currentValue < 1) {
                        quantityInput.value = 1;
                    } else if (currentValue > maxStock) {
                        quantityInput.value = maxStock;
                    }
                });
                
                // Agregar al carrito
                addToCartBtn.addEventListener('click', function() {                    const quantity = parseInt(quantityInput.value);
                    const productId = '<c:out value="${material.idMaterial}"/>';
                    const productName = '<c:out value="${material.nombre}"/>';
                    const productPrice = <c:out value="${material.precio}"/>;
                    
                    // Aquí iría la lógica para agregar al carrito
                    // Por ahora, solo mostramos un mensaje
                    alert(`Agregaste ${quantity} unidad(es) de ${productName} al carrito`);
                    
                    // Actualizar el contador del carrito (implementación básica)
                    const cartBadge = document.querySelector('.cart-badge-visible');
                    if (cartBadge) {
                        let currentCount = parseInt(cartBadge.textContent);
                        cartBadge.textContent = currentCount + quantity;
                    }
                });
            });
        </script>
    </body>
</html>
