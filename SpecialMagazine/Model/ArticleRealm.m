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


@implementation ArticleRealm

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        
        self.sid = [[dictionary objectForKey:SID] intValue];
        self.content = [dictionary objectForKey:CONTENT];
        self.coverImageUrl = [dictionary objectForKey:COVER_IMAGE];
        self.descriptionArticle = [dictionary objectForKey:DESC];
        self.hasVideos =[NSNumber numberWithBool: [[dictionary objectForKey:HAS_VIDEOS] boolValue]];
        self.lid = [dictionary objectForKey:LID] ;
        NSArray *listPictures = [dictionary objectForKey:LIST_IMAGES];
        [self preLoadImageForArticle:listPictures];
        self.listImages = [NSKeyedArchiver archivedDataWithRootObject:listPictures];
        NSArray *listMp4 = [dictionary objectForKey:LIST_VIDEOS];
        self.listVideos =  [NSKeyedArchiver archivedDataWithRootObject:listMp4];
        self.postTime = [[dictionary objectForKey:POST_TIME] doubleValue];
        self.titleArticle = [dictionary objectForKey:TITLE_ARTICLE];
        self.originalLink = [dictionary objectForKey:ORIGINAL_LINK];
        self.cid = [[dictionary objectForKey:CID] intValue];
        
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
    
    return string3;
}



-(void) preLoadImageForArticle:(NSArray *) listImage
{
//    NSLog(@"preload image for article");
    
    NSMutableArray *temp = [NSMutableArray new];
    
    [listImage enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *url = [NSURL URLWithString:obj];
        [temp addObject:url];
    }];
    
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:temp];
    [SDWebImagePrefetcher sharedImagePrefetcher].options = SDWebImageHighPriority;
    

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
            [temp addObject:element.firstChild.content];

        }
        
        if (element.firstChild.content == nil) {
//            NSLog(@"each element element.firstChild.attributes in this object is:%@",[element.firstChild.attributes objectForKey:@"src"]);
            
            if ([element.firstChild.attributes objectForKey:@"src"] != nil) {
                NSDictionary *linkImage = @{LINK_IMAGE:[element.firstChild.attributes objectForKey:@"src"]};
                [temp addObject:linkImage];
            }
        }
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
