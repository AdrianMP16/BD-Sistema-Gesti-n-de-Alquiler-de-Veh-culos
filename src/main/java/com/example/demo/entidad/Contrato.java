package com.example.demo.entidad;
import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "Contratos")
public class Contrato {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer contratoID;

    @ManyToOne
    @JoinColumn(name = "ClienteID")
    private Cliente cliente;

    @ManyToOne
    @JoinColumn(name = "VehiculoID")
    private Vehiculo vehiculo;

    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private Double montoTotal;

    // getters y setters
}

