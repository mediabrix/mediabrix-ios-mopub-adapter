//
//  MediaBrixWrapperMP.m
//  MoPubTestApp
//
//  Created by Muhammad Zubair on 1/25/17.
//  Copyright © 2017 MediaBrix. All rights reserved.
//

#import "MediaBrixWrapperMP.h"
#import "MPRewardedVideoReward.h"
#import "MediaBrix.h"

@implementation MediaBrixWrapperMP

static MediaBrixWrapperMP* __instance;
static dispatch_once_t onceToken;

+(MediaBrixWrapperMP*)sharedInstance{
     dispatch_once(&onceToken, ^{
         __instance = [[MediaBrixWrapperMP alloc] init];
     });
    
    return __instance;
}

-(void) loadMediaBrixAd:(NSString *) baseURL appID:(NSString *) appID interstitialZone:(NSString *) interstitialZone rewardZone:(NSString *) rewardZone interEvent:(MediaBrixInterstitialCustomEvent *) interEvent rewardEvent:(MediaBrixRewardedVideo *) rewardEvent{
    
    if(interEvent != nil)
        _interEvent = interEvent;
    if(rewardEvent != nil)
        _rewardEvent = rewardEvent;
    
    if(!_hasStarted && !_calledInit){
        _interstitialZone = interstitialZone;
        _rewardZone = rewardZone;
        _calledInit = YES;
        _callbackDelegate = self;
        _zones = [[NSMutableArray alloc] init];
        [[MediaBrixWrapperMP sharedInstance] addZonesToArray:interstitialZone rewardZone:rewardZone];
        [MediaBrix initMediaBrixDelegate:_callbackDelegate withBaseURL:@"https://mobile.mediabrix.com/v2/manifest" withAppID:appID];
    }else if(!_hasStarted && _calledInit)
        [[MediaBrixWrapperMP sharedInstance] addZonesToArray:interstitialZone rewardZone:rewardZone];
    else{
        if(interstitialZone != nil){
            _interstitialZone = interstitialZone;
            [[MediaBrixWrapperMP sharedInstance] loadMediaBrixAd:interstitialZone];
        }
        if(rewardZone != nil){
            _rewardZone = rewardZone;
            [[MediaBrixWrapperMP sharedInstance] loadMediaBrixAd:rewardZone];
        }
    }
}

-(void) loadMediaBrixAd:(NSString *)zone{
    [[MediaBrix sharedInstance] loadAdWithIdentifier:zone adData:nil withViewController:_callbackDelegate];
}

-(void) showMediaBrixAd:(NSString *) zone rootView:(UIViewController *)rootViewController{
    [[MediaBrix sharedInstance]showAdWithIdentifier:zone fromViewController:rootViewController reloadWhenFinish:NO];
}

-(void) addZonesToArray:(NSString *) interstitialZone rewardZone:(NSString *) rewardZone{
    if(interstitialZone != nil){
        _interstitialZone = interstitialZone;
        [_zones addObject:_interstitialZone];
    }
    if(rewardZone != nil){
        _rewardZone = rewardZone;
        [_zones addObject:_rewardZone];
    }
}

#pragma mark - <MediaBrixDelegate>

- (void)mediaBrixStarted {
    _hasStarted = true;
    NSMutableArray *toDelete = [NSMutableArray array];
    for (int i = 0; i < [_zones count]; i++) {
        [[MediaBrixWrapperMP sharedInstance] loadMediaBrixAd:_zones[i]];
        [toDelete addObject:_zones[i]];
    }
    [_zones removeObjectsInArray:toDelete];
}

- (void)mediaBrixAdWillLoad:(NSString *)identifier {
    
}

- (void)mediaBrixAdFailed:(NSString *)identifier {
    if([identifier isEqualToString:_interstitialZone]){
        if(_interEvent != nil)
            [[_interEvent delegate] interstitialCustomEvent:_interEvent didFailToLoadAdWithError:nil];
    }else{
        _adloaded = NO;
        NSError *error = [NSError errorWithDomain:@"AdFailedToDownload" code:-1100 userInfo:nil];
        if(_rewardEvent != nil)
            [[_rewardEvent delegate] rewardedVideoDidFailToLoadAdForCustomEvent:_rewardEvent error:error];
    }
}

- (void)mediaBrixAdReady:(NSString *)identifier {
    if([identifier isEqualToString:_interstitialZone]){
        if(_interEvent != nil)
            [[_interEvent delegate] interstitialCustomEvent:_interEvent didLoadAd:_interEvent];
    }else{
        if(_rewardEvent !=nil){
            _adloaded = YES;
            [[_rewardEvent delegate] rewardedVideoDidLoadAdForCustomEvent:_rewardEvent];
        }
    }
}

- (void)mediaBrixAdShow:(NSString *)identifier {
    if([identifier isEqualToString:_interstitialZone]){
        if(_interEvent != nil)
            [[_interEvent delegate] interstitialCustomEventDidAppear:_interEvent];
    }else{
        if(_rewardEvent != nil)
            [[_rewardEvent delegate]  rewardedVideoDidAppearForCustomEvent:_rewardEvent];
    }
}

- (void)mediaBrixAdDidClose:(NSString *)identifier {
    if([identifier isEqualToString:_interstitialZone]){
        if(_interEvent != nil){
            [[_interEvent delegate] interstitialCustomEventWillDisappear:_interEvent];
            [[_interEvent delegate] interstitialCustomEventDidDisappear:_interEvent];
        }
    }else{
        if(_rewardEvent !=nil){
            _adloaded = NO;
            [[_rewardEvent delegate] rewardedVideoWillDisappearForCustomEvent:_rewardEvent];
            [[_rewardEvent delegate] rewardedVideoDidDisappearForCustomEvent:_rewardEvent];
        }
    }
}

- (void)mediaBrixAdReward:(NSString *)identifier {
    if([identifier isEqualToString:_rewardZone]){
        if(_rewardEvent != nil){
            [[_rewardEvent delegate] rewardedVideoShouldRewardUserForCustomEvent:_rewardEvent reward:[[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(0)]];
        }
    }
}

- (void)mediaBrixAdClicked:(NSString *)identifier {
    if([identifier isEqualToString:_interstitialZone]){
       if(_interEvent != nil)
           [[_interEvent delegate] interstitialCustomEventDidReceiveTapEvent:_interEvent];
    }else{
        if(_rewardEvent != nil)
            [[_rewardEvent delegate] rewardedVideoDidReceiveTapEventForCustomEvent:_rewardEvent];
    }
}


@end
