package com.smaniotto.comunidade_api.service;

import com.smaniotto.comunidade_api.model.Aviso;
import com.smaniotto.comunidade_api.repository.AvisoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
@Service
public class AvisoService {
    @Autowired
    private AvisoRepository avisoRepository;

    public List<Aviso> findAll() {
        return avisoRepository.findAll();
    }

    public Optional<Aviso> findById(Long id) {
        return avisoRepository.findById(id);
    }

    public Aviso save(Aviso aviso) {
        return avisoRepository.save(aviso);
    }

    public void deleteById(Long id) {
        avisoRepository.deleteById(id);
    }
}
