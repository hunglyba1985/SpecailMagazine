//
//  WeatherObject.h
//  yql-ios
//
//  Created by MobileFolk on 2016-09-05.
//  Copyright © 2016 Guilherme Chapiewski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YQL.h"

@protocol WeatherObjectDelegate <NSObject>

@optional

@end

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

@property (nonatomic,strong) NSMutableDictionary *saveForecastWeather;

@property (nonatomic,weak) id <WeatherObjectDelegate> delegate;


//- (id)initWithJSONDict:(NSDictionary *)dict;

- (id) getWeatherForecast;

-(NSDictionary *) displayWeatherData;

-(void) requestWeatherForecast;


@end
