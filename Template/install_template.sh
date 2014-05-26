#!/bin/sh
mkdir -p ~/Library/Developer/Xcode/Templates/Project\ Templates/Cegeka
cd ~/Library/Developer/Xcode/Templates/Project\ Templates/Cegeka
curl -LO "https://github.com/cegeka/BuildEnvironment/raw/master/Template/Basic%20Application.xctemplate.zip"
unzip "Basic%20Application.xctemplate.zip"
rm -f "Basic%20Application.xctemplate.zip"