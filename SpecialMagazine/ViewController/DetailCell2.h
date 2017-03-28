//
//  DetailCell2.h
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-05.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageViewAligned.h"
#import "DGActivityIndicatorView.h"


@interface DetailCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageViewAligned *imageCell;

@property (nonatomic,strong)  DGActivityIndicatorView *activityIndicatorView;

@end
