package com.smaniotto.comunidade_api.service;

import java.util.Date;
import java.time.LocalTime;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.stereotype.Service;

import com.smaniotto.comunidade_api.model.Cotacao;
import com.smaniotto.comunidade_api.service.scraper.CotacoesCoopermilScraper;
import com.smaniotto.comunidade_api.service.scraper.CotacoesCotrirosaScraper;

@Service
public class CotacaoService {
    
    private static CopyOnWriteArrayList<Cotacao> cacheList = new CopyOnWriteArrayList<>();

    public List<Cotacao> buscarUltimasCotacoes() {
        atualizarCotacoes();
        return cacheList;
    }

    public void atualizarCotacoes() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 13);
        cal.set(Calendar.MINUTE, 30);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date hoje1330 = cal.getTime();

        if (cacheList.isEmpty()
            || cacheList.get(0).getData().before(new Date())
            || (LocalTime.now().isAfter(LocalTime.of(13, 30)) 
                && cacheList.get(0).getAtualizado().before(hoje1330))) {
            cacheList.clear();            
            CotacoesCotrirosaScraper.carregarCotacoes(cacheList);
            CotacoesCoopermilScraper.carregarCotacoes(cacheList);            
        }
    }    

}
