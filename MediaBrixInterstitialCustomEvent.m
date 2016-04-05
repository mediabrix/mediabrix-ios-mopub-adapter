//
//  MediaBrixInterstitialCustomEvent.m
//  MoPubTestApp
//
//  Created by Muhammad Zubair on 3/30/16.
//  Copyright © 2016 MediaBrix. All rights reserved.
//

#import "MediaBrixInterstitialCustomEvent.h"
#import "MediaBrix.h"
#import "MPInstanceProvider.h"

@interface MediaBrixInterstitialCustomEvent()

@property(strong,nonatomic) NSMutableDictionary * publisherVars;

@end

@implementation MediaBrixInterstitialCustomEvent

NSString * appID = @"";
NSString * zone  = @"";


- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    id callbackDelegate = self;
    [MediaBrix initMediaBrixAdHandler:callbackDelegate withBaseURL:@"http://mobile.mediabrix.com/v2/manifest" withAppID:appID];
    [[MediaBrix sharedInstance]loadAdWithIdentifier:zone adData:self.publisherVars withViewController:callbackDelegate];
}


-(void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    
    [[MediaBrix sharedInstance]showAdWithIdentifier:zone fromViewController:rootViewController reloadWhenFinish:NO];
}



- (void)mediaBrixAdHandler:(NSNotification *)notification {
    
    NSString * adIdentifier =[notification.userInfo objectForKey:kMediabrixTargetAdTypeKey];
    
    if([kMediaBrixAdWillLoadNotification isEqualToString:notification.name]){
        [self.delegate interstitialCustomEventWillAppear:self];
    }
    else if([kMediaBrixAdFailedNotification isEqualToString:notification.name]){
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
    else if([kMediaBrixAdReadyNotification isEqualToString:notification.name]){
        [self.delegate interstitialCustomEvent:self didLoadAd:self];
    }
    else if([kMediaBrixAdShowNotification isEqualToString:notification.name]){
         [self.delegate interstitialCustomEventDidAppear:self];
    }
    else if([kMediaBrixAdDidCloseNotification isEqualToString:notification.name]){
        
        [self.delegate interstitialCustomEventWillDisappear:self];
        [self.delegate interstitialCustomEventDidDisappear:self];
        
    }
    else if([ kMediaBrixAdRewardNotification isEqualToString:notification.name]){
        
        /* invoked when ad view is completed and reward can be given */
        
    }
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
