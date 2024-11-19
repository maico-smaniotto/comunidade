package com.example.comunidadeapp.model

data class Aviso(
    val id: Long,
    val cadastro: String,  // String para datas (ISO-8601)
    val validade: String,
    val titulo: String,
    val descricao: String
)