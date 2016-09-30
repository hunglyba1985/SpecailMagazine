//
//  ViewController.h
//  SpecialMagazine
//
//  Created by Macbook Pro on 9/3/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"

@interface ViewController : UIViewController <XLPagerTabStripChildItem>

@property (nonatomic,strong) NSDictionary *catagoryInfo;


@end

