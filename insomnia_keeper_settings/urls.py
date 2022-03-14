
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path

from insomnia_keeper_main.api_v1.views import build

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('insomnia_keeper_main.urls')),
]

urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

print(settings.MEDIA_URL, settings.MEDIA_ROOT)

urlpatterns += [
    path('', build, name='build'),
    path('<path:resource>', build, name='build'),
]
