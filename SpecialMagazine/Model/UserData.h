//
//  UserData.h
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-12.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

+ (UserData *)sharedInstance;


-(void) setCurrentProvince:(NSString *) currentProvince;
-(NSString *) getOldProvince;


-(void) setCurrentForcastWeather:(NSDictionary *) currentForcast;
-(NSDictionary *) getOldForcast;


@end
