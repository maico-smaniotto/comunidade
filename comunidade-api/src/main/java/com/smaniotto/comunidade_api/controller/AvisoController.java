package com.smaniotto.comunidade_api.controller;

import com.smaniotto.comunidade_api.model.Aviso;
import com.smaniotto.comunidade_api.service.AvisoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/avisos")
public class AvisoController {
    @Autowired
    private AvisoService avisoService;

    @GetMapping
    public List<Aviso> getAllAvisos() {
        return avisoService.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Aviso> getAvisoById(@PathVariable Long id) {
        return avisoService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Aviso createAviso(@RequestBody Aviso aviso) {
        return avisoService.save(aviso);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Aviso> updateAviso(@PathVariable Long id, @RequestBody Aviso aviso) {
        return avisoService.findById(id)
                .map(existingAviso -> {
                    aviso.setId(existingAviso.getId());
                    return ResponseEntity.ok(avisoService.save(aviso));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAviso(@PathVariable Long id) {
        if (avisoService.findById(id).isPresent()) {
            avisoService.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
