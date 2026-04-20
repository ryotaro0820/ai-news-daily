#!/usr/bin/env python3
import os
import sys
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from pathlib import Path


def send_news_email(news_file: str, date: str) -> None:
    gmail_user = os.environ["GMAIL_USER"]
    gmail_password = os.environ["GMAIL_APP_PASSWORD"]
    recipient = os.environ["RECIPIENT_EMAIL"]

    content = Path(news_file).read_text(encoding="utf-8")

    msg = MIMEMultipart()
    msg["Subject"] = f"AI ニュースまとめ — {date}"
    msg["From"] = gmail_user
    msg["To"] = recipient
    msg.attach(MIMEText(content, "plain", "utf-8"))

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(gmail_user, gmail_password)
        server.sendmail(gmail_user, recipient, msg.as_string())


if __name__ == "__main__":
    send_news_email(sys.argv[1], sys.argv[2])
    print(f"Email sent: {sys.argv[2]}")
