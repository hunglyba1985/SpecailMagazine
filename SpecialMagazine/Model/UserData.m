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

-(void) setFileConfigure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:@"https://raw.githubusercontent.com/hunglyba1985/SpecailMagazine/master/FileConfigure" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"file configure is %@",responseObject);
        
        NSDictionary *fileConfig = (NSDictionary*) responseObject;
        [_userDefaults setObject:fileConfig forKey:CONFIGURE_FILE];
        
        NSString *imageUrlStr = [fileConfig objectForKeyNotNull:BG_IMG_URL_STR];
        
        UIImage *storeImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrlStr];

        if (storeImage) {
            NSLog(@"already have image");
        }
        else
        {
            NSLog(@"doesn't load image from another time");
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(NSDictionary *) getFileConfigure
{
    return [_userDefaults dictionaryForKey:CONFIGURE_FILE];
    
}


@end










