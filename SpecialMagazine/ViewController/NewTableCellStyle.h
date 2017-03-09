//
//  NewTableCellStyle.h
//  SpecialMagazine
//
//  Created by Macbook Pro on 3/9/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTableCellStyle : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *articleImage;

@property (weak, nonatomic) IBOutlet UILabel *articleTitle;

@property (weak, nonatomic) IBOutlet UITextView *articleDescription;

@end
