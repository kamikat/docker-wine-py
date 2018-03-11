# wine-py

Running Python for Windows in Docker.

## Usage

```
$ docker run -it --rm kamikat/wine-py:2.7 bash
# python -c 'print 1 + 1'
2
# pip install pyinstaller
...
```

## Use GUI

1. Enable TCP support for Xserver (Xorg/XQuartz/...), it will be listening on TCP 6000.
2. Open terminal and `xhost <addr-to-bind>`（use `xhost +` to accept connection from any client).
3. `docker run -it --rm -e DISPLAY=<ip-addr>:6000 kamikat/wine-py:2.7 bash`.
4. Run GUI program with `wine <executable>`.

#### Note for XQuartz

TCP support can be enabled by `defaults write org.macosforge.xquartz.X11 nolisten_tcp 0`.
Then quit XQuartz to take effect.

## License

(The MIT License)

