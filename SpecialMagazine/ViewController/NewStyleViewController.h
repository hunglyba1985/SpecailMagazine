//
//  NewStyleViewController.h
//  SpecialMagazine
//
//  Created by Macbook Pro on 10/25/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewStyleViewController : UIViewController

@property (nonatomic,strong) NSArray* listCatagories;
@property (nonatomic,strong) NSString* nameOfWebsite;

-(void) reloadCatagories;




@end
