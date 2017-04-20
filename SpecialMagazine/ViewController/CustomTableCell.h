//
//  CustomTableCell.h
//  SpecialMagazine
//
//  Created by Macbook Pro on 2/8/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGActivityIndicatorView.h"


@protocol CustomTableCellDelegate <NSObject>

-(void) selectedArticleWithInformation:(ArticleRealm*) artistInfo;

@end


@interface CustomTableCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *collectionData;
    DGActivityIndicatorView *activityIndicatorView;

}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


-(void) loadingDataForCatalog:(NSDictionary *) catagoryInfo;

@property (nonatomic,strong) NSDictionary *cellCatagoryInfo;


@property(nonatomic,weak) id<CustomTableCellDelegate> delegate;


@end
