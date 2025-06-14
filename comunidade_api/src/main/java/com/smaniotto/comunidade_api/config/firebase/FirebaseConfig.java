package com.smaniotto.comunidade_api.config.firebase;

import java.io.IOException;
import java.io.InputStream;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import jakarta.annotation.PostConstruct;

@Configuration
public class FirebaseConfig {

    @Value("${firebase.config.path}")
    private String resource;

    @PostConstruct
    public void init() throws IOException {
        
        try (InputStream serviceAccount = new ClassPathResource(resource).getInputStream()) {
            FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                System.out.println("✅ Firebase inicializado com sucesso.");
            }
        } catch (Exception e) {
            throw new RuntimeException("❌ Erro ao inicializar Firebase: " + e.getMessage(), e);
        }

    }

}
