#!/bin/sh
# Android Duo 1.0 - Facebook 588.0.0.42.55 build. Needs: java 17+, python3, morphe-desktop-2.3.0-all.jar, zsplit.jks
# BASE   = base.apk "v1" (already carries the X.01Bu hooks -> FSplit.install / FSplit.isWide in classes2.dex)
# SPLITS = folder with the original split_*.apk files pulled from the phone (adb shell pm path com.facebook.katana)
J=${J:-morphe-desktop-2.3.0-all.jar}; BASE=${BASE:-base.v1.apk}; SPLITS=${SPLITS:-fb-splits}; KS=${KS:-zsplit.jks}
T=${TMPDIR:-/tmp}/fbduo; rm -rf $T; mkdir -p $T/merge
unzip -o -q $BASE classes2.dex classes6.dex -d $T
# 1. no Activity recreate when the window is resized (fold/unfold)
java -cp $J tools/Patch.java $T/classes2.dex $T/c2.dex "Lcom/facebook/katana/activity/FbMainTabActivityDelegate;" shouldRecreateOnWindowResize false
java -cp $J tools/Patch.java $T/classes6.dex $T/c6.dex "LX/0AkX;" onConfigurationChanged norecreate
# 2. FSplit classes -> classes32.dex
java -cp $J tools/Asm.java $T/c32.dex src/facebook/FSplit.smali src/facebook/L.smali src/facebook/N.smali src/facebook/R.smali
# 3. repack base, merge with splits into one APK, sign
python3 tools/rezip.py $BASE $T/merge/base.apk classes2.dex=$T/c2.dex classes6.dex=$T/c6.dex classes32.dex=$T/c32.dex
cp $SPLITS/split_*.apk $T/merge/
java -cp $J tools/MergeApk.java $T/merge $T/merged.apk
java -cp $J tools/Sign.java $T/merged.apk Facebook-AndroidDuo-build.apk $KS
