package com.example.comunidadeapp.network

import android.os.Build
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object NetworkModule {
    // Detectar se está em um emulador e alterar a URL base
    private val BASE_URL = if (isEmulator()) {
        "http://10.0.2.2:8080/api/" // IP para o emulador se referir à máquina de desenvolvimento
    } else {
        "http://192.168.1.147:8080/api/" // IP para dispositivo físico ou outra máquina
    }

    val api: AvisoApi by lazy {
        Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(AvisoApi::class.java)
    }
    // Função para verificar se o dispositivo está em um emulador
    private fun isEmulator(): Boolean {
        return Build.FINGERPRINT.contains("generic") || Build.MODEL.contains("Emulator") || Build.MANUFACTURER.contains("Genymotion")
    }
}