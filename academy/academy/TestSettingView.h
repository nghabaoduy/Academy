//
//  TestSettingView.h
//  academy
//
//  Created by Brian on 6/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordTestVC.h"
#import "TestMaker.h"

@interface TestSettingView : UITableViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, retain) WordTestVC * parentView;
@property (nonatomic, retain) TestMaker * testMaker;
@end
