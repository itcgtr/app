FROM python:3.11-slim

RUN python -m pip install --upgrade pip

RUN pip install python-telegram-bot 

WORKDIR /service/

COPY server/services/telegram_bot/stage/ .

CMD ["python", "App.py"]