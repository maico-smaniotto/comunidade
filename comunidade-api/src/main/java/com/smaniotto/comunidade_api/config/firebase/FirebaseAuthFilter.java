package com.smaniotto.comunidade_api.config.firebase;

import java.io.IOException;

import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.google.firebase.auth.FirebaseToken;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class FirebaseAuthFilter extends OncePerRequestFilter {

    private FirebaseTokenVerifier firebaseTokenVerifier;

    FirebaseAuthFilter(FirebaseTokenVerifier firebaseTokenVerifier) {
        this.firebaseTokenVerifier = firebaseTokenVerifier;
    }

    @Override
    protected void doFilterInternal (
        HttpServletRequest request,
        HttpServletResponse response,
        FilterChain filterChain
    ) throws IOException, ServletException {

        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7);
            try {
                FirebaseToken decodedToken = firebaseTokenVerifier.verifyToken(token);
                
                request.setAttribute("firebaseUser", decodedToken);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
        }
        filterChain.doFilter(request, response);

    }

}

