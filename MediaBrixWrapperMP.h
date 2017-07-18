//
//  MediaBrixWrapperMP.h
//  MoPubTestApp
//
//  Created by Muhammad Zubair on 1/25/17.
//  Copyright © 2017 MediaBrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaBrixInterstitialCustomEvent.h"
#import "MediaBrixRewardedVideo.h"

@interface MediaBrixWrapperMP : NSObject

@property(atomic) NSString* rewardZone;
@property(atomic) NSString* interstitialZone;
@property(atomic) BOOL adloaded;
@property(atomic) BOOL hasStarted;
@property(atomic) BOOL calledInit;
@property(atomic) NSMutableArray* zones;
@property(atomic) MediaBrixInterstitialCustomEvent * interEvent;
@property(atomic) MediaBrixRewardedVideo * rewardEvent;
@property(atomic) id callbackDelegate;

+(MediaBrixWrapperMP*)sharedInstance;
-(void) loadMediaBrixAd:(NSString *) baseURL appID:(NSString *) appID interstitialZone:(NSString *) interstitialZone rewardZone:(NSString *) rewardZone interEvent:(MediaBrixInterstitialCustomEvent *) interEvent rewardEvent:(MediaBrixRewardedVideo *) rewardEvent;
-(void) showMediaBrixAd:(NSString *) zone rootView:(UIViewController *)rootViewController;

@end
