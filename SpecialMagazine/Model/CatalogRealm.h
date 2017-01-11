//
//  CatalogRealm.h
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-11.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import <Realm/Realm.h>

@interface CatalogRealm : RLMObject


@property NSInteger id;
@property NSString *websiteName;
@property NSString *websiteIconLink;
@property NSData *categories;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary;



@end

// This protocol enables typed collections. i.e.:
// RLMArray<CatalogRealm *><CatalogRealm>
RLM_ARRAY_TYPE(CatalogRealm)
