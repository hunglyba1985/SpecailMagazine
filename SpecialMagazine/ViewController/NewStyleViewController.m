//
//  NewStyleViewController.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 10/25/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "NewStyleViewController.h"
#import "CollectionViewCell.h"

@interface NewStyleViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *collectionData;
    
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
    
    NSDictionary *oneCatagory = [self.listCatagories objectAtIndex:indexPath.row];
    [cell loadingDataForCatalog:oneCatagory];
    
    return cell;
}


#pragma mark CollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT - 10);
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
