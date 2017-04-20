//
//  ListWebsitesController.h
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-10-03.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListWebsitesControllerDelegate <NSObject>
@optional

-(void) selectWebsiteWithInfo:(NSArray*) websiteData andWebsiteName:(NSString *) websiteName;


@end

@interface ListWebsitesController : UIViewController

@property (nonatomic,weak) id <ListWebsitesControllerDelegate> delegate;

@end
