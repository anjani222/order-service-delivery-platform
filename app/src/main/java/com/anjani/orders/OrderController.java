package com.anjani.orders;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/orders")
public class OrderController {
    @GetMapping
    public List<Map<String, Object>> list() {
        return List.of(Map.of("id", "demo-1001", "item", "DevOps Handbook", "status", "READY"));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Map<String, Object> create(@RequestBody Map<String, Object> request) {
        return Map.of(
            "id", UUID.randomUUID().toString(),
            "item", request.getOrDefault("item", "unspecified"),
            "status", "CREATED",
            "createdAt", Instant.now().toString()
        );
    }
}
