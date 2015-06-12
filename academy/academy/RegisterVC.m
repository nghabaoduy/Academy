//
//  RegisterVC.m
//  academy
//
//  Created by Brian on 6/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "RegisterVC.h"
#import "User.h"
#import <MBProgressHUD/MBProgressHUD.h>

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
    if (![self validateBlankTextfield:@[profileNameTF,emailTF]]) {
        return;
    }
    if (![self validatePassword]) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User * newUser = [User new];
    newUser.authDelegate = self;
    [newUser registerUserWithParam:@{
                                     @"username" : emailTF.text,
                                     @"password" : passwordTF.text,
                                     @"password_confirmation" : rePasswordTF.text,
                                     @"profile_name" : profileNameTF.text
                                     }];
}
-(BOOL) validateBlankTextfield:(NSArray *) tfArray
{
    for (UITextField * tf in tfArray) {
        if (tf.text.length == 0) {
            return NO;
        }
    }
    return YES;
}

-(BOOL) validatePassword
{
    if (passwordTF.text.length < 6) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Mật khẩu không thể ít hơn 6 kí tự." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
        
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    if (![passwordTF.text isEqualToString:rePasswordTF.text]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Xác nhận mật khẩu sai." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
        
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *errorMessage = [statusCode intValue] == 200?@"Email này đã được đăng ký. Xin chọn email khác.":@"Đăng ký thất bại. Xin bạn thử lại";

    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                     }];
    
    [alertController addAction:dismiss];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)userRegiserSuccessful:(User *)user {
    NSLog(@"userRegiserSuccessful");
    [self goBackAndLogin];
}
-(void) goBackAndLogin
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (self.loginView) {
            self.loginView.textfUsername.text = emailTF.text;
            self.loginView.textfPassword.text = passwordTF.text;
            [self.loginView loginWithEmailAndPassword:emailTF.text Password:passwordTF.text];
        }
        NSLog(@"self.loginView = %@",self.loginView);
        self.loginView = nil;
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
}

@end
