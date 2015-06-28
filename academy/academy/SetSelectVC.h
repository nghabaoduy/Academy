//
//  SetSelectVC.h
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPackage.h"
#import "SetRow1Displayer.h"
#import "SetRow2Displayer.h"
@interface SetSelectVC : UITableViewController <SetDisplayerDelegate, ModelDelegate>

@property (nonatomic, retain) UserPackage * curUserPack;

@end
