//
//  UserData.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-12.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import "UserData.h"

@implementation UserData
{
    NSUserDefaults *_userDefaults;
    
    
}


static UserData  *sharedController = nil;

+ (UserData *)sharedInstance
{
    if (!sharedController) {
        
        sharedController = [[UserData alloc] init];
    }
    
    return sharedController;
}


- (id)init
{
    self = [super init];
    if (self) {
        _userDefaults   =   [NSUserDefaults standardUserDefaults];
        
    }
    
    return self;
}


-(void) setCurrentProvince:(NSString *) currentProvince
{
    [_userDefaults setObject:currentProvince forKey:PROVINCE];
    
}
-(NSString *) getOldProvince
{
    return [_userDefaults stringForKey:PROVINCE];
}


-(void) setCurrentForcastWeather:(NSDictionary *) currentForcast
{
    [_userDefaults setObject:currentForcast forKey:WEATHER_SAVE];
}
-(NSDictionary *) getOldForcast
{
    return [_userDefaults dictionaryForKey:WEATHER_SAVE];
}



@end
