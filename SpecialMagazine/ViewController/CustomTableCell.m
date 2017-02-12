//
//  CustomTableCell.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 2/8/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import "CustomTableCell.h"
#import "CellCollectionView.h"

@implementation CustomTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupCollectionView];
    [self createLoadingView];
    
    
}

-(void) createLoadingView
{
    int randomInt = arc4random_uniform(33);
    
    int randomColor = arc4random_uniform(14);
    
    
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[ACTIVE_TYPE[randomInt] integerValue] tintColor:FLAT_COLOR[randomColor]];
    CGFloat width = SCREEN_WIDTH / 5.0f;
    CGFloat height = SCREEN_HEIGHT / 7.0f;
    
    activityIndicatorView.frame = CGRectMake(0, 0, width, height);
    
    activityIndicatorView.center = CGPointMake(self.center.x - 40, self.center.y - 20);
    
    
    [self addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
}

-(void) setupCollectionView
{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"CellCollectionView" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CollectionCell"];
    
    UICollectionViewFlowLayout *layoutCollectionView = [[UICollectionViewFlowLayout alloc] init];
    layoutCollectionView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [layoutCollectionView setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    layoutCollectionView.itemSize = CGSizeMake(SCREEN_WIDTH - 30, SCREEN_HEIGHT - 20);
    layoutCollectionView.minimumInteritemSpacing = 0;
    layoutCollectionView.minimumLineSpacing = 0;
    
    
    self.collectionView.collectionViewLayout = layoutCollectionView;
    self.collectionView.pagingEnabled = YES;
    
    
}

-(void) getDataLocal
{
    NSLog(@"get local data ----");
    
    collectionData = [NSMutableArray new];
    NSArray *allLocalData = (NSArray*)[ArticleRealm allObjects];
    
    for (ArticleRealm *object in allLocalData) {
        
        [collectionData addObject:object];
        
    }
    
    //    NSLog(@"all data in local is %@",collectionData);
    
    
    [self.collectionView reloadData];
    
    
}


-(void) loadingDataForCatalog:(NSDictionary *) catagoryInfo
{
    self.cellCatagoryInfo = catagoryInfo;
    self.collectionView.hidden = YES;
    activityIndicatorView.hidden = NO;
    [activityIndicatorView startAnimating];
    
  NSLog(@"one catagory is %@",catagoryInfo);
    
    collectionData = [NSMutableArray new];
    
    [ARTIST_API getListArticleAccordingToMagazine:[catagoryInfo objectForKey:WEBSITE_ID] andCatalog:[catagoryInfo objectForKey:WEBSITE_CATEGORY] andLastId:@"0" successResult:^(id dataResponse, NSError *error) {
        if (dataResponse != nil)
        {
            NSArray *gettingArray = dataResponse;
            
            [gettingArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                ArticleRealm * realmObject = [[ArticleRealm alloc] initWithDictionary:obj];
                
                [collectionData addObject:realmObject];
                
            }];
            
            NSLog(@"done loading data from server ");
            
            [self.collectionView reloadData];
            
            self.collectionView.hidden = NO;
            
            
            self.collectionView.scrollsToTop = YES;
            
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            
            
            
            [activityIndicatorView stopAnimating];
            activityIndicatorView.hidden = YES;
            
            
        }
        else
        {
            [self getDataLocal];
        }
    }];
    
}

-(void) loadMoreData
{
    ArticleRealm *lastArticle = [collectionData lastObject];
    
    [ARTIST_API getListArticleAccordingToMagazine:[self.cellCatagoryInfo objectForKey:WEBSITE_ID] andCatalog:[self.cellCatagoryInfo objectForKey:WEBSITE_CATEGORY] andLastId:lastArticle.lid successResult:^(id dataResponse, NSError *error) {
        if (dataResponse != nil)
        {
            NSArray *gettingArray = dataResponse;
            
            [gettingArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                ArticleRealm * realmObject = [[ArticleRealm alloc] initWithDictionary:obj];
                
                [collectionData addObject:realmObject];
                
            }];
            [self.collectionView reloadData];
            
        }
    }];
    
}


#pragma mark - CollectionView Datasource
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellCollectionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    //    cell.lable.text = [NSString stringWithFormat:@"%i",(int)indexPath.row];
    ArticleRealm *cellData = [collectionData objectAtIndex:indexPath.row];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [cell layoutIfNeeded];
    
    
    //    [cell.image startLoaderWithTintColor:[UIColor blueColor]];
    
    
    //    [cell.image sd_setImageWithURL:[NSURL URLWithString:cellData.coverImageUrl]
    //                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    //    __weak typeof(CellCollectionView) *weakCell = cell;
    //
    //    [cell.image sd_setImageWithURL:[NSURL URLWithString:cellData.coverImageUrl] placeholderImage:nil options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //
    //        [weakCell.image updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    //
    //    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //
    //        [weakCell.image reveal];
    //
    //    }];
    
    
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"laughingMinion.gif" ofType:nil]];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:fileURL]];
    cell.loadingView.animatedImage = image;
    cell.loadingView.hidden = NO;
    
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:cellData.coverImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil) {
            
            cell.loadingView.hidden = YES;
            cell.image.image = image;
            
        }
        
    }];
    
    
    
    
    
    cell.title.text = cellData.titleArticle;
    
    cell.descriptionLabel.text = cellData.descriptionArticle;
    
    //    cell.catagory.text = [self.cellCatagoryInfo objectForKey:@"name"];
    cell.catagory.hidden = YES;
    
    
    //    NSLog(@"array content is %@", [NSKeyedUnarchiver unarchiveObjectWithData:cellData.arrayContent]);
    
    return cell;
}


#pragma mark CollectionView Delegate
-(void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > collectionData.count - 3) {
        NSLog(@"start to load more");
        [self loadMoreData];
    }
    
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<CustomTableCellDelegate> strongDelegate = self.delegate;
    
    ArticleRealm *cellData = [collectionData objectAtIndex:indexPath.row];
    
    if ([strongDelegate respondsToSelector:@selector(selectedArticleWithInformation:)]) {
        [strongDelegate selectedArticleWithInformation:cellData];
    }
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end






















