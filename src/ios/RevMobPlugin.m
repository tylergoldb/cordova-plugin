#import "RevMobPlugin.h"

@interface RevMobAds ()
    + (void) startSessionWithAppID:(NSString *)appID
                          delegate:(NSObject<RevMobAdsDelegate> *)delegate
                       testingMode:(RevMobAdsTestingMode)testingMode
                           sdkName:(NSString *)sdkName
                        sdkVersion:(NSString *)sdkVersion;
    + (RevMobAds *)sharedObject;
@end


@implementation RevMobPlugin
@synthesize sessionCommand;


NSString* SDK_NAME = @"cordova-ios";
NSString* SDK_VERSION = @"9.0.3";

RevMobFullscreen *fullscreenAd, *video, *rewardedVideo;


- (void)startSession:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;

    self.sessionCommand = command;
    @try {
        NSString* appId = [command.arguments objectAtIndex:0];
        if (appId != nil && [appId length] > 0) {
            [RevMobAds startSessionWithAppID:appId
                                    delegate:self
                                 testingMode:RevMobAdsTestingModeOff
                                     sdkName:SDK_NAME
                                  sdkVersion:SDK_VERSION];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            javaScript = [pluginResult toErrorCallbackString:command.callbackId];
        }
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:command.callbackId];
    }

    [self writeJavascript:javaScript];
} 


- (void)showFullscreen:(CDVInvokedUrlCommand*)command {
    RevMobFullscreen *fs = [[RevMobAds session] fullscreen];
    [fs loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
        [self eventCallbackSuccess:@"AD_RECEIVED" :command];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        [self eventCallbackError:@"AD_NOT_RECEIVED" :command];
    } onClickHandler:^{
        [self eventCallbackSuccess:@"AD_CLICKED" :command];
    } onCloseHandler:^{
        [self eventCallbackSuccess:@"AD_DISMISSED" :command];
    }];
}

- (void)loadFullscreen:(CDVInvokedUrlCommand*)command {
    self.fullscreenAd = [[RevMobAds session] fullscreen];
    self.fullscreenAd.delegate = self;
    [self.fullscreenAd loadAd];
}

- (void)showLoadedFullscreen:(CDVInvokedUrlCommand*)command{
    if (self.fullscreenAd != nil) [self.fullscreenAd showAd];
}

-(void) loadVideo:(CDVInvokedUrlCommand*)command {
    self.video = [[RevMobAds session] fullscreen];
    self.video.delegate = self;
    [self.video loadVideo];
}

-(void) showVideo:(CDVInvokedUrlCommand*)command{
    if(self.video != nil) [self.video showVideo];
}

-(void) loadRewardedVideo:(CDVInvokedUrlCommand*)command {
    self.rewardedVideo = [[RevMobAds session] fullscreen];
    self.rewardedVideo.delegate = self;
    [self.rewardedVideo loadRewardedVideo];
}

-(void) showRewardedVideo:(CDVInvokedUrlCommand*)command{
    if(self.rewardedVideo != nil) [self.rewardedVideo showRewardedVideo];
}

- (void)showPopup:(CDVInvokedUrlCommand*)command {
    RevMobPopup *popup = [[RevMobAds session] popup];
    [popup loadWithSuccessHandler:^(RevMobPopup *popup) {
        [popup showAd];
        [self eventCallbackSuccess:@"AD_RECEIVED" :command];
    } andLoadFailHandler:^(RevMobPopup *popup, NSError *error) {
        [self eventCallbackError:@"AD_NOT_RECEIVED" :command];
    } onClickHandler:^(RevMobPopup *popup) {
        [self eventCallbackSuccess:@"AD_CLICKED" :command];
    }];
}

- (void)showBanner:(CDVInvokedUrlCommand*)command {
    self.bannerWindow = [[RevMobAds session] banner];
   [self.bannerWindow loadWithSuccessHandler:^(RevMobBanner *banner) {
       [banner showAd];
       [self eventCallbackSuccess:@"AD_RECEIVED" :command];
   } andLoadFailHandler:^(RevMobBanner *banner, NSError *error) {
       [self eventCallbackError:@"AD_NOT_RECEIVED" :command];
   } onClickHandler:^(RevMobBanner *banner) {
       [self eventCallbackSuccess:@"AD_CLICKED" :command];
   }];
}

- (void)showCustomBannerPos:(CDVInvokedUrlCommand*)command {
    self.banner = [[RevMobAds session] bannerView];
    NSArray *arr = command.arguments;
    CGFloat x = [[arr objectAtIndex:0] floatValue];
    CGFloat y = [[arr objectAtIndex:1] floatValue];
    CGFloat w = [[arr objectAtIndex:2] floatValue];
    CGFloat h = [[arr objectAtIndex:3] floatValue];
    [self.banner loadWithSuccessHandler:^(RevMobBannerView *banner) {
        [_banner showAd:x y:y width:w height:h];
        [self eventCallbackSuccess:@"AD_RECEIVED" :command];
    } andLoadFailHandler:^(RevMobBannerView *banner, NSError *error) {
        [self eventCallbackError:@"AD_NOT_RECEIVED" :command];
    } onClickHandler:^(RevMobBannerView *banner) {
        [self eventCallbackSuccess:@"AD_CLICKED" :command];
    }];
}

- (void)showCustomBanner:(CDVInvokedUrlCommand*)command {
    self.banner = [[RevMobAds session] bannerView];
    [self.banner loadWithSuccessHandler:^(RevMobBannerView *banner) {
        [_banner showAd];
        [self eventCallbackSuccess:@"AD_RECEIVED" :command];
    } andLoadFailHandler:^(RevMobBannerView *banner, NSError *error) {
        [self eventCallbackError:@"AD_NOT_RECEIVED" :command];
    } onClickHandler:^(RevMobBannerView *banner) {
        [self eventCallbackSuccess:@"AD_CLICKED" :command];
    }];
}

- (void)hideBanner:(CDVInvokedUrlCommand*)command {
   [self.bannerWindow hideAd];
   [self eventCallbackSuccess:@"AD_DISMISSED" :command];
}

- (void)hideCustomBanner:(CDVInvokedUrlCommand*)command {
    [self.banner removeFromSuperview];
    [self eventCallbackSuccess:@"AD_DISMISSED" :command];
}


- (void)openButton:(CDVInvokedUrlCommand *)command {
    [self openLink];
}


- (void)openLink:(CDVInvokedUrlCommand *)command {
    RevMobAdLink *link = [[RevMobAds session] adLink];
    [link loadWithSuccessHandler:^(RevMobAdLink *link) {
        [link openLink];
        [self eventCallbackSuccess:@"AD_RECEIVED" :command];
    } andLoadFailHandler:^(RevMobAdLink *link, NSError *error) {
        [self eventCallbackError:@"AD_NOT_RECEIVED" :command];
    }];
}

- (void)setTestingMode:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    @try {
        int testingMode = [[command.arguments objectAtIndex:0] intValue];
        switch (testingMode) {
            case 0:
                [RevMobAds sharedObject].testingMode = RevMobAdsTestingModeOff;
                break;
            case 1:
                [RevMobAds sharedObject].testingMode = RevMobAdsTestingModeWithAds;
                break;
            case 2:
                [RevMobAds sharedObject].testingMode = RevMobAdsTestingModeWithoutAds;
                break;
        }
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:command.callbackId];
    }
    [self writeJavascript:javaScript];
}

- (void)setTimeoutInSeconds:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;

    @try {
        NSUInteger time = [[command.arguments objectAtIndex:0] intValue];
        [RevMobAds session].connectionTimeout = time;
    }
    @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:command.callbackId];
    }
    [self writeJavascript:javaScript];
}

- (void)printEnvironmentInformation:(CDVInvokedUrlCommand *)command {
    [[RevMobAds session] printEnvironmentInformation];
}

- (void)eventCallbackSuccess:(NSString*)event :(CDVInvokedUrlCommand*)command {
    NSDictionary* data = [self getResultString:event];

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:data];
    [pluginResult setKeepCallbackAsBool:YES];
    
    NSString* javaScript = nil;
    javaScript = [pluginResult toSuccessCallbackString:command.callbackId];
    [self writeJavascript:javaScript];
}

- (void)eventCallbackError:(NSString*)event :(CDVInvokedUrlCommand*)command {
    NSDictionary* data = [self getResultString:event];

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:data];
    [pluginResult setKeepCallbackAsBool:YES];

    NSString* javaScript = nil;
    javaScript = [pluginResult toErrorCallbackString:command.callbackId];
    [self writeJavascript:javaScript];
}

- (NSDictionary*)getResultString:(NSString*)event {
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithCapacity:1];
    [data setObject:event forKey:@"RevMobAdsEvent"];
    return data;
}

#pragma mark - RevMobAdsDelegate methods


/////Session Listeners/////
- (void)revmobSessionIsStarted {
    [self eventCallbackSuccess:@"SESSION_STARTED" :self.sessionCommand];
}

- (void)revmobSessionNotStartedWithError:(NSError *)error {
    [self eventCallbackError:@"SESSION_NOT_STARTED" :self.sessionCommand];
}


/////Ad Listeners/////
- (void)revmobAdDidReceive {
    [self eventCallbackSuccess:@"AD_RECEIVED" :self.sessionCommand];
}

- (void)revmobAdDidFailWithError:(NSError *)error {
    [self eventCallbackSuccess:@"AD_NOT_RECEIVED" :self.sessionCommand];
}

- (void)revmobAdDisplayed {
    [self eventCallbackSuccess:@"AD_DISPLAYED" :self.sessionCommand];
}

- (void)revmobUserClosedTheAd {
    [self eventCallbackSuccess:@"AD_DISMISSED" :self.sessionCommand];
}

- (void)revmobUserClickedInTheAd {
    [self eventCallbackSuccess:@"AD_CLICKED" :self.sessionCommand];
}


/////Video Listeners/////
-(void)revmobVideoDidLoad{
    [self eventCallbackSuccess:@"VIDEO_LOADED" :self.sessionCommand];
}

-(void)revmobVideoNotCompletelyLoaded{
    [self eventCallbackSuccess:@"VIDEO_NOT_COMPLETELY_LOADED" :self.sessionCommand];
}

-(void)revmobVideoDidStart{
    [self eventCallbackSuccess:@"VIDEO_STARTED" :self.sessionCommand];
}

-(void)revmobVideoDidFinish{
    [self eventCallbackSuccess:@"VIDEO_FINISHED" :self.sessionCommand];
}


/////Rewarded Video Listeners/////
-(void)revmobRewardedVideoDidLoad{
    [self eventCallbackSuccess:@"REWARDED_VIDEO_LOADED" :self.sessionCommand];
}

-(void)revmobRewardedVideoNotCompletelyLoaded{
    [self eventCallbackSuccess:@"REWARDED_VIDEO_NOT_COMPLETELY_LOADED" :self.sessionCommand];
}

-(void)revmobRewardedVideoDidStart{
    [self eventCallbackSuccess:@"REWARDED_VIDEO_STARTED" :self.sessionCommand];
}

-(void)revmobRewardedVideoDidFinish{
    [self eventCallbackSuccess:@"REWARDED_VIDEO_FINISHED" :self.sessionCommand];
}

-(void)revmobRewardedVideoComplete {
    [self eventCallbackSuccess:@"REWARDED_VIDEO_COMPLETED" :self.sessionCommand];
}

-(void)revmobRewardedPreRollDisplayed{
    [self eventCallbackSuccess:@"REWARDED_PRE_ROLL_DISPLAYED" :self.sessionCommand];
}


/////Advertiser Listeners/////
- (void)installDidReceive {
    NSLog(@"[RevMob Cordova iOS Sample App] Install received.");
}

- (void)installDidFail {
    NSLog(@"[RevMob Cordova iOS Sample App] Install failed.");
}


@end

