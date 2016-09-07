//
//  YQL.h
//  yql-ios
//
//  Created by Guilherme Chapiewski on 10/19/12.
//  Copyright (c) 2012 Guilherme Chapiewski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQL : NSObject

- (NSDictionary *)query:(NSString *)statement;

//    NSDictionary *results = [yql query:@"select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"hanoi, vn\")"];


@end
