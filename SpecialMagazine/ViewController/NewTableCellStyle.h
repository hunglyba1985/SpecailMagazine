//
//  NewTableCellStyle.h
//  SpecialMagazine
//
//  Created by Macbook Pro on 3/9/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageViewAligned.h"
#import "DGActivityIndicatorView.h"



@interface NewTableCellStyle : UITableViewCell
{
   

}

@property (weak, nonatomic) IBOutlet UIImageViewAligned *articleImage;

@property (weak, nonatomic) IBOutlet UILabel *articleTitle;

@property (weak, nonatomic) IBOutlet UITextView *articleDescription;

@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@property (weak, nonatomic) IBOutlet UILabel *websiteName;


@property (nonatomic,strong)  DGActivityIndicatorView *activityIndicatorView;
@end
