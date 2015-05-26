//
//  LoginVC.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "LoginVC.h"
#import "User.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UserShelfVC.h"
#import "AppDelegate.h"
#import "SideMenuVC.h"
#import "SoundEngine.h"

@interface LoginVC ()<AuthDelegate> {
    
    __weak IBOutlet UITextField *textfUsername;
    __weak IBOutlet UITextField *textfPassword;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [SoundEngine getInstance];
    
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)loginSuccess {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UserShelfVC *destination = [self.storyboard instantiateViewControllerWithIdentifier:@"userShelfView"];
    UINavigationController *desNavController = [[UINavigationController alloc] initWithRootViewController:destination];
    [self presentViewController:desNavController animated:YES completion:nil];
    //[self performSegueWithIdentifier:@"toBookShelf" sender:nil];
}

- (BOOL)validation {
    if ([textfUsername.text isEqualToString:@""] && [textfPassword.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

#pragma mark - Auth Delegate
- (void)userLogin:(User *)user WithError:(id)Error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    NSLog(@"navigateView");
    [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:NO];
}

    
    //[self performSegueWithIdentifier:@"toBookShelf" sender:nil];
   /* UserShelfVC *destination = [self.storyboard instantiateViewControllerWithIdentifier:@"userShelfView"];
    UINavigationController *desNavController = [[UINavigationController alloc] initWithRootViewController:destination];
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)];
    destination.navigationItem.leftBarButtonItem = menuBtn;
    [self presentViewController:desNavController animated:YES completion:nil];
}
- (void)dynamicsDrawerRevealLeftBarButtonItemTapped:(id)sender
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.menuViewController dynamicsDrawerRevealLeftBarButtonItemTapped:sender];
    
}*/

@end
