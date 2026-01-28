package com.example.demo.controlador;

import com.example.demo.entidad.Vehiculo;
import com.example.demo.repositorio.VehiculoRepositorio;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/vehiculos")
@CrossOrigin
public class VehiculoControlador {

    private final VehiculoRepositorio repo;

    public VehiculoControlador(VehiculoRepositorio repo) {
        this.repo = repo;
    }

    @GetMapping("/disponibles")
    public List<Vehiculo> disponibles() {
        return repo.findByDisponibleTrue();
    }
}

