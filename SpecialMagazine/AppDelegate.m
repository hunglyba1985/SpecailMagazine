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

@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"application did finish launching with option --");

    [self getCurrentLocation];
    
//    NSLog(@"get document path: %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);

    
    return YES;
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
