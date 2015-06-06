//
//  ProfileVC.m
//  academy
//
//  Created by Brian on 6/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ProfileVC.h"
#import "PNChart.h"

@interface ProfileVC ()

@end

@implementation ProfileVC
{
    
    IBOutlet UITextField *nameTF;
    IBOutlet UIImageView *avatar;
    IBOutlet UIView *chartView;
    
    PNBarChart * barChart;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [nameTF setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:20]];
    
    
    
    //For BarC hart
    barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180.0)];
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    [barChart setYValues:@[@1,  @10, @2, @6, @3]];
    [barChart setBarTopLabels:@[@1,  @10, @2, @6, @3]];
    [chartView addSubview:barChart];
    [chartView setBackgroundColor:[UIColor clearColor]];
    
    [self performSelector:@selector(refreshChart) withObject:self afterDelay:1.0f];
    

}
-(void) refreshChart
{
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    [barChart setYValues:@[@1,  @10, @2, @6, @3]];
    [barChart setBarTopLabels:@[@1,  @10, @2, @6, @3]];
    [barChart strokeChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goChangeName:(UITextField *)sender {
    NSLog(@"Change name to: %@",sender.text);
    [sender resignFirstResponder];
}
- (IBAction)changeAvatar:(id)sender {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)firstCellInsideTouchUp:(id)sender {
    [nameTF resignFirstResponder];
}

#pragma mark - Table view data source
/*
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
