//  MediaBrixInterstitialCustomEvent.m
//  MoPubTestApp
//
//  Created by Muhammad Zubair on 3/30/16.
//  Copyright © 2016 MediaBrix. All rights reserved.
//

#import "MediaBrixInterstitialCustomEvent.h"
#import "MediaBrix.h"

@interface MediaBrixInterstitialCustomEvent(){
    NSString * appID;
    NSString * zone;
    id callbackDelegate;
}

@property(strong,nonatomic) NSMutableDictionary * publisherVars;

@end

@implementation MediaBrixInterstitialCustomEvent

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
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
        
        callbackDelegate = self;
        [MediaBrix initMediaBrixDelegate:callbackDelegate withBaseURL:@"http://mobile.mediabrix.com/v2/manifest" withAppID:appID];

    }else{
         NSLog(@"Please ensure that you have added the appID and zone in the MoPub Dashboard");
    }
    
}


-(void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    [self.delegate interstitialCustomEventWillAppear:self];
    [[MediaBrix sharedInstance]showAdWithIdentifier:zone fromViewController:rootViewController reloadWhenFinish:NO];
}

#pragma mark - <MediaBrixDelegate>
- (void)mediaBrixStarted {
    [[MediaBrix sharedInstance]loadAdWithIdentifier:zone adData:self.publisherVars withViewController:callbackDelegate];
}

- (void)mediaBrixAdWillLoad:(NSString *)identifier {
    // Invoked when the ad has been requested
}

- (void)mediaBrixAdFailed:(NSString *)identifier {
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    // Invoked when the ad fails to load an ad
}

- (void)mediaBrixAdReady:(NSString *)identifier {
   [self.delegate interstitialCustomEvent:self didLoadAd:self];
    // Invoked when ad has succesfully downloaded and is ready to show
}

- (void)mediaBrixAdShow:(NSString *)identifier {
     [self.delegate interstitialCustomEventDidAppear:self];
    // Invoked when ad is being shown to the user
}

- (void)mediaBrixAdDidClose:(NSString *)identifier {
    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
    // Invoked when the ad is closed
}

- (void)mediaBrixAdReward:(NSString *)identifier {
    // Invoked when the user has watched an ad that offers an incentive and reward should be given
}

- (void)mediaBrixAdClicked:(NSString *)identifier {
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    
    // Invoked when the user has clicked the ad
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end