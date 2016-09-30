//
//  LaunchingViewController.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-09-30.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "LaunchingViewController.h"
#import "ContainViewController.h"


@interface LaunchingViewController ()
{
    NSMutableArray *listWebsites;

}
@end

@implementation LaunchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getCatagories];
    
}

- (IBAction)clickToStart:(id)sender {
    
    
    ContainViewController *containViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContainViewController"];
//    containViewController.listCatagories = listWebsites;
    [self presentViewController:containViewController animated:YES completion:nil];
    
    
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
            NSLog(@"get catagories done");
            
        }
        
    }];
    
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
