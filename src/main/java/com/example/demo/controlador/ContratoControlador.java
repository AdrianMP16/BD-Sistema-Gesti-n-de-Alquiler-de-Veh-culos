package com.example.demo.controlador;

import com.example.demo.repositorio.ContratoRepositorio;
import com.example.demo.repositorio.ContratoSPRepository;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/contratos")
@CrossOrigin
public class ContratoControlador {

    private final ContratoSPRepository spRepo;
    private final ContratoRepositorio contratoRepo;

    public ContratoControlador(ContratoSPRepository spRepo, ContratoRepositorio contratoRepo) {
        this.spRepo = spRepo;
        this.contratoRepo = contratoRepo;
    }

    @PostMapping
    public String crearContrato(@RequestParam Integer clienteId,
                                @RequestParam Integer vehiculoId,
                                @RequestParam Integer empleadoId,
                                @RequestParam LocalDate fechaFin,
                                @RequestParam Double monto) {

        spRepo.registrarContrato(clienteId, vehiculoId, empleadoId, fechaFin, monto);
        return "Contrato registrado correctamente";
    }

    @GetMapping("/activos")
    public List<Object[]> contratosActivos() {
        return contratoRepo.contratosActivos();
    }
}

