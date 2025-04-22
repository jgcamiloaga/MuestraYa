// Modelo/Material.java
package Modelo;

import java.math.BigDecimal;

public class Material {
    private String idMaterial;
    private String nombre;
    private BigDecimal precio;
    private String idCategoria;
    private String nombreCategoria;
    private String imagen;

    public Material(String idMaterial, String nombre, BigDecimal precio) {
        this.idMaterial = idMaterial;
        this.nombre = nombre;
        this.precio = precio;
        this.imagen = "default.jpg";
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
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }
}