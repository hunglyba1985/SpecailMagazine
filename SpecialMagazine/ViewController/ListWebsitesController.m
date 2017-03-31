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
#import <AMTagListView.h>

#define TagInfo  @"Tag Information"
#define CloseTagStr @"Close   "

@interface ListWebsitesController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tableData;
    BOOL firstTime;
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet AMTagListView *listTagView;



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

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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

-(void) setListWebsiteForTagView:(NSArray *) list
{
    [[AMTagView appearance] setTextPadding:CGPointMake(14, 14)];
    [[AMTagView appearance] setTextFont:[UIFont fontWithName:@"Futura" size:14]];

    [list enumerateObjectsUsingBlock:^(CatalogRealm *websiteRealm, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CatalogRealm *websiteInfo = [tableData objectAtIndex:idx];
        
        NSArray *catalogWebsite =[NSKeyedUnarchiver unarchiveObjectWithData:websiteInfo.categories];
        
        NSMutableArray *categoriesInWebsite = [NSMutableArray new];
        
        for (NSDictionary *dic in catalogWebsite) {
            
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            [tempDic setObject:[NSString stringWithFormat:@"%li",(long)websiteInfo.id] forKey:WEBSITE_ID];
            [tempDic setObject:[dic objectForKey:WEBSITE_ID] forKey:WEBSITE_CATEGORY];
            [tempDic setObject:[dic objectForKey:WEBSITE_NAME] forKey:WEBSITE_NAME];
            
            [categoriesInWebsite addObject:tempDic];
            
        }

        NSDictionary *infoForTag = @{TagInfo:categoriesInWebsite};

        AMTagView * tagView = [[AMTagView alloc] init];
        tagView.userInfo = infoForTag;
        tagView.tagText = websiteRealm.websiteName;
        int randomColor = arc4random_uniform(14);
        tagView.tagColor = FLAT_COLOR[randomColor];

        
//        [self.listTagView addTag:websiteRealm.websiteName];
        
        [self.listTagView addTagView:tagView];
        
    }];
    
    
//    [[AMTagView appearance] setAccessoryImage:[UIImage imageNamed:@"close"]];
//    [[AMTagView appearance] setTextPadding:CGPointMake(14, 14)];
//    [[AMTagView appearance] setTextFont:[UIFont fontWithName:@"Futura" size:14]];

    AMTagView * tagView = [[AMTagView alloc] init];
    tagView.userInfo = @{TagInfo:@"Close"};
    tagView.tagText = CloseTagStr;
    int randomColor = arc4random_uniform(14);
    [tagView setAccessoryImage:[UIImage imageNamed:@"close"]];
    
    tagView.tagColor = FLAT_COLOR[randomColor];
    [[AMTagView appearance] setAccessoryImage:[UIImage imageNamed:@"close"]];

//    [self.listTagView addTagView:tagView];
    
    [self.listTagView addTag:CloseTagStr];
    
    [self.listTagView setTapHandler:^(AMTagView * tagView) {
        
        
        if ([tagView.tagText isEqualToString:CloseTagStr]) {
            [self dismissViewControllerAnimated:YES completion:nil];

        }
        else
        {
            NSArray *realData = [tagView.userInfo objectForKey:TagInfo];
            id<ListWebsitesControllerDelegate> strongDelegate = self.delegate;
            
            if ([strongDelegate respondsToSelector:@selector(selectWebsiteWithInfo:)]) {
                [strongDelegate selectWebsiteWithInfo:realData];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        
     
        
    }];
    
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
                    if (![websiteRealm.websiteName containsString:@"Muvik"]) {
                        [tableData addObject:websiteRealm];
                    }
                }
                else
                {
                    if (![websiteRealm.websiteName containsString:@"Muvik"]) {
                        [tempArray addObject:websiteRealm];
                    }

                }
            }];
            
            if (firstTime) {
//                [self.tableView reloadData];
                
                [self setListWebsiteForTagView:tableData];
                firstTime = NO;
            }
            else
            {
                [self addDataToRealm:tempArray];

            }
        }
        
    }];
    
}





-(void) getDataFromLocal
{
    NSArray *allLocalData = (NSArray*)[CatalogRealm allObjects];
    NSLog(@"load local data  %i",(int)allLocalData.count);

    if (allLocalData.count > 0) {
        for (CatalogRealm *object in allLocalData) {
            
            if (![object.websiteName containsString:@"Muvik"]) {
                [tableData addObject:object];
            }
            
            
        }
        
//        [self.tableView reloadData];
        
        [self setListWebsiteForTagView:tableData];
        

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
//    NSLog(@"add catalog to realm");
    
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
    
//    [cell.websiteIcon sd_setImageWithURL:[NSURL URLWithString:websiteInfo.websiteIconLink]];
    
    
//    [cell.websiteIcon sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:websiteInfo.websiteIconLink] placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        if (image) {
//            cell.websiteIcon.image = image;
//        }
//    }];
    
    [cell.websiteIcon sd_setImageWithURL:[NSURL URLWithString:websiteInfo.websiteIconLink] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    
    
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
    
    id<ListWebsitesControllerDelegate> strongDelegate = self.delegate;

    if ([strongDelegate respondsToSelector:@selector(selectWebsiteWithInfo:)]) {
        [strongDelegate selectWebsiteWithInfo:categoriesInWebsite];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
//    NewStyleViewController *newStyleController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewStyleViewController"];
//    newStyleController.listCatagories = categoriesInWebsite;
//    [newStyleController reloadCatagories];
//    [self.navigationController pushViewController:newStyleController animated:YES];
    
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
