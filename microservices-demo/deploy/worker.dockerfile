## Alpine Based
# FROM python:3.10-alpine
# RUN apk add gcc python3-dev musl-dev linux-headers
# ADD worker/app/requirements.txt /app/
# WORKDIR /app
# RUN pip install --no-cache-dir --upgrade -r requirements.txt
# ADD worker/app/* /app/
# CMD ["/usr/local/bin/python", "-u", "main.py"]

## Debian Based
FROM python:3.10-bookworm
ADD worker/app/requirements.txt /app/
WORKDIR /app
RUN pip install --no-cache-dir --upgrade -r requirements.txt
ADD worker/app/* /app/
CMD ["/usr/local/bin/python", "-u", "main.py"]