//
//  CellCollectionView.h
//  SpecialMagazine
//
//  Created by MobileFolk on 2016-10-25.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellCollectionView : UICollectionViewCell



@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
