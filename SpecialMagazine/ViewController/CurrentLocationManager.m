//
//  CurrentLocationManager.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-12-06.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "CurrentLocationManager.h"

@implementation CurrentLocationManager

static CurrentLocationManager *sharedLocationController = nil;

+ (CurrentLocationManager *)sharedInstance
{
    static dispatch_once_t _LocationControllerPredicate;
    dispatch_once(&_LocationControllerPredicate, ^{
        sharedLocationController = [[CurrentLocationManager alloc] init];
    });
    
    return sharedLocationController;
}

- (id)init
{
    if (self = [super init])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        //TODO: change for map to Best
        _locationManager.activityType = CLActivityTypeFitness;
        _locationManager.distanceFilter = (CLLocationDistance)1.0;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        
        if([self checkLocationAuthorizationStatus])
        {
            [_locationManager startUpdatingLocation];
        }
    }
    return self;
}

#pragma mark - Public Methods

-(BOOL)checkLocationAuthorizationStatus
{
    //TODO: localization
    //TODO: check BG usage
//    DLog(@"%d", [CLLocationManager authorizationStatus]);
    NSString *errorMessage;
    switch ([CLLocationManager authorizationStatus])
    {
        case kCLAuthorizationStatusAuthorized:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return YES;
        case kCLAuthorizationStatusRestricted:
            errorMessage = @"Location services must be enabled in order to use Encounter.";
            return NO;
            break;
        case kCLAuthorizationStatusDenied:
            errorMessage = @"Location services must be enabled in order to use Encounter.";
            return NO;
            break;
        case kCLAuthorizationStatusNotDetermined:
        default:
        {
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            { //iOS 8+
                [self.locationManager requestWhenInUseAuthorization];
                return YES;
            }
            
            errorMessage = @"Unable to determine your location. Please make sure location services are enabled.";
            return YES;
            break;
        }
    }
    
    
}

- (void)currentLocationDataWithCompletion:(void (^)(CLPlacemark* placemark, NSError *error))completion
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.locationManager.location
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks firstObject];
         if (error)
         {
             completion(nil,error);
         }
         else
         {
             completion(placemark, nil);
         }
         
     }];
}


#pragma mark - Location Managerment Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    
    [_locationManager stopUpdatingLocation];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
//             NSLog(@"get current location -------------------------- ");
//             
//             NSLog(@"get current postalCode %@",placemark.postalCode);
//             NSLog(@"get current subAdministrativeArea %@",placemark.subAdministrativeArea);
//             NSLog(@"get current administrativeArea %@",placemark.administrativeArea);
//             NSLog(@"get current locality %@",placemark.locality);
//             NSLog(@"get current subLocality %@",placemark.subLocality);
//             NSLog(@"get current country %@",placemark.country);
             
             NSDictionary *currentProvince = @{PROVINCE:placemark.administrativeArea};
//             NSLog(@"current province is %@",currentProvince);
             
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FOR_LOCAITON object:nil userInfo:currentProvince];
             
             
             [[UserData sharedInstance] setCurrentProvince:placemark.administrativeArea];
             
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager startUpdatingLocation];
      
    }
}



@end






















