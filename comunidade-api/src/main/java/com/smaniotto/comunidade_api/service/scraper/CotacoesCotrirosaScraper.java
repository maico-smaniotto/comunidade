package com.smaniotto.comunidade_api.service.scraper;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

import com.smaniotto.comunidade_api.model.Cotacao;

public class CotacoesCotrirosaScraper {

    private CotacoesCotrirosaScraper() { }

    public static void carregarCotacoes(List<Cotacao> lista) {

        final String url = "https://cotrirosa.com";
        try {
            Document document = Jsoup.connect(url).get();

            Elements elementos = document.select(".menu-item-4319");

            if (elementos.first() == null) {
                System.out.println("Elemento não encontrado na página.");
                return;
            }            
            String texto = elementos.first().text();

            extrairCotacoes(texto, lista);

        } catch (Exception e) {
            System.out.println("Erro ao acessar a URL: " + e.getMessage());
        }

    }

    private static void extrairCotacoes(String texto, List<Cotacao> lista) throws ParseException {

        Pattern patternData = Pattern.compile("(\\d{2}/\\d{2}/\\d{4})");
        Matcher matcherData = patternData.matcher(texto);

        Date data = null;
        if (matcherData.find()) {
            String dataStr = matcherData.group(1);
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            data = sdf.parse(dataStr);
        }

        // Extrair produtos e valores
        Pattern patternProduto = Pattern.compile("([\\p{L}0-9 ]+): R\\$ ([\\d,.]+)");
        Matcher matcherProduto = patternProduto.matcher(texto);

        Map<String, Double> produtos = new LinkedHashMap<>();

        while (matcherProduto.find()) {
            String nome = matcherProduto.group(1).trim();
            String valorStr = matcherProduto.group(2).replace(".", "").replace(",", ".");
            Double valor = Double.parseDouble(valorStr);
            produtos.put(nome, valor);
        }

        for (Map.Entry<String, Double> entry : produtos.entrySet()) {
            Cotacao cotacao = new Cotacao();
            cotacao.setId("1");
            cotacao.setData(data);
            cotacao.setCooperativa("Cotrirosa");
            cotacao.setProduto(entry.getKey());
            cotacao.setPreco(entry.getValue());
            cotacao.setAtualizado(new Date());
            
            lista.add(cotacao);
        }
    }

}
