package com.smaniotto.comunidade_api.service.scraper;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.smaniotto.comunidade_api.model.Cotacao;

public class CotacoesCoopermilScraper {
    
    private CotacoesCoopermilScraper() { }

    public static void carregarCotacoes(List<Cotacao> lista) {

        final String url = "https://www.coopermil.com";
        try {
            Document document = Jsoup.connect(url).get();
            Element elemento = document.getElementById("_content_ucCotacao_pnlCommodities1");
            if (elemento == null) {
                System.out.println("Elemento de cotações não encontrado.");
                return;
            }
            extrairCotacoes(elemento, lista);
        } catch (Exception e) {
            System.out.println("Erro ao extrair informações da página: " + e.getMessage());
        }

    }

    private static void extrairCotacoes(Element elemento, List<Cotacao> lista) throws ParseException {

        Element spanGrupoData = elemento.getElementsByTag("span").first();
        if (spanGrupoData == null) {
            System.out.println("Elemento de data não encontrado.");
            return;
        }
        Element dataTexto = spanGrupoData.getElementById("_content_ucCotacao_labDataCotacaoCommodities1");
        if (dataTexto == null) {
            System.out.println("Elemento de data não encontrado.");
            return;
        }
        String dataCotacao = dataTexto.text();

        Element listaProd = elemento.getElementsByTag("ul").first();
        if (listaProd == null) {
            System.out.println("Lista de produtos não encontrada.");
            return;
        }
        Elements produtos = listaProd.getElementsByTag("li");
        if (produtos.isEmpty()) {
            System.out.println("Nenhum produto encontrado.");
            return;
        }
        produtos.stream()
            .forEach(produto -> {
                String nomeProduto = produto.child(0).text().trim();
                String valorProduto = produto.child(1).text().trim().replace("R$ ", "").replace(".", "").replace(",", ".");
                Double valor = Double.parseDouble(valorProduto);
                Cotacao cotacao = new Cotacao();
                cotacao.setId("1");
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    Date data = sdf.parse(dataCotacao);
                    cotacao.setData(data);
                } catch (ParseException e) {
                    System.out.println("Erro ler data: " + e.getMessage());
                }
                cotacao.setCooperativa("Coopermil");
                cotacao.setProduto(nomeProduto);
                cotacao.setPreco(valor);
                cotacao.setAtualizado(new Date());
                lista.add(cotacao);
            });
    }

}
