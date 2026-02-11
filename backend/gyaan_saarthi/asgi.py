"""
ASGI config for gyaan_saarthi project.
"""

import os
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'gyaan_saarthi.settings')

application = get_asgi_application()