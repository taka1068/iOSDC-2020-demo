# iOSDC-2020-demo

This is the demo code for talk "Grand Central Dispatchによる並行アルゴリズム入門" at iOSDC Japan 2020.
You can find details about the talk (in Japanese): https://fortee.jp/iosdc-japan-2020/proposal/6189eb33-5c9b-44c1-afc1-0ef479d505aa

## How to run

Make sure you have installed Swift 5.2 or 5.3.

```
$ git clone 'https://github.com/taka1068/iOSDC-2020-demo.git'
$ cd iOSDC-2020-demo
$ cd demo
$ swift run
```

If you want to compile with optimization, run with

```
$ swift run -Xswiftc -O
```

## Supported Swift Version

- This demo code is compatible with Swift 5.2 and 5.3.

## Acknowledgements

- https://github.com/objcio/S01E90-concurrent-map
    - Concept of concurrent map
    - Some benchmark codes
- https://www.isus.jp/products/vtune/pu38-02-detecting-and-mitigating-false- sharing/
    - False sharing

