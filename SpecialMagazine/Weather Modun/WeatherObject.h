//
//  WeatherObject.h
//  yql-ios
//
//  Created by MobileFolk on 2016-09-05.
//  Copyright © 2016 Guilherme Chapiewski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherObject : NSObject


@property (nonatomic,strong) NSDictionary *currentWeatherCondition;
@property (nonatomic,strong) NSArray *forecastWeather;
@property (nonatomic,strong) NSDictionary *astronomy;

- (id)initWithJSONDict:(NSDictionary *)dict;



@end
