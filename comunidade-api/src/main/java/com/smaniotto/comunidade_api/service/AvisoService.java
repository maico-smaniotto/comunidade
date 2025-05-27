package com.smaniotto.comunidade_api.service;

import com.smaniotto.comunidade_api.model.Aviso;
import com.smaniotto.comunidade_api.repository.AvisoRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutionException;

@Service
public class AvisoService {
    
    private AvisoRepository avisoRepository;

    public AvisoService(AvisoRepository avisoRepository) {
        this.avisoRepository = avisoRepository;
    }

    public List<Aviso> listar() throws ExecutionException, InterruptedException {
        return avisoRepository.listarNaoExpirados();
    }

    public Optional<Aviso> buscarPorId(String id) throws ExecutionException, InterruptedException {
        return avisoRepository.buscarPorId(id);
    }

    public Aviso salvar(Aviso aviso) {
        return avisoRepository.salvar(aviso);        
    }    

    public void excluir(String id) {
        avisoRepository.excluir(id);
    }
}
