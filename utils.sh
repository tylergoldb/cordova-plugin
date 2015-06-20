function update(){
	sed -i "" -e "s/SDK_VERSION = @\".*;/SDK_VERSION = @\"$1\";/g" ./src/ios/RevMobPlugin.m
	sed -i "" -e "s/SDK_VERSION = \".*/SDK_VERSION = \"$1\";/g" ./src/android/RevMobPlugin.java
	echo Updated Cordova version: $1
}

# call arguments verbatim:
$@