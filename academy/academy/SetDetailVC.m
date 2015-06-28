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
        if (self.curSet.wordList.count > 0) {
            
        }
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
        view.curUserPack = self.curUserPack;
        [self presentViewController:view animated:YES completion:nil];
    }
}

@end
