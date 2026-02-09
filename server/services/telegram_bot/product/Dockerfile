FROM python:3.11-slim

RUN python -m pip install --upgrade pip

RUN pip install python-telegram-bot 

COPY server/services/telegram_bot/product/ .

CMD ["python", "App.py"]


