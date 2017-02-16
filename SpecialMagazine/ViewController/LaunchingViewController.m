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
#import "Reachability.h"

#import "TFHpple.h"

#define HANOICITY @""
#define HOCHIMINHCITY @""
#define DANANGCITY @""

#import "JHChainableAnimations.h"
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)


@interface LaunchingViewController ()
{
//    WeatherObject *weather;
    NSDictionary *weather;
    BOOL haveInternet;
    
    
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


// Launching animation
@property (weak, nonatomic) IBOutlet UIImageView *sunImageView;

@property (weak, nonatomic) IBOutlet UIImageView *cloud1;
@property (weak, nonatomic) IBOutlet UIImageView *cloud2;

@end

@implementation LaunchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *oldProvince = [[UserData sharedInstance] getOldProvince];

    NSLog(@"launching view did load with old province is %@",oldProvince);
    
    
    [self loadingBeautifulAdvice];
    
    self.navigationController.navigationBarHidden = YES;
    
//    [self setYahooWeather];
    
    UITapGestureRecognizer *tapToView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToScreen)];
    [self.view addGestureRecognizer:tapToView];
    
    [self setDayOfCalendar];
    
    [self checkConnectNetwork];
    
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.cloud2.hidden = NO;
    self.cloud1.hidden = NO;
    self.sunImageView.hidden = NO;
    
    
    [self testAnimation];
    
 }


-(void) testHtmlString
{
    NSArray *allLocalData = (NSArray*)[ArticleRealm allObjects];
    
    ArticleRealm *oneObject = [allLocalData firstObject];
    
//    NSLog(@"content article is %@",oneObject.content);
    
    
    NSData* data = [oneObject.content dataUsingEncoding:NSUTF8StringEncoding];
   
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:data];

    NSString *tutorialsXpathQueryString = @"//div[@class='text-conent']/p";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
//    NSMutableArray *arrayContent = [NSMutableArray new];
    
    for (TFHppleElement *element in tutorialsNodes) {
      
        NSLog(@"------------------------------------------------------------");
        
 
        
        NSLog(@"get content --------------------%@",element.firstChild.content);
        if (element.firstChild.content == nil) {
            NSLog(@"each element element.firstChild.attributes in this object is:%@",[element.firstChild.attributes objectForKey:@"src"]);

        }

    }


}





-(void) checkConnectNetwork
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        NSLog(@"not connect to internet");
        
        [self setYahooWeather];
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        NSLog(@"connect to internet by wifi");
        haveInternet = YES;
        
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        NSLog(@"connect to internet by 3G");
        haveInternet = YES;
        
    }
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocalProvince:) name:NOTIFICATION_FOR_LOCAITON object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setYahooWeather) name:NOTIFICATION_FOR_WEATHER object:nil];

//        NSLog(@"all thread running in app %@", [NSThread callStackSymbols]);

    
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
    NSLog(@"notification when get weather ---------");
//     weather = [[WeatherObject alloc] getWeatherForecast];
    
//    NSLog(@"weather of hanoi is %@",weather.hanoiWeather);
//    NSLog(@"weather of hochiminh is %@",weather.hochiminhWeather);
//    NSLog(@"weather of danang is %@",weather.danangWeather);
    
     weather = [[UserData sharedInstance] getOldForcast];
    
//    NSLog(@"old weather forcast is %@",weather);
    
    NSString *oldProvince = [[UserData sharedInstance] getOldProvince];
    
    
//    NSLog(@"old province is %@",oldProvince);
    
    
//    NSLog(@"old weather is %@",weather);
    
    
    if (oldProvince != nil) {
        
        [self findWeatherForcastFromProvince:oldProvince];
    }
    else
    {
        [self setDataForWeatherView:[weather objectForKey:HANOI] inProvince:@"TP Hà Nội"];
    }
}

-(void) getLocalProvince:(NSNotification *) userData
{
    NSLog(@"notification when get location -----------");
    NSDictionary *localData = [userData userInfo];
    
//    NSLog(@"local data is %@", localData);
    
    NSString *localProvince = [localData objectForKey:PROVINCE];
    
    [self findWeatherForcastFromProvince:localProvince];
    
}

-(void) findWeatherForcastFromProvince:(NSString *) localProvince
{
    NSLog(@"findWeatherForcastFromProvince");
    if ([localProvince isEqualToString:@"Thành Phố Đà Nẵng"]) {
        
        [self setDataForWeatherView:[weather objectForKey:DANANG] inProvince:@"TP Đà Nẵng"];
    }
    else if ([localProvince isEqualToString:@"Ho Chi Minh City"])
    {
        [self setDataForWeatherView:[weather objectForKey:HOCHIMINH] inProvince:@"TP Hồ Chí Minh"];
    }
    else
    {
        NSLog(@"find ha noi here");
        [self setDataForWeatherView:[weather objectForKey:HANOI] inProvince:@"TP Hà Nội"];
    }

}


-(void) setDataForWeatherView:(NSDictionary *) weatherDic inProvince:(NSString *) provinceName
{
    if (weatherDic != nil) {
        NSLog(@"run to setDataForWeatherView");
        NSDictionary *currentWeather = [weatherDic objectForKey:CURRENT_CONDITION_WEATHER];
        self.currentDegree.text = [NSString stringWithFormat:@"%@°C",[currentWeather objectForKey:TEMP]];
        self.forcastWeather.text = [NSString stringWithFormat:@"Hôm nay %@",[currentWeather objectForKey:FORECAST]];
        
        NSArray *forecast = [weatherDic objectForKey:FORECAST_WEATHER];
        NSDictionary *object1 = [forecast firstObject];
        
        self.highDegree.text = [NSString stringWithFormat:@"%@°C",[object1 objectForKey:HIGH]];
        self.lowDegree.text =  [NSString stringWithFormat:@"%@°C",[object1 objectForKey:LOW]];
        
        if (haveInternet) {
            FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://l.yimg.com/a/i/us/we/52/%@.gif",[currentWeather objectForKey:@"code"]]]]];
    
            self.weatherIcon.animatedImage = image;
        }
        else
        {
            self.weatherIcon.hidden = YES;
        }
        

        
        self.nameProvince.text = provinceName;

    }
 
}


- (void) reachabilityChanged:(NSNotification *)note
{
    
    NSLog(@"connection change status");
    
    Reachability* curReach = [note object];
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    if (netStatus == NotReachable) {
        
        NSLog(@"don't have internet");
        
    }
    else
    {
        NSLog(@" have internet");
        
    }
    
}


-(void) tapToScreen
{
    ListWebsitesController *listWebsites = [self.storyboard instantiateViewControllerWithIdentifier:@"ListWebsitesController"];
    
    [self.navigationController pushViewController:listWebsites animated:YES];

}

- (IBAction)downloadClick:(id)sender {
    
    NSLog(@"download click");
    
    [self deleteAllOldData];
    
    
    [ARTIST_API downloadForNoInternet];
    
//    [self testAnimation];
    
    
    
}


-(void) testAnimation
{
    self.cloud1.moveX(300).animate(2);
    self.cloud2.moveX(- 300).animate(2);
    
    UIBezierPath *aPath = [self.sunImageView bezierPathForAnimation];
    aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 300)
                                           radius:150
                                       startAngle:DEGREES_TO_RADIANS(180)
                                         endAngle:DEGREES_TO_RADIANS(0)
                                        clockwise:YES];
    
    self.sunImageView.moveOnPath(aPath).animate(2);

    
}

-(void) deleteAllOldData
{
    NSLog(@"delete all old data in local");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(queue, ^{
        // Get the default Realm
        RLMRealm *realm = [RLMRealm defaultRealm];
        // You only need to do this once (per thread)
        
        RLMResults *allArticles = [ArticleRealm allObjects];
        
        [realm beginWriteTransaction];
        [realm deleteObjects:allArticles];
        
        [realm commitWriteTransaction];
        
    });
    
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
