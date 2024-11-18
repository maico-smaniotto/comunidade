package com.smaniotto.comunidade_api.repository;

import com.smaniotto.comunidade_api.model.Aviso;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AvisoRepository extends JpaRepository<Aviso, Long> {
    @Query("SELECT a FROM Aviso a WHERE a.validade >= CURRENT_TIMESTAMP")
    List<Aviso> findAllNonExpired();
}
