package com.smaniotto.comunidade_api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class ComunidadeApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(ComunidadeApiApplication.class, args);
	}

}
