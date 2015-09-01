function RevMob(appId) {
	this.appId = appId;
	this.TEST_DISABLED = 0;
	this.TEST_WITH_ADS = 1;
	this.TEST_WITHOUT_ADS = 2;

	this.startSession = function(successCallback, errorCallback) {
    	cordova.exec(successCallback, errorCallback, "RevMobPlugin", "startSession", [appId]);
  	}

	this.showFullscreen = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showFullscreen", []);
	}

	this.loadFullscreen = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "loadFullscreen", []);
	}

	this.showLoadedFullscreen = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showLoadedFullscreen", []);
	}

	this.loadVideo = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "loadVideo", []);
	}

	this.showVideo = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showVideo", []);
	}

	this.loadRewardedVideo = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "loadRewardedVideo", []);
	}

	this.showRewardedVideo = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showRewardedVideo", []);
	}

	this.openButton = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "openButton", []);
	}

	this.openLink = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "openLink", []);
	}

	this.showPopup = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showPopup", []);
	}

	this.showBanner = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showBanner", []);
	}

	this.hideBanner = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "hideBanner", []);
	}

	this.showCustomBanner = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showCustomBanner", []);
	}

	this.showCustomBannerPos = function(x, y, w, h, successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showCustomBannerPos", [x,y,w,h]);
	}

	this.hideCustomBanner = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "hideCustomBanner", []);
	}

	this.setTestingMode = function(testingMode) {
		cordova.exec(null, null, "RevMobPlugin", "setTestingMode", [testingMode]);
	}

	this.printEnvironmentInformation = function() {
		cordova.exec(null, null, "RevMobPlugin", "printEnvironmentInformation", []);
	}

	this.setTimeoutInSeconds = function(seconds) {
		cordova.exec(null, null, "RevMobPlugin", "setTimeoutInSeconds", [seconds]);
	}
}

module.exports = RevMob
