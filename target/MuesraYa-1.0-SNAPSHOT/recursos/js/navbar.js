/**
 * MuestraYa - Sistema de Carrito de Compras
 * Este script maneja todas las funcionalidades relacionadas con el carrito de compras 
 * y el navbar responsivo.
 */

// Clase para gestionar el carrito
class Carrito {
    constructor() {
        // Inicialización del carrito desde localStorage o creación de uno nuevo
        this.items = JSON.parse(localStorage.getItem('carrito')) || [];
        this.total = 0;
        this.cantidadTotal = 0;
        this.actualizarContador();
        this.inicializarEventos();
    }

    // Inicializar todos los eventos relacionados con el carrito
    inicializarEventos() {
        // Botones "Añadir al carrito"
        document.querySelectorAll('.btn-add-to-cart').forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                const card = e.target.closest('.product-card');                if (card) {
                    const id = card.dataset.id || card.querySelector('button[data-id]').dataset.id;
                    const nombre = card.querySelector('.card-title').textContent;
                    const precioText = card.querySelector('.card-text').textContent;
                    const precio = parseFloat(precioText.replace('$', '').trim());
                    const imagen = card.querySelector('img').src;
                    
                    this.agregarItem({
                        id,
                        nombre,
                        precio,
                        imagen,
                        cantidad: 1
                    });
                    
                    this.mostrarNotificacion(`${nombre} añadido al carrito`);
                }
            });
        });

        // Enlace del carrito en la navbar
        const enlacesCarrito = document.querySelectorAll('a[title="Carrito de compras"]');
        enlacesCarrito.forEach(enlace => {
            enlace.addEventListener('click', (e) => {
                e.preventDefault();
                this.mostrarModalCarrito();
            });
        });

        // Enlaces móviles del carrito
        document.querySelectorAll('.mobile-action-icon').forEach(enlace => {
            if (enlace.querySelector('i.fa-shopping-cart') || enlace.textContent.includes('Carrito')) {
                enlace.addEventListener('click', (e) => {
                    e.preventDefault();
                    this.mostrarModalCarrito();
                });
            }
        });
    }

    // Agregar un ítem al carrito
    agregarItem(item) {
        const itemExistente = this.items.find(i => i.id === item.id);
        
        if (itemExistente) {
            itemExistente.cantidad += item.cantidad;
        } else {
            this.items.push(item);
        }
        
        this.guardarCarrito();
        this.actualizarContador();
    }

    // Actualizar cantidad de un ítem
    actualizarCantidad(id, cantidad) {
        const item = this.items.find(i => i.id === id);
        if (item) {
            item.cantidad = cantidad;
            if (item.cantidad <= 0) {
                this.eliminarItem(id);
            } else {
                this.guardarCarrito();
                this.actualizarContador();
            }
        }
    }

    // Eliminar un ítem del carrito
    eliminarItem(id) {
        this.items = this.items.filter(item => item.id !== id);
        this.guardarCarrito();
        this.actualizarContador();
    }

    // Vaciar completamente el carrito
    vaciarCarrito() {
        this.items = [];
        this.guardarCarrito();
        this.actualizarContador();
    }

    // Guardar el carrito en localStorage
    guardarCarrito() {
        localStorage.setItem('carrito', JSON.stringify(this.items));
        // Calcular totales
        this.calcularTotal();
    }

    // Calcular el total del carrito
    calcularTotal() {
        this.total = this.items.reduce((sum, item) => sum + (item.precio * item.cantidad), 0);
        this.cantidadTotal = this.items.reduce((sum, item) => sum + item.cantidad, 0);
    }

    // Actualizar el contador visual del carrito
    actualizarContador() {
        this.calcularTotal();
        
        // Actualizar los badges del carrito
        const badges = document.querySelectorAll('.cart-badge-visible');
        badges.forEach(badge => {
            badge.textContent = this.cantidadTotal.toString();
            
            // Mostrar u ocultar el badge según si hay items
            if (this.cantidadTotal > 0) {
                badge.style.display = 'flex';
            } else {
                badge.style.display = 'none';
            }
        });
    }

    // Mostrar una notificación temporal
    mostrarNotificacion(mensaje, tipo = 'success') {
        // Crear el elemento de notificación
        const notificacion = document.createElement('div');
        notificacion.className = `toast toast-${tipo}`;
        notificacion.innerHTML = `
            <div class="toast-header">
                <i class="fas fa-shopping-cart me-2"></i>
                <strong class="me-auto">MuestraYa</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                ${mensaje}
            </div>
        `;
        
        // Añadir al DOM
        const toastContainer = document.querySelector('.toast-container');
        if (!toastContainer) {
            const container = document.createElement('div');
            container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            document.body.appendChild(container);
            container.appendChild(notificacion);
        } else {
            toastContainer.appendChild(notificacion);
        }
        
        // Mostrar con Bootstrap
        const toast = new bootstrap.Toast(notificacion, {
            autohide: true,
            delay: 3000
        });
        toast.show();
        
        // Eliminar después de ocultarse
        notificacion.addEventListener('hidden.bs.toast', () => {
            notificacion.remove();
        });
    }

    // Mostrar el modal del carrito
    mostrarModalCarrito() {
        // Eliminar modal anterior si existe
        const modalAnterior = document.getElementById('carritoModal');
        if (modalAnterior) {
            modalAnterior.remove();
        }
        
        // Crear el modal
        const modalHTML = `
        <div class="modal fade" id="carritoModal" tabindex="-1" aria-labelledby="carritoModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="carritoModalLabel">
                            <i class="fas fa-shopping-cart me-2"></i>Tu Carrito de Compras
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        ${this.renderizarItemsCarrito()}
                    </div>
                    <div class="modal-footer justify-content-between">
                        <div>
                            <button type="button" class="btn btn-outline-danger" id="vaciarCarrito">
                                <i class="fas fa-trash me-1"></i> Vaciar Carrito
                            </button>
                        </div>
                        <div class="d-flex flex-column align-items-end">
                            <h5 class="mb-3">Total: $${this.total.toFixed(2)}</h5>
                            <div>
                                <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">Seguir Comprando</button>
                                <button type="button" class="btn btn-primary" id="finalizarCompra">Finalizar Compra</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        `;
        
        // Añadir al DOM
        document.body.insertAdjacentHTML('beforeend', modalHTML);
        
        // Mostrar el modal
        const modal = new bootstrap.Modal(document.getElementById('carritoModal'));
        modal.show();
        
        // Añadir eventos a los botones del modal
        this.inicializarEventosModal();
    }

    // Renderizar los items del carrito para el modal
    renderizarItemsCarrito() {
        if (this.items.length === 0) {
            return `
                <div class="text-center py-5">
                    <i class="fas fa-shopping-cart fa-4x mb-3 text-muted"></i>
                    <h4>Tu carrito está vacío</h4>
                    <p class="text-muted">Añade productos para empezar a comprar</p>
                </div>
            `;
        }
        
        let html = `
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th scope="col">Producto</th>
                            <th scope="col" class="text-center">Precio</th>
                            <th scope="col" class="text-center">Cantidad</th>
                            <th scope="col" class="text-end">Subtotal</th>
                            <th scope="col"></th>
                        </tr>
                    </thead>
                    <tbody>
        `;
        
        this.items.forEach(item => {
            html += `
                <tr data-id="${item.id}">
                    <td>
                        <div class="d-flex align-items-center">
                            <img src="${item.imagen}" alt="${item.nombre}" class="cart-item-img me-3" style="width: 50px; height: 50px; object-fit: cover;">
                            <div>
                                <h6 class="mb-0">${item.nombre}</h6>
                            </div>
                        </div>
                    </td>
                    <td class="text-center">$${item.precio.toFixed(2)}</td>
                    <td class="text-center">
                        <div class="input-group input-group-sm quantity-selector" style="width: 120px;">
                            <button class="btn btn-outline-secondary btn-decrease" type="button">-</button>
                            <input type="number" class="form-control text-center item-quantity" value="${item.cantidad}" min="1">
                            <button class="btn btn-outline-secondary btn-increase" type="button">+</button>
                        </div>
                    </td>
                    <td class="text-end fw-bold">$${(item.precio * item.cantidad).toFixed(2)}</td>
                    <td class="text-end">
                        <button class="btn btn-sm btn-outline-danger btn-remove" title="Eliminar">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
            `;
        });
        
        html += `
                    </tbody>
                </table>
            </div>
        `;
        
        return html;
    }

    // Inicializar eventos del modal del carrito
    inicializarEventosModal() {
        const modal = document.getElementById('carritoModal');
        if (!modal) return;
        
        // Botones de aumentar cantidad
        modal.querySelectorAll('.btn-increase').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const row = e.target.closest('tr');
                const id = row.dataset.id;
                const inputCantidad = row.querySelector('.item-quantity');
                const cantidadActual = parseInt(inputCantidad.value);
                inputCantidad.value = cantidadActual + 1;
                this.actualizarCantidad(id, cantidadActual + 1);
                this.actualizarModalCarrito();
            });
        });
        
        // Botones de disminuir cantidad
        modal.querySelectorAll('.btn-decrease').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const row = e.target.closest('tr');
                const id = row.dataset.id;
                const inputCantidad = row.querySelector('.item-quantity');
                const cantidadActual = parseInt(inputCantidad.value);
                if (cantidadActual > 1) {
                    inputCantidad.value = cantidadActual - 1;
                    this.actualizarCantidad(id, cantidadActual - 1);
                    this.actualizarModalCarrito();
                }
            });
        });
        
        // Inputs de cantidad
        modal.querySelectorAll('.item-quantity').forEach(input => {
            input.addEventListener('change', (e) => {
                const row = e.target.closest('tr');
                const id = row.dataset.id;
                let cantidad = parseInt(e.target.value);
                if (isNaN(cantidad) || cantidad < 1) {
                    cantidad = 1;
                    e.target.value = 1;
                }
                this.actualizarCantidad(id, cantidad);
                this.actualizarModalCarrito();
            });
        });
        
        // Botones de eliminar item
        modal.querySelectorAll('.btn-remove').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const row = e.target.closest('tr');
                const id = row.dataset.id;
                this.eliminarItem(id);
                this.actualizarModalCarrito();
            });
        });
        
        // Botón de vaciar carrito
        const btnVaciar = modal.querySelector('#vaciarCarrito');
        if (btnVaciar) {
            btnVaciar.addEventListener('click', () => {
                if (confirm('¿Estás seguro de que deseas vaciar el carrito?')) {
                    this.vaciarCarrito();
                    this.actualizarModalCarrito();
                }
            });
        }
        
        // Botón de finalizar compra
        const btnFinalizar = modal.querySelector('#finalizarCompra');
        if (btnFinalizar) {
            btnFinalizar.addEventListener('click', () => {
                this.finalizarCompra();
            });
        }
    }

    // Actualizar el contenido del modal del carrito
    actualizarModalCarrito() {
        const modalBody = document.querySelector('#carritoModal .modal-body');
        if (modalBody) {
            modalBody.innerHTML = this.renderizarItemsCarrito();
        }
        
        const modalFooter = document.querySelector('#carritoModal .modal-footer h5');
        if (modalFooter) {
            modalFooter.textContent = `Total: $${this.total.toFixed(2)}`;
        }
        
        // Reinicializar eventos después de actualizar el contenido
        this.inicializarEventosModal();
    }

    // Finalizar el proceso de compra
    finalizarCompra() {
        // Si el usuario no está logueado, redirigir al login
        if (!this.usuarioLogueado()) {
            if (confirm('Debes iniciar sesión para finalizar la compra. ¿Deseas ir a la página de login?')) {
                window.location.href = window.location.origin + '/MuestraYa/login';
            }
            return;
        }
        
        // Si el carrito está vacío, mostrar mensaje
        if (this.items.length === 0) {
            alert('No hay productos en el carrito.');
            return;
        }
        
        // Aquí se implementaría el proceso de compra
        // Por ahora, solo mostramos confirmación y vaciamos el carrito
        alert('¡Gracias por tu compra! Tu orden ha sido procesada.');
        this.vaciarCarrito();
        
        // Cerrar el modal
        const modal = bootstrap.Modal.getInstance(document.getElementById('carritoModal'));
        if (modal) {
            modal.hide();
        }
    }

    // Verificar si el usuario está logueado
    usuarioLogueado() {
        // Verificar si existe el dropdown de usuario o el botón de login
        return document.querySelector('#userDropdown') !== null;
    }
}

// Inicialización del sistema de navegación responsive
class Navbar {
    constructor() {
        this.inicializarMenu();
        this.hacerNavbarFijo();
    }
    
    inicializarMenu() {
        // Toggle para menú móvil
        const menuToggle = document.querySelector('.navbar-toggler');
        const overlay = document.getElementById('menuOverlay');
        
        if (menuToggle) {
            menuToggle.addEventListener('click', () => {
                document.body.classList.toggle('menu-open');
                if (overlay) {
                    overlay.classList.toggle('active');
                }
            });
        }
        
        // Botón de cerrar menú móvil
        const closeButton = document.querySelector('.mobile-menu-close');
        if (closeButton) {
            closeButton.addEventListener('click', () => {
                document.body.classList.remove('menu-open');
                if (overlay) {
                    overlay.classList.remove('active');
                }
            });
        }
        
        // Click en overlay para cerrar menú
        if (overlay) {
            overlay.addEventListener('click', () => {
                document.body.classList.remove('menu-open');
                overlay.classList.remove('active');
            });
        }
    }
    
    hacerNavbarFijo() {
        // Hacer que la navbar sea fija al hacer scroll
        const navbar = document.querySelector('.navbar');
        
        if (navbar) {
            window.addEventListener('scroll', () => {
                if (window.scrollY > 50) {
                    navbar.classList.add('navbar-fixed');
                    document.body.style.paddingTop = navbar.offsetHeight + 'px';
                } else {
                    navbar.classList.remove('navbar-fixed');
                    document.body.style.paddingTop = '0';
                }
            });
        }
    }
}

// Inicialización cuando el DOM está listo
document.addEventListener('DOMContentLoaded', () => {
    // Inicializar el sistema de carrito
    window.carrito = new Carrito();
    
    // Inicializar el sistema de navegación
    window.navbar = new Navbar();
    
    console.log('Sistema de carrito y navbar inicializado correctamente.');
});