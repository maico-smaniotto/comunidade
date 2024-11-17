package com.smaniotto.comunidade_api.repository;

import com.smaniotto.comunidade_api.model.Aviso;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface AvisoRepository extends JpaRepository<Aviso, Long> {

}
