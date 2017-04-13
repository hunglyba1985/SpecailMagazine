//
//  NewDetailViewController.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-05.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import "NewDetailViewController.h"
#import "DetailCell1.h"
#import "DetailCell2.h"
#import "TFHpple.h"
#import "IDMPhotoBrowser.h"
#import "AdTableCell.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import "FavoriteArticles.h"
#import <SDWebImagePrefetcher.h>
#import "DGActivityIndicatorView.h"


@interface NewDetailViewController () <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,FBNativeAdDelegate>
{
    NSArray *tableData;
    NSMutableArray *heightCell;
    UIWebView *detailWebView;
    UIImage *iamge;
    BOOL getFbAd;
    UILabel *titleArtitcle;
    BOOL webFinishLoad;
    DGActivityIndicatorView *activityIndicatorView;
    BOOL favoriteStatus;
    FavoriteArticles *deleteFav;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *fromNewPaper;
@property (strong, nonatomic) FBNativeAd *_nativeAd;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;


@end

@implementation NewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"original content is %@",self.article.content);
//    
//    NSString *removeString = [self.article.content stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
//    NSString *string2 = [removeString stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
//    
//    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"<img" withString:@"<div> <p> Please add fucking image here</p> </div>"];
//    
//    
//    NSLog(@"parse image source from string %@",string3);
    
    
    tableData = [NSKeyedUnarchiver unarchiveObjectWithData:self.article.arrayContent];
    
    [self.tableView reloadData];

//    NSLog(@"array content now is %@",tableData);

    [self createWebViewForCaseFailLoadTable];
    
    
//    NSLog(@"when convert to array we have %@",tableData);
    
    [self getHeightForCell];
    
    [self setTitleAndSourceForArticle];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];

    [self loadingFbAd];
    
    [self setFavoriteButtonImage];
    
    
    
}


-(void) loadingFbAd
{
    // Create a native ad request with a unique placement ID (generate your own on the Facebook app settings).
    // Use different ID for each ad placement in your app.
    FBNativeAd *nativeAd = [[FBNativeAd alloc] initWithPlacementID:@"403196480057246_403499533360274"];
    
    // Set a delegate to get notified when the ad was loaded.
    nativeAd.delegate = self;
    
    // Configure native ad to wait to call nativeAdDidLoad: until all ad assets are loaded
    nativeAd.mediaCachePolicy = FBNativeAdsCachePolicyAll;
    
 //   [FBAdSettings addTestDevice:[FBAdSettings testDeviceHash]];
    
    
    // When testing on a device, add its hashed ID to force test ads.
    // The hash ID is printed to console when running on a device.
    // [FBAdSettings addTestDevice:@"THE HASHED ID AS PRINTED TO CONSOLE"];
    
    // Initiate a request to load an ad.
    [nativeAd loadAd];
}




#pragma mark Facebook Ad Delegate
- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    if (self._nativeAd) {
        [self._nativeAd unregisterView];
    }
    
    self._nativeAd = nativeAd;
    getFbAd = YES;
    [self.tableView reloadData];
    
    if (webFinishLoad) {
        [self addFbAdToWebview];
    }
    
}


-(void) addFbAdToWebview
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AdTableCell" owner:self options:nil];
    AdTableCell * cell = (AdTableCell*)[topLevelObjects objectAtIndex:0];

    [cell setUpAdWithData:self._nativeAd];
    
    
    [self._nativeAd registerViewForInteraction:cell
                            withViewController:self];
    
    float heightCurrentContentWebview = detailWebView.scrollView.contentSize.height;
    
    [cell setFrame:CGRectMake(0, heightCurrentContentWebview + 20, SCREEN_WIDTH, 350)];
    
    
    [detailWebView.scrollView addSubview:cell];
    
    detailWebView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, heightCurrentContentWebview + 420);
    
    

}


- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    NSLog(@"Native ad failed to load with error: %@", error);
}



-(void) setTitleAndSourceForArticle
{
    self.articleTitle.text = self.article.titleArticle;
    
}


-(void) createWebViewForCaseFailLoadTable
{
    CGFloat heightTitle = [self getHeightString:self.article.titleArticle withFont:[UIFont boldSystemFontOfSize:20]];

    detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
    detailWebView.backgroundColor = [UIColor whiteColor];
    
    NSString *htmlTitleStr =[NSString stringWithFormat:@"<h2> %@ </h2>",self.article.titleArticle];
    
    NSString *htmlEntailArticle = [NSString stringWithFormat:@"%@ \n %@",htmlTitleStr,self.article.content];
    
    [detailWebView loadHTMLString:htmlEntailArticle baseURL:nil];
    detailWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    
    detailWebView.delegate = self;

    [self addLoadingView];
    
}


-(void) addLoadingView
{
    int randomInt = arc4random_uniform(33);
    int randomColor = arc4random_uniform(14);
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[ACTIVE_TYPE[randomInt] integerValue] tintColor:FLAT_COLOR[randomColor]];
    activityIndicatorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    activityIndicatorView.center = self.view.center;
    

}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *listVideo = [NSKeyedUnarchiver unarchiveObjectWithData:self.article.listVideos];
    

    if (tableData.count < 3 || listVideo.count > 0 ) {

        [self showWebViewInsteadOfTableView];

    }
   
}

-(void) showWebViewInsteadOfTableView
{
     self.tableView.hidden = YES;
//    [self.view addSubview:detailWebView];
    [self.view insertSubview:detailWebView belowSubview:self.favoriteButton];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
}


#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView

{
    [activityIndicatorView stopAnimating];
    activityIndicatorView.hidden = YES;
    
    
    [webView stringByEvaluatingJavaScriptFromString:@"function showImageArticle(a){window.location = 'img://' + a}"];
    
    NSLog(@"scroll view in web view %f",webView.scrollView.contentSize.height);
    
    webFinishLoad = true;
    
    if (getFbAd) {
        [self addFbAdToWebview];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    NSURL *action = request.URL;
    if ([[action scheme] isEqualToString:@"img"]) {
        //        NSLog(@"string get from click on image is %@",action);
        [self showArrayImagesFrom:action.absoluteString];
        return NO;
    }
    
    return YES;
}


-(void) showArrayImagesFrom:(NSString *) imageLink

{
    
    NSArray *arrayString = [imageLink componentsSeparatedByString:@"://"];
    
    NSString *currentImageLink = [arrayString objectAtIndex:1];
    
    currentImageLink = [currentImageLink stringByReplacingOccurrencesOfString:@"//" withString:@"://"];
    
    //    NSLog(@"current image link is %@",currentImageLink);
    
    NSArray *arrayImages = [NSKeyedUnarchiver unarchiveObjectWithData:self.article.listImages] ;
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:arrayImages];
    
    [browser setInitialPageIndex:[arrayImages indexOfObject:currentImageLink]];
    
    [self presentViewController:browser animated:YES completion:nil];
    
    
}


-(NSArray *) convertHtmlStringToArray:(NSString *) htmlStr
{
    
    
    NSMutableArray *temp = [NSMutableArray new];
    
    NSData* data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tutorialsXpathQueryString = @"//p";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    
    [tutorialsNodes enumerateObjectsUsingBlock:^(TFHppleElement *element , NSUInteger idx, BOOL * _Nonnull stop) {
        
//                NSLog(@"get content --------------------%@",element.firstChild.content);
        
        if (element.firstChild.content != nil) {
            [temp addObject:element.firstChild.content];
            
        }
        
        if (element.firstChild.content == nil) {
//                        NSLog(@"each element element.firstChild.attributes in this object is:%@",[element.firstChild.attributes objectForKeyNotNull:@"src"]);
            
            if ([element.firstChild.attributes objectForKeyNotNull:@"src"] != nil) {
                NSDictionary *linkImage = @{LINK_IMAGE:[element.firstChild.attributes objectForKeyNotNull:@"src"]};
                [temp addObject:linkImage];
            }
            
            
        }
        
        
    }];
    
    
    return temp;
}

-(void) getHeightForCell
{
    heightCell = [NSMutableArray new];
    
    CGFloat heightTitle = [self getHeightString:self.article.titleArticle withFont:[UIFont boldSystemFontOfSize:20]];
    
    [heightCell addObject:[NSString stringWithFormat:@"%f",heightTitle]];
    
    
    [tableData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *) obj;
            
            CGFloat heightStr = [self getHeightString:str withFont:[UIFont systemFontOfSize:16]];
            
            [heightCell addObject:[NSString stringWithFormat:@"%f",heightStr]];
            
            
        }
        else
        {
            [heightCell addObject:@"300"];

        }
        
    }];
    
    [heightCell addObject:[NSString stringWithFormat:@"%f",350.0]];
    
    [self.tableView reloadData];
    
}

- (CGFloat)getHeightString:(NSString*)string withFont:(UIFont *) font
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGSize constraint = CGSizeMake((screenWidth - 30), CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [string boundingRectWithSize:constraint
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return (size.height + 8);
}



#pragma mark - TableView Datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (getFbAd) {
        return tableData.count + 2;

    }
    else
    {
        return tableData.count + 1;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        DetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell1" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.label.text = self.article.titleArticle;
        cell.label.lineBreakMode = NSLineBreakByWordWrapping;
        cell.label.font = [UIFont boldSystemFontOfSize:20];
        cell.label.textAlignment = NSTextAlignmentLeft;
        
        return cell;
    }
    else if (indexPath.row > 0 && indexPath.row < (tableData.count + 1))
    {
        id  cellData = [tableData objectAtIndex:(indexPath.row -1)];

        if ([cellData isKindOfClass:[NSString class]]) {
            
            DetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell1" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.label.text = cellData;
            cell.label.lineBreakMode = NSLineBreakByWordWrapping;
            cell.label.font = [UIFont systemFontOfSize:16];
            cell.label.textAlignment = NSTextAlignmentLeft;

            return cell;
            
        }
        else
        {
            DetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell2" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            NSDictionary *dic = (NSDictionary *) cellData;
            
            cell.imageCell.contentMode = UIViewContentModeScaleAspectFill;
            cell.imageCell.alignTop = YES;
            //        cell.imageCell.alignLeft = YES;
            //        cell.imageCell.alignRight = YES;
            
            cell.activityIndicatorView.center = cell.imageCell.center;
            
            cell.activityIndicatorView.hidden = NO;
            [cell.activityIndicatorView startAnimating];
            
            UIImage *storeImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[dic objectForKeyNotNull:LINK_IMAGE]];
            
            if (storeImage) {
                [cell.imageCell setImage:storeImage];
                [cell.activityIndicatorView stopAnimating];
                cell.activityIndicatorView.hidden = YES;
            }
            else
            {
                [cell.imageCell sd_setImageWithURL:[NSURL URLWithString:[dic objectForKeyNotNull:LINK_IMAGE]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        [cell.imageCell setImage:image];
                        [cell.activityIndicatorView stopAnimating];
                        cell.activityIndicatorView.hidden = YES;
                    }
                    
                    
                }];

            }

            
//            [cell.imageCell sd_setImageWithURL:[NSURL URLWithString:[dic objectForKeyNotNull:LINK_IMAGE]]
//                              placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            
            
            return cell;
            
        }
    }
    else
    {
        AdTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdTableCell"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AdTableCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        [cell setUpAdWithData:self._nativeAd];
        
        
        [self._nativeAd registerViewForInteraction:cell
                                 withViewController:self];
        

        return cell;

    }
    
  
    
}

#pragma mark - TableView Delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[heightCell objectAtIndex:indexPath.row] floatValue];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        id  cellData = [tableData objectAtIndex:(indexPath.row -1)];
        
        if (![cellData isKindOfClass:[NSString class]]) {
            
            NSDictionary *dic = (NSDictionary *) cellData;
            
            NSArray *arrayImages = [NSKeyedUnarchiver unarchiveObjectWithData:self.article.listImages] ;
            
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:arrayImages];
            
            [browser setInitialPageIndex:[arrayImages indexOfObject:[dic objectForKeyNotNull:LINK_IMAGE]]];
            
            [self presentViewController:browser animated:YES completion:nil];
            
        }
    }
  
}

#pragma mark - Favorite Function
-(void) setFavoriteButtonImage
{
//    UIImage *image = [[UIImage imageNamed:@"favorite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
//    [self.favoriteButton setBackgroundImage:image forState:UIControlStateNormal];
    
    NSArray *allFavArticles = (NSArray *) [FavoriteArticles allObjects];
    
    if (allFavArticles.count > 0) {
        
        for (FavoriteArticles *favArticle in allFavArticles) {
            ArticleRealm *article = favArticle.favoriteArticle;
            
//            NSLog(@"favorite article title is: %@",article.titleArticle);
//            
//            NSLog(@"find same article tile is: %@",self.article.titleArticle);
            
            if ([article.titleArticle isEqualToString:self.article.titleArticle]) {
                
//                NSLog(@"find same artistcle --------  ");
                //            self.favoriteButton.tintColor = [UIColor redColor];
                [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"closeFav"] forState:UIControlStateNormal];
                deleteFav = favArticle;
                favoriteStatus = YES;
                break;
            }
            else
            {
                [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
                favoriteStatus = NO;
            }
        }
    }
    else
    {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        favoriteStatus = NO;
    }
    
    
    
}

- (IBAction)addFavoriteClick:(UIButton*)sender {

    if (!favoriteStatus) {
//        NSLog(@"button selected");
        sender.tintColor = [UIColor redColor];
        favoriteStatus = YES;
        
        [self addArticleToFavoriteData];
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"closeFav"] forState:UIControlStateNormal];

        
    }
    else
    {
//        NSLog(@"button unselected");
        sender.tintColor = [UIColor greenColor];
        favoriteStatus = NO;
        [self deleteFavArticle];
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];

    }
}


-(void) addArticleToFavoriteData
{
    NSArray *allData = (NSArray*) [FavoriteArticles allObjects];
    
    NSInteger articleId = 0;
    
    if (allData.count > 0) {
        FavoriteArticles *favAritcle = [allData lastObject];
        articleId = favAritcle.id + 1;
        
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(queue, ^{
        // Get the default Realm
        RLMRealm *realm = [RLMRealm defaultRealm];
        // You only need to do this once (per thread)
            FavoriteArticles *favArticle = [[FavoriteArticles alloc] init];
            favArticle.favoriteArticle = self.article;
            favArticle.id = articleId;
            [realm beginWriteTransaction];
            [realm addObject:favArticle];
            [realm commitWriteTransaction];
            
        
    });
    
    NSLog(@"favorite id is %i",(int)articleId);
    
    
    NSArray *arrayImages = [NSKeyedUnarchiver unarchiveObjectWithData:self.article.listImages] ;
    
    __block int numberOfDownloadImage = 0;
    
    for (NSString *imgUrlStr in arrayImages) {
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrlStr] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image && finished) {
                
                numberOfDownloadImage ++;
                // Cache image to disk or memory
                [[SDImageCache sharedImageCache] storeImage:image forKey:imgUrlStr completion:nil];
                
                if (numberOfDownloadImage == arrayImages.count) {
                       [JDStatusBarNotification showWithStatus:@"Lưu bài báo thành công vào Favorite" dismissAfter:3 styleName:JDStatusBarStyleWarning];
                }
            }
        }];

    }
    
}

-(void) deleteFavArticle
{
   
    RLMRealm *realm = [RLMRealm defaultRealm];
    // You only need to do this once (per thread)
    
    [realm beginWriteTransaction];
    [realm deleteObject:deleteFav];
    [realm commitWriteTransaction];

    
    [JDStatusBarNotification showWithStatus:@"Xoá bài báo thành công trong Favorite" dismissAfter:3 styleName:JDStatusBarStyleWarning];

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
