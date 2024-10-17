package com.telmed.api.service;


//import com.telmed.api.service.llama4j.Llama;
//import com.telmed.api.service.llama4j.ModelLoader;
import com.telmed.api.service.llama4j.Llama;
import com.telmed.api.service.llama4j.ModelLoader;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;

@RestController
@RequestMapping("/chat")
public class Inference {
    @PostMapping("/v1/completions/")
    public ResponseEntity<?> loginUser(@RequestBody PromptComponent user) throws IOException {
        Llama model = ModelLoader.loadModel(Path.of("/Users/hardiksoni/Dev.hs/iMediXcare/api/src/main/java/com/telmed/api/service/llama4j/Llama-3.2-1B-Instruct-Q4_0.gguf"),
                                                        2048, true);
        return ResponseEntity.ok("Model Loaded");
    }
}
