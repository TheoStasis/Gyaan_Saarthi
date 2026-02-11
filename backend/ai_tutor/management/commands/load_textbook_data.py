"""
Django management command to load textbook data into RAG system
This loads YOUR JSON dataset into ChromaDB - NO TRAINING REQUIRED!

Usage:
python manage.py load_textbook_data C:/gyaansaarthi/dataset/epics_class1_to_9_books.json

File Location: backend/ai_tutor/management/commands/load_textbook_data.py
"""
import json
import os
from django.core.management.base import BaseCommand
from ai_tutor.models import TextbookContent
from ai_tutor.rag_service import get_rag_service
import uuid


class Command(BaseCommand):
    help = 'Load textbook data from JSON into RAG system'
    
    def add_arguments(self, parser):
        parser.add_argument(
            'json_file',
            type=str,
            nargs='?',  # Make it optional
            default='C:/gyaansaarthi/dataset/epics_class1_to_9_books.json',
            help='Path to JSON file (default: C:/gyaansaarthi/dataset/epics_class1_to_9_books.json)'
        )
        parser.add_argument(
            '--clear',
            action='store_true',
            help='Clear existing data before loading'
        )
    
    def handle(self, *args, **options):
        json_file = options['json_file']
        clear_existing = options.get('clear', False)
        
        # Check if file exists
        if not os.path.exists(json_file):
            self.stdout.write(self.style.ERROR(f'File not found: {json_file}'))
            self.stdout.write(self.style.WARNING(
                'Make sure the file exists at: C:/gyaansaarthi/dataset/epics_class1_to_9_books.json'
            ))
            return
        
        self.stdout.write(self.style.SUCCESS('='*70))
        self.stdout.write(self.style.SUCCESS('LOADING TEXTBOOK DATA INTO RAG SYSTEM'))
        self.stdout.write(self.style.SUCCESS('='*70))
        self.stdout.write(f'File: {json_file}')
        
        # Clear existing data if requested
        if clear_existing:
            self.stdout.write('\nClearing existing data...')
            count = TextbookContent.objects.count()
            TextbookContent.objects.all().delete()
            self.stdout.write(self.style.SUCCESS(f'✓ Deleted {count} existing entries'))
        
        # Load JSON data
        self.stdout.write('\nLoading JSON file...')
        try:
            with open(json_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            self.stdout.write(self.style.SUCCESS(f'✓ Loaded {len(data)} entries from JSON'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'✗ Error loading JSON: {e}'))
            return
        
        # Initialize RAG service
        self.stdout.write('\nInitializing RAG service...')
        try:
            rag_service = get_rag_service()
            self.stdout.write(self.style.SUCCESS('✓ RAG service initialized'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'✗ Error initializing RAG: {e}'))
            self.stdout.write(self.style.WARNING(
                '\nMake sure you have installed: pip install chromadb sentence-transformers'
            ))
            return
        
        # Process and add documents
        documents_for_rag = []
        textbook_objects = []
        skipped = 0
        
        self.stdout.write('\nProcessing documents...')
        
        for idx, entry in enumerate(data, 1):
            # YOUR JSON STRUCTURE:
            # {
            #   "source": "Government School Textbook",
            #   "class": "Class 1",
            #   "subject": "English",
            #   "chapter": "chapter1",
            #   "text": "..."
            # }
            
            # Skip empty text entries
            text_content = entry.get('text', '').strip()
            if not text_content:
                skipped += 1
                continue
            
            # Generate unique ID
            embedding_id = str(uuid.uuid4())
            
            # Extract fields from YOUR JSON
            source = entry.get('source', 'Unknown')
            class_level = entry.get('class', 'Unknown')  # "Class 1"
            subject = entry.get('subject', 'Unknown')     # "English"
            chapter = entry.get('chapter', 'Unknown')     # "chapter1"
            
            # Prepare metadata for ChromaDB
            metadata = {
                'source': source,
                'class_level': class_level,
                'subject': subject,
                'chapter': chapter,
            }
            
            # Create TextbookContent object for Django DB
            textbook_obj = TextbookContent(
                source=source,
                class_level=class_level,
                subject=subject,
                chapter=chapter,
                content=text_content,
                embedding_id=embedding_id,
                metadata=metadata
            )
            textbook_objects.append(textbook_obj)
            
            # Prepare document for RAG (ChromaDB)
            rag_doc = {
                'id': embedding_id,
                'text': text_content,
                'metadata': metadata
            }
            documents_for_rag.append(rag_doc)
            
            # Progress indicator
            if idx % 50 == 0:
                self.stdout.write(f'  Processed: {idx}/{len(data)}')
        
        self.stdout.write(self.style.SUCCESS(
            f'✓ Processed {len(textbook_objects)} documents (skipped {skipped} empty)'
        ))
        
        # Save to Django database
        self.stdout.write('\nSaving to Django database...')
        try:
            TextbookContent.objects.bulk_create(textbook_objects, batch_size=100)
            self.stdout.write(self.style.SUCCESS(
                f'✓ Saved {len(textbook_objects)} documents to database'
            ))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'✗ Error saving to database: {e}'))
            return
        
        # Add to RAG system (ChromaDB with vectors)
        self.stdout.write('\nAdding to vector database (ChromaDB)...')
        self.stdout.write('  This may take a few minutes...')
        try:
            # Add in batches to avoid memory issues
            batch_size = 50
            total_batches = (len(documents_for_rag) + batch_size - 1) // batch_size
            
            for i in range(0, len(documents_for_rag), batch_size):
                batch = documents_for_rag[i:i+batch_size]
                rag_service.add_documents(batch)
                current_batch = i // batch_size + 1
                self.stdout.write(f'  Batch {current_batch}/{total_batches} completed')
            
            self.stdout.write(self.style.SUCCESS(
                f'✓ Added {len(documents_for_rag)} documents to vector database'
            ))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'✗ Error adding to RAG: {e}'))
            return
        
        # Get final stats
        stats = rag_service.get_collection_stats()
        
        # Success summary
        self.stdout.write('\n' + '='*70)
        self.stdout.write(self.style.SUCCESS('🎉 DATA LOADING COMPLETE!'))
        self.stdout.write('='*70)
        self.stdout.write(f'📊 Total documents in system: {stats["total_documents"]}')
        self.stdout.write(f'📁 Collection name: {stats["collection_name"]}')
        self.stdout.write('='*70)
        self.stdout.write('\n✅ Your RAG system is now ready!')
        self.stdout.write('✅ No model training needed - using pre-trained embeddings')
        self.stdout.write('✅ You can now use the AI tutor API\n')
        self.stdout.write('Next steps:')
        self.stdout.write('  1. Run: python manage.py runserver')
        self.stdout.write('  2. Test the API at: http://localhost:8000/api/ai-tutor/')
        self.stdout.write('='*70)