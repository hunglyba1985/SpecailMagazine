//
//  ArtistAPI.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 9/3/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "ArtistAPI.h"

@implementation ArtistAPI

static ArtistAPI  *sharedController = nil;


+(ArtistAPI *) sharedInstance
{
    if (!sharedController) {
        
        sharedController = [[ArtistAPI alloc] init];
    }
    
    return sharedController;
}


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}



-(void) getAllWebsite:(GetAPIRequestHandle) result
{
    NSString *endPoint = @"website";
    
    NSDictionary *parameters = @{
                                 };
    
    [self baseGetDataFromEndPoint:endPoint andParameter:parameters hasResult:^(id dataResponse, NSError *error) {
        if (dataResponse != nil) {
            NSDictionary *dic = dataResponse;
            NSArray *listWebsites = [dic objectForKey:WEBSITE];
            result(listWebsites,nil);
        }
        else
        {
            result(nil,error);
        }
        
    }];
    
}

-(void) getListArticleAccordingToMagazine:(NSString*) sid andCatalog:(NSString *) cid andLastId:(NSString *) lid successResult:(GetAPIRequestHandle) result
{
    NSString *endPoint = [NSString stringWithFormat:@"articles?sid=%@&count=10&latest=0&deviceld=%@&lid=%@&cid=%@",sid,DEVICE_ID,lid,cid];
    
    NSDictionary *parameters = @{
                                 };
    
    [self baseGetDataFromEndPoint:endPoint andParameter:parameters hasResult:^(id dataResponse, NSError *error) {
       
        if (dataResponse != nil) {
            NSDictionary *dic = dataResponse;
            NSArray *listArticle = [dic objectForKey:LINFOS];
            
            
            result(listArticle,nil);
        }
        else
        {
            result(nil,error);
        }
        
    }];
  
}

-(void) addDataToRealm:(NSArray*) data
{
    NSLog(@"add data to realm");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(queue, ^{
        // Get the default Realm
        RLMRealm *realm = [RLMRealm defaultRealm];
        // You only need to do this once (per thread)
        
        [data enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ArticleRealm *article = [[ArticleRealm alloc] initWithDictionary:obj];
            [realm beginWriteTransaction];
            [realm addObject:article];
            [realm commitWriteTransaction];
            
            
        }];

    });
}


-(void) baseGetDataFromEndPoint:(NSString *) endPoint andParameter:(NSDictionary *) parameters hasResult:(GetAPIRequestHandle) result
{
    NSString *postLink = [NSString stringWithFormat:@"%@/%@",URL_BASE,endPoint];
    
    NSLog(@"post link is %@",postLink);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:postLink parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        result(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error %@",error);
        
        result (nil,error);
        
        
    }];
}



-(void) downloadForNoInternet
{
    self.downloadData = [NSMutableArray new];
    
    
    [self getListArticleAccordingToMagazine:@"999" andCatalog:@"999" andLastId:@"0" successResult:^(id dataResponse, NSError *error) {
        if (dataResponse != nil)
        {
          
            NSArray *arrayArticle = dataResponse;
            [self.downloadData addObjectsFromArray:arrayArticle];
            [self addDataToRealm:arrayArticle];
            [self loadMoreForDownload];
            
        }
    }];

    
}


-(void) loadMoreForDownload
{
    if (self.downloadData.count < 150) {
        NSDictionary *lastArticle = [self.downloadData lastObject];
        
        [self getListArticleAccordingToMagazine:@"999" andCatalog:@"999" andLastId:[lastArticle objectForKey:LID] successResult:^(id dataResponse, NSError *error) {
            if (dataResponse != nil)
            {
                
                NSArray *arrayArticle = dataResponse;
                [self.downloadData addObjectsFromArray:arrayArticle];
                [self addDataToRealm:arrayArticle];
                [self loadMoreForDownload];
                
            }
        }];

    }
    
   
}



@end
























