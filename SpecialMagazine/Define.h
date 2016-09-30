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







#endif /* Define_h */













