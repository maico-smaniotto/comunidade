package com.example.comunidadeapp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.comunidadeapp.model.Aviso
import com.example.comunidadeapp.viewmodel.AvisoViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                AvisosScreen()
            }
        }
    }
}

@Composable
fun AvisosScreen(viewModel: AvisoViewModel = viewModel()) {
    val avisos by viewModel.avisos.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Avisos") })
        }
    ) { padding ->
        LazyColumn(contentPadding = padding) {
            items(avisos) { aviso ->
                AvisoItem(aviso)
            }
        }
    }
}

@Composable
fun AvisoItem(aviso: Aviso) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp),
        elevation = 4.dp
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(text = aviso.titulo, style = MaterialTheme.typography.h6)
            Text(text = aviso.descricao, style = MaterialTheme.typography.body2)
            Text(text = "Validade: ${aviso.validade}", style = MaterialTheme.typography.caption)
        }
    }
}