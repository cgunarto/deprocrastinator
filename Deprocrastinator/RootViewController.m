//
//  ViewController.m
//  Deprocrastinator
//
//  Created by CHRISTINA GUNARTO on 10/27/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property NSMutableArray *toDoItemsArray;
@property (weak, nonatomic) IBOutlet UITextField *addToDoTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *toDoTableView;
//WE HAD TO CREATE THIS IN ORDER FOR BUTTON PRESSED TO ACCESS AND UPDATE THE TABLE VIEW ARRAY TO DO CELL

@end


@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoItemsArray = [[NSMutableArray alloc] initWithObjects:
                           @"to do list 1",
                           @"to do list 2",
                           @"to do list 3",
                           @"to do list 4", nil];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.toDoItemsArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoCell" forIndexPath:indexPath];
    cell.textLabel.text = self.toDoItemsArray[indexPath.row];
    return cell;
}

- (IBAction)onAddButtonPressed:(id)sender
{
    NSString *newToDoItem = self.addToDoTextLabel.text;
    [self.toDoItemsArray addObject:newToDoItem];
    [self.toDoTableView reloadData]; // WE HAD TO ADD THIS TO RELOAD TABLE VIEW
    self.addToDoTextLabel.text = @"";
    [self.addToDoTextLabel resignFirstResponder];
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//
//}

@end
