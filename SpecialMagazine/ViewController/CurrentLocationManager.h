//
//  CurrentLocationManager.h
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-12-06.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentLocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocation *currentLocation;

}
@property (strong, nonatomic) CLLocationManager *locationManager; //TODO: private


+ (CurrentLocationManager *)sharedInstance;
-(BOOL)checkLocationAuthorizationStatus;
- (void)currentLocationDataWithCompletion:(void (^)(CLPlacemark* placemark, NSError *error))completion;


@end
