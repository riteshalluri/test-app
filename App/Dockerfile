FROM python:3.7

RUN mkdir /app
WORKDIR /app
ADD . /app/
RUN pip install -r flask

ENV DATABASE_URI="localhost"
ENV FLASK_APP=app.py

EXPOSE 5000
CMD ["python", "/app/app.py"]