//
//  NSDictionary+NotNull.h
//  ShowSlinger
//
//  Created by Alex Curelea on 2014-07-16.
//  Copyright (c) 2014 ShowSlinger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NotNull)

- (id)objectForKeyNotNull:(id)key;

@end
