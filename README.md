# Mediabrix iOS MoPub Adapter
## Please see "Testing / Release Settings" section for new guidelines on testing and deploying your integration.

MediaBrix has created a MoPub adapter that allows publishers, using MoPub as their central ad server, to mediate the MediaBrix network as another demand source. This is done by setting up MediaBrix as a Custom Native Network in MoPub.

## Prerequisites
* MediaBrix App_ID and Zone_Name(s)
* MoPub SDK Integration
* XCode 6 or greater
* Supports iOS 7 and greater

## Adapter Integration Steps
**Step 1:** Add the MediaBrix SDK to your project
* Add the following files to your project ([which can be found here](https://github.com/mediabrix/mediabrix-ios-sdk/tree/master/IOS/src)):
 * MediaBrix.h
 * libMediaBrix.a
* In "Link Binary with Libraries" press the "+" button to add libxml2.tbd

**Step 2:** Copy all the Objective-C classes from this repo into your project src folder

**Step 3:** Login into your MoPub account

**Step 4:** Select the "Networks" tab, and click on "Add a Network"

![Step 4](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_03_07_16_42_163.png)

**Step 5:** Select the "Custom Native Network"

![Step 5](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_03_07_16_39_002.png)

**Step 6**: Set the title to "Mediabrix"

![Step 6](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_03_07_16_44_344.png)

**Step 7:** Find your app, and add **"MediaBrixInterstitialCustomEvent"** or **"MediaBrixRewardedVideo"** into **"Custom Event Class"** field for fullscreen ads/rewarded video ad. And in **Custom Event Class Data** copy the following:
`{"appID":"APP_ID","zone":"ZONE_NAME"}`. Replace `APP_ID` and `ZONE_NAME` with values provided by MediaBrix.

![Step 7](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_04_01_13_14_401.png)

**Step 8:** Save

**Step 9:** Select the **"Orders"** tab and click the **"Add new Order"** button

![Step 9](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_03_07_17_00_036.png)

**Step 10:** Create a **"Order Name"** and enter **"MediaBrix"** as the advertiser

![Step 10](https://cdn.mediabrix.com/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_03_07_17_03_507.png)

**Step 11:** With in the Line Item Details Section, select "Network" for "Type & Priority"

**Step 12:** Within the Class section enter: "MediaBrixInterstitialCustomEvent" or "MediaBrixRewardedVideo" 

**Step 13** Within the Data section enter:  `{"appID":"APP_ID","zone":"ZONE_NAME"}`. Replace `APP_ID` and `ZONE_NAME` with values provided by MediaBrix.

![Steps 11-13](https://hcs.hwcdn.net/v1/AUTH_mediabrix-231a/content/o38%2Fdevsupportportal%2FMoPub%20Adapter%20Images%2F2016_04_01_13_38_062.png)

**Step 14:** Within Ad Unit Targeting, select the fullscreen ad/rewarded video ad units where you added the Custom Event Class in Step 7

**Step 15:** Add other desired targeting and Save Order

## Logging 
To disable logging from the MediaBrix SDK, set `MBEnableVerboseLogging` to `NO` in "MediaBrixInterstitialCustomEvent.m" or "MediaBrixRewardedVideo.m" 

### Testing / Release Settings

To facilitate integrations and QA around the globe, MediaBrix has deployed an open Base URL for all of our world wide network partners to use while testing the MediaBrix SDK. This Test Base URL will eliminate the need for proxying your device to the US and ensure your app receives 100% fill during testing.

* **Test Base URL:** `https://test-mobile.mediabrix.com/v2/manifest/`

* **Production Base URL:** `https://mobile.mediabrix.com/v2/manifest/`

`https://test-mobile.mediabrix.com/v2/manifest/` should **ONLY** be used for testing purposes, as it will not deliver live campaigns to your app.

You can edit the Base URL for testing in "MediaBrixInterstitialCustomEvent.m" or "MediaBrixRewardedVideo.m":

```[MediaBrix initMediaBrixDelegate:callbackDelegate withBaseURL:@"BASE_URL" withAppID:appID];```

It is important to ensure that after testing, the Release build of your app uses the Production Base URL. **If you release your app using the Test Base URL, your app will not receive payable MediaBrix ads.**
