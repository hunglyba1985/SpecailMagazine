//
//  FavoriteArticles.h
//  SpecialMagazine
//
//  Created by Hung_mobilefolk on 4/7/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import <Realm/Realm.h>
#import "ArticleRealm.h"



@interface FavoriteArticles : RLMObject

@property NSInteger id;
@property ArticleRealm *favoriteArticle;



@end

// This protocol enables typed collections. i.e.:
// RLMArray<CatalogRealm *><CatalogRealm>
RLM_ARRAY_TYPE(FavoriteArticles)
