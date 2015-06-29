//
//  AlertTestModePickView.h
//  academy
//
//  Created by Brian on 5/29/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
typedef NS_ENUM(NSUInteger, TestPickType) {
    TestPickNormal,
    TestPickTimer,
    TestPickCount
};
@class AlertTestModePickView;

@protocol TestPickDelegate
-(void) AlertTestModePickView:(AlertTestModePickView*) modePickView modePicked:(TestPickType) testPickType;

@end
@interface AlertTestModePickView : UIWindow
{
    id <TestPickDelegate> delegate;
}
@property (retain) id delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) CustomIOSAlertView *alertView;
-(void) setTestTimeText:(int) sec;
@end
