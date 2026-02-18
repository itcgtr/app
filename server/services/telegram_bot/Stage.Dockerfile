FROM python:3.11-slim

RUN python -m pip install --upgrade pip

RUN pip install python-telegram-bot 

# COPY server/services/telegram_bot/ server/services/telegram_bot/
COPY server/services/telegram_bot/App.py server/services/telegram_bot/App.py

COPY Environment.py Environment.py

