# Mediabrix iOS MoPub Adapter

MediaBrix has created a MoPub adapter that allows publishers, using MoPub as their central ad server, to mediate the MediaBrix network as another demand source. This is done by setting up MediaBrix as a Custom Native Network in MoPub.

##Prerequisites
* MediaBrix App_ID and Zone_Name(s)
* MoPub SDK Integration
* XCode 6 or greater
* Supports iOS 7 and greater

##Adapter Integration Steps
**Step 1:** Add the MediaBrix SDK to your project
* Add the following files to your project ([which can be found here](https://github.com/mediabrix/mediabrix-ios-sdk/tree/master/IOS/src)):
 * MediaBrix.h
 * libMediaBrix.a
* In "Link Binary with Libraries" press the "+" button to add libxml2.tbd

**Step 2:** Copy "MediaBrixInterstitialCustomEvent.h" and "MediaBrixInterstitialCustomEvent.m" or "MediaBrixRewardedVideo.h" and "MediaBrixRewardedVideo.m" into your project src folder

**Step 3:** Login into your MoPub account

**Step 4:** Select the "Networks" tab, and click on "Add a Network"

![Step 4](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_03_07_16_42_163.png)

**Step 5:** Select the "Custom Native Network"

![Step 5](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_03_07_16_39_002.png)

**Step 6**: Set the title to "Mediabrix"

![Step 6](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_03_07_16_44_344.png)

**Step 7:** Find your app, and add **"MediaBrixInterstitialCustomEvent"** or **"MediaBrixRewardedVideo"** into **"Custom Event Class"** field for fullscreen ads. And in **Custom Event Class Data** copy the following:
```{"app":"APP_ID","zone":"ZONE_NAME"}```. Replace "APP_ID" and "ZONE_NAME" with values provided by MediaBrix.



![Step 7](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_04_01_13_14_401.png)

**Step 8:** Save

**Step 9:** Select the **"Orders"** tab and click the **"Add new Order"** button

![Step 9](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_03_07_17_00_036.png)

**Step 10:** Create a **"Order Name"** and enter **"MediaBrix"** as the advertiser

![Step 10](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_03_07_17_03_507.png)

**Step 11:** With in the Line Item Details Section, select "Network" for "Type & Priority"

**Step 12:** Within the Class section enter: "MediaBrixInterstitialCustomEvent" or "MediaBrixRewardedVideo" 

**Step 13** Within the Data section enter:  ``{"app":"APP_ID","zone":"ZONE_NAME"}``. Replace "APP_ID" and "ZONE_NAME" with values provided by MediaBrix.

![Steps 11-13](https://hcs.hwcdn.net/v1/AUTH_mediabrix-231a/content/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_04_01_13_38_062.png)

**Step 14:** Within Ad Unit Targeting, select the fullscreen ad units where you added the Custom Event Class in Step 7

**Step 15:** Add other desired targeting and Save Order

##Logging 
To disable logging from the MediaBrix SDK, set ```MBEnableVerboseLogging``` to ```NO``` in "MediaBrixInterstitialCustomEvent.m" or "MediaBrixRewardedVideo.m" 
