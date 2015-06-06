//
//  PasswordResetVC.m
//  academy
//
//  Created by Brian on 6/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "PasswordResetVC.h"
#import "MyCustomTextfield.h"
@interface PasswordResetVC ()

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
