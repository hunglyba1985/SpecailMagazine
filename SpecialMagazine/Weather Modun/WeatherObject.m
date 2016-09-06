//
//  WeatherObject.m
//  yql-ios
//
//  Created by MobileFolk on 2016-09-05.
//  Copyright © 2016 Guilherme Chapiewski. All rights reserved.
//

#import "WeatherObject.h"

@implementation WeatherObject

- (id)initWithJSONDict:(NSDictionary *)dict
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
    self.currentWeatherCondition = temp;
    
    
    
    // Convert F to C for few days weather
    NSArray *array = [item objectForKey:@"forecast"];
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary *dic  in array) {
        
        NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] initWithDictionary:dic];
        
        int high = [[dic objectForKey:@"high"] intValue];
        int convertHight = [self convertFToC:high];
        [dicTemp removeObjectForKey:@"high"];
        [dicTemp setObject:[NSString stringWithFormat:@"%i",convertHight] forKey:@"high"];
        
        
        int low = [[dic objectForKey:@"low"] intValue];
        int convertLow = [self convertFToC:low];
        [dicTemp removeObjectForKey:@"low"];
        [dicTemp setObject:[NSString stringWithFormat:@"%i",convertLow] forKey:@"low"];
        
        [tempArray addObject:dicTemp];
    }
    
    self.forecastWeather = tempArray;
    
    
    
    
    return self;
}

-(int) convertFToC:(int) fValue
{
    int cValue = round(((fValue - 32)*5)/9);
    
    return cValue;
}



@end
