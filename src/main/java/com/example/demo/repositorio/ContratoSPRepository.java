package com.example.demo.repositorio;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

@Repository
public class ContratoSPRepository {

    @PersistenceContext
    private EntityManager entityManager;

    public void registrarContrato(
            int clienteId,
            int vehiculoId,
            int empleadoId,
            LocalDate fechaFin,
            Double monto
    ) {
        entityManager
                .createStoredProcedureQuery("registrar_contrato")
                .registerStoredProcedureParameter("p_cliente_id", Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter("p_vehiculo_id", Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter("p_empleado_id", Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter("p_fecha_fin", LocalDate.class, ParameterMode.IN)
                .registerStoredProcedureParameter("p_monto", Double.class, ParameterMode.IN)
                .setParameter("p_cliente_id", clienteId)
                .setParameter("p_vehiculo_id", vehiculoId)
                .setParameter("p_empleado_id", empleadoId)
                .setParameter("p_fecha_fin", fechaFin)
                .setParameter("p_monto", monto)
                .execute();
    }
}
