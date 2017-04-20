//
//  NSDictionary+NotNull.m
//  ShowSlinger
//
//  Created by Alex Curelea on 2014-07-16.
//  Copyright (c) 2014 ShowSlinger. All rights reserved.
//

#import "NSDictionary+NotNull.h"

@implementation NSDictionary (NotNull)

- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}

@end
