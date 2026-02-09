FROM python:3.11-slim

RUN pip install python-telegram-bot 

RUN python -m pip install --upgrade pip

RUN pip install fastapi[all]
RUN pip install uvicorn
RUN pip install pillow
RUN pip install pymongo
RUN pip install minio
RUN pip install requests

WORKDIR /server/

COPY . .

# ENV EXAMPLE="example"

# Use only one CMD instruction; combine echo and python if needed
CMD echo ${EXAMPLE} && python App.py


