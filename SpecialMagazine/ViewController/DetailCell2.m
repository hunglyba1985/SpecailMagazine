//
//  DetailCell2.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-05.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import "DetailCell2.h"

@implementation DetailCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self addLoadingView];
}

-(void) addLoadingView
{
    int randomInt = arc4random_uniform(33);
    int randomColor = arc4random_uniform(14);
    self.activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[ACTIVE_TYPE[randomInt] integerValue] tintColor:FLAT_COLOR[randomColor]];
    
    CGRect frameImageView = self.imageCell.frame;
    
    self.activityIndicatorView.frame = CGRectMake(frameImageView.origin.x, frameImageView.origin.y, frameImageView.size.width, frameImageView.size.height);
    
    self.activityIndicatorView.center = self.imageCell.center;
    
    
    
    [self addSubview:self.activityIndicatorView];
    
    
    
    self.activityIndicatorView.hidden = YES;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
