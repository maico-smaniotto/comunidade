package com.smaniotto.comunidade_api.controller;

import com.smaniotto.comunidade_api.model.Aviso;
import com.smaniotto.comunidade_api.service.AvisoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/api/avisos")
public class AvisoController {
    
    private AvisoService avisoService;

    public AvisoController(AvisoService avisoService) {
        this.avisoService = avisoService;
    }

    @GetMapping
    public List<Aviso> listar() throws ExecutionException, InterruptedException {
        return avisoService.listar();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Aviso> buscarPorId(@PathVariable String id) throws ExecutionException, InterruptedException {
        return avisoService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Aviso> criar(@RequestBody Aviso aviso)  {
        return ResponseEntity.ok(avisoService.salvar(aviso));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Aviso> atualizar(@PathVariable String id, @RequestBody Aviso aviso) throws ExecutionException, InterruptedException {
       
        return avisoService.buscarPorId(id)
                .map(avisoEncontrado -> {
                    avisoEncontrado.setValidade(aviso.getValidade());
                    avisoEncontrado.setTitulo(aviso.getTitulo());
                    avisoEncontrado.setDescricao(aviso.getDescricao());
                    return ResponseEntity.ok(avisoService.salvar(avisoEncontrado));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable String id) throws ExecutionException, InterruptedException {
        if (avisoService.buscarPorId(id).isPresent()) {
            avisoService.excluir(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
