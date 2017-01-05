//
//  ArticleRealm.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-04.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import "ArticleRealm.h"
#import "TFHpple.h"

@implementation ArticleRealm

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        
        self.sid = [[dictionary objectForKey:SID] intValue];
        self.content = [dictionary objectForKey:CONTENT];
        self.coverImageUrl = [dictionary objectForKey:COVER_IMAGE];
        self.descriptionArticle = [dictionary objectForKey:DESC];
        self.hasVideos =[NSNumber numberWithBool: [[dictionary objectForKey:HAS_VIDEOS] boolValue]];
        self.lid = [[dictionary objectForKey:LID] intValue];
        NSArray *listPictures = [dictionary objectForKey:LIST_IMAGES];
        self.listImages = [NSKeyedArchiver archivedDataWithRootObject:listPictures];
        NSArray *listMp4 = [dictionary objectForKey:LIST_VIDEOS];
        self.listVideos =  [NSKeyedArchiver archivedDataWithRootObject:listMp4];
        self.postTime = [[dictionary objectForKey:POST_TIME] doubleValue];
        self.titleArticle = [dictionary objectForKey:TITLE_ARTICLE];
        self.originalLink = [dictionary objectForKey:ORIGINAL_LINK];
        self.cid = [[dictionary objectForKey:CID] intValue];
        
        NSArray *temp = [self convertHtmlStringToArray:self.content];
        
        self.arrayContent = [NSKeyedArchiver archivedDataWithRootObject:temp];
        
    }
    
    return self;
}


-(NSArray *) convertHtmlStringToArray:(NSString *) htmlStr
{
    
    
    NSMutableArray *temp = [NSMutableArray new];
    
    NSData* data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];

    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tutorialsXpathQueryString = @"//div[@class='text-conent']/p";
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
