//
//  ArticleRealm.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-04.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import "ArticleRealm.h"
#import "TFHpple.h"
#import <SDWebImage/SDWebImagePrefetcher.h>
#import <SDWebImage/SDWebImageManager.h>



@implementation ArticleRealm

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        
        self.sid = [[dictionary objectForKeyNotNull:SID] intValue];
        self.content = [dictionary objectForKeyNotNull:CONTENT];
        self.coverImageUrl = [dictionary objectForKeyNotNull:COVER_IMAGE];
        
        if ([NSURL URLWithString:self.coverImageUrl] != nil) {
            [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[[NSURL URLWithString:self.coverImageUrl]]];
            [[SDWebImagePrefetcher sharedImagePrefetcher] setOptions:SDWebImageHighPriority];
        }
      

        self.descriptionArticle = [dictionary objectForKeyNotNull:DESC];
        self.hasVideos =[NSNumber numberWithBool: [[dictionary objectForKeyNotNull:HAS_VIDEOS] boolValue]];
        self.lid = [dictionary objectForKeyNotNull:LID] ;
        
        NSArray *listPictures = [dictionary objectForKeyNotNull:LIST_IMAGES];
        [self preLoadImageForArticle:listPictures];
        if (listPictures != nil) {
            self.listImages = [NSKeyedArchiver archivedDataWithRootObject:listPictures];
        }
        
        NSArray *listMp4 = [dictionary objectForKeyNotNull:LIST_VIDEOS];
        if (listMp4 != nil) {
            self.listVideos =  [NSKeyedArchiver archivedDataWithRootObject:listMp4];
        }
        
        self.postTime = [[dictionary objectForKeyNotNull:POST_TIME] doubleValue];
        self.titleArticle = [dictionary objectForKeyNotNull:TITLE_ARTICLE];
        self.originalLink = [dictionary objectForKeyNotNull:ORIGINAL_LINK];
        self.cid = [[dictionary objectForKeyNotNull:CID] intValue];
        
        [self replaceSignImageWithActuallyLinkImage:listPictures];
        
        
        
    }
    
    return self;
}

-(void) replaceSignImageWithActuallyLinkImage:(NSArray *) arrayLinkImage
{
    NSArray *temp = [self convertHtmlStringToArray:[self removeUnusedTadAndAddImageSignToHtmlString:self.content]];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:temp];
    
    __block NSInteger index = 0;
//    self.arrayContent = [NSKeyedArchiver archivedDataWithRootObject:temp];
    [temp enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:PLACE_HOLDER_IMAGE]) {
            
            if (index < arrayLinkImage.count) {
                NSDictionary *linkImage = @{LINK_IMAGE:[arrayLinkImage objectAtIndex:index]};
                
                [mutableArray replaceObjectAtIndex:idx withObject:linkImage];
                
                index = index + 1;
            }
        }
        
    }];
    
    
    self.arrayContent = [NSKeyedArchiver archivedDataWithRootObject:mutableArray];

}

-(NSString *) removeUnusedTadAndAddImageSignToHtmlString:(NSString *) original
{
    NSString *removeString = [original stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    NSString *string2 = [removeString stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    
    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<div> <p>%@</p> </div>",PLACE_HOLDER_IMAGE]];
    
    NSString *string4 = [string3 stringByReplacingOccurrencesOfString:@"<i>" withString:@""];
    NSString *string5 = [string4 stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
    
    return string5;
}



-(void) preLoadImageForArticle:(NSArray *) listImage
{
//    NSLog(@"preload image for article");
    
    NSMutableArray *temp = [NSMutableArray new];
    
    [listImage enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *url = [NSURL URLWithString:obj];
        if (url != nil) {
            [temp addObject:url];
        }
    }];
    
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:temp progress:^(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls) {
        
//        NSLog(@"noOfFinishedUrls   %lu",(unsigned long)noOfFinishedUrls);
//        NSLog(@"noOfTotalUrls    %lu",(unsigned long)noOfTotalUrls);
        
        
    } completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
        
//        NSLog(@"noOfFinishedUrls   %lu",(unsigned long)noOfFinishedUrls);
//        NSLog(@"noOfSkippedUrls    %lu",(unsigned long)noOfSkippedUrls);
        
        
    }];
    [[SDWebImagePrefetcher sharedImagePrefetcher] setOptions:SDWebImageContinueInBackground];

    
//    NSLog(@"all thread running in app %@", [NSThread callStackSymbols]);

}


-(NSArray *) convertHtmlStringToArray:(NSString *) htmlStr
{
    
    NSMutableArray *temp = [NSMutableArray new];
    
    NSData* data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];

    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tutorialsXpathQueryString = @"//p";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];

    
    [tutorialsNodes enumerateObjectsUsingBlock:^(TFHppleElement *element , NSUInteger idx, BOOL * _Nonnull stop) {
        
//        NSLog(@"get content --------------------%@",element.firstChild.content);
        if (element.firstChild.content != nil) {
            [temp addObject:[element.firstChild.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

        }
        
//        if (element.firstChild.content == nil) {
//            NSLog(@"each element element.firstChild.attributes in this object is:%@",[element.firstChild.attributes objectForKeyNotNull:@"src"]);
//            
//            if ([element.firstChild.attributes objectForKeyNotNull:@"src"] != nil) {
//                NSDictionary *linkImage = @{LINK_IMAGE:[element.firstChild.attributes objectForKeyNotNull:@"src"]};
//                [temp addObject:linkImage];
//            }
//        }
    }];

    
    return temp;
}



// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
