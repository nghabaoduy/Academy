//
//  SetDisplayer.h
//  academy
//
//  Created by Brian on 6/1/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSet.h"
@class SetDisplayer;

@protocol SetDisplayerDelegate
-(void) setDisplayerClicked:(SetDisplayer *) _setDisplayer;
@end
                             
@interface SetDisplayer : UIView
{
    id <SetDisplayerDelegate> delegate;
}
@property (retain) id delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
- (void) setLSet:(LSet *) set;
-(LSet *) getLSet;
@end
