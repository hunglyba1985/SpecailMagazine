//
//  LaunchingViewController.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-09-30.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "LaunchingViewController.h"
#import "ContainViewController.h"
#import "ListWebsitesController.h"


@interface LaunchingViewController ()
{

}

@property (weak, nonatomic) IBOutlet UILabel *meaningfulSentence;


@end

@implementation LaunchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadingBeautifulAdvice];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self testYahooWeather];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}



-(void) loadingBeautifulAdvice
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"document" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    int randomInt = arc4random_uniform((int)json.count);
    
    NSString *randomSentence = [json objectAtIndex:randomInt];
    
    NSLog(@" nice advices:  %@",randomSentence);

    
    self.meaningfulSentence.text = randomSentence;
    
    
}

-(void) testYahooWeather
{
    
    WeatherObject *weather = [[WeatherObject alloc] getWeatherForecast];
    
//    NSLog(@"weather of hanoi is %@",weather.hanoiWeather);
//    NSLog(@"weather of hochiminh is %@",weather.hochiminhWeather);
//    NSLog(@"weather of danang is %@",weather.danangWeather);
    
    
}



- (IBAction)clickToStart:(id)sender {
    
    ListWebsitesController *listWebsites = [self.storyboard instantiateViewControllerWithIdentifier:@"ListWebsitesController"];
    
    [self.navigationController pushViewController:listWebsites animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
