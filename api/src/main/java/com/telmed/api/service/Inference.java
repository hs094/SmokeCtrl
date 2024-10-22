package com.telmed.api.service;

import com.telmed.api.service.model.PromptComponent;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import static com.telmed.api.service.model.CondaEnvRunner.runPythonScript;

@RestController
@RequestMapping("/chat")
public class Inference {
    @PostMapping("/v1/completions/")
    public ResponseEntity<?> loginUser(@RequestBody PromptComponent pr) {
        List<String> response = new ArrayList<>();
        try {
            String output = runPythonScript(pr.getPrompt());
            response.add(output);
        } catch (IOException | InterruptedException e) {
            return ResponseEntity.status(500).body(MessageFormat.format("Error while running script: {0}", e.getMessage()));
        }
        return ResponseEntity.ok(response);
    }
}
