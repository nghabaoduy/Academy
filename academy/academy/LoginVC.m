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
#import "SharedData.h"

#import "SIAlertView.h"
#import "AMSmoothAlertView.h"

@interface LoginVC ()<AuthDelegate, SharedDataDelegate> {
    
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
    //[self clearSave];
    [self performSelector:@selector(checkAutoLogin) withObject:self afterDelay:0.5];
    
    
}
-(void) getSharedData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[[DataEngine getInstance] sharedData].sharedDataDelegate = self;
    //[[[DataEngine getInstance] sharedData] updateSharedData];
}

-(void) clearSave
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    //facebook
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
    //google plus
    [[GPPSignIn sharedInstance] signOut];
}

-(void) checkAutoLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isAutoLogin = [defaults boolForKey:@"isAutoLogin"];
    NSLog(@"isAutoLogin = %@",isAutoLogin?@"YES":@"NO");
    if (isAutoLogin) {
        //[self performSelector:@selector(autoLogin) withObject:self afterDelay:0.5];
        [self autoLogin];
    }
    else
    {
        NSString *saveUsername = [[NSUserDefaults standardUserDefaults]valueForKey:@"saveUsername"];
        if (![saveUsername isEqualToString:@""]) {
            [textfUsername setText:saveUsername];
        }
    }
}
-(void) autoLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *saveUsername = [defaults valueForKey:@"saveUsername"];
    NSString *savePassword = [defaults valueForKey:@"savePassword"];
    NSString *fbId = [defaults valueForKey:@"facebook_id"];
    NSString *ggpId = [defaults valueForKey:@"ggp_id"];
    switch ([[DataEngine getInstance] loginType]) {
        case LoginNormal:
        {
            NSLog(@"autoLogin username = %@ password = %@",saveUsername,savePassword);
            if (saveUsername.length > 0) {
                [textfUsername setText:saveUsername];
                [textfPassword setText:savePassword];
                [self loginWithEmailAndPassword:saveUsername Password:savePassword];
            }
        }
            break;
        case LoginFacebook:
        {
            NSLog(@"autoLogin username = %@ FBId = %@",saveUsername,fbId);
            if (saveUsername.length > 0) {
                [self loginWithEmailAndFBId:saveUsername fbId:fbId];
            }
        }
            break;
        case LoginGooglePlus:
        {
            NSLog(@"autoLogin username = %@ ggpId = %@",saveUsername,ggpId);
            if (saveUsername.length > 0) {
                [self loginWithEmailAndGGPId:saveUsername ggpId:ggpId];
            }
        }
            break;
        default:
            break;
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
                     
                     NSString *profileName =[result[@"first_name"] stringByAppendingFormat:@" %@",result[@"last_name"]];
                     [[DataEngine getInstance] setLoginType:LoginFacebook];
                     [self registerNewUserWithEmail:email ProfileName:profileName fbId:result[@"id"] ggpId:@""];
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
                             
                             NSString *profileName =[result[@"first_name"] stringByAppendingFormat:@" %@",result[@"last_name"]];
                             [[DataEngine getInstance] setLoginType:LoginFacebook];
                             [self registerNewUserWithEmail:email ProfileName:profileName fbId:result[@"id"] ggpId:@""];
                             
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
                        
                        NSString *profileName =[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName];
                        [[DataEngine getInstance] setLoginType:LoginGooglePlus];
                        [self registerNewUserWithEmail:email ProfileName:profileName fbId:@"" ggpId:person.identifier];
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
                        
                        NSString *profileName =[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName];
                        [[DataEngine getInstance] setLoginType:LoginGooglePlus];
                        [self registerNewUserWithEmail:email ProfileName:profileName fbId:@"" ggpId:person.identifier];
                        
                    }
                }];
    }
}
-(void) showPermissionError
{
    SIAlertView * siAlertView = [[SIAlertView alloc] initWithTitle:@"Thông Báo" message:@"Xác nhận thất bại."];
    [siAlertView addButtonWithTitle:@"OK"
                               type:SIAlertViewButtonTypeDestructive
                            handler:^(SIAlertView *alert) {
                                
                            }];
    [siAlertView show];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionLogin:(id)sender {
    
    
    if (![self validation:textfUsername.text pass:textfPassword.text]) {
        
        AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"Thông Báo"
                                                                             andText:@"Email và mật khẩu không được để trống."
                                                                     andCancelButton:NO
                                                                        forAlertType:AlertFailure withCompletionHandler:^(AMSmoothAlertView * alert, UIButton * button) {
                                                                            //[alert dismissAlertView];
        }];
        [alert show];
        return;
    }
    registerDict = @{
                     @"username" : textfUsername.text,
                     @"password" : textfPassword.text,
                     @"password_confirmation" : textfPassword.text
                     };
    [[DataEngine getInstance] saveLoginInfo:textfUsername.text Password:textfPassword.text fbId:@"" ggpId:@""];
    [[DataEngine getInstance] setLoginType:LoginNormal];
    [self loginWithEmailAndPassword:textfUsername.text Password:textfPassword.text];
}
-(void) loginWithEmailAndPassword:(NSString *) email Password:(NSString *) password
{
    if(![self validation:email pass:password])
        return;
    User * newUser = [User new];
    [newUser setAuthDelegate:self];
    [newUser userLoginWith:email Password:password];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}
-(void) loginWithEmailAndFBId:(NSString *) email fbId:(NSString *) fbId
{
    User * newUser = [User new];
    [newUser setAuthDelegate:self];
    [newUser userLoginWith:email fbId:fbId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
-(void) loginWithEmailAndGGPId:(NSString *) email ggpId:(NSString *) ggpId
{
    User * newUser = [User new];
    [newUser setAuthDelegate:self];
    [newUser userLoginWith:email ggpId:ggpId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (BOOL)validation:(NSString*) username pass:(NSString *) pass{
    if ([username isEqualToString:@""] || [pass isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
- (void)loginOffline
{
    [User loadCurrentUserToNSUserDefaults];
    SIAlertView * siAlertView = [[SIAlertView alloc] initWithTitle:@"Thông Báo" message:@"Bạn đang đăng nhập Offline. Xin đăng nhập lại khi kết nối được Internet để sử dụng toàn bộ ứng dụng."];
    [siAlertView addButtonWithTitle:@"OK"
                               type:SIAlertViewButtonTypeDestructive
                            handler:^(SIAlertView *alert) {
                                [[DataEngine getInstance] setIsOffline:YES];
                                [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:NO];
                            }];
    [siAlertView show];
}
//=== REGISTER ===//
-(void)registerNewUserWithEmail:(NSString *) email ProfileName:(NSString *) profileName fbId:(NSString *)fbId ggpId:(NSString *) ggpId
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User * newUser = [User new];
    NSString *pass = [User createRandomStringWithLength:8];
    newUser.authDelegate = self;
    registerDict = @{
                 @"username" : email,
                 @"password" : pass,
                 @"password_confirmation" : pass,
                 @"profile_name" : profileName,
                 @"facebook_id" : fbId,
                 @"ggp_id":ggpId
                 };
    NSLog(@"registerNewUserWithEmail called %@",registerDict);
    [newUser registerUserWithParam:registerDict];
}

#pragma mark - Auth Delegate
- (void)userLogin:(User *)user WithError:(id)Error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString * errorMessage = @"";
    
    switch (statusCode.intValue) {
        case 400:
            errorMessage = Error;
            break;
        case 422:
            errorMessage = [NSString stringWithFormat:@"%@", statusCode];
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
            SIAlertView * siAlertView = [[SIAlertView alloc] initWithTitle:@"Báo Lỗi" message:@"Kết nối Internet thất bại"];

            [siAlertView addButtonWithTitle:@"OK"
                                       type:SIAlertViewButtonTypeDestructive
                                    handler:^(SIAlertView *alert) {
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    }];
            [siAlertView show];
        }
        return;
    }

    SIAlertView * siAlertView = [[SIAlertView alloc] initWithTitle:@"Báo Lỗi" message:@"Đăng nhập thất bại"];
    
    
    [siAlertView addButtonWithTitle:@"Quên mật khẩu"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              [self performSegueWithIdentifier:@"goForgotPassword" sender:self];
                          }];
    [siAlertView addButtonWithTitle:@"Thử lại"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                          }];
    
    siAlertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [siAlertView show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isAutoLogin"];
    [defaults synchronize];
}

- (void)userLoginSuccessfull:(User *)user {
    NSLog(@"navigateView");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isAutoLogin = [defaults boolForKey:@"isAutoLogin"];
    if (!isAutoLogin) {
        [[DataEngine getInstance] saveLoginInfo:registerDict[@"username"] Password:registerDict[@"password"] fbId:registerDict[@"facebook_id"] ggpId:registerDict[@"ggp_id"]];
    }
    
    [[DataEngine getInstance] setIsOffline:NO];
    if ([[DataEngine getInstance] loginType] == LoginNormal) {
        [user refreshUser];
    }else{
        
        [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:NO];
    }
    
    
    
}

- (void)refreshUserSucessful:(User *)user{
    [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:NO];
}
-(void)refreshUserFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode
{
    [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:NO];
}

- (IBAction)viewTouchUp:(id)sender {
    [curTextField resignFirstResponder];
}
- (void)userRegiserFailed:(User *)user WithError:(id)Error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *fbId = registerDict[@"facebook_id"];
    NSString *ggpId = registerDict[@"ggp_id"];
    if (fbId.length > 0) {
        [self loginWithEmailAndFBId:registerDict[@"username"] fbId:fbId];
    }
    if (ggpId.length > 0) {
        [self loginWithEmailAndGGPId:registerDict[@"username"] ggpId:ggpId];
    }
    
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

#pragma mark - SharedDataDelegate
-(void)SharedDataGetSuccessful:(SharedData *)sharedData
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString* curAppVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSString* latestAppVersion = [sharedData appVersion] ;
    NSLog(@"Compared curVersion %@ to %@",curAppVersion,latestAppVersion);
    
    
    SIAlertView * siAlertView = [[SIAlertView alloc] initWithTitle:@"Thông Báo" message:@"Cập nhật ngay phiên bản mới nhất để trải nghiệm vnAcademy một cách toàn diện nhất!"];
    
    [siAlertView addButtonWithTitle:@"Để Sau"
                               type:SIAlertViewButtonTypeCancel
                            handler:^(SIAlertView *alert) {
                                [self checkAutoLogin];
                                
                            }];
    [siAlertView addButtonWithTitle:@"Cập Nhập Ngay"
                               type:SIAlertViewButtonTypeDefault
                            handler:^(SIAlertView *alert) {
                                NSString *iTunesLink = [[DataEngine getInstance] getAppURL];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                            }];
    
    if ([curAppVersion floatValue] < [latestAppVersion floatValue]) {
        [siAlertView show];
    }
    else
    {
        [self checkAutoLogin];
    }
    
    
}
-(void)SharedDataGetFailed:(id)Error StatusCode:(NSNumber *)statusCode
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self checkAutoLogin];
}

@end
