//
//  ArticleObject.h
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-09-16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import <Realm/Realm.h>

@interface ArticleObject : RLMObject





@end

// This protocol enables typed collections. i.e.:
// RLMArray<ArticleObject>
RLM_ARRAY_TYPE(ArticleObject)
