FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
            wget \
            ca-certificates \
 && dpkg --add-architecture i386 \
 && echo 'deb http://dl.winehq.org/wine-builds/ubuntu/ xenial main' > /etc/apt/sources.list.d/winehq.list \
 && wget 'https://dl.winehq.org/wine-builds/Release.key' -O- | apt-key add \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
            winehq-staging \
            zenity \
 && apt-get clean \
 && wget  -O /usr/local/bin/winetricks 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks' \
 && chmod +x /usr/local/bin/winetricks

ENV WINEPREFIX /opt/wine
ENV WINEARCH   win32
ENV WINEDEBUG  fixme-all

ENV PATH /opt/bin:${PATH}

ARG PYTHON_VERSION=2.7.13

RUN wget "https://www.python.org/ftp/python/$PYTHON_VERSION/python-$PYTHON_VERSION.msi" -O python2.msi \
 && wine msiexec /qn /i python2.msi \
 && rm python2.msi \
 && sed -i 's/_windows_cert_stores = .*/_windows_cert_stores = ("ROOT",)/' "$WINEPREFIX/drive_c/Python27/Lib/ssl.py" \
 && mkdir -p /opt/bin \
 && echo 'wine C:\\\\Python27\\\\python.exe "$@"' > /opt/bin/python \
 && echo 'wine C:\\\\Python27\\\\python.exe -m pip "$@"' > /opt/bin/pip \
 && chmod +x /opt/bin/* \
 && pip install -U pip \
 && echo 'assoc .py=PythonScript' | wine cmd > /dev/null \
 && echo 'ftype PythonScript=C:\Python27\python.exe "%1" %*' | wine cmd > /dev/null \
 && while pgrep wineserver >/dev/null; do echo "Waiting for wineserver..."; sleep 1; done \
 && rm -rf /tmp/.wine-*

WORKDIR /opt/wine/drive_c
