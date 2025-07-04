# py-mcp-qdrant-rag

A Model Context Protocol (MCP) server implementation for RAG (Retrieval-Augmented Generation) using Qdrant vector database with support for both Ollama and OpenAI embeddings.

## Features

- 🔍 **Semantic Search**: Search through stored documents using advanced semantic similarity
- 📄 **Multi-Format Support**: Process various document formats including PDF, TXT, MD, DOCX, and more
- 🌐 **Web Scraping**: Add documentation directly from URLs
- 📁 **Bulk Import**: Import entire directories of documents at once
- 🧠 **Flexible Embeddings**: Choose between Ollama (local) or OpenAI embeddings
- 💾 **Vector Storage**: Efficient storage and retrieval using Qdrant vector database
- 🔧 **MCP Integration**: Seamless integration with Claude Desktop application
- ⚡ **Fast Retrieval**: Optimized vector search for quick information retrieval

## Prerequisites

- Python 3.11 or higher
- [Conda](https://docs.conda.io/en/latest/miniconda.html) (Miniconda or Anaconda)
- [Qdrant](https://qdrant.tech/) vector database
- [Ollama](https://ollama.ai/) for local embeddings OR OpenAI API key
- Claude Desktop application

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/amornpan/py-mcp-qdrant-rag.git
cd py-mcp-qdrant-rag
```

### 2. Setup Conda Environment

#### For macOS/Linux:

```bash
# Grant permissions and run installation script
chmod +x install_conda.sh
./install_conda.sh

# Activate the environment
conda activate mcp-rag-qdrant-1.0

# Install Ollama Python client
pip install ollama

# Pull the embedding model
ollama pull nomic-embed-text

# Get Python path (save this for later configuration)
which python
```

#### For Windows:

```powershell
# Create and activate environment
conda create -n mcp-rag-qdrant-1.0 python=3.11
conda activate mcp-rag-qdrant-1.0

# Install required packages
pip install ollama

# Pull the embedding model
ollama pull nomic-embed-text

# Get Python path (save this for later configuration)
where python
```

### 3. Start Qdrant Vector Database

Using Docker:
```bash
docker run -p 6333:6333 -v $(pwd)/qdrant_storage:/qdrant/storage qdrant/qdrant
```

Or using Qdrant Cloud:
- Sign up at [cloud.qdrant.io](https://cloud.qdrant.io)
- Create a cluster and get your URL and API key

### 4. Configure Claude Desktop

Locate your Claude Desktop configuration file:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
- **Linux**: `~/.config/claude/claude_desktop_config.json`

Add the following configuration:

```json
{
  "mcpServers": {
    "mcp-rag-qdrant-1.0": {
      "command": "/path/to/conda/envs/mcp-rag-qdrant-1.0/bin/python",
      "args": [
        "/path/to/py-mcp-qdrant-rag/run.py",
        "--mode",
        "mcp"
      ],
      "env": {
        "QDRANT_URL": "http://localhost:6333",
        "EMBEDDING_PROVIDER": "ollama",
        "OLLAMA_URL": "http://localhost:11434"
      }
    }
  }
}
```

**Important**: Replace `/path/to/...` with the actual paths from your system.

### 5. Restart Claude Desktop

After saving the configuration, completely restart Claude Desktop to load the MCP server.

## Usage

Once configured, you can interact with the RAG system directly in Claude Desktop using natural language commands.

### Adding Documentation

**From URLs:**
```
"Add documentation from https://docs.python.org/3/tutorial/"
"Index the content from https://github.com/user/repo/blob/main/README.md"
```

**From Local Directories:**
```
"Add all documents from /Users/username/Documents/project-docs"
"Index all files in C:\Projects\Documentation"
```

### Searching Documentation

```
"Search for information about authentication methods"
"Find documentation about REST API endpoints"
"What does the documentation say about error handling?"
"Look up information on database configuration"
```

### Managing Sources

```
"List all documentation sources"
"Show me what documents are indexed"
"What sources are available in the knowledge base?"
```

## Configuration Options

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `QDRANT_URL` | Qdrant server URL | `http://localhost:6333` | Yes |
| `EMBEDDING_PROVIDER` | Embedding provider (`ollama` or `openai`) | `ollama` | Yes |
| `OLLAMA_URL` | Ollama server URL (if using Ollama) | `http://localhost:11434` | If using Ollama |
| `OPENAI_API_KEY` | OpenAI API key (if using OpenAI) | - | If using OpenAI |
| `COLLECTION_NAME` | Qdrant collection name | `documents` | No |
| `CHUNK_SIZE` | Text chunk size for splitting | `1000` | No |
| `CHUNK_OVERLAP` | Overlap between chunks | `200` | No |
| `EMBEDDING_MODEL` | Model name for embeddings | `nomic-embed-text` (Ollama) or `text-embedding-3-small` (OpenAI) | No |

### Using OpenAI Embeddings

To use OpenAI embeddings instead of Ollama, update your configuration:

```json
{
  "mcpServers": {
    "mcp-rag-qdrant-1.0": {
      "command": "/path/to/python",
      "args": ["/path/to/run.py", "--mode", "mcp"],
      "env": {
        "QDRANT_URL": "http://localhost:6333",
        "EMBEDDING_PROVIDER": "openai",
        "OPENAI_API_KEY": "sk-your-openai-api-key-here"
      }
    }
  }
}
```

### Using Qdrant Cloud

For Qdrant Cloud deployment:

```json
{
  "env": {
    "QDRANT_URL": "https://your-cluster.qdrant.io",
    "QDRANT_API_KEY": "your-qdrant-api-key",
    "EMBEDDING_PROVIDER": "ollama",
    "OLLAMA_URL": "http://localhost:11434"
  }
}
```

## Supported File Types

The system automatically processes the following file types:

- **Text**: `.txt`, `.md`, `.markdown`, `.rst`
- **Documents**: `.pdf`, `.docx`, `.doc`, `.odt`
- **Code**: `.py`, `.js`, `.ts`, `.java`, `.cpp`, `.c`, `.h`, `.go`, `.rs`, `.php`, `.rb`, `.swift`
- **Data**: `.json`, `.yaml`, `.yml`, `.xml`, `.csv`
- **Web**: HTML content from URLs

## API Reference

### Core Functions

#### `add_documentation(url: str) -> dict`
Add documentation from a web URL to the vector database.

**Parameters:**
- `url`: The URL to fetch and index

**Returns:**
- Dictionary with status and indexed chunks count

#### `add_directory(path: str) -> dict`
Recursively add all supported files from a directory.

**Parameters:**
- `path`: Directory path to scan

**Returns:**
- Dictionary with indexed files and total chunks

#### `search_documentation(query: str, limit: int = 5) -> list`
Search through stored documentation using semantic similarity.

**Parameters:**
- `query`: Search query text
- `limit`: Maximum number of results (default: 5)

**Returns:**
- List of relevant document chunks with scores

#### `list_sources() -> list`
List all documentation sources in the database.

**Returns:**
- List of unique source identifiers

## Architecture

### Project Structure

```
py-mcp-qdrant-rag/
├── run.py                 # Main entry point
├── mcp_server.py          # MCP server implementation
├── rag_engine.py          # Core RAG functionality
├── embeddings/
│   ├── base.py           # Embedding provider interface
│   ├── ollama.py         # Ollama embedding implementation
│   └── openai.py         # OpenAI embedding implementation
├── document_loader.py     # Document processing and chunking
├── requirements.txt       # Python dependencies
├── install_conda.sh       # Installation script (Unix)
└── tests/                # Unit tests
```

### Component Overview

1. **MCP Server**: Handles communication with Claude Desktop
2. **RAG Engine**: Manages document indexing and retrieval
3. **Embedding Providers**: Abstract interface for different embedding services
4. **Document Loader**: Processes various file formats and splits text
5. **Vector Store**: Qdrant integration for efficient similarity search

## Development

### Running in Standalone Mode

For development and testing without Claude Desktop:

```bash
conda activate mcp-rag-qdrant-1.0
python run.py --mode standalone
```

### Running Tests

```bash
conda activate mcp-rag-qdrant-1.0
pytest tests/
```

### Adding New File Types

To support additional file types, modify the `SUPPORTED_EXTENSIONS` in `document_loader.py` and implement the corresponding parser.

## Troubleshooting

### Common Issues

#### "Path not found" Error
- Ensure all paths in configuration are absolute paths
- Verify Python path is from the conda environment: `which python`

#### "Connection refused" to Qdrant
- Check if Qdrant is running: `docker ps`
- Verify the port: `curl http://localhost:6333/health`

#### "Connection refused" to Ollama
- Ensure Ollama is running: `ollama list`
- Check the service: `curl http://localhost:11434/api/tags`

#### Claude Desktop doesn't show MCP server
- Verify JSON syntax in configuration file
- Check Claude Desktop logs for errors
- Ensure paths use forward slashes or escaped backslashes

### Windows-Specific Issues

1. **Path format**: Use double backslashes `\\` or forward slashes `/`
2. **Firewall**: Allow ports 6333 (Qdrant) and 11434 (Ollama)
3. **Admin rights**: Run Anaconda Prompt as Administrator if needed

### Debug Mode

Enable debug logging by adding to environment:

```json
{
  "env": {
    "LOG_LEVEL": "DEBUG",
    "QDRANT_URL": "http://localhost:6333",
    "EMBEDDING_PROVIDER": "ollama"
  }
}
```

## Performance Optimization

### Chunking Strategy
- Adjust `CHUNK_SIZE` for your document types
- Increase `CHUNK_OVERLAP` for better context preservation
- Use smaller chunks for technical documentation

### Embedding Cache
- Documents are embedded only once
- Re-indexing skips unchanged files
- Clear collection to force re-indexing

### Search Optimization
- Increase `limit` parameter for more results
- Use specific technical terms for better precision
- Combine searches with different phrasings

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and add tests
4. Commit with clear messages: `git commit -m 'Add amazing feature'`
5. Push to your fork: `git push origin feature/amazing-feature`
6. Open a Pull Request

### Development Guidelines

- Follow PEP 8 style guide
- Add unit tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

## Security Considerations

- **API Keys**: Never commit API keys to version control
- **File Access**: The system only accesses explicitly provided paths
- **Network**: Ensure Qdrant and Ollama are not exposed to public internet
- **Sensitive Data**: Be cautious when indexing confidential documents

## License

This project is provided for educational purposes. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Anthropic](https://anthropic.com) for the Model Context Protocol
- [Qdrant](https://qdrant.tech/) for the excellent vector database
- [Ollama](https://ollama.ai/) for local LLM infrastructure
- [OpenAI](https://openai.com/) for embedding models

## Support

For questions, issues, or feature requests:
- Open an issue: [GitHub Issues](https://github.com/amornpan/py-mcp-qdrant-rag/issues)
- Check existing issues before creating new ones
- Provide detailed information for bug reports

---

Made with ❤️ by [amornpan](https://github.com/amornpan)
