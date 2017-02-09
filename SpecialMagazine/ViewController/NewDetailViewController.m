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

@interface NewDetailViewController () <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    NSArray *tableData;
    NSMutableArray *heightCell;
    UIWebView *detailWebView;
    UIImage *iamge;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *fromNewPaper;


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

    
}

-(void) setTitleAndSourceForArticle
{
    self.articleTitle.text = self.article.titleArticle;
    
}


-(void) createWebViewForCaseFailLoadTable
{
    detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
    [detailWebView loadHTMLString:self.article.content baseURL:nil];
    detailWebView.delegate = self;

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *listVideo = [NSKeyedUnarchiver unarchiveObjectWithData:self.article.listVideos];
    
    if (tableData.count < 3 || listVideo.count > 0 ) {
        
        
        [self.view addSubview:detailWebView];
    }
   
}


#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView

{
    [webView stringByEvaluatingJavaScriptFromString:@"function showImageArticle(a){window.location = 'img://' + a}"];
    
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
//                        NSLog(@"each element element.firstChild.attributes in this object is:%@",[element.firstChild.attributes objectForKey:@"src"]);
            
            if ([element.firstChild.attributes objectForKey:@"src"] != nil) {
                NSDictionary *linkImage = @{LINK_IMAGE:[element.firstChild.attributes objectForKey:@"src"]};
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
    return tableData.count + 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        DetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell1" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.label.text = self.article.titleArticle;
        cell.label.lineBreakMode = NSLineBreakByWordWrapping;
        cell.label.font = [UIFont boldSystemFontOfSize:20];
        cell.label.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
    else
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
            
            
            
            [cell.imageCell sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:LINK_IMAGE]]
                              placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            
            
            return cell;
            
        }
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
            
            [browser setInitialPageIndex:[arrayImages indexOfObject:[dic objectForKey:LINK_IMAGE]]];
            
            [self presentViewController:browser animated:YES completion:nil];
            
        }
    }
  
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
