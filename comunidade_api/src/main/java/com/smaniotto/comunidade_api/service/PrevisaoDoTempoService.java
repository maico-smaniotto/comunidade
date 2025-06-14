package com.smaniotto.comunidade_api.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class PrevisaoDoTempoService {

    @Value("${weatherapi.key}")
    private String chaveApi;

    private final RestTemplate restTemplate = new RestTemplate();

    @Cacheable("previsaoDoTempo")
    public String buscarPrevisao() {        
        System.out.println("Buscando previsão da API externa");
        String url = String.format(
            "http://api.weatherapi.com/v1/forecast.json?key=%s&q=%s&days=%d&aqi=no&alerts=no",
            chaveApi, "Tucunduva", 3
        );
        return restTemplate.getForObject(url, String.class);
    }

}
