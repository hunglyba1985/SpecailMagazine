//
//  ArticleRealm.h
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-04.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import <Realm/Realm.h>

@interface ArticleRealm : RLMObject

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
// RLMArray<ArticleRealm *><ArticleRealm>
RLM_ARRAY_TYPE(ArticleRealm)
