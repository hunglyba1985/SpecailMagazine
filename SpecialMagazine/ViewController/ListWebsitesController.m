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
#import "CatalogRealm.h"


@interface ListWebsitesController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tableData;
    BOOL firstTime;
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ListWebsitesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableData = [NSMutableArray new];
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = YES;
    
    [self getDataFromLocal];

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
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    [ARTIST_API getAllWebsite:^(id dataResponse, NSError *error) {
        
        if (dataResponse != nil) {
//                        NSLog(@"get list all website ----------- %@",dataResponse);
            
            NSArray *temp = (NSArray*)dataResponse;
            
            [temp enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CatalogRealm *websiteRealm = [[CatalogRealm alloc] initWithDictionary:obj];
                
                if (firstTime) {
                    [tableData addObject:websiteRealm];
                }
                else
                {
                    [tempArray addObject:websiteRealm];

                }
            }];
            
            if (firstTime) {
                [self.tableView reloadData];
                firstTime = NO;
            }
            else
            {
                [self addDataToRealm:tempArray];

            }
        }
        
    }];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
        [self getCatagories];

}



-(void) getDataFromLocal
{
    NSArray *allLocalData = (NSArray*)[CatalogRealm allObjects];
    NSLog(@"load local data  %i",(int)allLocalData.count);

    if (allLocalData.count > 0) {
        for (CatalogRealm *object in allLocalData) {
            
            [tableData addObject:object];
            
        }
        
        [self.tableView reloadData];

    }
    else
    {
        NSLog(@"first time get data");
        firstTime = YES;
        [self getCatagories];
    }
    
    
    
}

-(void) addDataToRealm:(NSArray*) data
{
    NSLog(@"add catalog to realm");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(queue, ^{
        // Get the default Realm
        RLMRealm *realm = [RLMRealm defaultRealm];
        // You only need to do this once (per thread)
        
        [data enumerateObjectsUsingBlock:^(CatalogRealm * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:obj];
            [realm commitWriteTransaction];
            
            
        }];
        
    });
}



#pragma mark - TableView Datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListWebsiteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListWebsiteCell" forIndexPath:indexPath];
    
    CatalogRealm *websiteInfo = [tableData objectAtIndex:indexPath.row];
    
    [cell.websiteIcon sd_setImageWithURL:[NSURL URLWithString:websiteInfo.websiteIconLink]];
    
    
    cell.websiteName.text = websiteInfo.websiteName;
    
    
    
    return cell;
    
}

#pragma mark - TableView Delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogRealm *websiteInfo = [tableData objectAtIndex:indexPath.row];
    
    NSArray *catalogWebsite =[NSKeyedUnarchiver unarchiveObjectWithData:websiteInfo.categories];
    
    NSMutableArray *categoriesInWebsite = [NSMutableArray new];
    
    for (NSDictionary *dic in catalogWebsite) {
        
        NSMutableDictionary *tempDic = [NSMutableDictionary new];
        [tempDic setObject:[NSString stringWithFormat:@"%li",(long)websiteInfo.id] forKey:WEBSITE_ID];
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
