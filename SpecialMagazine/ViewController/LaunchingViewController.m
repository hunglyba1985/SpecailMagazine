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
#import "FLAnimatedImage.h"
#import "CurrentLocationManager.h"


@interface LaunchingViewController ()
{
    WeatherObject *weather;
    
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
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *forcastWeather;
@property (weak, nonatomic) IBOutlet UILabel *nameProvince;

// Launching wellcome
@property (weak, nonatomic) IBOutlet UILabel *wellcomeLabel;


@end

@implementation LaunchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"launching view did load");
    
    
    [self loadingBeautifulAdvice];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setYahooWeather];
    
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
    
    dateFormat.dateFormat = @"HH";
//    NSLog(@"get current time %@",[dateFormat stringFromDate:today]);
    int hours = [[dateFormat stringFromDate:today] intValue];
    if (hours > 5 && hours < 12 ) {
        self.wellcomeLabel.text = @"Good morning";
    }
    else if (hours >= 12 && hours < 19)
    {
        self.wellcomeLabel.text = @"Good afternoon";
    }
    else
    {
        self.wellcomeLabel.text = @"Good evening";
    }
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocalProvince:) name:NOTIFICATION_FOR_WEATHER object:nil];
    
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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

-(void) setYahooWeather
{
    
     weather = [[WeatherObject alloc] getWeatherForecast];
    
    NSLog(@"weather of hanoi is %@",weather.hanoiWeather);
//    NSLog(@"weather of hochiminh is %@",weather.hochiminhWeather);
//    NSLog(@"weather of danang is %@",weather.danangWeather);
    
    [self setDataForWeatherView:weather.hanoiWeather inProvince:@"TP Hà Nội"];
    
    
}

-(void) getLocalProvince:(NSNotification *) userData
{
    NSDictionary *localData = [userData userInfo];
    
    NSLog(@"local data is %@", localData);
    
    NSString *localProvince = [localData objectForKey:PROVINCE];
    
    if ([localProvince isEqualToString:@"Thành Phố Đà Nẵng"]) {
        
        [self setDataForWeatherView:weather.danangWeather inProvince:@"TP Đà Nẵng"];
    }
    else if ([localProvince isEqualToString:@"Ho Chi Minh City"])
    {
        [self setDataForWeatherView:weather.hochiminhWeather inProvince:@"TP Hồ Chí Minh"];
    }
    else
    {
        [self setDataForWeatherView:weather.hanoiWeather inProvince:@"TP Hà Nội"];
    }
    
    
}


-(void) setDataForWeatherView:(NSDictionary *) weatherDic inProvince:(NSString *) provinceName
{
    if (weatherDic != nil) {
        NSDictionary *currentWeather = [weatherDic objectForKey:CURRENT_CONDITION_WEATHER];
        self.currentDegree.text = [NSString stringWithFormat:@"%@°C",[currentWeather objectForKey:TEMP]];
        self.forcastWeather.text = [NSString stringWithFormat:@"Hôm nay %@",[currentWeather objectForKey:FORECAST]];
        
        NSArray *forecast = [weatherDic objectForKey:FORECAST_WEATHER];
        NSDictionary *object1 = [forecast firstObject];
        
        self.highDegree.text = [NSString stringWithFormat:@"%@°C",[object1 objectForKey:HIGH]];
        self.lowDegree.text =  [NSString stringWithFormat:@"%@°C",[object1 objectForKey:LOW]];
        
        
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://l.yimg.com/a/i/us/we/52/%@.gif",[currentWeather objectForKey:@"code"]]]]];
        
        self.weatherIcon.animatedImage = image;
        
        self.nameProvince.text = provinceName;

    }
 
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
