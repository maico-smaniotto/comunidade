package com.smaniotto.comunidade_api.service.scraper;

import java.util.Date;
import java.util.List;

import com.smaniotto.comunidade_api.model.Cotacao;

public class CotacoesCoopermilScraper {
    
    private CotacoesCoopermilScraper() { }

    public static void carregarCotacoes(List<Cotacao> lista) {
        lista.add(new Cotacao("2", new Date(), "Coopermil", "Produto Z", 15.0, new Date()));
    }

}
