# Really Tiny HotCorner for Windows 10

from the [C source by Tavis Ormandy](https://github.com/taviso/hotcorner), I've made a Delphi version of his almost tiny C tool :)

the C version 1.4 released on 16 May 2017 weighs 74 240 bytes, only 51 712 bytes for the Delphi Rio version :)

it could be even smaller, but that requires to patch the System unit.

oh wait ! I've forgot to add two compiler switches
```
{$WEAKLINKRTTI ON}
{$SETPEFLAGS 1}
```

now the exe is only 40 448 bytes :)