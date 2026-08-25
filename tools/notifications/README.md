# Notificaciones de ventas con Python

El script recibe manualmente un ID de `transactions`, consulta `userId`,
`amount` y `currency`, obtiene los tokens desde `user_devices/{userId}` y envia
una notificacion FCM. Al tocarla, Flutter abre el detalle y vuelve a cargar la
transaccion desde Firestore.

## Preparacion

1. Despliega las reglas actualizadas:

```powershell
firebase deploy --only firestore:rules
```

2. Descarga una cuenta de servicio desde Firebase Console > Configuracion del
   proyecto > Cuentas de servicio. Guarda el JSON fuera del repositorio.

3. Ejecuta el script con `uv`, disponible en este equipo. `uv` crea un entorno
    aislado e instala la version indicada en `requirements.txt`:

```powershell
$uv = "$env:USERPROFILE\.local\bin\uv.exe"
& $uv run --with-requirements tools\notifications\requirements.txt `
   python tools\notifications\send_sale_notification.py --help
```

4. Inicia sesion en la app y acepta las notificaciones. Esto crea
   `user_devices/{uid}` con `fcmTokens`.

5. Ejecuta el envio con un ID real de `transactions`:

```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS = "C:\ruta\service-account.json"
& $uv run --with-requirements tools\notifications\requirements.txt `
   python tools\notifications\send_sale_notification.py SALE_ID
```

Para validar Firestore y el mensaje sin enviarlo a FCM:

```powershell
& $uv run --with-requirements tools\notifications\requirements.txt `
   python tools\notifications\send_sale_notification.py SALE_ID --dry-run
```