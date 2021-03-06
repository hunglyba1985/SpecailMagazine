//
//  CatalogRealm.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-11.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import "CatalogRealm.h"

@implementation CatalogRealm

+ (NSString *)primaryKey {
    return @"id";
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        
     
        self.id = [[dictionary objectForKey:WEBSITE_ID] integerValue];
        self.websiteName = [dictionary objectForKey:WEBSITE_NAME];
        self.websiteIconLink = [dictionary objectForKey:WEBSITE_ICON];
        NSArray *catalog = [dictionary objectForKey:WEBSITE_CATEGORY];
        self.categories = [NSKeyedArchiver archivedDataWithRootObject:catalog];
        
        
    }
    
    return self;
}


// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
