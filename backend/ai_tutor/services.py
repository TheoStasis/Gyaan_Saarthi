import logging
import os
from typing import List, Dict, Optional
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

logger = logging.getLogger(__name__)


class AITutorService:
    def __init__(self):
        try:
            from groq import Groq
            
            # Load API key from environment
            api_key = os.getenv('GROQ_API_KEY')
            
            if not api_key or api_key == 'your-groq-api-key-here':
                raise ValueError(
                    "⚠️ GROQ_API_KEY not configured!\n"
                    "Get your FREE key from: https://console.groq.com\n"
                    "Then add it to backend/.env file"
                )
            
            self.client = Groq(api_key=api_key)
            self.model = os.getenv('GROQ_MODEL', 'llama-3.1-8b-instant')
            self.use_groq = True
            
            logger.info(f"✅ Groq AI initialized: {self.model}")
            print(f"✅ Groq AI initialized with model: {self.model}")
            
        except ImportError:
            logger.error("❌ Groq package not installed! Run: pip install groq")
            raise
        except Exception as e:
            logger.error(f"❌ Groq initialization failed: {e}")
            raise
    
    def generate_response(
        self,
        question: str,
        class_level: int = 5,
        subject: str = 'General',
        language: str = 'english',
        conversation_history: Optional[List[Dict]] = None,
        include_knowledge: bool = True
    ) -> Dict:
        """Generate AI response using Groq"""
        
        try:
            # Debug logging
            logger.info(f"🔵 Generating response")
            logger.info(f"🔵 Language: {language}")
            logger.info(f"🔵 Question: {question[:100]}...")
            
            print(f"🔵 Generating response in: {language}")
            print(f"🔵 Question: {question[:100]}...")
            
            # Build system prompt with specified language
            system_prompt = self.generate_system_prompt(
                class_level=class_level,
                subject=subject,
                language=language
            )
            
            # Search knowledge base if needed
            context_docs = []
            if include_knowledge:
                context_docs = self.search_knowledge_base(
                    query=question,
                    limit=3
                )
            
            # Build context
            context = ""
            if context_docs:
                context = "\n\nRelevant information from textbooks:\n"
                for doc in context_docs:
                    context += f"- {doc.get('content', '')}\n"
            
            # Build messages
            messages = [
                {"role": "system", "content": system_prompt}
            ]
            
            # Add conversation history if provided
            if conversation_history:
                messages.extend(conversation_history)
            
            # Add current question
            user_message = question
            if context:
                user_message = f"{question}\n{context}"
            
            messages.append({"role": "user", "content": user_message})
            
            print(f"🔵 Calling Groq API with {language} prompt...")
            
            # Call Groq API
            response = self.client.chat.completions.create(
                model=self.model,
                messages=messages,
                temperature=0.7,
                max_tokens=1000
            )
            
            answer = response.choices[0].message.content
            
            logger.info(f"🟢 Response generated successfully")
            logger.info(f"🟢 Answer preview: {answer[:100]}...")
            
            print(f"🟢 Response generated in: {language}")
            print(f"🟢 Answer preview: {answer[:100]}...")
            
            return {
                'answer': answer,
                'metadata': {
                    'model': self.model,
                    'language': language,
                    'context_used': len(context_docs) > 0,
                    'sources': [doc.get('id') for doc in context_docs]
                }
            }
            
        except Exception as e:
            logger.error(f"🔴 Error generating response: {e}")
            print(f"🔴 Error generating response: {e}")
            import traceback
            traceback.print_exc()
            return {
                'answer': f"Sorry, I encountered an error: {str(e)}",
                'metadata': {'error': str(e)}
            }
    
    def generate_system_prompt(
        self,
        class_level: int,
        subject: str,
        language: str = 'english'
    ) -> str:
        """Generate system prompt based on parameters"""
        
        # Map language to full name
        language_names = {
            'english': 'English',
            'hindi': 'Hindi',
            'bengali': 'Bengali',
            'tamil': 'Tamil',
            'telugu': 'Telugu',
            'marathi': 'Marathi'
        }
        
        language_name = language_names.get(language.lower(), 'English')
        
        print(f"🔵 Creating system prompt in: {language_name}")
        
        # CRITICAL: Tell AI to respond in the specified language!
        base_prompt = f"""You are an AI tutor for Indian government school students.

CRITICAL INSTRUCTION: You MUST respond in {language_name} language ONLY!
Even if the question is in a different language, your answer MUST be in {language_name}.

Student Level: Class {class_level}
Subject: {subject}
Response Language: {language_name}

Your role:
- Explain concepts clearly in {language_name}
- Use simple language appropriate for Class {class_level} students
- Provide examples from daily life
- Be encouraging and supportive
- Break down complex topics into simple steps
- If the student asks a question in English but you must respond in {language_name}, translate your answer to {language_name}

Remember: ALWAYS respond in {language_name}, no matter what language the question is in!

Example:
Question (English): "What is photosynthesis?"
Your Answer (in {language_name}): [Explain photosynthesis in {language_name}]
"""
        
        logger.info(f"🟢 System prompt created for: {language_name}")
        
        return base_prompt
    
    def search_knowledge_base(
        self,
        query: str,
        limit: int = 3
    ) -> List[Dict]:
        """Search knowledge base for relevant content"""
        
        try:
            # Try to import and use the knowledge base
            from knowledge_base.models import TextbookEntry
            
            # Simple keyword search
            results = TextbookEntry.objects.filter(
                content__icontains=query
            )[:limit]
            
            return [{
                'id': entry.id,
                'content': entry.content[:200],  # Limit context length
                'subject': getattr(entry, 'subject', 'General'),
            } for entry in results]
            
        except ImportError:
            logger.warning("Knowledge base not available")
            return []
        except Exception as e:
            logger.error(f"Error searching knowledge base: {e}")
            return []


def get_ai_service():
    """Factory function to get AI service instance"""
    return AITutorService()