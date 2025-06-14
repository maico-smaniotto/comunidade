package com.smaniotto.comunidade_api.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.auth.FirebaseToken;

import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/api/auth")
public class UsuarioAuthenticationController {

    @GetMapping("/test-auth")
    public ResponseEntity<String> testAuth(HttpServletRequest request) {

        FirebaseToken firebaseUser = (FirebaseToken) request.getAttribute("firebaseUser");        
        if (firebaseUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Usuário não autenticado.");
        }        
        return ResponseEntity.ok("Usuário autenticado: " + firebaseUser.getEmail());

    }

}
