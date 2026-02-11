"""
WSGI config for gyaan_saarthi project.
"""

import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'gyaan_saarthi.settings')

application = get_wsgi_application()