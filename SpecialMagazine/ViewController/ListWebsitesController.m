//
//  ListWebsitesController.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-10-03.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "ListWebsitesController.h"
#import "ListWebsiteCell.h"
#import "ContainViewController.h"
#import "NewStyleViewController.h"


@interface ListWebsitesController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *tableData;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ListWebsitesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = YES;
    [self getCatagories];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void) getCatagories
{
    [ARTIST_API getAllWebsite:^(id dataResponse, NSError *error) {
        
        if (dataResponse != nil) {
            //            NSLog(@"get list all website ----------- %@",dataResponse);
            
            tableData = dataResponse;
            [self.tableView reloadData];
        }
        
    }];
    
}



#pragma mark - TableView Datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListWebsiteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListWebsiteCell" forIndexPath:indexPath];
    
    NSDictionary *websiteInfo = [tableData objectAtIndex:indexPath.row];
    
    [cell.websiteIcon sd_setImageWithURL:[websiteInfo objectForKey:WEBSITE_ICON]];
    cell.websiteName.text = [websiteInfo objectForKey:WEBSITE_NAME];
    
    
    
    return cell;
    
}

#pragma mark - TableView Delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *websiteInfo = [tableData objectAtIndex:indexPath.row];
    NSArray *catalogWebsite = [websiteInfo objectForKey:WEBSITE_CATEGORY];
    
    NSMutableArray *categoriesInWebsite = [NSMutableArray new];
    
    for (NSDictionary *dic in catalogWebsite) {
        
        NSMutableDictionary *tempDic = [NSMutableDictionary new];
        [tempDic setObject:[websiteInfo objectForKey:WEBSITE_ID] forKey:WEBSITE_ID];
        [tempDic setObject:[dic objectForKey:WEBSITE_ID] forKey:WEBSITE_CATEGORY];
        [tempDic setObject:[dic objectForKey:WEBSITE_NAME] forKey:WEBSITE_NAME];
        
        [categoriesInWebsite addObject:tempDic];
        
    }
    
//    ContainViewController *containView = [self.storyboard instantiateViewControllerWithIdentifier:@"ContainViewController"];
//    containView.listCatagories = categoriesInWebsite;
//    [containView reloadPagerTabStripView];
//    [self.navigationController pushViewController:containView animated:YES];

    
    NewStyleViewController *newStyleController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewStyleViewController"];
    newStyleController.listCatagories = categoriesInWebsite;
    [newStyleController reloadCatagories];
    
//    [self presentViewController:newStyleController animated:YES completion:nil];
    
    [self.navigationController pushViewController:newStyleController animated:YES];
    
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
