# 🛠️ Technical Deep-Dive: RAG System Internals

This document provides a low-level technical analysis of the system components and internal protocols.

## 1. Data Synchronization & Integrity

The core challenge of this RAG system is maintaining strict consistency between **Unstructured Vector Data** (Qdrant) and **Structured Metadata** (PostgreSQL).

### The Synchronization Protocol:

* **Unique Ingestion Hash:** Every document is hashed (SHA-256) before processing to prevent duplicate embeddings and redundant compute.
* **UUID Mapping:** Qdrant `Point ID` is shared with the PostgreSQL `document_chunks.vector_id`.
* **Transactional Ingestion:** n8n ensures that if the Qdrant indexing fails, the metadata in Postgres is rolled back or marked as `failed`, preventing "phantom references".

## 2. Dynamic Hot-Swap Configuration

The system state is not defined in static `.env` files or hardcoded logic.

* **Runtime Fetching:** At the start of every query workflow, n8n fetches the `rag_models` from Postgres for granular control over:
* `top_k` retrieval parameters.
* System Prompts (Role-based).
* Model-specific parameters (Temperature, Max Tokens, Stop Sequences).

## 3. SSH Inference Orchestration (Edge Compute)

The `SSH Engine Manager` (implemented via custom n8n nodes) is a key differentiator.

* **Task Queuing:** Instead of a simple API call, the system can send inference tasks to remote GPU workers.
* **Isolation:** The API layer never touches the GPU hardware directly, allowing for a "Clean Room" architecture where the data-handling backend and the high-compute engines live on separate networks.

* **Frontend Rendering:** The Angular frontend uses the citation to position the PDF viewer (PDF.js) to relevant text at correct page


---

> **Stability Note:** The architecture described herein is the result of iterative stress-testing. The decoupling of services (NestJS, n8n, FastAPI) was specifically implemented to handle production workloads where high availability and data consistency are non-negotiable requirements.

---

