package com.example.demo.repositorio;

import com.example.demo.entidad.Cliente;
import com.example.demo.entidad.Vehiculo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ClienteRepositorio extends JpaRepository<Cliente, Long> {
}
