FROM ubuntu:latest

RUN apt update -y > /dev/null 2>&1 \
    && apt upgrade -y > /dev/null 2>&1 \
    && apt install locales -y \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8
ARG NGROK_TOKEN
ENV NGROK_TOKEN=${NGROK_TOKEN}

RUN apt install python3 python3-pip -y > /dev/null 2>&1
RUN pip3 install Flask > /dev/null 2>&1

# Flask web server script
RUN echo "from flask import Flask\n" \
         "app = Flask(__name__)\n" \
         "\n" \
         "@app.route('/')\n" \
         "def hello():\n" \
         "    return 'Hello, Cyclic!'\n" \
         "\n" \
         "if __name__ == '__main__':\n" \
         "    app.run(host='0.0.0.0', port=80)\n" \
         > /app.py

EXPOSE 80

CMD ["python3", "/app.py"]
