//
//  AppDelegate.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 9/3/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "AppDelegate.h"
#import "CurrentLocationManager.h"
#import "Reachability.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate () <UIAlertViewDelegate>
@property (nonatomic) Reachability *internetReachability;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    NSLog(@"application did finish launching with option --");

        [Fabric with:@[[Crashlytics class]]];
    
    [self getCurrentLocation];
    
//   NSLog(@"get document path: %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    [self getWeatherForcast];

    [self changeModelOfDatabase];
    [self setCheckingConnectNetwork];
    
    [[UserData sharedInstance] setFileConfigure];
    
    return YES;
}

-(void) setCheckingConnectNetwork
{
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
}

-(void) changeModelOfDatabase
{
    
//    NSLog(@"change model of database");
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
//    NSLog(@"realm local data %@",config.fileURL);
    
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = 1;
    
    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
            
//            NSLog(@"change model of database just one time");
            
            
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
    };
    
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    [RLMRealm defaultRealm];
}

-(void) getWeatherForcast
{
    WeatherObject *weather = [[WeatherObject alloc] init];
    [weather requestWeatherForecast];
}


-(void) getCurrentLocation
{
    if ([[CurrentLocationManager sharedInstance] checkLocationAuthorizationStatus]) {
        NSLog(@"gain permission to access current location ");
    }
    else
    {
        NSLog(@"fail to get current location");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Bật location để chúng tôi thông báo dự báo thời tiết cho bạn tốt hơn." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alertView show];

    }
}

#pragma mark - AlertView Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationDidEnterBackground");
    
    NSDictionary *fileConfigure = [[UserData sharedInstance] getFileConfigure];
    NSString *imageUrlStr = [fileConfigure objectForKeyNotNull:BG_IMG_URL_STR];
    if (imageUrlStr) {
        
        UIImage *storeImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrlStr];
        
        if (!storeImage) {
            NSLog(@"don't have image start download");
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrlStr] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (image && finished) {
                    // Cache image to disk or memory
                    NSLog(@"down image comlete and store in disk");
                    //                [[SDImageCache sharedImageCache] storeImage:image forKey:CUSTOM_KEY toDisk:YES];
                    [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrlStr completion:nil];
                    
                }
            }];
            
        }
        
    }

    
//    self.bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
//        
//     
//        
////        dispatch_async(dispatch_get_main_queue(), ^{
////            
////            
////            [application endBackgroundTask:self.bgTask];
////            
////            self.bgTask = UIBackgroundTaskInvalid;
////            
////        });
//        
//    }];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
