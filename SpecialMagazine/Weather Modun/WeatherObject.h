//
//  WeatherObject.h
//  yql-ios
//
//  Created by MobileFolk on 2016-09-05.
//  Copyright © 2016 Guilherme Chapiewski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YQL.h"

#define CURRENT_CONDITION_WEATHER @"CurrentConditionWeather"
#define FORECAST_WEATHER @"ForecastWeather"
#define ASTRONOMY @"Astronomy"

#define FORECAST @"Forecast"
#define DATE @"date"
#define TEMP @"temp"
#define LOW @"low"
#define HIGH @"high"
#define CODE @"code"


@interface WeatherObject : NSObject
{
    NSDictionary *converForecast;
}

@property (nonatomic,strong) NSDictionary *currentWeatherCondition;
@property (nonatomic,strong) NSArray *forecastWeather;
@property (nonatomic,strong) NSDictionary *astronomy;

@property (nonatomic,strong) NSDictionary *hanoiWeather;
@property (nonatomic,strong) NSDictionary *hochiminhWeather;
@property (nonatomic,strong) NSDictionary *danangWeather;


//- (id)initWithJSONDict:(NSDictionary *)dict;

-(id) getWeatherForecast;



@end
