package com.example.demo.controlador;

import com.example.demo.entidad.Cliente;
import com.example.demo.repositorio.ClienteRepositorio;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/clientes")
@CrossOrigin
public class ClienteControlador {

    private final ClienteRepositorio repo;

    public ClienteControlador(ClienteRepositorio repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Cliente> listar() {
        return repo.findAll();
    }

    @PostMapping
    public Cliente guardar(@RequestBody Cliente cliente) {
        return repo.save(cliente);
    }
}
