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



@interface MediaBrixRewardedVideo(){
    NSString * appID;
    NSString * zone;
    BOOL _adReady;
    id callbackDelegate;
}

@property(strong,nonatomic) NSMutableDictionary * publisherVars;

@end

@implementation MediaBrixRewardedVideo


- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info
{
    appID = @"";
    zone  = @"";
    
    if(info){
        
        if([info objectForKey:@"appID"]){
            appID = info[@"appID"];
        }else{
            NSLog(@"Please ensure that you have added appID in the MoPub Dashboard");
        }
        if([info objectForKey:@"zone"]){
            zone = info[@"zone"];
        }else{
            NSLog(@"Please ensure that you have added zone in the MoPub Dashboard");
        }
        _adReady = NO;
        callbackDelegate = self;
        [MediaBrix initMediaBrixDelegate:callbackDelegate withBaseURL:@"http://mobile.mediabrix.com/v2/manifest" withAppID:appID];
        
    }else{
        NSLog(@"Please ensure that you have added the appID and zone in the MoPub Dashboard");
    }
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

#pragma mark - <MediaBrixDelegate>
- (void)mediaBrixStarted {
    [[MediaBrix sharedInstance]loadAdWithIdentifier:zone adData:self.publisherVars withViewController:callbackDelegate];
}

- (void)mediaBrixAdWillLoad:(NSString *)identifier {
    // Invoked when the ad has been requested
}

- (void)mediaBrixAdFailed:(NSString *)identifier {
    _adReady = NO;
    NSError *error = [NSError errorWithDomain:@"AdFailedToDownload" code:-1100 userInfo:nil];
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];

    // Invoked when the ad fails to load an ad
}

- (void)mediaBrixAdReady:(NSString *)identifier {
    _adReady = YES;
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
    // Invoked when ad has succesfully downloaded and is ready to show
}

- (void)mediaBrixAdShow:(NSString *)identifier {
       [self.delegate rewardedVideoDidAppearForCustomEvent:self];    // Invoked when ad is being shown to the user
}

- (void)mediaBrixAdDidClose:(NSString *)identifier {
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];    // Invoked when the ad is closed
}

- (void)mediaBrixAdReward:(NSString *)identifier {
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:[[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(0)]];

    // Invoked when the user has watched an ad that offers an incentive and reward should be given
}

- (void)mediaBrixAdClicked:(NSString *)identifier {
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    // Invoked when the user has clicked the ad
}


-(void)handleCustomEventInvalidated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    
}

@end