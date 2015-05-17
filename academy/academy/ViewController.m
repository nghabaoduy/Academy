//
//  ViewController.m
//  academy
//
//  Created by Brian on 5/13/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ViewController.h"
#import "UserShelfNavVC.h"
#import "ShopNavVC.h"
#import "AModel.h"
#import "User.h"

@interface ViewController () <AuthDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"here");
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    //ShopNavVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"shopNavView"];
    UserShelfNavVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"userShelfNavView"];
    [self presentViewController:view animated:NO completion:nil];
    
}


- (IBAction)actionLogin:(id)sender {
    User * newUser = [User new];
    [newUser setAuthDelegate:self];
    [newUser userLoginWith:@"nghabaoduy" Password:@"00000"];
}


- (void)userLogout:(User *)user WithError:(NSDictionary *)Error {
    
}

- (void)userLoginSuccessfull:(User *)user {
    NSLog(@"%@", [user getDictionaryFromObject]);
}






@end
