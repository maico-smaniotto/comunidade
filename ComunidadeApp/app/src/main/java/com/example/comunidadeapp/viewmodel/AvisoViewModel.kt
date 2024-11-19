package com.example.comunidadeapp.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.comunidadeapp.model.Aviso
import com.example.comunidadeapp.network.NetworkModule
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class AvisoViewModel : ViewModel() {
    private val _avisos = MutableStateFlow<List<Aviso>>(emptyList())
    val avisos: StateFlow<List<Aviso>> get() = _avisos

    init {
        fetchAvisos()
    }

    private fun fetchAvisos() {
        viewModelScope.launch {
            try {
                _avisos.value = NetworkModule.api.getAvisos()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}