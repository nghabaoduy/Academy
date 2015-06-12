//
//  PasswordChangeVC.m
//  academy
//
//  Created by Brian on 6/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "PasswordChangeVC.h"
#import "MyCustomTextfield.h"
#import "User.h"
@interface PasswordChangeVC ()<AuthDelegate>

@end

@implementation PasswordChangeVC
{
    IBOutlet MyCustomTextfield *curPassTF;
    IBOutlet MyCustomTextfield *passwordTF;
    IBOutlet MyCustomTextfield *rePasswordTF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.navigationItem.title = @"Thay Đổi Mật Khẩu";
    curPassTF.placeholder = @"Mật khẩu hiện tại: ";
    passwordTF.placeholder = @"Mật khẩu mới: ";
    rePasswordTF.placeholder = @"Xác nhận mật khẩu: ";

}
- (IBAction)goChangePass:(id)sender {
    if (![self validatePassword]) {
        return;
    }
    User *curUser = [User currentUser];
    curUser.authDelegate = self;
    [curUser changePassword:curPassTF.text NewPass:passwordTF.text];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma AuthDelegate
-(void)userChangePasswordSuccessful:(User *)user
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Thay đổi mật khẩu thành công." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }];
    
    [alertController addAction:dismiss];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)userChangePasswordFailed:(User *)user WithError:(id)Error StatusCode:(NSNumber *)statusCode
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Thay đổi mật khẩu thất bại. Xin vui lòng kiểm tra và thử lại." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                     }];
    
    [alertController addAction:dismiss];
    [self presentViewController:alertController animated:YES completion:nil];
}


/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
