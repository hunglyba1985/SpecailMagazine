//
//  NewStyleViewController.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 10/25/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "NewStyleViewController.h"
#import "CollectionViewCell.h"
#import "DetailViewController.h"
#import "HMSegmentedControl.h"
#import "NewDetailViewController.h"
#import "CustomTableCell.h"
#import "ListWebsitesController.h"



@interface NewStyleViewController () <UICollectionViewDelegate,UICollectionViewDataSource,CollectionViewCellDelegate,UITableViewDataSource,UITableViewDelegate,CustomTableCellDelegate,ListWebsitesControllerDelegate>
{
    NSMutableArray *collectionData;
    UIView *topNavigationView;
    BOOL haveInternet;
    HMSegmentedControl*    segmentedControl1;
    UIColor *categoryBarColor;
    UIColor *indicateBarColor;
    
    ListWebsitesController *listWebsites;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation NewStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor yellowColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpCollectionView];
    [self setCategoryColor];
    [self addTopNavigationView];
    
}

-(void) setCategoryColor
{
    int randomColor = arc4random_uniform(14);
    categoryBarColor = FLAT_COLOR[randomColor];
    
    int anotherRandomColor = arc4random_uniform(8);
    indicateBarColor = FLAT_COLOR[anotherRandomColor];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void) addTopNavigationView
{
    topNavigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    topNavigationView.backgroundColor = categoryBarColor;
    [self.view addSubview:topNavigationView];
    [self addVerticalSegment];
}

-(void) setupTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}



- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NSLog(@"NewStyleViewController internet chagne satatt");
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    if (netStatus == NotReachable) {
        NSLog(@"don't have internet");
        [JDStatusBarNotification showWithStatus:@"Bạn đang không kết nối internet" dismissAfter:3 styleName:JDStatusBarStyleWarning];
        
    }
    else
    {
        NSLog(@" have internet");
        [JDStatusBarNotification showWithStatus:@"Bạn đã kết nối internet" dismissAfter:3 styleName:JDStatusBarStyleWarning];
        [self reloadCatagories];
    }

}


-(void) addVerticalSegment
{
    [segmentedControl1 removeFromSuperview];
    
//    NSLog(@"list catalog is %@",self.listCatagories);
    NSMutableArray *listNameOfCatalog = [NSMutableArray new];
    [self.listCatagories enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [listNameOfCatalog addObject:[obj objectForKey:@"name"]];
    }];
    
    
    // Segmented control with scrolling
    segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:listNameOfCatalog];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 20, SCREEN_WIDTH, 30);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.verticalDividerEnabled = YES;
    segmentedControl1.verticalDividerColor = [UIColor whiteColor];
    segmentedControl1.selectionIndicatorColor = indicateBarColor;
    segmentedControl1.backgroundColor = categoryBarColor;
    segmentedControl1.verticalDividerWidth = 1.0f;
    [segmentedControl1 setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:16]}];
        return attString;
    }];
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
//    __weak typeof(self) weakSelf = self;
//    [segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
//        [weakSelf.collectionView scrollRectToVisible:CGRectMake((SCREEN_HEIGHT - 20) * index, 0, SCREEN_HEIGHT - 20, 200) animated:YES];
//    }];
//
    
    
    
//    CGRect newFrame = rotateView.frame;
//    newFrame.origin = CGPointMake(0, 20);
//    rotateView.frame = newFrame;
    
    [topNavigationView addSubview:segmentedControl1];
}

- (IBAction)showListWebsite:(id)sender {
    
    if (listWebsites == nil) {
        listWebsites = [self.storyboard instantiateViewControllerWithIdentifier:@"ListWebsitesController"];
        listWebsites.delegate = self;
        [self presentViewController:listWebsites animated:YES completion:nil];
    }
    else
    {
        [self presentViewController:listWebsites animated:YES completion:nil];
    }
  
    
    
}

#pragma mark - ListWebsiteViewDelegate
-(void) selectWebsiteWithInfo:(NSArray *)websiteData
{
    self.collectionView.hidden = YES;
    self.listCatagories = websiteData;
    [self addVerticalSegment];
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.collectionView.hidden = NO;
}



-(void) setUpCollectionView
{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
//    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell Collection"];
    UINib *nib = [UINib nibWithNibName:@"CollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"Cell Collection"];
    
    
    UICollectionViewFlowLayout *layoutCollectionView = [[UICollectionViewFlowLayout alloc] init];
    layoutCollectionView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [layoutCollectionView setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
//    layoutCollectionView.minimumInteritemSpacing = 0;
//    layoutCollectionView.minimumLineSpacing = 0;
    
    self.collectionView.collectionViewLayout = layoutCollectionView;
    
    self.collectionView.pagingEnabled = YES;
    
    collectionData = [NSMutableArray new];
    

}

-(void) reloadCatagories
{
    [self.collectionView reloadData];
    
}

#pragma mark - TableView Datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listCatagories.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableCell"];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomTableCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;

    cell.delegate = self;
    
    NSDictionary *oneCatagory = [self.listCatagories objectAtIndex:indexPath.row];
    [cell loadingDataForCatalog:oneCatagory];
    
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT - 20;
}




#pragma mark - CollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listCatagories.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell Collection" forIndexPath:indexPath];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [cell layoutIfNeeded];
    
    cell.delegate = self;
    
    
    
#pragma mark - For have internet
    NSDictionary *oneCatagory = [self.listCatagories objectAtIndex:indexPath.row];
//    NSLog(@"one catagory is %@",oneCatagory);

    [cell loadingDataForCatalog:oneCatagory];
    
#pragma mark - For not have internet
//      [cell getDataLocal];
    
    return cell;
}

-(UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

#pragma mark CollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH - 10, self.collectionView.frame.size.height - 10);
}




- (IBAction)backToList:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




#pragma mark - CollectionViewCell Delegate
-(void) selectedArticleWithInformation:(ArticleRealm *)artistInfo
{
//    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
//
//    detail.article = artistInfo;
    
//    NSLog(@"article information is %@",artistInfo);
//    [self presentViewController:detail animated:YES completion:nil];
    
    NewDetailViewController *newDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"NewDetailViewController"];
    newDetail.article = artistInfo;
    
    [self.navigationController pushViewController:newDetail animated:YES];
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
//    NSLog(@"page of collection view is %i",(int) page);
    
    
    [segmentedControl1 setSelectedSegmentIndex:page animated:YES];
}

#pragma mark - Segment Delegate
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
 
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:segmentedControl.selectedSegmentIndex inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    
}

- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
