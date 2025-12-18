{ config, lib, pkgs, ... }:

{
  # Ollama AI model server with ROCm support for AMD GPUs
  services.ollama = {
    enable = true;
    # Optional: preload models, see https://ollama.com/library
    loadModels = [ "llama3.2:3b" "deepseek-r1:1.5b" ];
    package = pkgs.ollama-rocm; # Use ROCm for AMD GPU acceleration
  };

  # Open WebUI for Ollama
  services.open-webui.enable = true;
}
