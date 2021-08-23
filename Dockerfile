FROM python:3.8-slim-buster

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    tzdata \
    ca-certificates \
    && echo "America/Mexico_City" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && echo 'LANG="en_US.UTF-8"'>/etc/default/locale \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime

COPY ["requirements.txt", "/tsc/"]

WORKDIR /tsc

RUN pip install -r requirements.txt

COPY [".", "/tsc/"]

EXPOSE 80

CMD ["jupyter", "notebook", "--ip='*'", "--port=80","--no-browser", "--allow-root"]
