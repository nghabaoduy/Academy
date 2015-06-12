//
//  PasswordResetVC.m
//  academy
//
//  Created by Brian on 6/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "PasswordResetVC.h"
#import "MyCustomTextfield.h"
#import "User.h"

@interface PasswordResetVC ()<AuthDelegate>

@end

@implementation PasswordResetVC
{
    IBOutlet MyCustomTextfield *emailTF;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Quên Mật Khẩu";
    emailTF.placeholder = @"Email: ";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resetEmail:(id)sender {
    if (emailTF.text.length == 0) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User *user = [User new];
    user.authDelegate = self;
    [user resetPassword:emailTF.text];
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
- (IBAction)touchUp:(id)sender {
    [emailTF resignFirstResponder];
}

#pragma User Delegate
-(void)userResetPasswordSuccessful:(User *)user
{
    NSLog(@"userResetPasswordSuccessful");
}
-(void)userResetPasswordFailed:(User *)user WithError:(id)Error StatusCode:(NSNumber *)statusCode
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *errorMessage = [statusCode intValue] == 404?@"Không tìm được email của bạn. Xin kiểm tra lại.":@"Có lỗi xãy ra. Xin bạn thử lại";
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                     }];
    
    [alertController addAction:dismiss];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
