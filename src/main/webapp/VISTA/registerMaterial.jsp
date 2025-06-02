<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.dto.Usuario"%>
<%
    // Verificar si el usuario está autenticado
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // Obtener el usuario de la sesión
    Usuario usuarioActual = (Usuario) userSession.getAttribute("usuario");
%>
<!DOCTYPE html>
<html lang="es">
    <head>        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MuestraYa - Registro Materiales</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/css/registerMaterial-style.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/css/form-fields.css"/>
    </head>
    <body>
        <div class="page-container">
            <div class="form-card">
                <div class="header">
                    <h1>Registro Materiales</h1>
                    <p class="subtitle">MuestraYa</p>
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/vista/listado.jsp" class="nav-link">
                            <i class="fas fa-list"></i> Ver Listado
                        </a>
                    </div>
                </div>

                <% if (request.getAttribute("errorMessage") != null) {%>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("errorMessage")%>
                </div>
                <% } %>

                <% if (request.getAttribute("successMessage") != null) {%>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("successMessage")%>
                </div>
                <% }%>

                <form action="../SendForm" method="POST" class="form-container" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="codigo">Código</label>
                        <div class="input-container">
                            <i class="fas fa-barcode icon"></i>
                            <input type="text" id="codigo" name="codigo" placeholder="Ingrese el código" value="${prevCodigo}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="nombre">Nombre</label>
                        <div class="input-container">
                            <i class="fas fa-tag icon"></i>
                            <input type="text" id="nombre" name="nombre" placeholder="Ingrese el nombre" value="${prevNombre}" required>
                        </div>
                    </div>                    <div class="form-group">
                        <label for="precio">Precio</label>
                        <div class="input-container">
                            <i class="fas fa-dollar-sign icon"></i>
                            <input type="number" id="precio" name="precio" step="0.01" min="0" placeholder="Ingrese el precio" value="${prevPrecio}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="stock">Stock</label>
                        <div class="input-container">
                            <i class="fas fa-cubes icon"></i>
                            <input type="number" id="stock" name="stock" min="0" placeholder="Cantidad disponible" value="${prevStock}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="descripcion">Descripción</label>
                        <div class="input-container textarea-container">
                            <i class="fas fa-align-left icon"></i>
                            <textarea id="descripcion" name="descripcion" placeholder="Descripción detallada del producto" rows="3">${prevDescripcion}</textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="especificaciones">Especificaciones</label>
                        <div class="input-container textarea-container">
                            <i class="fas fa-list-ul icon"></i>
                            <textarea id="especificaciones" name="especificaciones" placeholder="Especificaciones técnicas del producto" rows="3">${prevEspecificaciones}</textarea>
                        </div>
                    </div>

                    <div class="form-group form-row">
                        <div class="form-col">
                            <label for="unidadMedida">Unidad de Medida</label>
                            <div class="input-container">
                                <i class="fas fa-ruler icon"></i>
                                <input type="text" id="unidadMedida" name="unidadMedida" placeholder="Ej: unidades, kg, m" value="${prevUnidadMedida}">
                            </div>
                        </div>
                        <div class="form-col">
                            <label for="color">Color</label>
                            <div class="input-container">
                                <i class="fas fa-palette icon"></i>
                                <input type="text" id="color" name="color" placeholder="Color principal" value="${prevColor}">
                            </div>
                        </div>
                    </div>

                    <div class="form-group form-row">
                        <div class="form-col">
                            <label for="peso">Peso (kg)</label>
                            <div class="input-container">
                                <i class="fas fa-weight-hanging icon"></i>
                                <input type="number" id="peso" name="peso" step="0.01" min="0" placeholder="Peso en kg" value="${prevPeso}">
                            </div>
                        </div>
                        <div class="form-col">
                            <label for="dimension">Dimensiones</label>
                            <div class="input-container">
                                <i class="fas fa-ruler-combined icon"></i>
                                <input type="text" id="dimension" name="dimension" placeholder="Ej: 10x20x30 cm" value="${prevDimension}">
                            </div>
                        </div>
                    </div>

                    <div class="form-group checkbox-group">
                        <div class="input-container checkbox-container">
                            <input type="checkbox" id="destacado" name="destacado" ${prevDestacado ? 'checked' : ''}>
                            <label for="destacado">Marcar como producto destacado</label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="categoria">Categoría</label>
                        <div class="input-container">
                            <i class="fas fa-folder icon"></i>
                            <select id="categoria" name="categoria" required>
                                <option value="" disabled ${empty prevCategoria ? 'selected' : ''}>Seleccione una categoría</option>
                                <option value="CAT001" ${prevCategoria eq 'CAT001' ? 'selected' : ''}>Herramienta</option>
                                <option value="CAT002" ${prevCategoria eq 'CAT002' ? 'selected' : ''}>Ropa</option>
                                <option value="CAT003" ${prevCategoria eq 'CAT003' ? 'selected' : ''}>Cocina</option>
                                <option value="CAT004" ${prevCategoria eq 'CAT004' ? 'selected' : ''}>Electrónica</option>
                                <option value="CAT005" ${prevCategoria eq 'CAT005' ? 'selected' : ''}>Construcción</option>
                                <option value="CAT006" ${prevCategoria eq 'CAT006' ? 'selected' : ''}>Oficina</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="imagen">Imagen del Material</label>
                        <div class="input-container file-input-container">
                            <i class="fas fa-image icon"></i>
                            <input type="file" id="imagen" name="imagen" accept="image/*" class="file-input">
                            <div class="file-input-label">
                                <span id="file-name">Seleccionar imagen...</span>
                            </div>
                        </div>
                        <div class="image-preview-container">
                            <div id="imagePreview" class="image-preview">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <span>Vista previa de la imagen</span>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="submit-btn">
                        <span>REGISTRAR</span>
                        <i class="fas fa-arrow-right"></i>
                    </button>
                </form>
            </div>
        </div>
        <script>
            // Función para mostrar la vista previa de la imagen
            document.getElementById('imagen').addEventListener('change', function(e) {
                const file = e.target.files[0];
                const fileNameElement = document.getElementById('file-name');
                const imagePreview = document.getElementById('imagePreview');
                
                // Actualizar el nombre del archivo seleccionado
                if (file) {
                    fileNameElement.textContent = file.name;
                    
                    // Crear un objeto FileReader para leer el archivo
                    const reader = new FileReader();
                    
                    // Configurar el evento onload que se dispara cuando la lectura se completa
                    reader.onload = function(event) {
                        // Limpiar el contenido actual del contenedor de vista previa
                        imagePreview.innerHTML = '';
                        
                        // Crear un elemento de imagen y establecer su fuente
                        const img = document.createElement('img');
                        img.src = event.target.result;
                        img.alt = 'Vista previa';
                        
                        // Agregar la imagen al contenedor de vista previa
                        imagePreview.appendChild(img);
                        
                        // Agregar la clase has-image para aplicar estilos específicos
                        imagePreview.classList.add('has-image');
                    };
                    
                    // Iniciar la lectura del archivo como una URL de datos
                    reader.readAsDataURL(file);
                } else {
                    // Restablecer a los valores predeterminados si no hay archivo
                    fileNameElement.textContent = 'Seleccionar imagen...';
                    imagePreview.innerHTML = `
                        <i class="fas fa-cloud-upload-alt"></i>
                        <span>Vista previa de la imagen</span>
                    `;
                    imagePreview.classList.remove('has-image');
                }
            });
            
            // Permitir hacer clic en el contenedor de vista previa para activar el input de archivo
            document.getElementById('imagePreview').addEventListener('click', function() {
                document.getElementById('imagen').click();
            });
            
            // También permitir hacer clic en la etiqueta para activar el input de archivo
            document.querySelector('.file-input-label').addEventListener('click', function(e) {
                e.preventDefault(); // Prevenir comportamiento predeterminado
                document.getElementById('imagen').click();
            });
        </script>
    </body>
</html>