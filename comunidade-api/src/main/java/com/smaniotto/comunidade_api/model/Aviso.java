package com.smaniotto.comunidade_api.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "avisos")
@Getter
@Setter
public class Aviso {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private LocalDateTime cadastro;

    @Column(nullable = false)
    private LocalDateTime validade;

    @Column(nullable = false, length = 20)
    private String titulo;

    @Column(nullable = false, length = 1024)
    private String descricao;
}
