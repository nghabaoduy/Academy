//
//  TestRankAnimView.h
//  academy
//
//  Created by Brian on 6/2/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSet.h"
@interface TestRankAnimView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
-(void) setLSet:(LSet *) set;
-(void) setMessage:(NSString *) message;
@end