FROM python:3.11-slim

RUN python -m pip install --upgrade pip


RUN pip install fastapi[all]
RUN pip install uvicorn
RUN pip install pillow
RUN pip install pymongo
RUN pip install minio
RUN pip install requests
RUN pip install python-telegram-bot
RUN pip install python-dotenv


COPY server/ server/
COPY Environment.py Environment.py


EXPOSE 8000


# CMD ["uvicorn", "server.App:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]

