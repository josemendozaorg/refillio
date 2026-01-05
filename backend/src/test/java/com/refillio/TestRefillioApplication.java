package com.refillio;

import org.springframework.boot.SpringApplication;

public class TestRefillioApplication {

	public static void main(String[] args) {
		SpringApplication.from(RefillioApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
