package com.smaniotto.comunidade_api.controller;

import org.springframework.web.bind.annotation.RestController;

import com.smaniotto.comunidade_api.service.PrevisaoDoTempoService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
@RequestMapping("/api/tempo")
public class PrevisaoDoTempoController {

    private final PrevisaoDoTempoService previsaoDoTempoService;

    public PrevisaoDoTempoController(PrevisaoDoTempoService previsaoDoTempoService) {
        this.previsaoDoTempoService = previsaoDoTempoService;
    }

    @GetMapping
    public ResponseEntity<String> getPrevisao() {
        try {
            String previsao = previsaoDoTempoService.buscarPrevisao();
            return ResponseEntity.ok(previsao);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Erro ao buscar previsão do tempo: " + e.getMessage());
        }
    }
    
}
