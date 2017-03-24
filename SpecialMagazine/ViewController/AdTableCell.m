//
//  AdTableCell.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 3/24/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import "AdTableCell.h"

@implementation AdTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setUpAdWithData:(FBNativeAd *) nativeAd
{
    // Create native UI using the ad metadata.
    [self.adCoverMediaView setNativeAd:nativeAd];
    
    __weak typeof(self) weakSelf = self;
    [nativeAd.icon loadImageAsyncWithBlock:^(UIImage *image) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.adIconImageView.image = image;
    }];
    
    // Render native ads onto UIView
    self.adTitleLabel.text = nativeAd.title;
    self.adBodyLabel.text = nativeAd.body;
    self.adSocialContextLabel.text = nativeAd.socialContext;
    self.sponsoredLabel.text = @"Sponsored";
    
    [self.adCallToActionButton setHidden:NO];
    [self.adCallToActionButton setTitle:nativeAd.callToAction
                               forState:UIControlStateNormal];
    
    NSLog(@"Register UIView for impression and click...");
    
    // Wire up UIView with the native ad; the whole UIView will be clickable.
//    [nativeAd registerViewForInteraction:self.adUIView
//                      withViewController:self];
    
    // Or you can replace above call with following function, so you can specify the clickable areas.
    // NSArray *clickableViews = @[self.adCallToActionButton, self.adCoverMediaView];
    // [nativeAd registerViewForInteraction:self.adUIView
    //                   withViewController:self
    //                   withClickableViews:clickableViews];
    
    // Update AdChoices view
    self.adChoicesView.nativeAd = nativeAd;
    self.adChoicesView.corner = UIRectCornerTopRight;
    self.adChoicesView.hidden = NO;
}


@end
