package com.smaniotto.comunidade_api.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "avisos")
@Getter
@Setter
@NoArgsConstructor
public class Aviso {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, updatable = false)
    private LocalDateTime cadastro;

    @Column(nullable = false)
    private LocalDateTime validade;

    @Column(nullable = false, length = 50)
    private String titulo;

    @Column(nullable = false, length = 1024)
    private String descricao;

    public Aviso(LocalDateTime validade, String titulo, String descricao) {
        this.validade = validade;
        this.titulo = titulo;
        this.descricao = descricao;
        this.cadastro = LocalDateTime.now();
    }
}
