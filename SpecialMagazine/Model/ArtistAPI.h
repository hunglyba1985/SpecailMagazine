//
//  ArtistAPI.h
//  SpecialMagazine
//
//  Created by Macbook Pro on 9/3/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GetAPIRequestHandle)(id dataResponse, NSError *error);


@interface ArtistAPI : NSObject


+(ArtistAPI *) sharedInstance;

-(void) getAllWebsite:(GetAPIRequestHandle) result;



@end
