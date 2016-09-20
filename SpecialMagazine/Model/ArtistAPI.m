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
    NSString *endPoint = [NSString stringWithFormat:@"articles?sid=%@&count=24&latest=0&deviceld=%@&lid=%@&cid=%@",sid,DEVICE_ID,lid,cid];
    
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


-(void) baseGetDataFromEndPoint:(NSString *) endPoint andParameter:(NSDictionary *) parameters hasResult:(GetAPIRequestHandle) result
{
    NSString *postLink = [NSString stringWithFormat:@"%@/%@",URL_BASE,endPoint];
    
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







@end
























