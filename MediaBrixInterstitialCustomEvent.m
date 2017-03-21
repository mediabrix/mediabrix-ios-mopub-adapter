//  MediaBrixInterstitialCustomEvent.m
//  MoPubTestApp
//
//  Created by Muhammad Zubair on 3/30/16.
//  Copyright © 2016 MediaBrix. All rights reserved.
//

#import "MediaBrixInterstitialCustomEvent.h"
#import "MediaBrix.h"
#import "MediaBrixWrapperMP.h"

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
        [MediaBrix MBEnableVerboseLogging:YES];
        
        [[MediaBrixWrapperMP sharedInstance] loadMediaBrixAd:@"https://mobile.mediabrix.com/v2/manifest/" appID:appID interstitialZone:zone rewardZone:nil interEvent:self rewardEvent:nil];

    }else{
         NSLog(@"Please ensure that you have added the appID and zone in the MoPub Dashboard");
    }   
}

-(void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    [self.delegate interstitialCustomEventWillAppear:self];
    [[MediaBrix sharedInstance]showAdWithIdentifier:zone fromViewController:rootViewController reloadWhenFinish:NO];
}



- (void)dealloc
{
    
}


@end
