import de.kherud.llama.LlamaModel;
import de.kherud.llama.ModelParameters;
import de.kherud.llama.args.LogFormat;
import de.kherud.llama.InferenceParameters;

public class main {

    public static void main(String... args) throws IOException {
        ModelParameters modelParams = new ModelParameters()
                .setModelFilePath("chat/model/llama-3.2-1b-instruct-q4_k_m.gguf")
                .setNGpuLayers(43);

        String system = "This is a conversation between User and Llama, a friendly chatbot.\n" +
                "Llama is helpful, kind, honest, good at writing, and never fails to answer any " +
                "requests immediately and with precision.\n";
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in, StandardCharsets.UTF_8));
        try (LlamaModel model = new LlamaModel(modelParams)) {
            System.out.print(system);
            String prompt = system;
            while (true) {
                prompt += "\nUser: ";
                System.out.print("\nUser: ");
                String input = reader.readLine();
                prompt += input;
                System.out.print("Llama: ");
                prompt += "\nLlama: ";
                InferenceParameters inferParams = new InferenceParameters(prompt)
                        .setTemperature(0.7f)
                        .setPenalizeNl(true)
                        .setMirostat(InferenceParameters.MiroStat.V2)
                        .setAntiPrompt("\n");
                for (LlamaOutput output : model.generate(inferParams)) {
                    System.out.print(output);
                    prompt += output;
                }
            }
        }
    }
}