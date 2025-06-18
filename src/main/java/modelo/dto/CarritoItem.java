package modelo.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class CarritoItem {
    private int idCarrito;
    private int idUsuario;
    private String idMaterial;
    private int cantidad;
    private BigDecimal precioUnitario;
    private LocalDateTime fechaAgregado;
    
    // Campos adicionales para mostrar información del material
    private String nombreMaterial;
    private String imagenMaterial;
    private String nombreCategoria;
    private BigDecimal subtotal;
    
    public CarritoItem() {
        this.fechaAgregado = LocalDateTime.now();
        this.cantidad = 1;
    }
    
    public CarritoItem(int idUsuario, String idMaterial, int cantidad, BigDecimal precioUnitario) {
        this.idUsuario = idUsuario;
        this.idMaterial = idMaterial;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.fechaAgregado = LocalDateTime.now();
    }
    
    // Getters y Setters
    public int getIdCarrito() {
        return idCarrito;
    }
    
    public void setIdCarrito(int idCarrito) {
        this.idCarrito = idCarrito;
    }
    
    public int getIdUsuario() {
        return idUsuario;
    }
    
    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }
    
    public String getIdMaterial() {
        return idMaterial;
    }
    
    public void setIdMaterial(String idMaterial) {
        this.idMaterial = idMaterial;
    }
    
    public int getCantidad() {
        return cantidad;
    }
    
    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }
    
    public BigDecimal getPrecioUnitario() {
        return precioUnitario;
    }
    
    public void setPrecioUnitario(BigDecimal precioUnitario) {
        this.precioUnitario = precioUnitario;
    }
    
    public LocalDateTime getFechaAgregado() {
        return fechaAgregado;
    }
    
    public void setFechaAgregado(LocalDateTime fechaAgregado) {
        this.fechaAgregado = fechaAgregado;
    }
    
    public String getNombreMaterial() {
        return nombreMaterial;
    }
    
    public void setNombreMaterial(String nombreMaterial) {
        this.nombreMaterial = nombreMaterial;
    }
    
    public String getImagenMaterial() {
        return imagenMaterial;
    }
    
    public void setImagenMaterial(String imagenMaterial) {
        this.imagenMaterial = imagenMaterial;
    }
    
    public String getNombreCategoria() {
        return nombreCategoria;
    }
    
    public void setNombreCategoria(String nombreCategoria) {
        this.nombreCategoria = nombreCategoria;
    }
    
    public BigDecimal getSubtotal() {
        if (precioUnitario != null && cantidad > 0) {
            return precioUnitario.multiply(BigDecimal.valueOf(cantidad));
        }
        return BigDecimal.ZERO;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
}
