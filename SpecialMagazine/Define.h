//
//  Define.h
//  SpecialMagazine
//
//  Created by Macbook Pro on 9/3/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#ifndef Define_h
#define Define_h

#define SCREEN_HEIGHT                        [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH                         [[UIScreen mainScreen] bounds].size.width


#define DEVICE_ID  [UIDevice currentDevice].identifierForVendor.UUIDString


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define URL_BASE @"http://api.5play.mobi/news/v2.0"


#define ARTIST_API [ArtistAPI  sharedInstance]


#define ACTIVE_TYPE  @[@(DGActivityIndicatorAnimationTypeNineDots),@(DGActivityIndicatorAnimationTypeTriplePulse),@(DGActivityIndicatorAnimationTypeFiveDots),@(DGActivityIndicatorAnimationTypeRotatingSquares),@(DGActivityIndicatorAnimationTypeDoubleBounce),@(DGActivityIndicatorAnimationTypeTwoDots),@(DGActivityIndicatorAnimationTypeThreeDots),@(DGActivityIndicatorAnimationTypeBallPulse),@(DGActivityIndicatorAnimationTypeBallClipRotate),@(DGActivityIndicatorAnimationTypeBallClipRotatePulse),@(DGActivityIndicatorAnimationTypeBallClipRotateMultiple),@(DGActivityIndicatorAnimationTypeBallRotate),@(DGActivityIndicatorAnimationTypeBallZigZag),@(DGActivityIndicatorAnimationTypeBallZigZagDeflect),@(DGActivityIndicatorAnimationTypeBallTrianglePath),@(DGActivityIndicatorAnimationTypeBallScale),@(DGActivityIndicatorAnimationTypeLineScale),@(DGActivityIndicatorAnimationTypeLineScaleParty),@(DGActivityIndicatorAnimationTypeBallScaleMultiple),@(DGActivityIndicatorAnimationTypeBallPulseSync),@(DGActivityIndicatorAnimationTypeBallBeat),@(DGActivityIndicatorAnimationTypeLineScalePulseOut),@(DGActivityIndicatorAnimationTypeLineScalePulseOutRapid),@(DGActivityIndicatorAnimationTypeBallScaleRipple),@(DGActivityIndicatorAnimationTypeBallScaleRippleMultiple),@(DGActivityIndicatorAnimationTypeTriangleSkewSpin),@(DGActivityIndicatorAnimationTypeBallGridBeat),@(DGActivityIndicatorAnimationTypeBallGridPulse),@(DGActivityIndicatorAnimationTypeRotatingSandglass),@(DGActivityIndicatorAnimationTypeRotatingTrigons),@(DGActivityIndicatorAnimationTypeTripleRings),@(DGActivityIndicatorAnimationTypeCookieTerminator),@(DGActivityIndicatorAnimationTypeBallSpinFadeLoader)]


#define FLAT_COLOR @[UIColorFromRGB(0x1abc9c),UIColorFromRGB(0x2ecc71),UIColorFromRGB(0x3498db),UIColorFromRGB(0x9b59b6),UIColorFromRGB(0x34495e),UIColorFromRGB(0xf1c40f),UIColorFromRGB(0xe67e22),UIColorFromRGB(0xe74c3c),UIColorFromRGB(0xDB0A5B),UIColorFromRGB(0xF64747),UIColorFromRGB(0xF62459),UIColorFromRGB(0xAEA8D3),UIColorFromRGB(0x913D88),UIColorFromRGB(0x81CFE0)]


#define WEBSITE @"websites"

#define WEBSITE_ID @"id"
#define WEBSITE_CATEGORY @"categorys"
#define WEBSITE_NAME @"name"
#define WEBSITE_ICON @"icon_url"


#define LINFOS @"linfos"



#pragma mark - DEFINE ARTICLE
#define  SID   @"sid"
#define  DESC @"desc"
#define POST_TIME @"posttime"
#define LIST_VIDEOS @"listMp4"
#define IS_PIN @"isPin"
#define CID @"cid"
#define ORIGINAL_LINK @"url"
#define CONTENT @"content"
#define LID @"lid"
#define COVER_IMAGE @"cover"
#define TITLE_ARTICLE @"title"
#define HAS_VIDEOS @"hasVideo"
#define CTACTION @"ctaction"
#define SUPER_CID @"supercid"
#define LIST_IMAGES @"listimage"
#define LINK_IMAGE @"linkImage"

#define PLACE_HOLDER_IMAGE @"Please add fucker image here!"


// Weather properties
#pragma mark - DEFINE WEATHER
#define HANOI @"hanoi"
#define HOCHIMINH @"hochiminh"
#define DANANG @"danang"

#define CURRENT_CONDITION_WEATHER @"CurrentConditionWeather"
#define FORECAST_WEATHER @"ForecastWeather"
#define ASTRONOMY @"Astronomy"

#define FORECAST @"Forecast"
#define DATE @"date"
#define TEMP @"temp"
#define LOW @"low"
#define HIGH @"high"
#define CODE @"code"
#define PROVINCE @"province"

#define WEATHER_SAVE @"Weather save"


// Notification Center
#define NOTIFICATION_FOR_WEATHER @"Notification for weather"
#define NOTIFICATION_FOR_LOCAITON @"Notification for location"

#define CONFIGURE_FILE @"Configure file"
#define BACKGROUND_IMAGES @"Background images"



#endif /* Define_h */













