package com.smaniotto.comunidade_api.controller;

import com.smaniotto.comunidade_api.dto.AvisoDTO;
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
    public Aviso createAviso(@RequestBody AvisoDTO avisoDTO) {
        // Map the DTO to the entity
        Aviso aviso = new Aviso(
                avisoDTO.getValidade(),
                avisoDTO.getTitulo(),
                avisoDTO.getDescricao()
        );

        Aviso savedAviso = avisoService.save(aviso);

//        return ResponseEntity.ok(savedAviso);

        return avisoService.save(savedAviso);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Aviso> updateAviso(@PathVariable Long id, @RequestBody AvisoDTO avisoDTO) {
        return avisoService.findById(id)
                .map(aviso -> {
                    aviso.setValidade(avisoDTO.getValidade());
                    aviso.setTitulo(avisoDTO.getTitulo());
                    aviso.setDescricao(avisoDTO.getDescricao());
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
