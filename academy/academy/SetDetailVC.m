//
//  SetDetailVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetDetailVC.h"
#import "WordInfoVC.h"
#import "WordTestVC.h"

@interface SetDetailVC ()

@end

@implementation SetDetailVC{
    NSArray *tempArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tempArray = [NSArray arrayWithObjects:@"startCell", @"checkCell", @"testCell", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tempArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[tempArray objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if (indexPath.section == 0) {
        return;
    }*/
    if (indexPath.row == 0) {
        WordInfoVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"wordInfoView"];
        view.curSet = self.curSet;
        view.isWordCheckSession = NO;
        [self presentViewController:view animated:YES completion:nil];
    }
    if (indexPath.row == 1) {
        WordInfoVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"wordInfoView"];
        view.curSet = self.curSet;
        view.isWordCheckSession = YES;
        [self presentViewController:view animated:YES completion:nil];
    }
    if (indexPath.row == 2) {
        WordTestVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"wordTestView"];
        view.curSet = self.curSet;
        [self presentViewController:view animated:YES completion:nil];
    }
}

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
