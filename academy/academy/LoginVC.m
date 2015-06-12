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
#import "RegisterVC.h"



@interface LoginVC ()<AuthDelegate> {
    
}
@end

@implementation LoginVC
{
    UITextField *curTextField;
    NSDictionary *registerDict;
}

@synthesize textfPassword,textfUsername;

static NSString * const kClientId = @"581227388428-rn5aloe857g2rjll30tm4qbmhr98o4bp.apps.googleusercontent.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    [SoundEngine getInstance];
    
    //[self logoutFBandGGP];
    
    textfUsername.placeholder = @"Email: ";
    textfPassword.placeholder = @"Mật khẩu: ";

    
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
    //[signIn trySilentAuthentication];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isAutoLogin = [defaults boolForKey:@"isAutoLogin"];
    NSLog(@"isAutoLogin = %@",isAutoLogin?@"YES":@"NO");
    if (isAutoLogin) {
        [self autoLogin];
    }
}
-(void) autoLogin
{
    NSDictionary *loginDict = [[DataEngine getInstance] loadLoginInfo];
    
    NSString *saveUsername = [loginDict objectForKey:@"saveUsername"];
    NSString *savePassword = [loginDict objectForKey:@"savePassword"];
    NSLog(@"autoLogin username = %@ password = %@",saveUsername,savePassword);
    if (saveUsername.length > 0) {
        [self loginWithEmailAndPassword:saveUsername Password:savePassword];
    }
}



-(void) logoutFBandGGP
{
    //facebook
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
    //google plus
    [[GPPSignIn sharedInstance] signOut];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"FB token userID = %@",[FBSDKAccessToken currentAccessToken].userID);

            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"fetched user:%@", result);
                     NSString *email = result[@"email"];
                     NSString *password = result[@"id"];
                     NSString *profileName =[result[@"first_name"] stringByAppendingFormat:@" %@",result[@"last_name"]];
                     [[DataEngine getInstance] setLoginType:LoginFacebook];
                     [self registerNewUserWithEmail:email Password:password ProfileName:profileName];
                 }
                 else
                 {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }
             }];
    }
    else
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                //error
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showPermissionError];
            } else if (result.isCancelled) {
                //error
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showPermissionError];
            } else {
                NSLog(@"FB token userID = %@",[FBSDKAccessToken currentAccessToken].userID);
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"fetched user:%@", result);
                             NSString *email = result[@"email"];
                             NSString *password = result[@"id"];
                             NSString *profileName =[result[@"first_name"] stringByAppendingFormat:@" %@",result[@"last_name"]];
                             [[DataEngine getInstance] setLoginType:LoginFacebook];
                             [self registerNewUserWithEmail:email Password:password ProfileName:profileName];
                             
                         }
                         else
                         {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             [self showPermissionError];
                         }
                     }];
                }
                else
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self showPermissionError];
                }
                
            }
        }];
    }
    
}
- (IBAction)loginWithGooglePlus:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self showPermissionError];
                        
                    } else
                    {
                        NSLog(@"Email= %@",[GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@",person.identifier);
                        NSLog(@"User Name=%@",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName]);
                        NSLog(@"Gender=%@",person.gender);
                        
                        NSString *email = [GPPSignIn sharedInstance].authentication.userEmail;
                        NSString *password = person.identifier;
                        NSString *profileName =[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName];
                        [[DataEngine getInstance] setLoginType:LoginGooglePlus];
                        [self registerNewUserWithEmail:email Password:password ProfileName:profileName];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showPermissionError];
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
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self showPermissionError];
                        
                    } else
                    {
                        NSLog(@"Email= %@",[GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@",person.identifier);
                        NSLog(@"User Name=%@",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName]);
                        NSLog(@"Gender=%@",person.gender);
                        NSString *email = [GPPSignIn sharedInstance].authentication.userEmail;
                        NSString *password = person.identifier;
                        NSString *profileName =[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName];
                        [[DataEngine getInstance] setLoginType:LoginGooglePlus];
                        [self registerNewUserWithEmail:email Password:password ProfileName:profileName];
                        
                    }
                }];
    }
}
-(void) showPermissionError
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Xác nhận thất bại." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                     }];
    
    [alertController addAction:dismiss];
    [self presentViewController:alertController animated:YES completion:nil];
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
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Email và mật khẩu không được để trống." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
        
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    registerDict = @{
                     @"username" : textfUsername.text,
                     @"password" : textfPassword.text,
                     @"password_confirmation" : textfPassword.text
                     };
    [[DataEngine getInstance] setLoginType:LoginNormal];
    [self loginWithEmailAndPassword:textfUsername.text Password:textfPassword.text];
}
-(void) loginWithEmailAndPassword:(NSString *) email Password:(NSString *) password
{
    User * newUser = [User new];
    [newUser setAuthDelegate:self];
    [newUser userLoginWith:email Password:password];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

- (BOOL)validation {
    if ([textfUsername.text isEqualToString:@""] && [textfPassword.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
- (void)loginOffline
{
    [User loadCurrentUserToNSUserDefaults];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Bạn đang đăng nhập Offline. Xin đăng nhập lại khi kết nối được Internet để sử dụng toàn bộ ứng dụng." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                         [[DataEngine getInstance] setIsOffline:YES];
                                                         [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:NO];
                                                     }];
    [alertController addAction:dismiss];
    [self presentViewController:alertController animated:YES completion:nil];
}
//=== REGISTER ===//
-(void)registerNewUserWithEmail:(NSString *) email Password:(NSString*) password ProfileName:(NSString *) profileName
{
    NSLog(@"registerNewUserWithEmail called");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User * newUser = [User new];
    newUser.authDelegate = self;
    registerDict = @{
                 @"username" : email,
                 @"password" : password,
                 @"password_confirmation" : password,
                 @"profile_name" : profileName
                 };
    [newUser registerUserWithParam:registerDict];
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
    NSLog(@"error Message[%i] = %@",statusCode.intValue,errorMessage);
    if (statusCode.intValue == 0)// login offline
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL isAutoLogin = [defaults boolForKey:@"isAutoLogin"];
        if (isAutoLogin) {
            [self loginOffline];
        }
        else
        {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Báo Lỗi" message:@"Kết nối Internet thất bại" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"Thử lại"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 // do destructive stuff here
                                                             }];
            [alertController addAction:dismiss];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        return;
    }
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Báo Lỗi" message:@"Đăng nhập thất bại" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"Thử lại"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                         // do destructive stuff here
                                                     }];
    UIAlertAction * forgotPass = [UIAlertAction actionWithTitle:@"Quên mật khẩu"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         [self performSegueWithIdentifier:@"goForgotPassword" sender:self];
                                                     }];
    [alertController addAction:dismiss];
    [alertController addAction:forgotPass];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)userLoginSuccessfull:(User *)user {
    NSLog(@"navigateView");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isAutoLogin = [defaults boolForKey:@"isAutoLogin"];
    if (!isAutoLogin) {
        [[DataEngine getInstance] saveLoginInfo:registerDict[@"username"] Password:registerDict[@"password"]];
    }
    [[DataEngine getInstance] setIsOffline:NO];
    [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:NO];
}

- (IBAction)viewTouchUp:(id)sender {
    [curTextField resignFirstResponder];
}
- (void)userRegiserFailed:(User *)user WithError:(id)Error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self loginWithEmailAndPassword:registerDict[@"username"] Password:registerDict[@"password"]];
}

- (void)userRegiserSuccessful:(User *)user {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"userRegiserSuccessful");
    [self loginWithEmailAndPassword:registerDict[@"username"] Password:registerDict[@"password"]];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goRegister"]) {
        RegisterVC *destination = segue.destinationViewController;
        destination.loginView = self;
    }
}

#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    curTextField = textField;
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
