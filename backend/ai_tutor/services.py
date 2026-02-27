"""
AI Tutor Service using Groq API (FREE Cloud API)
Works perfectly on Android phones!

File Location: C:\gyaansaarthi\backend\ai_tutor\services.py
"""

import logging
from typing import List, Dict, Optional
from django.conf import settings
import os

logger = logging.getLogger(__name__)


class AITutorService:
    """
    AI Tutor using FREE Groq Cloud API
    Perfect for government schools - works on all Android phones!
    """
    
    def __init__(self):
        # Initialize Groq client
        try:
            from groq import Groq
            
            api_key = os.getenv('GROQ_API_KEY')
            if not api_key:
                raise ValueError("GROQ_API_KEY not found in environment variables")
            
            self.client = Groq(api_key=api_key)
            self.model = os.getenv('GROQ_MODEL', 'llama-3.1-8b-instant')
            self.use_groq = True
            
            logger.info(f"✅ Groq AI initialized with model: {self.model}")
            
        except Exception as e:
            logger.error(f"❌ Failed to initialize Groq: {e}")
            self.use_groq = False
            raise
    
    def generate_system_prompt(
        self,
        class_level: int,
        subject: str,
        language: str = 'hindi'
    ) -> str:
        """Generate context-aware system prompt"""
        
        if language in ['hindi', 'hi']:
            if class_level <= 2:
                prompt = f"""आप एक बहुत प्यारे और धैर्यवान शिक्षक हैं।

छात्र: कक्षा {class_level} का बहुत छोटा बच्चा
विषय: {subject}

कृपया:
1. बहुत-बहुत आसान शब्दों में बोलें
2. छोटे-छोटे वाक्य बनाएं (3-4 शब्द)
3. कहानियों और उदाहरणों से समझाएं
4. हमेशा बच्चे की तारीफ करें
5. 2-3 वाक्यों में जवाब दें"""
            
            elif class_level <= 5:
                prompt = f"""आप एक अनुभवी और मिलनसार शिक्षक हैं।

छात्र: कक्षा {class_level}
विषय: {subject}

कृपया:
1. सरल हिंदी में समझाएं
2. रोजमर्रा के उदाहरण दें
3. 3-4 वाक्यों में जवाब दें
4. बच्चे को प्रोत्साहित करें
5. धैर्य से पढ़ाएं"""
            
            elif class_level <= 8:
                prompt = f"""आप एक कुशल और समझदार शिक्षक हैं।

छात्र: कक्षा {class_level}
विषय: {subject}

कृपया:
1. स्पष्ट हिंदी में व्याख्या करें
2. अच्छे उदाहरणों का प्रयोग करें
3. 4-5 वाक्यों में विस्तार से बताएं
4. तर्क और समझ पर ध्यान दें
5. छात्र को सोचने के लिए प्रेरित करें"""
            
            else:  # class_level >= 9
                prompt = f"""आप एक विशेषज्ञ और अनुभवी शिक्षक हैं।

छात्र: कक्षा {class_level}
विषय: {subject}

कृपया:
1. विस्तृत और गहन व्याख्या दें
2. वैज्ञानिक तर्क और उदाहरण प्रस्तुत करें
3. 5-6 वाक्यों में पूरी जानकारी दें
4. परीक्षा की दृष्टि से महत्वपूर्ण बिंदु बताएं
5. छात्र की सोच को विकसित करें"""
        
        else:  # English
            if class_level <= 5:
                prompt = f"""You are a friendly and patient teacher.

Student: Class {class_level}
Subject: {subject}

Please:
1. Use simple English
2. Give everyday examples
3. Answer in 3-4 sentences
4. Be encouraging
5. Be patient"""
            
            else:
                prompt = f"""You are an experienced and knowledgeable teacher.

Student: Class {class_level}
Subject: {subject}

Please:
1. Explain clearly in English
2. Provide detailed examples
3. Answer in 4-5 sentences
4. Focus on understanding
5. Prepare for exams"""
        
        return prompt
    
    def search_knowledge_base(
        self,
        query: str,
        class_level: int,
        subject: str,
        limit: int = 3
    ) -> List[Dict]:
        """
        Search textbook knowledge base for relevant content
        Uses RAG (Retrieval Augmented Generation) approach
        """
        try:
            from ai_tutor.models import KnowledgeBase
            
            # Extract keywords from query
            keywords = query.lower().split()[:5]
            
            # Search in knowledge base
            knowledge_items = KnowledgeBase.objects.filter(
                class_level=class_level,
                subject__icontains=subject
            )
            
            # Score each item based on keyword matches
            scored_items = []
            for item in knowledge_items:
                score = sum(1 for keyword in keywords if keyword in item.text.lower())
                if score > 0:
                    scored_items.append((score, item))
            
            # Sort by relevance and get top results
            scored_items.sort(reverse=True, key=lambda x: x[0])
            top_items = [item[1] for item in scored_items[:limit]]
            
            return [
                {
                    'chapter': item.chapter,
                    'content': item.text[:500],  # First 500 chars
                    'class': item.class_level,
                    'subject': item.subject
                }
                for item in top_items
            ]
        
        except Exception as e:
            logger.error(f"Knowledge base search error: {str(e)}")
            return []
    
    def generate_response(
        self,
        question: str,
        class_level: int = 5,
        subject: str = 'General',
        language: str = 'hindi',
        conversation_history: Optional[List[Dict]] = None,
        include_knowledge: bool = True
    ) -> Dict:
        """
        Generate AI tutor response using FREE Groq API
        Works perfectly on Android phones via cloud!
        
        Cost: ₹0 per month (FREE!)
        Limits: 30 requests/min, 6000/day (more than enough!)
        """
        try:
            if not self.use_groq:
                return {
                    'success': False,
                    'error': 'Groq API not initialized',
                    'response': self._get_fallback_response(language)
                }
            
            # Build context from knowledge base
            context = ""
            knowledge_items = []
            
            if include_knowledge:
                knowledge_items = self.search_knowledge_base(
                    question, class_level, subject
                )
                if knowledge_items:
                    context = "\n\nसंबंधित पाठ्यक्रम सामग्री:\n"
                    for idx, item in enumerate(knowledge_items, 1):
                        context += f"\n{idx}. अध्याय: {item['chapter']}\n"
                        context += f"   {item['content'][:300]}...\n"
            
            # Generate system prompt
            system_prompt = self.generate_system_prompt(
                class_level, subject, language
            )
            
            # Handle greetings
            greetings = ['hi', 'hello', 'hey', 'नमस्ते', 'হাই', 'வணக்கம்', 'నమస్తే', 'नमस्कार']
            if question.lower().strip() in greetings:
                greeting_responses = {
                    'hindi': 'नमस्ते! मैं आपका AI शिक्षक हूं। मैं आपकी पढ़ाई में मदद कर सकता हूं। कोई भी सवाल पूछें! 📚',
                    'english': 'Hello! I am your AI tutor. I can help you with your studies. Ask me anything! 📚',
                }
                return {
                    'success': True,
                    'response': greeting_responses.get(language, greeting_responses['hindi']),
                    'tokens_used': 0,
                    'model': self.model,
                    'has_knowledge': False
                }
            
            # Build full prompt
            if language in ['hindi', 'hi']:
                user_message = f"""छात्र का प्रश्न: {question}
{context}

कृपया सरल हिंदी में उत्तर दें:"""
            else:
                user_message = f"""Student's question: {question}
{context}

Please answer in simple {language}:"""
            
            # Call Groq API
            logger.info(f"🌐 Calling Groq API with model {self.model}")
            
            response = self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_message}
                ],
                temperature=0.7,
                max_tokens=500,
                top_p=0.9,
            )
            
            answer = response.choices[0].message.content.strip()
            
            logger.info(f"✅ Groq response generated successfully")
            
            return {
                'success': True,
                'response': answer,
                'tokens_used': 0,  # Groq is FREE!
                'model': self.model,
                'has_knowledge': bool(knowledge_items)
            }
                
        except Exception as e:
            logger.error(f"❌ Error generating AI response: {str(e)}")
            return {
                'success': False,
                'error': str(e),
                'response': self._get_fallback_response(language)
            }
    
    def _get_fallback_response(self, language: str) -> str:
        """Fallback response if AI fails"""
        responses = {
            'hindi': "क्षमा करें, मैं अभी आपकी मदद नहीं कर पा रहा हूं। कृपया थोड़ी देर बाद फिर से कोशिश करें।",
            'english': "Sorry, I cannot help you right now. Please try again later."
        }
        return responses.get(language, responses['hindi'])


# FREE Speech Services (Keep as is for future use)

class FreeSpeechService:
    """
    FREE speech-to-text and text-to-speech using open source
    """
    
    @staticmethod
    def text_to_speech_gtts(
        text: str,
        language: str = 'hi',
        output_path: str = None
    ) -> Dict:
        """
        FREE Text-to-Speech using gTTS
        """
        try:
            from gtts import gTTS
            import uuid
            
            tts = gTTS(text=text, lang=language, slow=False)
            
            if not output_path:
                output_path = f"/tmp/tts_{uuid.uuid4()}.mp3"
            
            tts.save(output_path)
            
            return {
                'success': True,
                'audio_path': output_path
            }
            
        except Exception as e:
            logger.error(f"gTTS error: {str(e)}")
            return {
                'success': False,
                'error': str(e),
                'audio_path': None
            }


# Export the main service class
__all__ = ['AITutorService', 'FreeSpeechService']