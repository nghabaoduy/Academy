//
//  RegisterVC.m
//  academy
//
//  Created by Brian on 6/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "RegisterVC.h"
#import "User.h"

@interface RegisterVC () <AuthDelegate>

@end

@implementation RegisterVC
{
    IBOutlet MyCustomTextfield *profileNameTF;
    IBOutlet MyCustomTextfield *emailTF;
    IBOutlet MyCustomTextfield *passwordTF;
    IBOutlet MyCustomTextfield *rePasswordTF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.navigationItem.title = @"Đăng Ký";
    profileNameTF.placeholder = @"Họ tên: ";
    emailTF.placeholder = @"Email: ";
    passwordTF.placeholder = @"Mật khẩu: ";
    rePasswordTF.placeholder = @"Xác nhận mật khẩu: ";
    [self newUser];
}

- (void)newUser {
    //example only checking Register APi Indropbox
    User * newUser = [User new];
    newUser.authDelegate = self;
    [newUser registerUserWithParam:@{
                                     @"username" : @"test@gmail.com",
                                     @"password" : @"000000",
                                     @"password_confirmation" : @"000000",
                                     @"profile_name" : @"test user"
                                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goRegister:(id)sender {
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)userRegiserFailed:(User *)user WithError:(id)Error StatusCode:(NSNumber *)statusCode {
    
}

- (void)userRegiserSuccessful:(User *)user {
    NSLog(@"success");
}

@end
