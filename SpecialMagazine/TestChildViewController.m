//
//  TestChildViewController.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-09-30.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "TestChildViewController.h"

@interface TestChildViewController ()

@end

@implementation TestChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"View";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor whiteColor];
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
