#!/bin/sh
# Android Duo 1.0 - Zalo build. Needs: java 17+, python3, morphe-desktop-2.3.0-all.jar, zsplit.jks
# BASE = Zalo-v26.11.01-ZSplit-v0.6.apk (classes.dex already carries the b.C0/b.r0 hooks and addView/removeView redirects; src/zalo/classes.patched.dex is that dex)
J=${J:-morphe-desktop-2.3.0-all.jar}; BASE=${BASE:-Zalo-v26.11.01-ZSplit-v0.6.apk}; KS=${KS:-zsplit.jks}
grep -v "ZSplit;->dlog(Ljava/util/ArrayList;Landroid/view/View;II)V" src/zalo/ZSplit.smali | grep -v "^    invoke-static {v0, v2, v4, v14}, Lcom/zing/zalo/zsplit/ZSplit;->dlog" > /tmp/ZSplitRel.smali
cd src/zalo && java -cp ../../$J ../../tools/Asm.java /tmp/c10.dex /tmp/ZSplitRel.smali ZRetry.smali ZFix.smali ZOutline.smali ZBack.smali ZGlass.smali ZDrag.smali ZFore.smali && cd ../..
python3 tools/rezip.py $BASE /tmp/z.u.apk classes.dex=src/zalo/classes.patched.dex classes10.dex=/tmp/c10.dex assets/dexopt/baseline.prof=- assets/dexopt/baseline.profm=-
java -cp $J tools/Sign.java /tmp/z.u.apk Zalo-AndroidDuo-build.apk $KS
