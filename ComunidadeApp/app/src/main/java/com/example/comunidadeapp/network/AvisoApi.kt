package com.example.comunidadeapp.network

import com.example.comunidadeapp.model.Aviso

import retrofit2.http.GET

interface AvisoApi {
    @GET("/avisos")
    suspend fun getAvisos(): List<Aviso>
}