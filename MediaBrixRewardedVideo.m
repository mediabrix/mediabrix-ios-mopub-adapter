//
//  MediaBrixRewardedVideo.m
//  MoPubTestApp
//
//  Created by Muhammad Zubair on 4/15/16.
//  Copyright © 2016 MediaBrix. All rights reserved.
//
#import "MediaBrix.h"
#import "MediaBrixRewardedVideo.h"
#import "MPRewardedVideoReward.h"



@interface MediaBrixRewardedVideo()

@property(strong,nonatomic) NSMutableDictionary * publisherVars;

@end

@implementation MediaBrixRewardedVideo

NSString * appID = @"";
NSString * zone  = @"";

BOOL _adReady;

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info
{
    id callbackDelegate = self;
    _adReady = NO;
    [MediaBrix initMediaBrixAdHandler:callbackDelegate withBaseURL:@"http://mobile.mediabrix.com/v2/manifest" withAppID:appID];
    [[MediaBrix sharedInstance]loadAdWithIdentifier:zone adData:self.publisherVars withViewController:callbackDelegate];
}

- (BOOL) hasAdAvailable{
    return _adReady;
}

- (void) presentRewardedVideoFromViewController:(UIViewController *)viewController{
    if(_adReady){
        [self.delegate rewardedVideoWillAppearForCustomEvent:self];
        [[MediaBrix sharedInstance]showAdWithIdentifier:zone fromViewController:viewController reloadWhenFinish:NO];
    }else
        NSLog(@"Ad not loaded");
}

- (void)mediaBrixAdHandler:(NSNotification *)notification {
    
    NSString * adIdentifier =[notification.userInfo objectForKey:kMediabrixTargetAdTypeKey];
    
    if([kMediaBrixAdWillLoadNotification isEqualToString:notification.name]){
        
    }
    else if([kMediaBrixAdFailedNotification isEqualToString:notification.name]){
        _adReady = NO;
        NSError *error = [NSError errorWithDomain:@"AdFailedToDownload" code:-1100 userInfo:nil];
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
    }
    else if([kMediaBrixAdReadyNotification isEqualToString:notification.name]){
        _adReady = YES;
        [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
    }
    else if([kMediaBrixAdShowNotification isEqualToString:notification.name]){
        [self.delegate rewardedVideoDidAppearForCustomEvent:self];
    }
    else if([kMediaBrixAdDidCloseNotification isEqualToString:notification.name]){
        [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
        [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
    }
    else if([ kMediaBrixAdRewardNotification isEqualToString:notification.name]){
        [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:[[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(0)]];
    }else if([ kMediaBrixAdClickedNotification isEqualToString:notification.name]){
        [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    }
    
}

-(void)handleCustomEventInvalidated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    
}

@end