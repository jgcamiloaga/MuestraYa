package modelo.dto;

import java.time.LocalDateTime;

public class Favorito {
    private int idFavorito;
    private int idUsuario;
    private String idMaterial;
    private LocalDateTime fechaAgregado;
    
    // Campos adicionales para mostrar información del material
    private String nombreMaterial;
    private String preciomaterial;
    private String imagenMaterial;
    private String nombreCategoria;
    
    public Favorito() {
        this.fechaAgregado = LocalDateTime.now();
    }
    
    public Favorito(int idUsuario, String idMaterial) {
        this.idUsuario = idUsuario;
        this.idMaterial = idMaterial;
        this.fechaAgregado = LocalDateTime.now();
    }
    
    // Getters y Setters
    public int getIdFavorito() {
        return idFavorito;
    }
    
    public void setIdFavorito(int idFavorito) {
        this.idFavorito = idFavorito;
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
    
    public String getPrecioMaterial() {
        return preciomaterial;
    }
    
    public void setPrecioMaterial(String preciomaterial) {
        this.preciomaterial = preciomaterial;
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
}
