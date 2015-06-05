//
//  LoginVC.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

#import "MSDynamicsDrawerViewController.h"
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
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@end

@implementation LoginVC

static NSString * const kClientId = @"581227388428-rn5aloe857g2rjll30tm4qbmhr98o4bp.apps.googleusercontent.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    [SoundEngine getInstance];
    
    //disable sideMenu Drag
    MSDynamicsDrawerViewController *dynamicsDrawerViewController = (MSDynamicsDrawerViewController *)self.navigationController.parentViewController;
    
    MSDynamicsDrawerDirectionActionForMaskedValues(dynamicsDrawerViewController.possibleDrawerDirection, ^(MSDynamicsDrawerDirection drawerDirection) {
        [dynamicsDrawerViewController setPaneDragRevealEnabled:NO forDirection:drawerDirection];
    });
    
    //GGP singleton setup
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    signIn.clientID = kClientId;
    signIn.scopes = @[ kGTLAuthScopePlusLogin];  // "https://www.googleapis.com/auth/plus.login" scope
    signIn.scopes = @[ @"profile" ];            // "profile" scope
    signIn.delegate = self;
    [signIn trySilentAuthentication];
    
    
    
}
-(IBAction) testPost:(id)sender
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
            [[[FBSDKGraphRequest alloc]
              initWithGraphPath:@"me/feed"
              parameters: @{ @"message" : @"hello world"}
              HTTPMethod:@"POST"]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"Post id:%@", result[@"id"]);
                 }
             }];
        }
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
                [[[FBSDKGraphRequest alloc]
                  initWithGraphPath:@"me/feed"
                  parameters: @{ @"message" : @"hello world"}
                  HTTPMethod:@"POST"]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         NSLog(@"Post id:%@", result[@"id"]);
                     }
                 }];
            }
        }];
    }
}
- (IBAction)loginWithFB:(id)sender {
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"FB token userID = %@",[FBSDKAccessToken currentAccessToken].userID);
        if ([FBSDKAccessToken currentAccessToken]) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"fetched user:%@", result);
                 }
             }];
        }
        
        
    }
    else
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                // Process error
            } else if (result.isCancelled) {
                // Handle cancellations
            } else {
                NSLog(@"FB token userID = %@",[FBSDKAccessToken currentAccessToken].userID);
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"fetched user:%@", result);
                         }
                     }];
                }
                
            }
        }];
    }
    
}
- (IBAction)loginWithGooglePlus:(id)sender {
    if ([[GPPSignIn sharedInstance] authentication]) {
        NSLog(@"email %@ ",[NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        // *4. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        
                        
                        
                        //Handle Error
                        
                    } else
                    {
                        
                        
                        NSLog(@"Email= %@",[GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@",person.identifier);
                        NSLog(@"User Name=%@",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName]);
                        NSLog(@"Gender=%@",person.gender);
                        
                    }
                }];
    
    }
    else
    {
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        [signIn authenticate];
    }

}
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        
        NSLog(@"email %@ ",[NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        // *4. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        
                        
                        
                        //Handle Error
                        
                    } else
                    {
                        
                        
                        NSLog(@"Email= %@",[GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@",person.identifier);
                        NSLog(@"User Name=%@",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName]);
                        NSLog(@"Gender=%@",person.gender);
                        
                    }
                }];
    }
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
- (IBAction)registerNewUser:(id)sender {
}

- (IBAction)viewTouchUp:(id)sender {
    
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
