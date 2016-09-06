//
//  ViewController.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 9/3/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "ViewController.h"
#import "YQL.h"
#import "WeatherObject.h"




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testApi];
    [self testYahooWeather];
    
    
}


-(void) testApi
{
    
    [ARTIST_API getAllWebsite:^(id dataResponse, NSError *error) {
    
        if (dataResponse != nil) {
            
            
            NSDictionary *dic = dataResponse;
            
            NSArray *array = [dic objectForKey:WEBSITE];
            
            NSLog(@"data get is %@",[array firstObject]);
            
            
        }
        
    }];
    
    
}

-(void) testYahooWeather
{
  
    WeatherObject *weather = [[WeatherObject alloc] getWeatherForecast];

    NSLog(@"weather of hanoi is %@",weather.hanoiWeather);
    NSLog(@"weather of hochiminh is %@",weather.hochiminhWeather);
    NSLog(@"weather of danang is %@",weather.danangWeather);

    
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
























