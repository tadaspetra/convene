#!/bin/bash
flutter clean

cd lib
flutter packages pub upgrade
flutter pub run build_runner build --delete-conflicting-outputs

cd ..
cd packages

for d in */ ; do
    cd $d
    flutter packages pub upgrade
    flutter pub run build_runner build --delete-conflicting-outputs
    cd ..
done