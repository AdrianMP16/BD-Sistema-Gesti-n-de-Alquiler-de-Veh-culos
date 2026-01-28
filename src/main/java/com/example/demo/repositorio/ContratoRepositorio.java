package com.example.demo.repositorio;

import com.example.demo.entidad.Contrato;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ContratoRepositorio extends JpaRepository<Contrato, Integer> {
    @Query(value = "SELECT * FROM VistaContratosActivos", nativeQuery = true)
    List<Object[]> contratosActivos();
}
