package com.revmob.cordova.plugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.revmob.RevMob;
import com.revmob.RevMobAdsListener;
import com.revmob.RevMobTestingMode;
import com.revmob.ads.fullscreen.RevMobFullscreen;
import com.revmob.client.RevMobClient;


public class RevMobPlugin extends CordovaPlugin {
	private RevMob revmob;
	private RevMobFullscreen video, fullscreen, rewardedVideo;
	public static final String SDK_NAME = "cordova-android";
	public static final String SDK_VERSION = "9.0.3";
	private CallbackContext lastCallbackContext = null;
	
	RevMobAdsListener revmobListener = new RevMobAdsListener() {
		public void onRevMobAdReceived() {
			eventCallbackSuccess("AD_RECEIVED");
		}
		public void onRevMobAdNotReceived(String message) {
			eventCallbackError(message);
		}
		public void onRevMobAdDismissed() {
			eventCallbackSuccess("AD_DISMISSED");
		}
		public void onRevMobAdClicked() {
			eventCallbackSuccess("AD_CLICKED");
		}
		public void onRevMobAdDisplayed() {
			eventCallbackSuccess("AD_DISPLAYED");
		}
		public void onRevMobEulaIsShown() {
			eventCallbackSuccess("EULA_DISPLAYED");
		}
		public void onRevMobEulaWasAcceptedAndDismissed() {
			eventCallbackSuccess("EULA_ACCEPTED");
		}
		public void onRevMobEulaWasRejected() {
			eventCallbackSuccess("EULA_REJECTED");	
		}
		public void onRevMobSessionIsStarted() {
			eventCallbackSuccess("SESSION_STARTED");
		}
		public void onRevMobSessionNotStarted(String message) {
			eventCallbackError(message);
		}    
	    public void onRevMobVideoLoaded(){
	    	eventCallbackSuccess("VIDEO_LOADED");
	    }
	    public void onRevMobVideoNotCompletelyLoaded(){
	    	eventCallbackSuccess("VIDEO_NOT_LOADED");
	    }
	    public void onRevMobVideoStarted(){
	    	eventCallbackSuccess("VIDEO_STARTED");
	    }  
		public void onRevMobVideoFinished(){
			eventCallbackSuccess("VIDEO_FINISHED");
		}
		public void onRevMobRewardedVideoLoaded(){
	    	eventCallbackSuccess("REWARDED_VIDEO_LOADED");
	    }
	    public void onRevMobRewardedVideoNotCompletelyLoaded(){
	    	eventCallbackSuccess("REWARDED_VIDEO_NOT_LOADED");
	    }
	    public void onRevMobRewardedVideoStarted(){
	    	eventCallbackSuccess("REWARDED_VIDEO_STARTED");
	    }  
		public void onRevMobRewardedPreRollDisplayed(){
			eventCallbackSuccess("REWARDED_PRE_ROLL_DISPLAYED");
		}
		public void onRevMobRewardedVideoCompleted(){
			eventCallbackSuccess("REWARDED_VIDEO_COMPLETED");
		}
		public void onRevMobRewardedVideoFinished(){
			eventCallbackSuccess("REWARDED_VIDEO_FINISHED");
		}
	};

	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {        
		Log.i("[RevMobPlugin]", action);
		
		if (action.equals("startSession")) {
			setCallbackContext(callbackContext);
      startSession(args.getString(0));
			return true;
		}
		if (revmob == null) {
			return error(callbackContext, "Session has not been started. Call the startSession method.");
		}
		if (action.equals("showFullscreen")) {
			setCallbackContext(callbackContext);
			showFullscreen();
			return true;
		}
		if (action.equals("loadFullscreen")) {
			setCallbackContext(callbackContext);
			loadFullscreen();
			return true;
		}
		if (action.equals("showLoadedFullscreen")) {
			setCallbackContext(callbackContext);
			showLoadedFullscreen();
			return true;
		}
		if (action.equals("showPopup")) {
			setCallbackContext(callbackContext);
			showPopup();
			return true;
		}
		if (action.equals("showBanner")) {
			setCallbackContext(callbackContext);
			showBanner();
			return true;
		}
		if (action.equals("hideBanner")) {
			setCallbackContext(callbackContext);
			hideBanner();
			return true;
		}
		if (action.equals("openButton")) {
			setCallbackContext(callbackContext);
			openLink();
			return true;
		}
		if (action.equals("openLink")) {
			setCallbackContext(callbackContext);
			openLink();
			return true;
		}
		if (action.equals("setTestingMode")) {
			setTestingMode(args.getInt(0));
			return success(callbackContext);
		}
		if (action.equals("printEnvironmentInformation")) {
			printEnvironmentInformation();
			return success(callbackContext);
		}
		if (action.equals("setTimeoutInSeconds")) {
			setTimeoutInSeconds(args.getInt(0));
			return success(callbackContext);
		}
		if (action.equals("showVideo")) {
			setCallbackContext(callbackContext);
			showVideo();
			return true;
		}
		if (action.equals("loadVideo")) {
			setCallbackContext(callbackContext);
			loadVideo();
			return true;
		}
		if (action.equals("loadRewardedVideo")) {
			setCallbackContext(callbackContext);
			loadRewardedVideo();
			return true;
		}
		if (action.equals("showRewardedVideo")) {
			setCallbackContext(callbackContext);
			showRewardedVideo();
			return true;
		}
		return error(callbackContext, "Invalid method call: " + action);
	}

	private boolean error(CallbackContext callbackContext, String message) {
		Log.e("[RevMobPlugin]", message);
		if (callbackContext != null) {
			callbackContext.error(message);
		}
		return false;
	}

	private boolean success(CallbackContext callbackContext) {
		if (callbackContext != null) {
			callbackContext.success();
		}
		return true;
	}

	private void startSession(String appId) {
		RevMobClient.setSDKName(SDK_NAME);
		RevMobClient.setSDKVersion(SDK_VERSION);
		revmob = RevMob.startWithListenerForWrapper(cordova.getActivity(), appId, revmobListener);
	}

	private void showFullscreen() {
		revmob.showFullscreen(cordova.getActivity(), revmobListener);
	}

	private void loadFullscreen() {
		fullscreen = revmob.createFullscreen(cordova.getActivity(), revmobListener);
	}

	private void showLoadedFullscreen() {
		if(fullscreen != null)
			fullscreen.show();
	}
	
	private void loadVideo() {
		video = revmob.createVideo(cordova.getActivity(), revmobListener);
	}

	private void showVideo() {
		if(video != null)
			video.showVideo();
	}
	
	private void loadRewardedVideo() {
		rewardedVideo = revmob.createRewardedVideo(cordova.getActivity(), revmobListener);
	}
	
	private void showRewardedVideo() {
		if(rewardedVideo != null)
			rewardedVideo.showRewardedVideo();
	}

	private void showPopup() {
		revmob.showPopup(cordova.getActivity(), null, revmobListener);
	}

	private void showBanner() {
		revmob.showBanner(cordova.getActivity(), null, revmobListener);
	}

	private void hideBanner() {
		revmob.hideBanner(cordova.getActivity());
	}

	private void openButton() {
		revmob.openLink(cordova.getActivity(), revmobListener);
	}

	private void openLink() {
		revmob.openLink(cordova.getActivity(), revmobListener);
	}

	private void setTestingMode(int testingMode) {
		switch(testingMode) {
		case 0:
			revmob.setTestingMode(RevMobTestingMode.DISABLED);
			break;
		case 1:
			revmob.setTestingMode(RevMobTestingMode.WITH_ADS);
			break;
		case 2:
			revmob.setTestingMode(RevMobTestingMode.WITHOUT_ADS);
			break;
		default:
			revmob.setTestingMode(RevMobTestingMode.DISABLED);
			break;
		}
	}

	private void printEnvironmentInformation() {
		revmob.printEnvironmentInformation(cordova.getActivity());
	}

	private void setTimeoutInSeconds(int seconds) {
		revmob.setTimeoutInSeconds(seconds);
	}
	
	private JSONObject getResultString(String event) {
        JSONObject obj = new JSONObject();
        try {
            obj.put("RevMobAdsEvent", event);
        } catch (JSONException e) {
            Log.e("[RevMobPlugin]", e.getMessage(), e);
        }
        return obj;
    }
	
	private void setCallbackContext(CallbackContext callbackContext) {
		PluginResult pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        lastCallbackContext = callbackContext;
	}
	
	private void eventCallbackSuccess(String event) {
		Log.w("[RevMobPlugin]", event);
		if (lastCallbackContext != null) {
			PluginResult result = new PluginResult(PluginResult.Status.OK, getResultString(event));
	        result.setKeepCallback(true);
	        lastCallbackContext.sendPluginResult(result);
		}
	}
	
	private void eventCallbackError(String error) {
		Log.e("[RevMobPlugin]", error);
		if (lastCallbackContext != null) {
			PluginResult result = new PluginResult(PluginResult.Status.ERROR, getResultString(error));
	        result.setKeepCallback(true);
	        lastCallbackContext.sendPluginResult(result);
		}
	}	

}
