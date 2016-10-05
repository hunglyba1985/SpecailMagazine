//
//  ArticleObject.h
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-09-16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

//#import <Realm/Realm.h>

@interface ArticleObject : NSObject

@property int  cid;
@property NSString *content;
@property NSString *coverImageUrl;
@property NSString *descriptionArticle;
@property BOOL hasVideos;
@property NSInteger lid;
@property NSData *listImages;
@property NSData *listVideos;
@property double postTime;
@property int sid;
@property int superCid;
@property NSString *titleArticle;
@property NSString *originalLink;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;




@end

// This protocol enables typed collections. i.e.:
// RLMArray<ArticleObject>
//RLM_ARRAY_TYPE(ArticleObject)
