package com.example.demo.entidad;
import jakarta.persistence.*;
@Entity
@Table(name = "Vehiculos")
public class Vehiculo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer vehiculoID;

    private String placa;
    private String marca;
    private String modelo;
    private Integer año;
    private Double precioDia;
    private Boolean disponible;


    public Integer getVehiculoID() {
        return vehiculoID;
    }

    public void setVehiculoID(Integer vehiculoID) {
        this.vehiculoID = vehiculoID;
    }

    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public Integer getAño() {
        return año;
    }

    public void setAño(Integer año) {
        this.año = año;
    }

    public Double getPrecioDia() {
        return precioDia;
    }

    public void setPrecioDia(Double precioDia) {
        this.precioDia = precioDia;
    }

    public Boolean getDisponible() {
        return disponible;
    }

    public void setDisponible(Boolean disponible) {
        this.disponible = disponible;
    }
}

