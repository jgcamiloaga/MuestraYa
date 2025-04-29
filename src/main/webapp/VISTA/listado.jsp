<%@page import="Modelo.Material"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="Controlador.ConexionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Configurar cabeceras para evitar caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%
    // Verificar si el usuario está autenticado
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // Obtener el usuario de la sesión
    Modelo.Usuario usuarioActual = (Modelo.Usuario) userSession.getAttribute("usuario");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MuestraYa - Listado de Materiales</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="../CSS/listado-style.css">
        <link rel="stylesheet" href="../CSS/cards-style.css">
        <script>
            //MENSAJE DE ELIMINAR UN PRODUCTO
            function confirmarEliminar(id, nombre) {
                if (confirm("¿Estás seguro de que deseas eliminar el material '" + nombre + "'?")) {
                    window.location.href = "<%= request.getContextPath()%>/DeleteMaterial?id=" + id;
                }
            }

            //MENSAJE DE MATERIAL AÑADIDO
            window.onload = function () {
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

            function mostrarNotificacion(mensaje, tipo) {
                const notificacion = document.createElement('div');
                notificacion.className = 'notificacion ' + tipo;
                notificacion.innerHTML = '<i class="fas fa-' + (tipo === 'success' ? 'check-circle' : 'exclamation-circle') + '"></i> ' + mensaje;

                document.body.appendChild(notificacion);

                //MOSTRAR NOTIFICACION
                setTimeout(function () {
                    notificacion.classList.add('mostrar');
                }, 100);

                //OCULTAR LUEGO DE 3 SEGUNDOS
                setTimeout(function () {
                    notificacion.classList.remove('mostrar');
                    setTimeout(function () {
                        document.body.removeChild(notificacion);
                    }, 300);
                }, 3000);
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
        </script>
    </head>
    <body>
        <div class="header">
            <h1>Sistema de Gestión de Materiales</h1>
            <div class="user-info">
                <span class="welcome-text">Bienvenido, <%= usuarioActual.getNombre()%></span>
                <div class="nav-links">
                    <a href="registerMaterial.jsp" class="nav-link">
                        <i class="fas fa-plus-circle"></i> Nuevo Material
                    </a>
                    <a href="<%= request.getContextPath()%>/logout" class="nav-link logout-link">
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

            <%
                Connection cxn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                // SQL
                String sql = "SELECT m.idMaterial, m.nombre, m.precio, m.idCategoria, m.imagen, "
                        + "CASE "
                        + "    WHEN m.idCategoria = 'CAT001' THEN 'Herramienta' "
                        + "    WHEN m.idCategoria = 'CAT002' THEN 'Ropa' "
                        + "    WHEN m.idCategoria = 'CAT003' THEN 'Cocina' "
                        + "    WHEN m.idCategoria = 'CAT004' THEN 'Electrónica' "
                        + "    WHEN m.idCategoria = 'CAT005' THEN 'Construcción' "
                        + "    WHEN m.idCategoria = 'CAT006' THEN 'Oficina' "
                        + "    ELSE 'Sin categoría' "
                        + "END AS nombreCategoria "
                        + "FROM material m "
                        + "ORDER BY m.nombre ASC";

                List<Material> lista = new ArrayList<>();

                try {
                    // Obtener la conexión de la base de datos
                    cxn = ConexionDB.getConnection();

                    // Preparar y ejecutar la consulta SQL
                    ps = cxn.prepareStatement(sql);
                    rs = ps.executeQuery();

                    // Procesar los resultados de la consulta
                    while (rs.next()) {
                        BigDecimal precio = rs.getBigDecimal("precio");
                        Material m = new Material(
                                rs.getString("idMaterial"),
                                rs.getString("nombre"),
                                precio
                        );
                        // Añadir la categoría al objeto Material
                        m.setIdCategoria(rs.getString("idCategoria"));
                        m.setNombreCategoria(rs.getString("nombreCategoria"));
                        // Añadir la imagen al objeto Material
                        m.setImagen(rs.getString("imagen"));
                        lista.add(m);
                    }

                    rs.close();
                } catch (Exception e) {
                    out.println("<div class='error'><i class='fas fa-exclamation-circle'></i> Error: " + e.getMessage() + "</div>");
                } finally {
                    try {
                        if (ps != null) {
                            ps.close();
                        }
                        if (cxn != null) {
                            cxn.close();
                        }
                    } catch (Exception e) {
                        out.println("<div class='error'><i class='fas fa-exclamation-circle'></i> Error al cerrar recursos: " + e.getMessage() + "</div>");
                    }
                }
            %>

            <% if (!lista.isEmpty()) { %>
            <!-- Vista de tabla (original) -->
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
                        <% for (Material m : lista) {%>
                        <tr>
                            <td class="col-id"><%= m.getIdMaterial()%></td>
                            <td class="col-name"><%= m.getNombre()%></td>
                            <td class="col-category">
                                <span class="category-badge <%= m.getIdCategoria().toLowerCase()%>">
                                    <i class="<%= getCategoryIcon(m.getIdCategoria())%>"></i>
                                    <%= m.getNombreCategoria()%>
                                </span>
                            </td>
                            <td class="col-price">
                                <span class="price">$<%= m.getPrecio()%></span>
                            </td>
                            <td class="col-actions">
                                <button class="delete-btn" onclick="confirmarEliminar('<%= m.getIdMaterial()%>', '<%= m.getNombre()%>')">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Vista de tarjetas (nueva) -->
            <div id="cards-container" class="cards-container">
                <% for (Material m : lista) {%>
                <div class="material-card <%= m.getIdCategoria().toLowerCase()%>">
                    <div class="card-image">
                        <% if (m.getImagen() != null && !m.getImagen().isEmpty() && !m.getImagen().equals("default.jpg")) {%>
                        <img src="uploads/<%= m.getImagen()%>" alt="<%= m.getNombre()%>" onerror="this.onerror=null; this.src='images/default.jpg';">
                        <% } else {%>
                        <div class="default-image">
                            <i class="<%= getCategoryIcon(m.getIdCategoria())%>"></i>
                        </div>
                        <% }%>
                        <div class="card-category">
                            <span class="category-badge <%= m.getIdCategoria().toLowerCase()%>">
                                <i class="<%= getCategoryIcon(m.getIdCategoria())%>"></i>
                                <%= m.getNombreCategoria()%>
                            </span>
                        </div>
                    </div>
                    <div class="card-content">
                        <h3 class="card-title"><%= m.getNombre()%></h3>
                        <div class="card-details">
                            <div class="card-id">
                                <span class="detail-label">ID:</span>
                                <span class="detail-value"><%= m.getIdMaterial()%></span>
                            </div>
                            <div class="card-price">
                                <span class="price">$<%= m.getPrecio()%></span>
                            </div>
                        </div>
                    </div>
                    <div class="card-actions">
                        <button class="delete-btn" onclick="confirmarEliminar('<%= m.getIdMaterial()%>', '<%= m.getNombre()%>')">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="no-data">
                <i class="fas fa-database"></i>
                <p>No hay materiales disponibles.</p>
            </div>
            <% }%>
        </div>
    </body>
</html>

<%!
    // Método para obtener el icono correspondiente a cada categoría
    private String getCategoryIcon(String categoryId) {
        switch (categoryId) {
            case "CAT001":
                return "fas fa-tools";          // Herramienta
            case "CAT002":
                return "fas fa-tshirt";         // Ropa
            case "CAT003":
                return "fas fa-utensils";       // Cocina
            case "CAT004":
                return "fas fa-laptop";         // Electrónica
            case "CAT005":
                return "fas fa-hard-hat";       // Construcción
            case "CAT006":
                return "fas fa-briefcase";      // Oficina
            default:
                return "fas fa-tag";                  // Por defecto
        }
    }

    // Método para obtener el color correspondiente a cada categoría
    private String getCategoryColor(String categoryId) {
        switch (categoryId) {
            case "CAT001":
                return "#3a86ff";          // Herramienta
            case "CAT002":
                return "#ff006e";         // Ropa
            case "CAT003":
                return "#fb5607";       // Cocina
            case "CAT004":
                return "#8338ec";         // Electrónica
            case "CAT005":
                return "#ffbe0b";       // Construcción
            case "CAT006":
                return "#06d6a0";      // Oficina
            default:
                return "#8d99ae";                  // Por defecto
        }
    }
%>
