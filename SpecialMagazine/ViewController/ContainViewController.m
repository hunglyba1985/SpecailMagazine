//
//  ContainViewController.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-09-30.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "ContainViewController.h"
#import "XLButtonBarViewCell.h"
#import "ViewController.h"
#import "TestChildViewController.h"

@interface ContainViewController ()
{
    BOOL _isReload;
    NSMutableArray *listWebsites;
}

@end

@implementation ContainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    listWebsites = [NSMutableArray new];
    
//    [self getCatagories];

    
    [self setupBarView];
    
    
}




-(void) setupBarView
{
    NSLog(@"set up bar view ");
    
    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    self.isProgressiveIndicator = YES;
    // Do any additional setup after loading the view.
    self.buttonBarView.selectedBar.backgroundColor = [UIColor whiteColor];
    self.buttonBarView.backgroundColor = [UIColor blackColor];

    self.changeCurrentIndexProgressiveBlock = ^void(XLButtonBarViewCell *oldCell, XLButtonBarViewCell *newCell, CGFloat progressPercentage, BOOL changeCurrentIndex, BOOL animated){
        if (changeCurrentIndex) {
            
            [oldCell.label setTextColor:[UIColor whiteColor]];
            [newCell.label setTextColor:[UIColor whiteColor]];
            
            if (animated) {
                [UIView animateWithDuration:0.1
                                 animations:^(){
                                     newCell.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                     oldCell.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                 }
                                 completion:nil];
            }
            else{
                newCell.transform = CGAffineTransformMakeScale(1.0, 1.0);
                oldCell.transform = CGAffineTransformMakeScale(0.8, 0.8);
            }
        }
    };

}

-(void) getCatagories
{
    [ARTIST_API getAllWebsite:^(id dataResponse, NSError *error) {
        
        if (dataResponse != nil) {
            //            NSLog(@"get list all website ----------- %@",dataResponse);
            
            NSDictionary *website1 = [dataResponse objectAtIndex:0];
            
            NSArray *catalogWebsite1 = [website1 objectForKey:WEBSITE_CATEGORY];
            
            for (NSDictionary *dic in catalogWebsite1) {
                
                NSMutableDictionary *tempDic = [NSMutableDictionary new];
                [tempDic setObject:[website1 objectForKey:WEBSITE_ID] forKey:WEBSITE_ID];
                [tempDic setObject:[dic objectForKey:WEBSITE_ID] forKey:WEBSITE_CATEGORY];
                [tempDic setObject:[dic objectForKey:WEBSITE_NAME] forKey:WEBSITE_NAME];
                
                [listWebsites addObject:tempDic];
                
                
            }
            
            [self reloadPagerTabStripView];
            
        }
        
    }];
    
}




#pragma mark - XLPagerTabStripViewControllerDataSource

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    // create child view controllers that will be managed by XLPagerTabStripViewController
 
    if (!_isReload) {
        
        TestChildViewController *loadingView = [[TestChildViewController alloc] init];
        
        return @[loadingView];
    }
    else
    {
        NSLog(@"reload new contain view ");
        NSMutableArray *catagories = [NSMutableArray new];
        
        for (NSDictionary *tempDic  in self.listCatagories) {
            
            ViewController *tempViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            tempViewController.catagoryInfo = tempDic;
            [catagories addObject:tempViewController];
            
        }
        
        return catagories;

    }
    
 }

-(void)reloadPagerTabStripView
{
    _isReload = YES;
//    self.isProgressiveIndicator = (rand() % 2 == 0);
//    self.isElasticIndicatorLimit = (rand() % 2 == 0);
    [super reloadPagerTabStripView];
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
