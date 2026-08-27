import argparse
import os
from collections.abc import Iterator
from typing import Optional

import firebase_admin
from firebase_admin import credentials, firestore, messaging


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Envia una notificacion FCM para una venta de Firestore."
    )
    parser.add_argument("sale_id", help="ID del documento en transactions")
    parser.add_argument(
        "--credentials",
        help=(
            "Ruta al JSON de cuenta de servicio. Tambien puede usar "
            "GOOGLE_APPLICATION_CREDENTIALS."
        ),
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Consulta Firestore y muestra el envio sin contactar FCM.",
    )
    return parser.parse_args()


def initialize_firebase(credentials_path: Optional[str]) -> None:
    path = credentials_path or os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    credential = (
        credentials.Certificate(path) if path else credentials.ApplicationDefault()
    )
    firebase_admin.initialize_app(credential)


def chunks(values: list[str], size: int = 500) -> Iterator[list[str]]:
    for index in range(0, len(values), size):
        yield values[index : index + size]


def send_sale_notification(sale_id: str, dry_run: bool = False) -> None:
    database = firestore.client()
    sale_snapshot = database.collection("transactions").document(sale_id).get()
    if not sale_snapshot.exists:
        raise ValueError(f"No existe transactions/{sale_id}")

    sale = sale_snapshot.to_dict() or {}
    user_id = sale.get("userId")
    if not user_id:
        raise ValueError("La transaccion no contiene userId")

    devices_snapshot = database.collection("user_devices").document(user_id).get()
    devices = devices_snapshot.to_dict() if devices_snapshot.exists else {}
    tokens = list(dict.fromkeys(devices.get("fcmTokens", [])))
    if not tokens:
        raise ValueError(f"El usuario {user_id} no tiene tokens FCM registrados")

    amount = float(sale.get("amount", 0))
    currency = str(sale.get("currency", "USD"))
    title = "Compra confirmada"
    body = f"Tu compra por {amount:.2f} {currency} fue registrada."
    route = f"/transaction-detail/{sale_id}"

    if dry_run:
        print(
            f"DRY RUN: {title} | {body} | venta={sale_id} | tokens={len(tokens)}"
        )
        return

    invalid_tokens: list[str] = []
    success_count = 0
    failure_count = 0

    for token_group in chunks(tokens):
        message = messaging.MulticastMessage(
            tokens=token_group,
            notification=messaging.Notification(title=title, body=body),
            data={
                "type": "sale_detail",
                "saleId": sale_id,
                "transactionId": sale_id,
                "route": route,
                "amount": f"{amount:.2f}",
                "currency": currency,
            },
            android=messaging.AndroidConfig(
                priority="high",
                notification=messaging.AndroidNotification(sound="default"),
            ),
            apns=messaging.APNSConfig(
                payload=messaging.APNSPayload(aps=messaging.Aps(sound="default"))
            ),
        )
        response = messaging.send_each_for_multicast(message)
        success_count += response.success_count
        failure_count += response.failure_count

        for index, (token, result) in enumerate(
            zip(token_group, response.responses), start=1
        ):
            if result.success:
                continue

            exception = result.exception
            error_code = getattr(exception, "code", None)
            print(
                "FCM rechazo el token "
                f"#{index}: tipo={type(exception).__name__}, "
                f"codigo={error_code}, detalle={exception}"
            )

            if isinstance(
                exception,
                (messaging.UnregisteredError, messaging.SenderIdMismatchError),
            ):
                invalid_tokens.append(token)

    if invalid_tokens:
        database.collection("user_devices").document(user_id).update(
            {"fcmTokens": firestore.ArrayRemove(invalid_tokens)}
        )
        print(f"Se eliminaron {len(invalid_tokens)} tokens FCM invalidos.")

    print(f"Envio terminado: {success_count} exitosos, {failure_count} fallidos")


def main() -> None:
    args = parse_args()
    initialize_firebase(args.credentials)
    send_sale_notification(args.sale_id, args.dry_run)


if __name__ == "__main__":
    main()
