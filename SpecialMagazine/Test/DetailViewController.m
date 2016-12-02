//
//  DetailViewController.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 9/20/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "DetailViewController.h"
#import "IDMPhotoBrowser.h"


@interface DetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    
    NSLog(@"content article is %@",[self.article objectForKey:CONTENT]);
    
    [self.webView loadHTMLString:[self.article objectForKey:CONTENT] baseURL:nil];
    
    self.webView.delegate = self;
    
}


#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView

{
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"function showImageArticle(a){window.location = 'img://' + a}"];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    NSURL *action = request.URL;
    
    if ([[action scheme] isEqualToString:@"img"]) {
        
        NSLog(@"string get from click on image is %@",action);
        
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
    
    NSLog(@"current image link is %@",currentImageLink);
    
    NSArray *arrayImages = [self.article objectForKey:LIST_IMAGES];
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:arrayImages];
    
    [browser setInitialPageIndex:[arrayImages indexOfObject:currentImageLink]];
    
    [self presentViewController:browser animated:YES completion:nil];
    
    
}

- (IBAction)backToCatalog:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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
