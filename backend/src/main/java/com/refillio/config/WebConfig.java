package com.refillio.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Arrays;

@Configuration
public class WebConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                String allowedOrigins = System.getenv("CORS_ORIGINS");
                if (allowedOrigins == null || allowedOrigins.isBlank()) {
                    allowedOrigins = "http://localhost:3000,http://localhost,https://refillio.josemendoza.dev";
                }
                registry.addMapping("/api/**")
                        .allowedOrigins(Arrays.stream(allowedOrigins.split(","))
                                .map(String::trim)
                                .toArray(String[]::new))
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                        .allowedHeaders("*")
                        .allowCredentials(true);
            }
        };
    }
}
