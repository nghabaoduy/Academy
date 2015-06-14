//
//  TestRankAnimView.h
//  academy
//
//  Created by Brian on 6/2/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSet.h"
#import "Package.h"
@interface TestRankAnimView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
-(void) setLSet:(LSet *) set;
-(void) setPackage:(Package *) pack grade:(int) grade;
-(void) setMessage:(NSString *) message;
@end
