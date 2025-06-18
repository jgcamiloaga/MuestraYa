// Sistema de carrito y navegación mejorado con integración backend
class Carrito {
    constructor() {
        this.items = [];
        this.total = 0;
        this.cantidadTotal = 0;
        this.contextPath = window.contextPath || '';
        
        // Cargar carrito desde el servidor al inicializar
        this.cargarCarritoDelServidor();
        this.inicializarEventos();
    }

    // Cargar carrito desde el servidor
    async cargarCarritoDelServidor() {
        try {
            const response = await fetch(this.contextPath + '/carrito-server?action=listar', {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            });

            if (response.ok) {
                const data = await response.json();
                this.items = data.items || [];
                this.cantidadTotal = data.totalItems || 0;
                this.total = data.total || 0;
                this.actualizarContador();
            } else if (response.status === 401) {
                // Usuario no autenticado, usar localStorage como fallback
                this.cargarCarritoLocal();
            }
        } catch (error) {
            console.log('Error al cargar carrito del servidor, usando localStorage');
            this.cargarCarritoLocal();
        }
    }

    // Cargar carrito desde localStorage (fallback)
    cargarCarritoLocal() {
        const carritoGuardado = localStorage.getItem('carrito');
        if (carritoGuardado) {
            this.items = JSON.parse(carritoGuardado);
            this.calcularTotal();
        }
        this.actualizarContador();
    }

    // Inicializar eventos del carrito
    inicializarEventos() {
        // Enlaces del carrito en la navbar
        document.querySelectorAll('.nav-link').forEach(enlace => {
            if (enlace.querySelector('i.fa-shopping-cart') || enlace.textContent.includes('Carrito')) {
                enlace.addEventListener('click', (e) => {
                    e.preventDefault();
                    this.mostrarModalCarrito();
                });
            }
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

    // Agregar un ítem al carrito (integrado con backend)
    async agregarItem(idMaterial, nombre, precio, cantidad = 1, imagen = 'default.jpg') {
        try {
            const response = await fetch(this.contextPath + '/carrito-server', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=agregar&idMaterial=${encodeURIComponent(idMaterial)}&cantidad=${cantidad}&precio=${precio}`
            });

            if (response.ok) {
                const data = await response.json();
                if (data.success) {
                    // Actualizar estado local
                    this.cantidadTotal = data.totalItems;
                    this.total = data.total;
                    this.actualizarContador();
                    
                    // Recargar items del servidor
                    await this.cargarCarritoDelServidor();
                    
                    return true;
                } else {
                    console.error('Error del servidor:', data.message);
                    return false;
                }
            } else if (response.status === 401) {
                // Usuario no autenticado, usar localStorage
                return this.agregarItemLocal(idMaterial, nombre, precio, cantidad, imagen);
            }
        } catch (error) {
            console.error('Error al agregar al carrito:', error);
            // Fallback a localStorage
            return this.agregarItemLocal(idMaterial, nombre, precio, cantidad, imagen);
        }
        return false;
    }

    // Agregar item localmente (fallback)
    agregarItemLocal(idMaterial, nombre, precio, cantidad, imagen) {
        const itemExistente = this.items.find(i => i.idMaterial === idMaterial);
        
        if (itemExistente) {
            itemExistente.cantidad += cantidad;
        } else {
            this.items.push({
                idMaterial: idMaterial,
                nombre: nombre,
                precio: precio,
                cantidad: cantidad,
                imagen: imagen
            });
        }
        
        this.guardarCarritoLocal();
        this.actualizarContador();
        return true;
    }

    // Actualizar cantidad de un ítem
    async actualizarCantidad(idMaterial, cantidad) {
        try {
            const response = await fetch(this.contextPath + '/carrito-server', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=actualizar&idMaterial=${encodeURIComponent(idMaterial)}&cantidad=${cantidad}`
            });

            if (response.ok) {
                const data = await response.json();
                if (data.success) {
                    this.cantidadTotal = data.totalItems;
                    this.total = data.total;
                    this.actualizarContador();
                    await this.cargarCarritoDelServidor();
                    return true;
                }
            } else if (response.status === 401) {
                return this.actualizarCantidadLocal(idMaterial, cantidad);
            }
        } catch (error) {
            console.error('Error al actualizar cantidad:', error);
            return this.actualizarCantidadLocal(idMaterial, cantidad);
        }
        return false;
    }

    // Actualizar cantidad localmente
    actualizarCantidadLocal(idMaterial, cantidad) {
        const item = this.items.find(i => i.idMaterial === idMaterial);
        if (item) {
            item.cantidad = cantidad;
            if (item.cantidad <= 0) {
                this.eliminarItemLocal(idMaterial);
            } else {
                this.guardarCarritoLocal();
                this.actualizarContador();
            }
            return true;
        }
        return false;
    }

    // Eliminar un ítem del carrito
    async eliminarItem(idMaterial) {
        try {
            const response = await fetch(this.contextPath + '/carrito-server', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=eliminar&idMaterial=${encodeURIComponent(idMaterial)}`
            });

            if (response.ok) {
                const data = await response.json();
                if (data.success) {
                    this.cantidadTotal = data.totalItems;
                    this.total = data.total;
                    this.actualizarContador();
                    await this.cargarCarritoDelServidor();
                    return true;
                }
            } else if (response.status === 401) {
                return this.eliminarItemLocal(idMaterial);
            }
        } catch (error) {
            console.error('Error al eliminar del carrito:', error);
            return this.eliminarItemLocal(idMaterial);
        }
        return false;
    }

    // Eliminar item localmente
    eliminarItemLocal(idMaterial) {
        this.items = this.items.filter(item => item.idMaterial !== idMaterial);
        this.guardarCarritoLocal();
        this.actualizarContador();
        return true;
    }

    // Vaciar completamente el carrito
    async vaciarCarrito() {
        try {
            const response = await fetch(this.contextPath + '/carrito-server?action=vaciar', {
                method: 'POST'
            });

            if (response.ok) {
                const data = await response.json();
                if (data.success) {
                    this.items = [];
                    this.cantidadTotal = 0;
                    this.total = 0;
                    this.actualizarContador();
                    return true;
                }
            } else if (response.status === 401) {
                return this.vaciarCarritoLocal();
            }
        } catch (error) {
            console.error('Error al vaciar carrito:', error);
            return this.vaciarCarritoLocal();
        }
        return false;
    }

    // Vaciar carrito localmente
    vaciarCarritoLocal() {
        this.items = [];
        this.guardarCarritoLocal();
        this.actualizarContador();
        return true;
    }

    // Guardar el carrito en localStorage (solo para usuarios no autenticados)
    guardarCarritoLocal() {
        localStorage.setItem('carrito', JSON.stringify(this.items));
        this.calcularTotal();
    }

    // Calcular el total del carrito
    calcularTotal() {
        this.total = this.items.reduce((sum, item) => {
            const precio = typeof item.precio === 'string' ? parseFloat(item.precio) : item.precio;
            return sum + (precio * item.cantidad);
        }, 0);
        this.cantidadTotal = this.items.reduce((sum, item) => sum + item.cantidad, 0);
    }

    // Actualizar el contador visual del carrito
    actualizarContador() {
        const contadores = document.querySelectorAll('.cart-count, #cart-count, .carrito-contador');
        contadores.forEach(contador => {
            if (contador) {
                contador.textContent = this.cantidadTotal;
                contador.style.display = this.cantidadTotal > 0 ? 'inline' : 'none';
            }
        });
    }

    // Mostrar modal del carrito
    mostrarModalCarrito() {
        // Verificar si ya existe un modal
        let modal = document.getElementById('carritoModal');
        
        if (!modal) {
            // Crear el modal si no existe
            modal = document.createElement('div');
            modal.id = 'carritoModal';
            modal.className = 'modal fade';
            modal.setAttribute('tabindex', '-1');
            modal.innerHTML = this.generarHTMLModal();
            document.body.appendChild(modal);
        }

        // Actualizar contenido del modal
        this.actualizarModalCarrito();

        // Mostrar el modal usando Bootstrap
        const bsModal = new bootstrap.Modal(modal);
        bsModal.show();

        // Configurar eventos del modal
        this.configurarEventosModal(modal);
    }

    // Generar HTML del modal
    generarHTMLModal() {
        return `
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-shopping-cart me-2"></i>Tu Carrito de Compras
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="carritoModalBody">
                        <!-- Contenido dinámico del carrito -->
                    </div>
                </div>
            </div>
        `;
    }

    // Actualizar contenido del modal
    actualizarModalCarrito() {
        const modalBody = document.getElementById('carritoModalBody');
        if (!modalBody) return;

        if (this.items.length === 0) {
            modalBody.innerHTML = `
                <div class="text-center py-5">
                    <i class="fas fa-shopping-cart text-muted" style="font-size: 4rem;"></i>
                    <h4 class="text-muted mt-3">Tu carrito está vacío</h4>
                    <p class="text-muted">Agrega algunos productos para empezar a comprar</p>
                </div>
            `;
        } else {
            modalBody.innerHTML = `
                <div class="carrito-items">
                    ${this.items.map(item => this.generarItemHTML(item)).join('')}
                </div>
                <hr>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5>Total: <span class="text-primary">$${this.total.toFixed(2)}</span></h5>
                    <span class="text-muted">${this.cantidadTotal} producto${this.cantidadTotal !== 1 ? 's' : ''}</span>
                </div>
                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <button type="button" class="btn btn-outline-danger" id="vaciarCarrito">
                        <i class="fas fa-trash me-1"></i> Vaciar Carrito
                    </button>
                    <button type="button" class="btn btn-outline-secondary me-md-2" data-bs-dismiss="modal">
                        <i class="fas fa-arrow-left me-1"></i> Seguir Comprando
                    </button>
                    <button type="button" class="btn btn-primary" id="finalizarCompra">
                        <i class="fas fa-credit-card me-1"></i> Finalizar Compra
                    </button>
                </div>
            `;
        }
    }

    // Generar HTML para un item del carrito
    generarItemHTML(item) {
        const precio = typeof item.precio === 'string' ? parseFloat(item.precio) : item.precio;
        const subtotal = precio * item.cantidad;
        
        return `
            <div class="carrito-item d-flex align-items-center py-3 border-bottom" data-id="${item.idMaterial}">
                <img src="${this.contextPath}/image/${item.imagen || 'default.jpg'}" 
                     alt="${item.nombre}" class="me-3" 
                     style="width: 60px; height: 60px; object-fit: cover; border-radius: 8px;">
                <div class="flex-grow-1">
                    <h6 class="mb-1">${item.nombre}</h6>
                    <small class="text-muted">$${precio.toFixed(2)} c/u</small>
                </div>
                <div class="d-flex align-items-center me-3">
                    <button class="btn btn-sm btn-outline-secondary me-2" onclick="carrito.actualizarCantidad('${item.idMaterial}', ${item.cantidad - 1})">
                        <i class="fas fa-minus"></i>
                    </button>
                    <span class="mx-2 fw-bold">${item.cantidad}</span>
                    <button class="btn btn-sm btn-outline-secondary ms-2" onclick="carrito.actualizarCantidad('${item.idMaterial}', ${item.cantidad + 1})">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
                <div class="text-end me-3">
                    <div class="fw-bold">$${subtotal.toFixed(2)}</div>
                </div>
                <button class="btn btn-sm btn-outline-danger" onclick="carrito.eliminarItem('${item.idMaterial}')">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `;
    }

    // Configurar eventos del modal
    configurarEventosModal(modal) {
        // Botón de vaciar carrito
        const btnVaciar = modal.querySelector('#vaciarCarrito');
        if (btnVaciar) {
            btnVaciar.addEventListener('click', () => {
                this.mostrarModalVaciarCarrito();
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

    // Finalizar compra
    finalizarCompra() {
        if (this.items.length === 0) {
            alert('Tu carrito está vacío');
            return;
        }

        // Aquí se implementaría el proceso de compra
        alert('¡Gracias por tu compra! Tu orden ha sido procesada.');
        this.vaciarCarrito();
        
        // Cerrar el modal
        const modal = bootstrap.Modal.getInstance(document.getElementById('carritoModal'));
        if (modal) {
            modal.hide();
        }
    }

    // Mostrar modal personalizado para vaciar carrito
    mostrarModalVaciarCarrito() {
        // Verificar si ya existe un modal activo
        const existingModal = document.querySelector('.modal-overlay-carrito');
        if (existingModal) {
            return;
        }
        
        const carritoItems = this.items.length;
        const totalCarrito = this.total;
        
        // Crear el modal personalizado
        const modalOverlay = document.createElement('div');
        modalOverlay.className = 'modal-overlay-carrito';
        modalOverlay.innerHTML = `
            <div class="modal-content-carrito">
                <div class="modal-header-carrito">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>¿Vaciar Carrito?</h3>
                </div>
                <div class="modal-body-carrito">
                    <p>¿Estás seguro de que deseas vaciar tu carrito de compras?</p>
                    <div class="carrito-info">
                        <div class="info-item">
                            <i class="fas fa-box"></i>
                            <span>${carritoItems} producto${carritoItems !== 1 ? 's' : ''}</span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-dollar-sign"></i>
                            <span>$${totalCarrito.toFixed(2)}</span>
                        </div>
                    </div>
                    <small class="modal-warning">Esta acción eliminará todos los productos de tu carrito.</small>
                </div>
                <div class="modal-footer-carrito">
                    <button class="btn-cancelar-carrito" onclick="cerrarModalCarrito()">
                        <i class="fas fa-times"></i> Cancelar
                    </button>
                    <button class="btn-vaciar-carrito" onclick="confirmarVaciarCarrito()">
                        <i class="fas fa-trash"></i> Vaciar Carrito
                    </button>
                </div>
            </div>
        `;
        
        document.body.appendChild(modalOverlay);
        
        // Agregar estilos si no existen
        if (!document.getElementById('modal-carrito-styles')) {
            const style = document.createElement('style');
            style.id = 'modal-carrito-styles';
            style.textContent = `
                .modal-overlay-carrito {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background-color: rgba(0, 0, 0, 0.6);
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    z-index: 10001;
                    opacity: 0;
                    visibility: hidden;
                    transition: all 0.3s ease;
                }
                
                .modal-overlay-carrito.show {
                    opacity: 1;
                    visibility: visible;
                }
                
                .modal-content-carrito {
                    background: white;
                    border-radius: 15px;
                    box-shadow: 0 25px 70px rgba(0, 0, 0, 0.3);
                    max-width: 480px;
                    width: 90%;
                    overflow: hidden;
                    transform: scale(0.8) translateY(-30px);
                    transition: all 0.3s ease;
                }
                
                .modal-overlay-carrito.show .modal-content-carrito {
                    transform: scale(1) translateY(0);
                }
                
                .modal-header-carrito {
                    background: linear-gradient(135deg, #007bff, #0056b3);
                    color: white;
                    padding: 25px;
                    text-align: center;
                    position: relative;
                }
                
                .modal-header-carrito i {
                    font-size: 3rem;
                    margin-bottom: 15px;
                    display: block;
                    animation: bounce 2s infinite;
                }
                
                .modal-header-carrito h3 {
                    margin: 0;
                    font-size: 1.4rem;
                    font-weight: 600;
                }
                
                .modal-body-carrito {
                    padding: 30px;
                    text-align: center;
                }
                
                .modal-body-carrito p {
                    margin: 0 0 20px 0;
                    font-size: 1.1rem;
                    color: #333;
                    line-height: 1.5;
                }
                
                .carrito-info {
                    background: #f8f9fa;
                    padding: 20px;
                    border-radius: 10px;
                    margin: 20px 0;
                    display: flex;
                    justify-content: space-around;
                    align-items: center;
                }
                
                .info-item {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    gap: 8px;
                }
                
                .info-item i {
                    font-size: 1.5rem;
                    color: #007bff;
                }
                
                .info-item span {
                    font-weight: 600;
                    color: #333;
                }
                
                .modal-warning {
                    color: #dc3545;
                    font-style: italic;
                    display: block;
                    margin-top: 15px;
                }
                
                .modal-footer-carrito {
                    padding: 25px;
                    display: flex;
                    gap: 15px;
                    justify-content: center;
                    background: #f8f9fa;
                }
                
                .modal-footer-carrito button {
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
                    min-width: 130px;
                    justify-content: center;
                }
                
                .btn-cancelar-carrito {
                    background: #6c757d;
                    color: white;
                }
                
                .btn-cancelar-carrito:hover {
                    background: #5a6268;
                    transform: translateY(-2px);
                }
                
                .btn-vaciar-carrito {
                    background: #dc3545;
                    color: white;
                }
                
                .btn-vaciar-carrito:hover {
                    background: #c82333;
                    transform: translateY(-2px);
                }
                
                @keyframes bounce {
                    0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
                    40% { transform: translateY(-10px); }
                    60% { transform: translateY(-5px); }
                }
                
                @media (max-width: 480px) {
                    .modal-content-carrito {
                        width: 95%;
                        margin: 20px;
                    }
                    
                    .carrito-info {
                        flex-direction: column;
                        gap: 15px;
                    }
                    
                    .modal-footer-carrito {
                        flex-direction: column;
                    }
                    
                    .modal-footer-carrito button {
                        width: 100%;
                    }
                }
            `;
            document.head.appendChild(style);
        }
        
        // Mostrar modal con animación
        setTimeout(() => modalOverlay.classList.add('show'), 10);
        
        // Funciones globales para el modal
        window.cerrarModalCarrito = () => {
            modalOverlay.classList.remove('show');
            setTimeout(() => {
                if (document.body.contains(modalOverlay)) {
                    document.body.removeChild(modalOverlay);
                }
                if (window.cerrarModalCarrito) delete window.cerrarModalCarrito;
                if (window.confirmarVaciarCarrito) delete window.confirmarVaciarCarrito;
            }, 300);
        };
        
        window.confirmarVaciarCarrito = async () => {
            const success = await this.vaciarCarrito();
            if (success) {
                this.actualizarModalCarrito();
                window.cerrarModalCarrito();
                
                // Mostrar notificación de éxito
                if (typeof mostrarNotificacion === 'function') {
                    mostrarNotificacion('Carrito vaciado correctamente', 'success');
                }
            }
        };
        
        // Cerrar con ESC
        const handleEsc = (e) => {
            if (e.key === 'Escape') {
                window.cerrarModalCarrito();
                document.removeEventListener('keydown', handleEsc);
            }
        };
        document.addEventListener('keydown', handleEsc);
        
        // Cerrar al hacer click fuera del modal
        modalOverlay.addEventListener('click', (e) => {
            if (e.target === modalOverlay) {
                window.cerrarModalCarrito();
            }
        });
    }

    // Verificar si el usuario está logueado
    usuarioLogueado() {
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
        const menuToggle = document.querySelector('.navbar-toggler');
        const navbarCollapse = document.querySelector('.navbar-collapse');
        
        if (menuToggle) {
            menuToggle.addEventListener('click', () => {
                document.body.classList.toggle('menu-open');
            });
        }
        
        const closeButton = document.querySelector('.mobile-menu-close');
        if (closeButton) {
            closeButton.addEventListener('click', () => {
                document.body.classList.remove('menu-open');
            });
        }
        
        if (navbarCollapse) {
            navbarCollapse.addEventListener('click', (e) => {
                if (!e.target.closest('[data-bs-toggle="collapse"]') && !e.target.closest('.mobile-menu-close')) {
                    e.stopPropagation();
                }
            });
        }
    }
    
    hacerNavbarFijo() {
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
