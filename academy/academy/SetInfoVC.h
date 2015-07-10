//
//  SetInfoVC.h
//  academy
//
//  Created by Mac Mini on 7/8/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPackage.h"
#import "LSet.h"
#import "UserPackage.h"

@interface SetInfoVC : UIViewController

@property (nonatomic, retain) UserPackage *curUserPack;
@property (nonatomic, retain) LSet * curSet;

-(void) resetView;
@end
