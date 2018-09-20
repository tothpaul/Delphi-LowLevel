# app_process

with ADB and app_process it's possible to start a Java (Dalvik) application as a console application.

+ test.java is the entry point, it's a standard Java application with arguments and System.out (WriteLn) outputs.
+ hello.java is a wrapper to libhello.so
+ hello.dpr is the Delphi source code of libhello.so
+ build.cmd can build all this with the following requirements
+ build_dex.cmd is the same but do not use an APK

1. JDK 1.7.0_25 (see SET JDK) - warning ! you can not use version 1.8 or the compilation will fail
2. Android SDK (see SET SDK) - I use Delphi Tokyo SDK
3. Android NDK (see SET NDK) - I use Delphi Tokyo NDK
4. Embarcedero Delphi (see SET BSD) - I use Delphi Tokyo, you'll need at least the Community Edition.
 
If you start Build.cmd you should have something like that
```
>SET JDK=C:\Program Files\Java\jdk1.7.0_25\bin 
>SET SDK=C:\Users\Public\Documents\Embarcadero\Studio\19.0\PlatformSDKs\android-sdk-windows 
>SET NDK=C:\Users\Public\Documents\Embarcadero\Studio\19.0\PlatformSDKs\android-ndk-r9c 
>SET BSD=C:\Program Files (x86)\Embarcadero\Studio\19.0 
>SET TOOLS=C:\Users\Public\Documents\Embarcadero\Studio\19.0\PlatformSDKs\android-sdk-windows\build-tools\22.0.1 
>SET ADB=C:\Users\Public\Documents\Embarcadero\Studio\19.0\PlatformSDKs\android-sdk-windows\platform-tools\adb 
Compilation JAVA
>del obj\*.class 
>"C:\Program Files\Java\jdk1.7.0_25\bin\javac.exe" test.java -d obj 
>"C:\Program Files\Java\jdk1.7.0_25\bin\javac.exe" hello.java -d obj 
JAVA to DEX
>del apk\*.dex 
>call "C:\Users\Public\Documents\Embarcadero\Studio\19.0\PlatformSDKs\android-sdk-windows\build-tools\22.0.1\dx" --dex --output=.\apk\classes.dex obj 
Embarcadero Delphi for Android compiler version 32.0
Copyright (c) 1983,2017 Embarcadero Technologies, Inc.
Linker command line: C:\Users\Public\Documents\Embarcadero\Studio\19.0\PlatformSDKs\android-ndk-r9c\toolchains\arm-linux-androideabi-4.6\prebuilt\windows\bin\arm-linux-androideabi-ld.exe -o .\\lib\\libhello.so --gc-sections --version-script .\\lib\\hello.vsr -shared --no-undefined -z noexecstack -z relro -z now -L "C:\\Program Files (x86)\\Embarcadero\\Studio\\19.0\\lib\\Android\\Release" -L C:\\Users\\Public\\Documents\\Embarcadero\\Studio\\19.0\\PlatformSDKs\\android-ndk-r9c\\platforms\\android-14\\arch-arm\\usr\\lib -L C:\\Users\\Public\\Documents\\Embarcadero\\Studio\\19.0\\PlatformSDKs\\android-ndk-r9c\\sources\\cxx-stl\\gnu-libstdc++\\4.8\\libs\\armeabi-v7a C:\\Users\\Public\\Documents\\Embarcadero\\Studio\\19.0\\PlatformSDKs\\android-ndk-r9c\\platforms\\android-14\\arch-arm\\usr\\lib\\crtbegin_so.o @.\\lib\\hello.lnk -ldl -lc -lm -lrtlhelper -landroid -lcompiler_rt -rpath $ORIGIN C:\\Users\\Public\\Documents\\Embarcadero\\Studio\\19.0\\PlatformSDKs\\android-ndk-r9c\\platforms\\android-14\\arch-arm\\usr\\lib\\crtend_so.o
15 lignes, 0.11 secondes.
DEX to APK
Processing raw dir 'apk'
Found 1 asset file in apk
Configurations:
 (default)

Files:
  classes.dex
    Src: () apk\classes.dex

Resource Dirs:
Opening 'test.apk'
Writing all files...
      'classes.dex' (compressed 43%)
Generated 1 file
Included 0 files from jar/zip files.
Checking for deleted files
Done!
SEND to ANDROID
[100%] /data/local/tmp/test.apk
test.apk: 1 file pushed. 0.2 MB/s (912 bytes in 0.005s)
[ 12%] /data/local/tmp/libhello.so
[ 24%] /data/local/tmp/libhello.so
[ 36%] /data/local/tmp/libhello.so
[ 48%] /data/local/tmp/libhello.so
[ 60%] /data/local/tmp/libhello.so
[ 72%] /data/local/tmp/libhello.so
[ 84%] /data/local/tmp/libhello.so
[ 97%] /data/local/tmp/libhello.so
[100%] /data/local/tmp/libhello.so
lib\libhello.so: 1 file pushed. 3.6 MB/s (540180 bytes in 0.143s)
Start application
ready

ArgCount = 2
Args[0] = param1
Args[1] = param2
WARNING: linker: /data/local/tmp/libhello.so: unused DT entry: type 0xf arg 0xfe0
1 + 2 = 3
bye.

"DONE!"
```

Unfortunatly, I did not found a way to put libhello.so inside the APK (move the .so file to the APK directory to test)
```
09-20 10:29:41.483: E/AndroidRuntime(23450): java.lang.UnsatisfiedLinkError: dalvik.system.PathClassLoader[DexPathList[[zip file "/data/local/tmp/test.apk"],nativeLibraryDirectories=[/vendor/lib, /system/lib]]] couldn't find "libhello.so"
```

Since the APK contains only the dex file, build_dex.cmd can be used to send the dex file instead of an APK :)