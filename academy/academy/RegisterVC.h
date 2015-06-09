//
//  RegisterVC.h
//  academy
//
//  Created by Brian on 6/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomTextfield.h"
#import "LoginVC.h"

@interface RegisterVC : UITableViewController <UITextFieldDelegate>
@property (nonatomic, retain) LoginVC *loginView;

@end
