//
//  WeatherObject.m
//  yql-ios
//
//  Created by MobileFolk on 2016-09-05.
//  Copyright © 2016 Guilherme Chapiewski. All rights reserved.
//

#import "WeatherObject.h"

#define HANOI @"hanoi"
#define HOCHIMINH @"hochiminh"
#define DANANG @"danang"


@implementation WeatherObject

-(id) getWeatherForecast
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"WeatherForecast" ofType:@"plist"];
    converForecast = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    YQL *yql = [[YQL alloc] init];

    NSDictionary *hanoiResult = [yql query:@"select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"hanoi, vn\")"];
    
    [self initWithJSONDict:hanoiResult forRegion:HANOI];
    
    NSDictionary *hochiminhResult = [yql query:@"select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"hochiminh, vn\")"];
    
    [self initWithJSONDict:hochiminhResult forRegion:HOCHIMINH];

    
    NSDictionary *danangResult = [yql query:@"select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"danang, vn\")"];
    
    [self initWithJSONDict:danangResult forRegion:DANANG];

    
    return self;
}

- (void)initWithJSONDict:(NSDictionary *)dict forRegion:(NSString*) region
{
    
    NSDictionary *query = [dict objectForKey:@"query"];
    
    NSDictionary *result = [query objectForKey:@"results"];
    
    NSDictionary *channel = [result objectForKey:@"channel"];
    
    self.astronomy =  [channel objectForKey:@"astronomy"];
    
    
    NSDictionary *item = [channel objectForKey:@"item"];
    
    
    // Convert F to C for current condition of weather
    NSDictionary *current = [item objectForKey:@"condition"];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:current];
    int fTemp = [[temp objectForKey:@"temp"] intValue];
    int cTemp = [self convertFToC:fTemp];
    [temp removeObjectForKey:@"temp"];
    [temp setObject:[NSString stringWithFormat:@"%i",cTemp] forKey:@"temp"];
    NSString *forecastWeather = [converForecast objectForKey:[current objectForKey:CODE]];
    if (forecastWeather) {
        [temp setObject:forecastWeather forKey:FORECAST];
    }
    self.currentWeatherCondition = temp;
    
    
    
    // Convert F to C for few days weather
    NSArray *array = [item objectForKey:@"forecast"];
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary *dic  in array) {
        
        NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] initWithDictionary:dic];
        
        int high = [[dic objectForKey:HIGH] intValue];
        int convertHight = [self convertFToC:high];
        [dicTemp removeObjectForKey:HIGH];
        [dicTemp setObject:[NSString stringWithFormat:@"%i",convertHight] forKey:HIGH];
        
        
        int low = [[dic objectForKey:LOW] intValue];
        int convertLow = [self convertFToC:low];
        [dicTemp removeObjectForKey:LOW];
        [dicTemp setObject:[NSString stringWithFormat:@"%i",convertLow] forKey:LOW];
        
        NSString *forecastWeather = [converForecast objectForKey:[dic objectForKey:CODE]];
        if (forecastWeather) {
            [dicTemp setObject:forecastWeather forKey:FORECAST];
        }
        [tempArray addObject:dicTemp];
    }
    
    self.forecastWeather = tempArray;
    
    NSMutableDictionary *allData = [NSMutableDictionary new];
    [allData setObject:self.astronomy forKey:ASTRONOMY];
    [allData setObject:self.currentWeatherCondition forKey:CURRENT_CONDITION_WEATHER];
    [allData setObject:self.forecastWeather forKey:FORECAST_WEATHER];
    
    
    if ([region isEqualToString:HANOI]) {
    
        self.hanoiWeather = allData;
        
    }
    else if ([region isEqualToString:HOCHIMINH])
    {
        self.hochiminhWeather = allData;
    }
    else
    {
        self.danangWeather = allData;
    }
    
    
}

-(int) convertFToC:(int) fValue
{
    int cValue = round(((fValue - 32)*5)/9);
    
    return cValue;
}



@end
