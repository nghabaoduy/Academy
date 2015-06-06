//
//  RegisterVC.m
//  academy
//
//  Created by Brian on 6/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

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
@end
