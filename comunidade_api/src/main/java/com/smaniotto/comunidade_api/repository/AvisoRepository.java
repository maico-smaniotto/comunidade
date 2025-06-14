package com.smaniotto.comunidade_api.repository;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.cloud.FirestoreClient;
import com.smaniotto.comunidade_api.model.Aviso;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

@Repository
public class AvisoRepository {
    
    private static final String COLLECTION_NAME = "avisos";

    public List<Aviso> listarNaoExpirados() throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = db.collection(COLLECTION_NAME).get();
        return future.get().getDocuments().stream()
                .filter(doc -> doc.getDate("validade") == null || doc.getDate("validade").after(new java.util.Date()))
                .map(doc -> doc.toObject(Aviso.class))
                .toList();
    }

    public Aviso salvar(Aviso aviso) {
        Firestore db = FirestoreClient.getFirestore();

        String id = aviso.getId();
        if (id == null) {
            id = UUID.randomUUID().toString();
            aviso.setId(id);
        }
        //firestore.collection("avisos").document(id).set(aviso);        
        //db.collection(COLLECTION_NAME).add(aviso);
        db.collection(COLLECTION_NAME).document(id).set(aviso);
        return aviso;
    }

    public void excluir(String id) {
        Firestore db = FirestoreClient.getFirestore();
        db.collection(COLLECTION_NAME).document(String.valueOf(id)).delete();
    }

    public Optional<Aviso> buscarPorId(String id) throws ExecutionException, InterruptedException {

        Firestore db = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = db.collection(COLLECTION_NAME).whereEqualTo("id", id).get();
        return future.get().getDocuments().stream()
            .findFirst()
            .map(doc -> Optional.of(doc.toObject(Aviso.class))).orElse(Optional.empty());

    }

}
