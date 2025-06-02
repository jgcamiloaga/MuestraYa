package modelo.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Material {
    private String idMaterial;
    private String nombre;
    private BigDecimal precio;
    private String idCategoria;
    private String nombreCategoria;
    private String imagen;
    private String descripcion;
    private int stock;
    private boolean destacado;
    private String especificaciones;
    private LocalDateTime fechaCreacion;
    private String unidadMedida;
    private BigDecimal peso;
    private String dimension;
    private String color;    public Material(String idMaterial, String nombre, BigDecimal precio) {
        this.idMaterial = idMaterial;
        this.nombre = nombre;
        this.precio = precio;
        this.imagen = "default.jpg";
        this.stock = 0;
        this.destacado = false;
        this.fechaCreacion = LocalDateTime.now();
    }

    // Getters y setters existentes
    public String getIdMaterial() {
        return idMaterial;
    }

    public void setIdMaterial(String idMaterial) {
        this.idMaterial = idMaterial;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public String getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(String idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNombreCategoria() {
        return nombreCategoria;
    }

    public void setNombreCategoria(String nombreCategoria) {
        this.nombreCategoria = nombreCategoria;
    }

    // Nuevo getter y setter para imagen
    public String getImagen() {
        return imagen;
    }    public void setImagen(String imagen) {
        this.imagen = imagen;
    }
    
    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public boolean isDestacado() {
        return destacado;
    }

    public void setDestacado(boolean destacado) {
        this.destacado = destacado;
    }

    public String getEspecificaciones() {
        return especificaciones;
    }

    public void setEspecificaciones(String especificaciones) {
        this.especificaciones = especificaciones;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public String getUnidadMedida() {
        return unidadMedida;
    }

    public void setUnidadMedida(String unidadMedida) {
        this.unidadMedida = unidadMedida;
    }

    public BigDecimal getPeso() {
        return peso;
    }

    public void setPeso(BigDecimal peso) {
        this.peso = peso;
    }

    public String getDimension() {
        return dimension;
    }

    public void setDimension(String dimension) {
        this.dimension = dimension;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
}    