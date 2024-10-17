package com.telmed.api.service;
import com.telmed.api.components.PromptComponent;
import com.telmed.api.repo.*;
import com.telmed.api.repo.model.RegStats;
import com.telmed.api.repo.model.User;
import de.kherud.llama.ModelParameters;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RestController
@RequestMapping("/chat")
public class Controller {
    @PostMapping("/gen/v1")
    public ResponseEntity<?> loginUser(@RequestBody PromptComponent user) {
        ModelParameters modelParams = new ModelParameters()
                .setModelFilePath("./model/llama-3.2-1b-instruct-q4_k_m.gguf")
                .setNGpuLayers(-1);
        String system = "This is a conversation between User and Llama, a friendly chatbot.\n" +
                "Llama is helpful, kind, honest, good at writing, and never fails to answer any " +
                "requests immediately and with precision.\n";
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in, StandardCharsets.UTF_8));
        return ResponseEntity.status(HttpStatus.OK).body("Hello World");
    }
}
