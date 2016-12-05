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
// Calendar
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

// Weather
@property (weak, nonatomic) IBOutlet UILabel *currentDegree;
@property (weak, nonatomic) IBOutlet UILabel *highDegree;
@property (weak, nonatomic) IBOutlet UILabel *lowDegree;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;


@end

@implementation LaunchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"launching view did load");
    
    
    [self loadingBeautifulAdvice];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self testYahooWeather];
    
    UITapGestureRecognizer *tapToView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToScreen)];
    [self.view addGestureRecognizer:tapToView];
    
    [self setDayOfCalendar];
    
    
}


-(void) setDayOfCalendar
{
    NSDate * today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    dateFormat.dateFormat = @"EEEE";
    self.dateLabel.text = [dateFormat stringFromDate:today];
    
    dateFormat.dateFormat = @"MMMM";
    self.monthLabel.text = [dateFormat stringFromDate:today];
    
    dateFormat.dateFormat = @"dd";
    self.dayLabel.text = [dateFormat stringFromDate:today];
    
    
    
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

-(void) tapToScreen
{
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
