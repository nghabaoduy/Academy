//
//  LoginVC.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "LoginVC.h"
#import "User.h"

@interface LoginVC ()<AuthDelegate> {
    
    __weak IBOutlet UITextField *textfUsername;
    __weak IBOutlet UITextField *textfPassword;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionLogin:(id)sender {
    
    if (![self validation]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Error!!!" message:@"Username or password cannot empty." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
        
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    User * newUser = [User new];
    [newUser setAuthDelegate:self];
    [newUser userLoginWith:textfUsername.text Password:textfPassword.text];
}

- (void)loginSuccess {
    [self performSegueWithIdentifier:@"toBookShelf" sender:nil];
}

- (BOOL)validation {
    if ([textfUsername.text isEqualToString:@""] && [textfPassword.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

#pragma mark - Auth Delegate
- (void)userLogin:(User *)user WithError:(id)Error StatusCode:(NSNumber *)statusCode {
    NSString * errorMessage = @"";
    
    switch (statusCode.intValue) {
        case 400:
            //NSLog(@"error: %@", Error);
            errorMessage = Error;
            break;
        case 422:
            errorMessage = [NSString stringWithFormat:@"%@", statusCode];
            //NSLog(@"error: %@", Error);
            break;
            
        default:
            //smthing wrong
            break;
    }
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Error!!!" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"Dismiss"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                         // do destructive stuff here
                                                     }];
    
    [alertController addAction:dismiss];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)userLoginSuccessfull:(User *)user {
    [self performSegueWithIdentifier:@"toBookShelf" sender:nil];
}


@end
