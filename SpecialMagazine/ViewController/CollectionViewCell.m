//
//  CollectionViewCell.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 10/25/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "CollectionViewCell.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "NewTableCellStyle.h"
#import "ODRefreshControl.h"



NSDictionary * catagoryInfor;

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    [self setupTableView];
    
    [self addLoadingView];
}

-(void) addLoadingView
{
        self.tableView.hidden = YES;
        int randomInt = arc4random_uniform(33);
        int randomColor = arc4random_uniform(14);
        activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[ACTIVE_TYPE[randomInt] integerValue] tintColor:FLAT_COLOR[randomColor]];
        CGFloat width = SCREEN_WIDTH / 5.0f;
        CGFloat height = SCREEN_HEIGHT / 7.0f;

        activityIndicatorView.frame = CGRectMake(0, 0, width, height);

        activityIndicatorView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 20);


        [self addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
}


-(void) setupTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.pagingEnabled = YES;
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    NSLog(@"start refresh data ----------  ");
//    double delayInSeconds = 3.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [refreshControl endRefreshing];
//    });
    
    [self loadingDataForCatalog:self.cellCatagoryInfo];
    
}


#pragma mark - TableView Datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return collectionData.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTableCellStyle *cell = [tableView dequeueReusableCellWithIdentifier:@"NewStyleTableCell"];
    
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewTableCellStyle" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ArticleRealm *cellData = [collectionData objectAtIndex:indexPath.row];
    
    cell.articleTitle.text = cellData.titleArticle;
    
    cell.articleDescription.text = cellData.descriptionArticle;
    
    cell.articleImage.alignTop = YES;
    
    [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:cellData.coverImageUrl]];
    
    cell.clickButton.tag = indexPath.row;
    
    [cell.clickButton addTarget:self action:@selector(clickToCell:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

#pragma mark - TableView Delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_HEIGHT - 60);
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > collectionData.count - 3) {
        printf("start to load more ");
        [self loadMoreData];
    }
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"click table cell -------------- ");
//    id<CollectionViewCellDelegate> strongDelegate = self.delegate;
//    
//    ArticleRealm *cellData = [collectionData objectAtIndex:indexPath.row];
//    
//    if ([strongDelegate respondsToSelector:@selector(selectedArticleWithInformation:)]) {
//        [strongDelegate selectedArticleWithInformation:cellData];
//    }

}

-(void) clickToCell:(UIButton *) button
{
    id<CollectionViewCellDelegate> strongDelegate = self.delegate;
    
    ArticleRealm *cellData = [collectionData objectAtIndex:button.tag];
    
    if ([strongDelegate respondsToSelector:@selector(selectedArticleWithInformation:)]) {
        [strongDelegate selectedArticleWithInformation:cellData];
    }

}



#pragma mark ------------------------------------------ OLD STYLE --------------------------------------------------------

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
    
    NSLog(@"all local data in realm is %i",(int)allLocalData.count);
    
    for (ArticleRealm *object in allLocalData) {
        
        [collectionData addObject:object];
        
    }
    
//    NSLog(@"all data in local is %@",collectionData);
    
    if (collectionData.count > 0) {
        
        [self startShowArticle];
        
    }
    
}


-(void) startShowArticle
{
    [self.tableView reloadData];
    self.tableView.hidden = NO;
    
    [activityIndicatorView stopAnimating];
    activityIndicatorView.hidden = YES;

}

-(void) loadingDataForCatalog:(NSDictionary *) catagoryInfo
{
    self.cellCatagoryInfo = catagoryInfo;
    
//    NSLog(@"one catagory is %@",catagoryInfor);

    
    collectionData = [NSMutableArray new];

    [ARTIST_API getListArticleAccordingToMagazine:[catagoryInfo objectForKey:WEBSITE_ID] andCatalog:[catagoryInfo objectForKey:WEBSITE_CATEGORY] andLastId:@"0" successResult:^(id dataResponse, NSError *error) {
        if (dataResponse != nil)
        {
//            NSLog(@"getting new data here ");
            NSArray *gettingArray = dataResponse;
            
            [gettingArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                ArticleRealm * realmObject = [[ArticleRealm alloc] initWithDictionary:obj];
                
                [collectionData addObject:realmObject];
                
            }];
            
//            [self.collectionView reloadData];
//
//            
//            self.collectionView.scrollsToTop = YES;
//            
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            

            [self startShowArticle];
            
            
        }
        else
        {
            NSLog(@"getting local data");
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
//            [self.collectionView reloadData];
            [self.tableView reloadData];
            
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










