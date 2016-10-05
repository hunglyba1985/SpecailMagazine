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
#import "TableViewCell.h"
#import "DetailViewController.h"


@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tableData;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testApi];
//    [self testDrawView];
//    [self testYahooWeather];

//    [self testDatePicker];
    
    [self setUpTableView];
    
}

-(void) setUpTableView
{
    tableData = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *documentsDirectory = [paths objectAtIndex:0];
    
//    NSLog(@"document directory ------ %@",documentsDirectory);
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test Cell" forIndexPath:indexPath];
    
    NSDictionary *cellData = [tableData objectAtIndex:indexPath.row];
//    cell.textLabel.text = [cellData objectForKey:TITLE_ARTICLE];
    
    [cell.imageCell sd_setImageWithURL:[NSURL URLWithString:[cellData objectForKey:COVER_IMAGE]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    cell.nameCell.text = [cellData objectForKey:TITLE_ARTICLE];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellData = [tableData objectAtIndex:indexPath.row];
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detail.article = cellData;
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > tableData.count - 5) {
        printf("start to load more ");
        [self loadMoreData];
    }
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
    
    NSLog(@"parameter in request api is website id is %@ -----------  and catolog is %@ and name of catalog is %@",[self.catagoryInfo objectForKey:WEBSITE_ID],[self.catagoryInfo objectForKey:WEBSITE_CATEGORY],[self.catagoryInfo objectForKey:WEBSITE_NAME]);
    
    
    [ARTIST_API getListArticleAccordingToMagazine:[self.catagoryInfo objectForKey:WEBSITE_ID] andCatalog:[self.catagoryInfo objectForKey:WEBSITE_CATEGORY] andLastId:@"0" successResult:^(id dataResponse, NSError *error) {
       if (dataResponse != nil)
       {
//           NSLog(@"get list article -------- %@",dataResponse);
           
           [tableData addObjectsFromArray:dataResponse];
           [self.tableView reloadData];
        
//           [self importDataToRealm];
           
           
       }
    }];
    
    
}

-(void) loadMoreData
{
    NSDictionary *lastArticle = [tableData lastObject];
    
    [ARTIST_API getListArticleAccordingToMagazine:[self.catagoryInfo objectForKey:WEBSITE_ID] andCatalog:[self.catagoryInfo objectForKey:WEBSITE_CATEGORY] andLastId:[lastArticle objectForKey:LID] successResult:^(id dataResponse, NSError *error) {
        if (dataResponse != nil)
        {
//            NSLog(@"get list article -------- %@",dataResponse);
            [tableData addObjectsFromArray:dataResponse];
            [self.tableView reloadData];
            
            
        }
    }];

}

//-(void) importDataToRealm
//{
//    NSLog(@"import data to realm ");
//    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    // Import many items in a background thread
//    dispatch_async(queue, ^{
//        // Get new realm and table since we are in a new thread
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm beginWriteTransaction];
//        [tableData  enumerateObjectsUsingBlock:^(NSDictionary * article, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            ArticleObject *object = [[ArticleObject alloc] initWithDictionary:article];
//            [ArticleObject createInRealm:realm withValue:object];
//            
//        }];
//        [realm commitWriteTransaction];
//    });
//    
//}



-(void) testYahooWeather
{
  
    WeatherObject *weather = [[WeatherObject alloc] getWeatherForecast];

    NSLog(@"weather of hanoi is %@",weather.hanoiWeather);
    NSLog(@"weather of hochiminh is %@",weather.hochiminhWeather);
    NSLog(@"weather of danang is %@",weather.danangWeather);

    
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [self.catagoryInfo objectForKey:WEBSITE_NAME];
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor whiteColor];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
























