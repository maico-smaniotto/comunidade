package com.smaniotto.comunidade_api.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

import com.google.cloud.Timestamp;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Aviso {
    @Id
    private String id;

    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(nullable = false, updatable = false)
    private Date cadastro = Timestamp.now().toDate();

    @Column(nullable = false)
    private Date validade;

    @Column(nullable = false, length = 50)
    private String titulo;

    @Column(nullable = false, length = 1024)
    private String descricao;

}
