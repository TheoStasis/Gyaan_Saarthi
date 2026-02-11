"""
RAG (Retrieval Augmented Generation) Service
Updated for ChromaDB 0.4.22+
"""
import os
import chromadb
from sentence_transformers import SentenceTransformer
from django.conf import settings
import logging

logger = logging.getLogger(__name__)


class RAGService:
    """
    RAG Service for semantic search using ChromaDB
    """
    
    def __init__(self):
        """Initialize ChromaDB and embedding model"""
        try:
            # Create directory for ChromaDB
            chroma_dir = os.path.join(settings.BASE_DIR, 'chroma_db')
            os.makedirs(chroma_dir, exist_ok=True)
            
            # ✅ NEW ChromaDB Client (Fixed!)
            self.chroma_client = chromadb.PersistentClient(
                path=chroma_dir
            )
            
            # Get or create collection
            try:
                self.collection = self.chroma_client.get_collection(
                    name='textbook_knowledge'
                )
                logger.info(f"✓ Loaded existing collection with {self.collection.count()} documents")
            except:
                self.collection = self.chroma_client.create_collection(
                    name='textbook_knowledge',
                    metadata={"description": "Government textbook content"}
                )
                logger.info("✓ Created new collection")
            
            # Initialize embedding model
            self.embedding_model = SentenceTransformer(
                'paraphrase-multilingual-mpnet-base-v2'
            )
            logger.info("✓ Embedding model loaded successfully")
            
        except Exception as e:
            logger.error(f"Error initializing RAG service: {e}")
            raise
    
    def add_documents(self, documents: list):
        """
        Add documents to vector database
        
        Args:
            documents: List of dicts with keys: id, text, metadata
        """
        try:
            ids = [doc['id'] for doc in documents]
            texts = [doc['text'] for doc in documents]
            metadatas = [doc['metadata'] for doc in documents]
            
            # Generate embeddings
            logger.info(f"Generating embeddings for {len(texts)} documents...")
            embeddings = self.embedding_model.encode(texts).tolist()
            
            # Add to ChromaDB
            self.collection.add(
                ids=ids,
                embeddings=embeddings,
                documents=texts,
                metadatas=metadatas
            )
            
            logger.info(f"✓ Successfully added {len(documents)} documents")
            return True
            
        except Exception as e:
            logger.error(f"Error adding documents: {e}")
            return False
    
    def search(self, query: str, n_results: int = 3, filters: dict = None):
        """
        Search for relevant content
        
        Args:
            query: User's question
            n_results: Number of results to return
            filters: Optional filters (e.g., {'class_level': 'Class 5'})
        
        Returns:
            List of relevant documents with metadata
        """
        try:
            # Generate query embedding
            logger.info(f"Searching for: {query}")
            query_embedding = self.embedding_model.encode([query]).tolist()[0]
            
            # Search in ChromaDB
            results = self.collection.query(
                query_embeddings=[query_embedding],
                n_results=n_results,
                where=filters if filters else None
            )
            
            # Format results
            formatted_results = []
            if results['documents']:
                for i in range(len(results['documents'][0])):
                    formatted_results.append({
                        'id': results['ids'][0][i],
                        'text': results['documents'][0][i],
                        'metadata': results['metadatas'][0][i],
                        'distance': results['distances'][0][i] if 'distances' in results else None
                    })
            
            logger.info(f"✓ Found {len(formatted_results)} relevant documents")
            return formatted_results
            
        except Exception as e:
            logger.error(f"Error searching documents: {e}")
            return []
    
    def get_context_for_query(self, query: str, class_level: str = None, 
                              subject: str = None, n_results: int = 3):
        """
        Get relevant context for a user query
        """
        # Build filters
        filters = {}
        if class_level:
            filters['class_level'] = class_level
        if subject:
            filters['subject'] = subject
        
        # Search for relevant content
        results = self.search(query, n_results=n_results, 
                            filters=filters if filters else None)
        
        if not results:
            return ""
        
        # Format context
        context_parts = []
        for i, result in enumerate(results, 1):
            metadata = result['metadata']
            text = result['text']
            
            context_part = f"""
[Source {i}]
Class: {metadata.get('class_level', 'Unknown')}
Subject: {metadata.get('subject', 'Unknown')}
Chapter: {metadata.get('chapter', 'Unknown')}

Content:
{text}
"""
            context_parts.append(context_part)
        
        return "\n\n".join(context_parts)
    
    def get_collection_stats(self):
        """Get statistics about the vector database"""
        try:
            count = self.collection.count()
            return {
                'total_documents': count,
                'collection_name': 'textbook_knowledge'
            }
        except Exception as e:
            logger.error(f"Error getting collection stats: {e}")
            return None


# Singleton instance
_rag_service = None

def get_rag_service():
    """Get or create RAG service instance"""
    global _rag_service
    if _rag_service is None:
        _rag_service = RAGService()
    return _rag_service