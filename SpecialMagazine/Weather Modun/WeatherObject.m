//
//  WeatherObject.m
//  yql-ios
//
//  Created by MobileFolk on 2016-09-05.
//  Copyright © 2016 Guilherme Chapiewski. All rights reserved.
//

#import "WeatherObject.h"


#define QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q="
#define QUERY_SUFFIX @"&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

#define HANOI_WEATHER_QUERY @"select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"hanoi, vn\")"
#define HOCHIMINH_WEATHER_QUERY @"select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"hochiminh, vn\")"
#define DANANG_WEATHER_QUERY @"select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"danang, vn\")"


@implementation WeatherObject

- (id) getWeatherForecast
{
    self.saveForecastWeather = [NSMutableDictionary new];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"WeatherForecast" ofType:@"plist"];
    converForecast = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    YQL *yql = [[YQL alloc] init];

    NSDictionary *hanoiResult = [yql query:HANOI_WEATHER_QUERY];
    
    [self initWithJSONDict:hanoiResult forRegion:HANOI];
    
    NSDictionary *hochiminhResult = [yql query:HOCHIMINH_WEATHER_QUERY];
    
    [self initWithJSONDict:hochiminhResult forRegion:HOCHIMINH];

    
    NSDictionary *danangResult = [yql query:DANANG_WEATHER_QUERY];
    
    [self initWithJSONDict:danangResult forRegion:DANANG];

    
    return self;
}

-(void) requestWeatherForecast
{
    self.saveForecastWeather = [NSMutableDictionary new];

    [self getForcastFromProvince:HANOI_WEATHER_QUERY andNameProvince:HANOI];
    [self getForcastFromProvince:HOCHIMINH_WEATHER_QUERY andNameProvince:HOCHIMINH];
    [self getForcastFromProvince:DANANG_WEATHER_QUERY andNameProvince:DANANG];
}

-(void) getForcastFromProvince:(NSString *) province andNameProvince:(NSString*) nameProvince
{
    NSString *query = [NSString stringWithFormat:@"%@%@%@", QUERY_PREFIX, [province stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], QUERY_SUFFIX];
    
    //    NSLog(@"query yahoo %@",query);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:query parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"get data from yahoo never stable %@",responseObject);
        
        [self initWithJSONDict:responseObject forRegion:nameProvince];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FOR_WEATHER object:nil];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FOR_WEATHER object:nil];

        
    }];

}

- (void)initWithJSONDict:(NSDictionary *)dict forRegion:(NSString*) region
{
    if (dict != nil) {
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
            [self.saveForecastWeather setObject:self.hanoiWeather forKey:HANOI];
        }
        else if ([region isEqualToString:HOCHIMINH])
        {
            self.hochiminhWeather = allData;
            [self.saveForecastWeather setObject:self.hochiminhWeather forKey:HOCHIMINH];
        }
        else
        {
            self.danangWeather = allData;
            [self.saveForecastWeather setObject:self.danangWeather forKey:DANANG];
        }
        
//        [[NSUserDefaults standardUserDefaults] setObject:self.saveForecastWeather forKey:WEATHER_SAVE];
        [[UserData sharedInstance] setCurrentForcastWeather:self.saveForecastWeather];
        
    }
//    else
//    {
//        NSDictionary *getOldData = [[NSUserDefaults standardUserDefaults] dictionaryForKey:WEATHER_SAVE];
//        
//        self.hanoiWeather = [getOldData objectForKey:HANOI];
//        self.hochiminhWeather = [getOldData objectForKey:HOCHIMINH];
//        self.danangWeather = [getOldData objectForKey:DANANG];
//    }
 
}

-(int) convertFToC:(int) fValue
{
    int cValue = round(((fValue - 32)*5)/9);
    
    return cValue;
}

-(NSDictionary *) displayWeatherData
{
    NSMutableDictionary *temp = [NSMutableDictionary new];
    
    
    
    return temp;
}

@end














