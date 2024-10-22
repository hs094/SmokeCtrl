package com.telmed.api.service.model;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class CondaEnvRunner {
    private static final String CONDA_ENV_NAME = "bot"; // Replace with your environment name
    private static final String ROOT_DIR = "./src/main/java/com/telmed/api/service/chat/";
    private static final String ENVIRONMENT_YML = ROOT_DIR + "environment.yml"; // Path to your environment.yml
    private static final String PYTHON_SCRIPT = ROOT_DIR + "main.py"; // Path to your Python script
    private static final String LLAMA_MODEL = ROOT_DIR + "model/llama-3.2/llama-3.2-1b-instruct-q4_k_m.gguf";
    private static final String SENT_TRANS_MODEL = ROOT_DIR + "model/all-mpnet-base-v2/";

    private static boolean doesCondaEnvironmentExist() throws IOException, InterruptedException {
        // Command to list conda environments
        String[] command = {"conda", "env", "list"};

        Process process = new ProcessBuilder(command).start();
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

        String line;
        while ((line = reader.readLine()) != null) {
            if (line.contains(CondaEnvRunner.CONDA_ENV_NAME)) {
                return true; // Environment exists
            }
        }

        int exitCode = process.waitFor();
        return (exitCode == 0); // Return true if the command was successful
    }

    private static void createCondaEnvironment() throws IOException, InterruptedException {
        String[] command = {
            "conda", "env", "create", "-f", ENVIRONMENT_YML
        };

        System.out.println("Creating Conda environment...");
        Process process = new ProcessBuilder(command).inheritIO().start();
        int exitCode = process.waitFor();

        if (exitCode == 0) {
            System.out.println("Conda environment created successfully.");
        } else {
            System.err.println("Failed to create Conda environment.");
        }
    }

    public static String runPythonScript(String prompt) throws IOException, InterruptedException {
        long startTime = System.currentTimeMillis(); // Start time
        StringBuilder outputBuilder = null;
        try {
            // Step 1: Check if the Conda environment exists
            if (!doesCondaEnvironmentExist()) {
                // If it does not exist, create it
                createCondaEnvironment();
            } else {
                System.out.println("Conda environment already exists. Skipping creation.");
            }
            // Command to run the Python script in the created Conda environment
            String[] command = {
                    "conda", "run", "-n", CONDA_ENV_NAME, "python", PYTHON_SCRIPT,
                    "--prompt", prompt,
                    "--model", LLAMA_MODEL,
                    "--embed", SENT_TRANS_MODEL,
            };

            System.out.println("Running Python script...");
            Process process = new ProcessBuilder(command).start();

            outputBuilder = new StringBuilder();

//             // Create a separate thread for reading the error stream
//             Thread errorThread = new Thread(() -> {
//                 try (BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()))) {
//                     String errorLine;
//                     while ((errorLine = errorReader.readLine()) != null) {
//                         System.err.println(errorLine); // Print error messages to standard error
//                     }
//                 } catch (IOException e) {
//                     System.err.println("Error reading from error stream: " + e.getMessage());
//                 }
//             });
//
//             // Start the error thread
//             errorThread.start();

            // Read from the standard output stream and build the output string
            try (BufferedReader outputReader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = outputReader.readLine()) != null) {
                    outputBuilder.append(line).append("\n"); // Append to the output builder
                }
            }

            // Wait for the process to finish and join the error thread
            int exitCode = process.waitFor();
//            errorThread.join(); // Ensure the error thread finishes before proceeding

            if (exitCode == 0) {
                System.out.println("Python script ran successfully.");
            } else {
                System.err.println("Failed to run Python script. Exit code: " + exitCode);
            }
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        } finally {
            long endTime = System.currentTimeMillis(); // End time
            long duration = endTime - startTime; // Calculate duration
            System.out.println("Execution time: " + duration + " milliseconds");
        }
        assert outputBuilder != null;
        return outputBuilder.toString(); // Return the captured output
    }

    public static void main(String[] args) {
        long startTime = System.currentTimeMillis(); // Start time
        try {
            // Step 2: Run the Python script from the created environment and capture output
            String output = runPythonScript("Who are you?");
            System.out.println("Output from Python script:");
            System.out.println(output); // Print the output from the Python script

        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        } finally {
            long endTime = System.currentTimeMillis(); // End time
            long duration = endTime - startTime; // Calculate duration
            System.out.println("Execution time: " + duration + " milliseconds");
        }
    }
}
