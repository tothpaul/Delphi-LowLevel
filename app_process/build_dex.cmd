SET JDK=C:\Program Files\Java\jdk1.7.0_25\bin
SET SDK=C:\Users\Public\Documents\Embarcadero\Studio\19.0\PlatformSDKs\android-sdk-windows
SET NDK=C:\Users\Public\Documents\Embarcadero\Studio\19.0\PlatformSDKs\android-ndk-r9c
SET BSD=C:\Program Files (x86)\Embarcadero\Studio\19.0

SET TOOLS=%SDK%\build-tools\22.0.1
SET ADB=%SDK%\platform-tools\adb

@ECHO Compilation JAVA
@mkdir obj
del obj\*.class
"%JDK%\javac.exe" test.java -d obj
"%JDK%\javac.exe" hello.java -d obj

@ECHO JAVA to DEX
@mkdir apk
del apk\*.dex
call "%TOOLS%\dx" --dex --output=.\apk\classes.dex obj

:delphi
SET DCC=%BSD%\bin\dccaarm.exe
SET LNK=%NDK%\toolchains\arm-linux-androideabi-4.6\prebuilt\windows\bin\arm-linux-androideabi-ld.exe
SET LIB=%BSD%\lib\Android\Release;%NDK%\platforms\android-14\arch-arm\usr\lib;%NDK%\sources\cxx-stl\gnu-libstdc++\4.8\libs\armeabi-v7a

@mkdir lib
del lib\*.so
"%DCC%" -$O- --no-config -M -Q -TX.so -E.\lib -U"%BSD%\lib\Android\Release" hello.dpr "--libpath:%LIB%" "--linker:%LNK%" -V -VN 

@ECHO SEND to ANDROID
"%ADB%" push apk\classes.dex /data/local/tmp/test.dex
"%ADB%" push lib\libhello.so /data/local/tmp/libhello.so

@ECHO Start application
"%ADB%" shell CLASSPATH=/data/local/tmp/test.dex LD_LIBRARY_PATH=/data/local/tmp app_process / test param1 param2

echo "DONE!"