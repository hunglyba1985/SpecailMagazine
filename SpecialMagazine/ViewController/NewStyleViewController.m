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


@interface NewStyleViewController () <UICollectionViewDelegate,UICollectionViewDataSource,CollectionViewCellDelegate>
{
    NSMutableArray *collectionData;
    HMSegmentedControl *segmentedControl1;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation NewStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor yellowColor];
    
    NSLog(@"new style view controller did load");
    
    [self setUpCollectionView];
    [self addVerticalSegment];
    
}

-(void) addVerticalSegment
{
//    NSLog(@"list catalog is %@",self.listCatagories);
    NSMutableArray *listNameOfCatalog = [NSMutableArray new];
    [self.listCatagories enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [listNameOfCatalog addObject:[obj objectForKey:@"name"]];
    }];
    
    
    // Segmented control with scrolling
    segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:listNameOfCatalog];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 0, SCREEN_HEIGHT - 20, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.verticalDividerEnabled = YES;
    segmentedControl1.verticalDividerColor = [UIColor blackColor];
    segmentedControl1.verticalDividerWidth = 1.0f;
    [segmentedControl1 setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
        return attString;
    }];
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
//    __weak typeof(self) weakSelf = self;
//    [segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
//        [weakSelf.collectionView scrollRectToVisible:CGRectMake((SCREEN_HEIGHT - 20) * index, 0, SCREEN_HEIGHT - 20, 200) animated:YES];
//    }];
//
    
    
    UIView *rotateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT - 20, 40)];
    rotateView.backgroundColor = [UIColor yellowColor];
    rotateView.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    [self.view addSubview:rotateView];
    
    CGRect newFrame = rotateView.frame;
    newFrame.origin = CGPointMake(0, 20);
    rotateView.frame = newFrame;
    
    [rotateView addSubview:segmentedControl1];
}

-(void) setUpCollectionView
{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
//    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell Collection"];
    UINib *nib = [UINib nibWithNibName:@"CollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"Cell Collection"];
    
    
    UICollectionViewFlowLayout *layoutCollectionView = [[UICollectionViewFlowLayout alloc] init];
    layoutCollectionView.scrollDirection = UICollectionViewScrollDirectionVertical;
    [layoutCollectionView setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
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


#pragma mark CollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listCatagories.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell Collection" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    NSDictionary *oneCatagory = [self.listCatagories objectAtIndex:indexPath.row];
    
    
    [cell loadingDataForCatalog:oneCatagory];
    
    
    return cell;
}


#pragma mark CollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - 10);
}




- (IBAction)backToList:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




#pragma mark CollectionViewCell Delegate
-(void) selectedArticleWithInformation:(NSDictionary *)artistInfo
{
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];

    detail.article = artistInfo;
    
    [self presentViewController:detail animated:YES completion:nil];
    
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.height;
    NSInteger page = scrollView.contentOffset.y / pageWidth;
    
//    NSLog(@"page of collection view is %i",(int) page);
    
    
    [segmentedControl1 setSelectedSegmentIndex:page animated:YES];
}

#pragma mark - Segment Delegate
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
 
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:segmentedControl.selectedSegmentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
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
