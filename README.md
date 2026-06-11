Focus: exploring how to combine Rails backend patterns with LLM-based retrieval systems.

## Baba Yaga's Library

A small Retrieval-Augmented Generation (RAG) application built with Ruby on Rails, PostgreSQL `pgvector`, and Hugging Face APIs.

## Features

- **Semantic search:** Retrieves relevant documents using PostgreSQL `pgvector` and cosine similarity
- **LLM integration:** Generates responses using Hugging Face Router API with basic caching to reduce repeated requests
- **Reactive UI:** Built with Rails Turbo Streams for dynamic updates without full page reloads
- **Testing:** RSpec test coverage for core functionality
- **Embedding pipeline:** Simple Python utility using `sentence-transformers` to generate embeddings

## Architecture Overview

The system consists of two main parts:

1. **Rails application**

   - Handles user queries
   - Retrieves relevant documents from PostgreSQL
   - Builds prompts and communicates with the LLM API
   - Renders results via Turbo Streams

2. **Embedding utility (`scripts/embed.py`)**
   - Generates embeddings using Hugging Face models
   - Used to prepare or query data for semantic search

## Setup & Installation

### Prerequisites

- Ruby 3.4 / Rails 8
- PostgreSQL with `pgvector`
- Python 3.x (for embedding script)
