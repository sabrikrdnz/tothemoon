
# using ubuntu LTS version
FROM alpine:3.16 AS builder-image

RUN apk update && apk add --update --no-cache python3 python3-dev py3-virtualenv py3-pip py3-wheel build-base py3-mysqlclient

# create and activate virtual environment
# using final folder name to avoid path issues with packages
RUN python3 -m venv /home/tothemoon/venv
ENV PATH="/home/tothemoon/venv/bin:$PATH"

RUN python3 -m pip install --upgrade pip
# install requirements
COPY requirements.txt .
RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir -r requirements.txt

FROM alpine:3.16 AS runner-image
RUN apk update && apk add --update --no-cache python3 py3-virtualenv

RUN adduser -D tothemoon
COPY --from=builder-image /home/tothemoon/venv /home/tothemoon/venv

USER tothemoon
RUN mkdir /home/tothemoon/code
WORKDIR /home/tothemoon/code
COPY . .

EXPOSE 3000

# make sure all messages always reach console
ENV PYTHONUNBUFFERED=1

# activate virtual environment
ENV VIRTUAL_ENV=/home/tothemoon/venv
ENV PATH="/home/tothemoon/venv/bin:$PATH"

# /dev/shm is mapped to shared memory and should be used for gunicorn heartbeat
# this will improve performance and avoid random freezes
CMD ["gunicorn","-b", "0.0.0.0:3000", "-w", "4", "-k", "gevent", "--worker-tmp-dir", "/dev/shm", "app:app"]
