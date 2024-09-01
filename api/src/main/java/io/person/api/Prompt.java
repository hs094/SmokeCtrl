package io.person.api;

import java.util.List;
import java.util.Map;

public class Prompt {

    private PromptDetails prompt;
    private double temperature;
    private int candidateCount;
    private int topP;
    private int topK;

    // Getters and Setters
    public PromptDetails getPrompt() {
        return prompt;
    }

    public void setPrompt(PromptDetails prompt) {
        this.prompt = prompt;
    }

    public double getTemperature() {
        return temperature;
    }

    public void setTemperature(double temperature) {
        this.temperature = temperature;
    }

    public int getCandidateCount() {
        return candidateCount;
    }

    public void setCandidateCount(int candidateCount) {
        this.candidateCount = candidateCount;
    }

    public int getTopP() {
        return topP;
    }

    public void setTopP(int topP) {
        this.topP = topP;
    }

    public int getTopK() {
        return topK;
    }

    public void setTopK(int topK) {
        this.topK = topK;
    }

    // Nested class for messages
    public static class PromptDetails {
        private List<Map<String, String>> messages;

        public List<Map<String, String>> getMessages() {
            return messages;
        }

        public void setMessages(List<Map<String, String>> messages) {
            this.messages = messages;
        }
    }

    // Convenience method to create the request
    public Map<String, Object> toRequestMap() {
        return Map.of(
            "prompt", Map.of("messages", this.prompt.getMessages()),
            "temperature", this.temperature,
            "candidateCount", this.candidateCount,
            "topP", this.topP,
            "topK", this.topK
        );
    }
}
