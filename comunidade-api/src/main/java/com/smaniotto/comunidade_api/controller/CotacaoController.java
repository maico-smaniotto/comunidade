package com.smaniotto.comunidade_api.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.smaniotto.comunidade_api.model.Cotacao;
import com.smaniotto.comunidade_api.service.CotacaoService;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping("/api/cotacoes")
public class CotacaoController {

    private final CotacaoService cotacaoService;
    
    public CotacaoController(CotacaoService cotacaoService) {
        this.cotacaoService = cotacaoService;
    }

    @GetMapping
    public List<Cotacao> buscarUltimasCotacoes() {
        return cotacaoService.buscarUltimasCotacoes();
    }
    
}
