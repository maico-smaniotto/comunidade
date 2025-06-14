package com.smaniotto.comunidade_api.model;

import java.util.Date;

import com.google.firebase.database.annotations.NotNull;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Cotacao {

    @Id
    @NotNull
    private String id;

    @NotNull
    private Date data;

    @NotNull
    private String cooperativa;

    @NotNull
    private String produto;

    @NotNull
    private Double preco;

    @NotNull
    private Date atualizado;

}
