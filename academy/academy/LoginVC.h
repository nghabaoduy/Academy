//
//  LoginVC.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//
#import <GooglePlus/GooglePlus.h>
#import <UIKit/UIKit.h>
#import "MyCustomTextfield.h"

@interface LoginVC : UIViewController<GPPSignInDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet MyCustomTextfield *textfUsername;
@property (strong, nonatomic) IBOutlet MyCustomTextfield *textfPassword;

-(void) loginWithEmailAndPassword:(NSString *) email Password:(NSString *) password;

@end
