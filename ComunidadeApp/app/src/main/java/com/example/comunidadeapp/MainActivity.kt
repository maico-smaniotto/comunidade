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
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        android.util.Log.d("NetworkDebug", "Debugging Network...")
        setContent {
            MaterialTheme {
                AvisosScreen(
                    AvisoViewModel().avisos.collectAsState().value

//                    avisos = listOf(
//                        Aviso(id = 1, cadastro = "20/11/2024", validade = "20/11/2024", titulo = "Aviso 1", descricao = "Descrição do aviso 1"),
//                        Aviso(id = 1, cadastro = "20/11/2024", validade = "20/11/2024", titulo = "Aviso 2", descricao = "Descrição do aviso 2"),
//                        Aviso(id = 1, cadastro = "20/11/2024", validade = "20/11/2024", titulo = "Aviso 3", descricao = "Descrição do aviso 3")
//                    )
                )
            }
        }
    }
}

@Composable
fun AvisosScreen(avisos: List<Aviso>) {
    Column {
        Text(
            text = "Avisos",
            style = MaterialTheme.typography.h4,
            modifier = Modifier.padding(16.dp)
        )
        LazyColumn {
            items(avisos.size) { index ->
                AvisoItem(aviso = avisos[index])
            }
        }
    }
}

//@Composable
//fun AvisosScreen(viewModel: AvisoViewModel = viewModel()) {
//    val avisos by viewModel.avisos.collectAsState()
//
//    Scaffold(
//        topBar = {
//            TopAppBar(title = { Text("Avisos") })
//        }
//    ) { padding ->
//        LazyColumn(contentPadding = padding) {
//            items(avisos) { aviso ->
//                AvisoItem(aviso)
//            }
//        }
//    }
//}

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