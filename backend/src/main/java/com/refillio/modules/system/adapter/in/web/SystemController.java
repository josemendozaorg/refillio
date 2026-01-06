package com.refillio.modules.system.adapter.in.web;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/system")
public class SystemController {

    @GetMapping("/hello")
    public Map<String, Object> hello() {
        return Map.of(
            "message", "Hello from Refillio Backend!",
            "status", "UP",
            "timestamp", LocalDateTime.now().toString()
        );
    }
}
