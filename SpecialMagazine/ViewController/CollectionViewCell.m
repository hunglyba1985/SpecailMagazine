//
//  CollectionViewCell.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 10/25/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "CollectionViewCell.h"


NSDictionary * catagoryInfor;

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // Create random background color
//    CGFloat hue = ( arc4random() % 256 / 256.0 );
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
//    UIColor *randomColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//    self.backgroundColor = randomColor;
    
    [self setupCollectionView];
    
//    self.collectionView.hidden = YES;
    
}

-(void) setupCollectionView
{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"CellCollectionView" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CollectionCell"];
    
    UICollectionViewFlowLayout *layoutCollectionView = [[UICollectionViewFlowLayout alloc] init];
    layoutCollectionView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [layoutCollectionView setSectionInset:UIEdgeInsetsMake(10, 0, 5, 5)];
    layoutCollectionView.itemSize = CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT - 25);
    layoutCollectionView.minimumInteritemSpacing = 0;
    layoutCollectionView.minimumLineSpacing = 0;
    
    
    self.collectionView.collectionViewLayout = layoutCollectionView;
    self.collectionView.pagingEnabled = YES;
    collectionData = [NSMutableArray new];
    
    
}

-(void) loadingDataForCatalog:(NSDictionary *) catagoryInfo
{
    catagoryInfor = catagoryInfo;
    
    [ARTIST_API getListArticleAccordingToMagazine:[catagoryInfo objectForKey:WEBSITE_ID] andCatalog:[catagoryInfo objectForKey:WEBSITE_CATEGORY] andLastId:@"0" successResult:^(id dataResponse, NSError *error) {
        if (dataResponse != nil)
        {
            [collectionData addObjectsFromArray:dataResponse];
            [self.collectionView reloadData];
            
        }
    }];

}

-(void) loadMoreData
{
    NSDictionary *lastArticle = [collectionData lastObject];
    
    [ARTIST_API getListArticleAccordingToMagazine:[catagoryInfor objectForKey:WEBSITE_ID] andCatalog:[catagoryInfor objectForKey:WEBSITE_CATEGORY] andLastId:[lastArticle objectForKey:LID] successResult:^(id dataResponse, NSError *error) {
        if (dataResponse != nil)
        {
            [collectionData addObjectsFromArray:dataResponse];
            [self.collectionView reloadData];
            
        }
    }];
    
}



#pragma mark CollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return collectionData.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellCollectionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    //    cell.lable.text = [NSString stringWithFormat:@"%i",(int)indexPath.row];
    NSDictionary *cellData = [collectionData objectAtIndex:indexPath.row];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[cellData objectForKey:COVER_IMAGE]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    cell.title.text = [cellData objectForKey:TITLE_ARTICLE];
    
    cell.descriptionLabel.text = [cellData objectForKey:DESC];
    
    
    return cell;
}

#pragma mark CollectionView Delegate
-(void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > collectionData.count - 3) {
        printf("start to load more ");
        [self loadMoreData];
    }

}



@end










