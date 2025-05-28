# MSSQL Server for RAG - Cross-Platform Setup Guide

This guide will walk you through installing and using pyRAGDocs with Conda as the package and environment manager for Mac, Linux, and Windows systems.

## Prerequisites - Essential Requirements

1. [Conda](https://docs.conda.io/en/latest/miniconda.html) (Miniconda or Anaconda)
2. [Qdrant](https://qdrant.tech/) (vector database for storing embeddings)
3. [Ollama](https://ollama.ai/) (for local embedding generation) or OpenAI API key

## Installation Instructions for MSSQL Server for RAG (First-time Installation)

### For Mac/Linux Systems

1. **Grant permissions and run installation script**

   ```bash
   chmod +x install_conda.sh
   ./install_conda.sh

   conda activate mcp-rag-qdrant-1.0
   pip install ollama

   ollama pull nomic-embed-text
   ```

2. **Check Python installation path**

   ```bash
   which python
   ```

### For Windows Systems

1. **Open Anaconda Prompt or Command Prompt and run installation commands**

   ```cmd
   # If you have the install script, run it
   # Otherwise, create the environment manually:
   
   conda create -n mcp-rag-qdrant-1.0 python=3.11
   conda activate mcp-rag-qdrant-1.0
   
   # Install required packages
   pip install ollama
   
   # Pull the embedding model
   ollama pull nomic-embed-text
   ```

2. **Check Python installation path**

   ```cmd
   where python
   ```

   Or use PowerShell:
   ```powershell
   Get-Command python
   ```

## Claude Desktop Configuration

### Configuration File Locations

- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
- **Linux**: `~/.config/claude/claude_desktop_config.json`

### Configuration Setup

Open the Claude Desktop configuration file and add the following settings (replace `/path/to/conda/bin/python` with your actual Python installation path):

#### For Mac/Linux:
```json
{
  "mcpServers": {
    "mcp-rag-qdrant-1.0": {
      "command": "/path/to/conda/bin/python",
      "args": [
        "/path/to/run.py",
        "--mode",
        "mcp"
      ],
      "env": {
        "QDRANT_URL": "http://34.27.111.38:6333",
        "EMBEDDING_PROVIDER": "ollama",
        "OLLAMA_URL": "http://localhost:11434"
      }
    }
  }
}
```

#### For Windows:
```json
{
  "mcpServers": {
    "mcp-rag-qdrant-1.0": {
      "command": "C:\\path\\to\\conda\\python.exe",
      "args": [
        "C:\\path\\to\\run.py",
        "--mode",
        "mcp"
      ],
      "env": {
        "QDRANT_URL": "http://34.27.111.38:6333",
        "EMBEDDING_PROVIDER": "ollama",
        "OLLAMA_URL": "http://localhost:11434"
      }
    }
  }
}
```

**Important**: Before saving and proceeding, please review that you are using the correct local paths in your `claude_desktop_config.json`. If the paths are incorrect, you must change them accordingly.

### Finding the Correct Python Path

#### Mac/Linux:
```bash
conda activate mcp-rag-qdrant-1.0
which python
```

#### Windows:
```cmd
conda activate mcp-rag-qdrant-1.0
where python
```

## Additional Windows-Specific Notes

1. **Ollama Installation on Windows**: Download Ollama for Windows from [ollama.ai](https://ollama.ai/) and follow the Windows installation instructions.

2. **Path Separators**: Use double backslashes (`\\`) or forward slashes (`/`) in JSON configuration files for Windows paths.

3. **Environment Activation**: Always activate your conda environment before running commands:
   ```cmd
   conda activate mcp-rag-qdrant-1.0
   ```

4. **Firewall Considerations**: Ensure that Ollama (port 11434) and Qdrant (port 6333) are allowed through your Windows Firewall if needed.

## Troubleshooting

### Common Issues:
- **Path not found**: Verify that all paths in the configuration file are absolute and correct
- **Conda environment not found**: Ensure the environment is created and activated
- **Ollama connection failed**: Check that Ollama is running on `http://localhost:11434`
- **Qdrant connection failed**: Verify Qdrant server accessibility

## Disclaimer

The "MSSQL Server for RAG" software ("Software") is provided for educational purposes only. The developers, instructors, and related teams make no warranty, express or implied, regarding the accuracy, completeness, or fitness for any particular purpose of this software.

Use of this software is at the user's sole risk. The developers, instructors, and related teams shall not be liable for any damages, whether direct, indirect, incidental, special, or consequential, including but not limited to loss of data, loss of profits, or business interruption, arising from the use or inability to use this software, even if advised of the possibility of such damages.

Users acknowledge that this software may contain defects or errors and accept all risks associated with the quality, performance, accuracy, and operation of the software.

Users must comply with all applicable laws, regulations, and rules when using this software, including but not limited to personal data protection laws, copyright laws, and any relevant licensing agreements.

By using this software, you accept all terms and conditions specified in this disclaimer.