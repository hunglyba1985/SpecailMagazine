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
    NSString *postLink =[NSString stringWithFormat:@"%@/v2.0/website",URL_BASE];
    
    NSDictionary *parameters = @{
                                 };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:postLink parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        result(responseObject,nil);
        
//        NSLog(@"response object is %@",responseObject);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error %@",error);
        
        result (nil,error);
        
        
    }];


    
    
    
}










@end
























