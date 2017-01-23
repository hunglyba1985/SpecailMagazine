//
//  CollectionViewCell.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 10/25/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "CollectionViewCell.h"
#import <FLAnimatedImage/FLAnimatedImage.h>



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
    
    [self checkConnectNetwork];
    
    
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator tintColor:UIColorFromRGB(0xe67e22)];
    CGFloat width = SCREEN_WIDTH / 5.0f;
    CGFloat height = SCREEN_HEIGHT / 7.0f;
    
    activityIndicatorView.frame = CGRectMake(0, 0, width, height);
    
    activityIndicatorView.center = self.center;
    
    
    [self addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
}


-(void) checkConnectNetwork
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        NSLog(@"not connect to internet");
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        NSLog(@"connect to internet by wifi");
        
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        NSLog(@"connect to internet by 3G");
        
    }
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
    layoutCollectionView.itemSize = CGSizeMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - 25);
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
    
//    NSLog(@"one catagory is %@",catagoryInfor);

    collectionData = [NSMutableArray new];

    [ARTIST_API getListArticleAccordingToMagazine:[catagoryInfo objectForKey:WEBSITE_ID] andCatalog:[catagoryInfo objectForKey:WEBSITE_CATEGORY] andLastId:@"0" successResult:^(id dataResponse, NSError *error) {
        if (dataResponse != nil)
        {
            NSArray *gettingArray = dataResponse;
            
            [gettingArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                ArticleRealm * realmObject = [[ArticleRealm alloc] initWithDictionary:obj];
                
                [collectionData addObject:realmObject];
                
            }];
            
            [self.collectionView reloadData];
            
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
    ArticleRealm *cellData = [collectionData objectAtIndex:indexPath.row];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
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
    
    cell.catagory.text = [self.cellCatagoryInfo objectForKey:@"name"];
    
//    NSLog(@"array content is %@", [NSKeyedUnarchiver unarchiveObjectWithData:cellData.arrayContent]);
    
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

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<CollectionViewCellDelegate> strongDelegate = self.delegate;
    
    ArticleRealm *cellData = [collectionData objectAtIndex:indexPath.row];
    
    if ([strongDelegate respondsToSelector:@selector(selectedArticleWithInformation:)]) {
        [strongDelegate selectedArticleWithInformation:cellData];
    }
    
}




@end










