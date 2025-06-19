package com.smaniotto.comunidade_api.config.firebase;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import jakarta.annotation.PostConstruct;

@Configuration
public class FirebaseConfig {

    private static final String LOCAL_PATH = "firebase-service-account.json";

    @PostConstruct
    public void init() throws IOException {
        try (InputStream credentialsStream = getFirebaseCredentialsStream()) {

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(credentialsStream))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                System.out.println("✅ Firebase inicializado com sucesso.");
            }

        } catch (Exception e) {
            throw new RuntimeException("❌ Erro ao inicializar Firebase: " + e.getMessage(), e);
        }
    }

    private InputStream getFirebaseCredentialsStream() throws IOException {
        String json = System.getenv("FIREBASE_CONFIG");

        if (json != null && !json.isBlank()) {
            System.out.println("🔐 Firebase config carregado da variável de ambiente");
            return new ByteArrayInputStream(json.getBytes(StandardCharsets.UTF_8));
        }

        System.out.println("📂 Firebase config carregado de arquivo local");
        return new ClassPathResource(LOCAL_PATH).getInputStream();
    }
}
