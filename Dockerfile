#
# Lama Cleaner Dockerfile
# @author Loreto Parisi (loretoparisi at gmail dot com)
#

FROM python:3.8.13-slim-bullseye

LABEL maintainer Loreto Parisi loretoparisi@gmail.com

WORKDIR app

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    libsm6 libxext6 ffmpeg libfontconfig1 libxrender1 libgl1-mesa-glx \
    curl \
    npm

# python requirements

RUN pip install torch>=1.8.2 opencv-python flask_cors flask==1.1.4 flaskwebgui tqdm pydantic loguru pytest markupsafe==2.0.1

# nodejs
RUN npm install n -g && \
    n lts
# yarn
RUN npm install -g yarn

# webapp
RUN set -x; \
    curl -SL -o lama-cleaner.tar.gz https://github.com/Sanster/lama-cleaner/archive/refs/tags/0.14.0.tar.gz  \
    && mkdir -p lama_cleaner/app/ \
    && tar xvf lama-cleaner.tar.gz -C lama_cleaner --strip-components=1 \
    && rm lama-cleaner.tar.gz
    
RUN cd lama_cleaner/lama_cleaner/app/ && \
    yarn && \
    yarn build

EXPOSE 8080

CMD ["bash"]
