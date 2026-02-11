"""
FREE AI Tutor Service using Ollama (Local LLM)
NO API COSTS - Runs completely free!

File Location: C:\gyaansaarthi\backend\ai_tutor\services.py
"""

import requests
import json
import logging
from typing import List, Dict, Optional
from django.conf import settings
import os

logger = logging.getLogger(__name__)


class FreeAITutorService:
    """
    AI Tutor using FREE Ollama (Local LLM)
    Replaces expensive Claude API with free alternative
    """
    
    def __init__(self):
        # Ollama runs locally on your machine or free cloud
        self.ollama_url = getattr(settings, 'OLLAMA_URL', 'http://localhost:11434')
        self.model = getattr(settings, 'OLLAMA_MODEL', 'llama3.2')  # Free model
        
    def generate_system_prompt(
        self,
        class_level: int,
        subject: str,
        language: str = 'hindi'
    ) -> str:
        """Generate context-aware system prompt in Hindi"""
        
        if language == 'hindi':
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
        class_level: int,
        subject: str,
        language: str = 'hindi',
        conversation_history: Optional[List[Dict]] = None,
        include_knowledge: bool = True
    ) -> Dict:
        """
        Generate AI tutor response using FREE Ollama
        
        This completely replaces the expensive Claude API!
        Cost: ₹0 per month (FREE!)
        """
        try:
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
            
            # Build full prompt for Ollama
            full_prompt = f"""{system_prompt}

छात्र का प्रश्न: {question}
{context}

कृपया सरल हिंदी में उत्तर दें:"""
            
            # Call FREE Ollama API
            logger.info(f"Calling Ollama at {self.ollama_url} with model {self.model}")
            
            response = requests.post(
                f"{self.ollama_url}/api/generate",
                json={
                    "model": self.model,
                    "prompt": full_prompt,
                    "stream": False,
                    "options": {
                        "temperature": 0.7,
                        "top_p": 0.9,
                        "num_predict": 200,  # Limit response length
                    }
                },
                timeout=300
            )
            
            if response.status_code == 200:
                result = response.json()
                answer = result.get('response', '').strip()
                
                logger.info(f"Ollama response generated successfully")
                
                return {
                    'success': True,
                    'response': answer,
                    'tokens_used': 0,  # Free! No token costs
                    'model': self.model,
                    'has_knowledge': bool(knowledge_items)
                }
            else:
                logger.error(f"Ollama error: {response.status_code} - {response.text}")
                raise Exception(f"Ollama API error: {response.text}")
                
        except requests.exceptions.ConnectionError:
            logger.error("Cannot connect to Ollama. Is it running?")
            return {
                'success': False,
                'error': 'Ollama is not running. Please start Ollama first.',
                'response': self._get_fallback_response(language)
            }
        
        except Exception as e:
            logger.error(f"Error generating AI response: {str(e)}")
            return {
                'success': False,
                'error': str(e),
                'response': self._get_fallback_response(language)
            }
    
    def _get_fallback_response(self, language: str) -> str:
        """Fallback response if AI fails"""
        responses = {
            'hindi': "क्षमा करें, मैं अभी आपकी मदद नहीं कर पा रहा हूं। कृपया थोड़ी देर बाद फिर से कोशिश करें। सुनिश्चित करें कि Ollama चल रहा है।",
            'english': "Sorry, I cannot help you right now. Please try again later. Make sure Ollama is running."
        }
        return responses.get(language, responses['hindi'])
    
    def analyze_image_with_question(
        self,
        image_path: str,
        question: str,
        class_level: int,
        subject: str,
        language: str = 'hindi'
    ) -> Dict:
        """
        Analyze image with FREE Ollama + LLaVA (vision model)
        
        Note: This requires Ollama's LLaVA model for image support
        Install: ollama pull llava
        """
        try:
            import base64
            
            # Read and encode image
            with open(image_path, 'rb') as f:
                image_data = base64.b64encode(f.read()).decode('utf-8')
            
            # Use LLaVA model for vision (FREE)
            vision_model = getattr(settings, 'OLLAMA_VISION_MODEL', 'llava')
            
            system_prompt = self.generate_system_prompt(
                class_level, subject, language
            )
            
            if language == 'hindi':
                prompt = f"""{system_prompt}

छात्र ने यह चित्र भेजा है।

प्रश्न: {question if question else "इस चित्र को देखकर समझाएं"}

कृपया:
1. चित्र में क्या दिख रहा है, बताएं
2. अगर यह कोई गणित की समस्या है, तो हल करें
3. अगर यह आरेख है, तो समझाएं
4. सरल भाषा में जवाब दें"""
            else:
                prompt = f"""{system_prompt}

Student sent this image.

Question: {question if question else "Explain what you see in this image"}

Please:
1. Describe what's in the image
2. If it's a math problem, solve it
3. If it's a diagram, explain it
4. Answer in simple language"""
            
            # Call Ollama with image
            logger.info(f"Analyzing image with {vision_model}")
            
            response = requests.post(
                f"{self.ollama_url}/api/generate",
                json={
                    "model": vision_model,
                    "prompt": prompt,
                    "images": [image_data],
                    "stream": False,
                    "options": {
                        "temperature": 0.7,
                    }
                },
                timeout=90
            )
            
            if response.status_code == 200:
                result = response.json()
                answer = result.get('response', '').strip()
                
                return {
                    'success': True,
                    'response': answer,
                    'tokens_used': 0,
                    'extracted_text': None
                }
            else:
                raise Exception(f"Vision model error: {response.text}")
                
        except requests.exceptions.ConnectionError:
            logger.error("Cannot connect to Ollama vision model")
            return {
                'success': False,
                'error': 'Vision model not available. Install with: ollama pull llava',
                'response': "क्षमा करें, चित्र विश्लेषण उपलब्ध नहीं है। कृपया पहले 'ollama pull llava' चलाएं।"
            }
        
        except Exception as e:
            logger.error(f"Image analysis error: {str(e)}")
            return {
                'success': False,
                'error': str(e),
                'response': "क्षमा करें, चित्र को पढ़ने में समस्या हो रही है।"
            }


# FREE Speech Services

class FreeSpeechService:
    """
    FREE speech-to-text and text-to-speech using open source
    No Google Cloud API costs!
    """
    
    @staticmethod
    def transcribe_audio_vosk(
        audio_file_path: str,
        language: str = 'hi'
    ) -> Dict:
        """
        FREE Speech-to-Text using Vosk (Offline)
        No API costs!
        
        Download models from: https://alphacephei.com/vosk/models
        Hindi model: vosk-model-small-hi-0.22
        """
        try:
            from vosk import Model, KaldiRecognizer
            import wave
            
            # Model path (download and place here)
            model_path = getattr(
                settings,
                'VOSK_MODEL_PATH',
                f"/path/to/vosk-model-small-{language}-0.22"
            )
            
            if not os.path.exists(model_path):
                return {
                    'success': False,
                    'error': f'Vosk model not found at {model_path}. Download from https://alphacephei.com/vosk/models'
                }
            
            model = Model(model_path)
            
            # Open audio file
            wf = wave.open(audio_file_path, "rb")
            rec = KaldiRecognizer(model, wf.getframerate())
            
            result = ""
            while True:
                data = wf.readframes(4000)
                if len(data) == 0:
                    break
                if rec.AcceptWaveform(data):
                    result_dict = json.loads(rec.Result())
                    result += result_dict.get('text', '') + " "
            
            # Final result
            final_result = json.loads(rec.FinalResult())
            result += final_result.get('text', '')
            
            return {
                'success': True,
                'transcript': result.strip(),
                'confidence': 0.9
            }
            
        except Exception as e:
            logger.error(f"Vosk transcription error: {str(e)}")
            return {
                'success': False,
                'error': str(e),
                'transcript': ''
            }
    
    @staticmethod
    def text_to_speech_gtts(
        text: str,
        language: str = 'hi',
        output_path: str = None
    ) -> Dict:
        """
        FREE Text-to-Speech using gTTS (Google TTS - Free tier)
        No API key needed!
        """
        try:
            from gtts import gTTS
            import uuid
            
            # Create TTS
            tts = gTTS(text=text, lang=language, slow=False)
            
            # Save audio
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
__all__ = ['FreeAITutorService', 'FreeSpeechService']
