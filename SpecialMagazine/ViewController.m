//
//  ViewController.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 9/3/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "ViewController.h"
#import "DrawInView.h"
#import "WeatherObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testApi];
//    [self testDrawView];
//    [self testYahooWeather];

//    [self testDatePicker];
    
}


-(void) testDatePicker
{
    
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    
    NSLog(@"local time zone name is %@",[localTimeZone name]);
    NSLog(@"local time zone compare with GMT   %ld",[localTimeZone secondsFromGMT]/(60*60));
    NSLog(@"local time zone abbreviation name is  %@",[localTimeZone abbreviation]);
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.center = self.view.center;
    
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Paris"];
    datePicker.minuteInterval = 15;
    
    datePicker.datePickerMode = UIDatePickerModeTime;
    
    datePicker.backgroundColor = [UIColor whiteColor];
    
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:datePicker];
    

}

-(void)dateChanged:(id)sender{
    NSLog(@"%@",[sender date]);
}


-(void) testDrawView
{
    DrawInView *view = [[DrawInView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    view.center = self.view.center;
    view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:view];
    

    
    
}


-(void) testApi
{
    
    [ARTIST_API getAllWebsite:^(id dataResponse, NSError *error) {
    
        if (dataResponse != nil) {
            
            
            NSLog(@"get list all website ----------- %@",dataResponse);
            
            
        }
        
    }];
    
    
    [ARTIST_API getListArticleAccordingToMagazine:@"999" andCatalog:@"999" successResult:^(id dataResponse, NSError *error) {
      
       if (dataResponse != nil)
       {
           NSLog(@"get list article -------- %@",dataResponse);
           
           
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
























