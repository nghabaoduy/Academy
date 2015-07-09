//
//  SetCollectionVC.h
//  academy
//
//  Created by Mac Mini on 7/8/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPackage.h"
@interface SetCollectionVC : UIViewController
@property (nonatomic, retain) UserPackage * curUserPack;

@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;

@end
