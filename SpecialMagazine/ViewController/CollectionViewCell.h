//
//  CollectionViewCell.h
//  SpecialMagazine
//
//  Created by Macbook Pro on 10/25/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellCollectionView.h"

@protocol CollectionViewCellDelegate <NSObject>

-(void) selectedArticleWithInformation:(NSDictionary*) artistInfo;


@end


@interface CollectionViewCell : UICollectionViewCell <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *collectionData;
    
}

@property (weak, nonatomic) IBOutlet UILabel *lable;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



-(void) loadingDataForCatalog:(NSDictionary *) catagoryInfo;

@property (nonatomic,strong) NSDictionary *cellCatagoryInfo;



@property(nonatomic,weak) id<CollectionViewCellDelegate> delegate;



@end
