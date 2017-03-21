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
#import "MediaBrixWrapperMP.h"



@interface MediaBrixRewardedVideo(){
    NSString * appID;
    NSString * zone;
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
        [MediaBrix MBEnableVerboseLogging:YES];
        [[MediaBrixWrapperMP sharedInstance] loadMediaBrixAd:@"http://mobile.mediabrix.com/v2/manifest/" appID:appID interstitialZone:nil rewardZone:zone interEvent:nil rewardEvent:self];
        
    }else{
        NSLog(@"Please ensure that you have added the appID and zone in the MoPub Dashboard");
    }
}

- (BOOL) hasAdAvailable{
    return [[MediaBrixWrapperMP sharedInstance] adloaded];
}

- (void) presentRewardedVideoFromViewController:(UIViewController *)viewController{
    if([[MediaBrixWrapperMP sharedInstance] adloaded]){
        [self.delegate rewardedVideoWillAppearForCustomEvent:self];
        [[MediaBrix sharedInstance]showAdWithIdentifier:zone fromViewController:viewController reloadWhenFinish:NO];
    }else
        NSLog(@"Ad not loaded");
}

-(void)handleCustomEventInvalidated{

}

- (void)dealloc
{
    
}

@end
