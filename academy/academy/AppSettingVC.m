//
//  AppSettingVC.m
//  academy
//
//  Created by Brian on 6/18/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AppSettingVC.h"
#import "DataEngine.h"
#import "User.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AppSettingVC () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    IBOutlet UISwitch *soundSwitch;
    BOOL isReportError;
}

@end

@implementation AppSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isReportError = NO;
    [soundSwitch setOn:![[DataEngine getInstance] isSoundOff] animated:NO];
}
- (IBAction)soundSwitchChangedValue:(id)sender {
    [[DataEngine getInstance] switchisSoundOff:![[DataEngine getInstance] isSoundOff]];
    if ([[DataEngine getInstance] isSoundOff]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Khi tắc âm thanh, vnAcademy sẽ loại ra những câu hỏi nghe trong phần luyện tập và kiểm tra." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
        
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (IBAction)goRateAndReview:(id)sender {
    NSString *iTunesLink = [[DataEngine getInstance] getAppURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
- (IBAction)goGiveFeedback:(id)sender {
    isReportError = NO;
    MFMailComposeViewController *messageController = [[MFMailComposeViewController alloc] init];
    messageController.mailComposeDelegate = self;
    [messageController setToRecipients:@[[[DataEngine getInstance] getFeedbackEmail]]];
    
    User *curUser = [User currentUser];
    [messageController setSubject:[NSString stringWithFormat:@"[vnAcademy] Góp Ý từ %@ [Id:%@]",[curUser profileName],[curUser modelId]]];

    
    [self presentViewController:messageController animated:YES completion:nil];
    
    
}
- (IBAction)goErrorReport:(id)sender {
    isReportError = YES;
    MFMailComposeViewController *messageController = [[MFMailComposeViewController alloc] init];
    messageController.mailComposeDelegate = self;
    [messageController setToRecipients:@[[[DataEngine getInstance] getFeedbackEmail]]];
    
    User *curUser = [User currentUser];
    [messageController setSubject:[NSString stringWithFormat:@"[vnAcademy] Báo Lỗi từ %@ [Id:%@]",[curUser profileName],[curUser modelId]]];
    
    
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSLog(@"mail sent");
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent) {
            NSString * title = isReportError?@"Sorry!":@"Thank You!";
            NSString * message = isReportError?
            @"Xin Lỗi bạn, bọn mình sẽ xem xét và xử lý trong thời gian sớm nhất. Cảm ơn bạn đã góp ý. vnAcademy sẽ cố gắng cho bạn quá trình học ngoại ngữ tốt và vui vẻ nhất!":
            @"Cảm ơn bạn đã góp ý. vnAcademy sẽ cố gắng cho bạn quá trình học ngoại ngữ tốt và vui vẻ nhất!";
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                             }];
            
            [alertController addAction:dismiss];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
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
