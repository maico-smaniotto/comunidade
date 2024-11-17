package com.smaniotto.comunidade_api.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
public class AvisoDTO {

    private LocalDateTime validade;
    private String titulo;
    private String descricao;

}
