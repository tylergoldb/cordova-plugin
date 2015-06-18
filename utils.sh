SDK_VERSION=9.0.2
function update(){
	sed -i "" -e "s/SDK_VERSION = @\".*;/SDK_VERSION = @\"$SDK_VERSION\";/g" ./src/ios/RevMobPlugin.m
	sed -i "" -e "s/SDK_VERSION = \".*/SDK_VERSION = \"$SDK_VERSION\";/g" ./src/android/RevMobPlugin.java
	echo Updated version: $SDK_VERSION
}

# call arguments verbatim:
$@