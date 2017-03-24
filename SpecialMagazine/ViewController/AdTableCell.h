//
//  AdTableCell.h
//  SpecialMagazine
//
//  Created by Macbook Pro on 3/24/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>


@interface AdTableCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *adIconImageView;
@property (weak, nonatomic) IBOutlet FBMediaView *adCoverMediaView;
@property (strong, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *adBodyLabel;
@property (strong, nonatomic) IBOutlet UIButton *adCallToActionButton;
@property (strong, nonatomic) IBOutlet UILabel *adSocialContextLabel;
@property (strong, nonatomic) IBOutlet UILabel *sponsoredLabel;
@property (weak, nonatomic) IBOutlet FBAdChoicesView *adChoicesView;


-(void) setUpAdWithData:(FBNativeAd *) nativeAd;

@end
