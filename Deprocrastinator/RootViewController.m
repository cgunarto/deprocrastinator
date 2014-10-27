//
//  ViewController.m
//  Deprocrastinator
//
//  Created by CHRISTINA GUNARTO on 10/27/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "RootViewController.h"
#import "ToDoData.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property NSMutableArray *toDoItemsArray;
@property (weak, nonatomic) IBOutlet UITextField *addToDoTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *toDoTableView;
//WE HAD TO CREATE THIS IN ORDER FOR BUTTON PRESSED TO ACCESS AND UPDATE THE TABLE VIEW ARRAY TO DO CELL
@property NSInteger selectedRow;

@end


@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.toDoItemsArray = [NSMutableArray new];
    ToDoData *firstItem = [[ToDoData alloc] init];
    firstItem.toDoText = @"Testing";
    [self.toDoItemsArray addObject:firstItem];

    ToDoData *secondItem = [[ToDoData alloc] init];
    secondItem.toDoText = @"Testing 2";
    [self.toDoItemsArray addObject:secondItem];

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.toDoItemsArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoCell" forIndexPath:indexPath];
    ToDoData *toDoItem = self.toDoItemsArray[indexPath.row];

    cell.textLabel.text = toDoItem.toDoText;
    return cell;

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.selectedRow = indexPath.row;
    NSLog(@"Row Selected %li", (long)self.selectedRow);
   //[self.toDoTableView cellForRowAtIndexPath:[self.selectedRow intValue]].accessoryType = UITableViewCellAccessoryCheckmark;

}

- (IBAction)onAddButtonPressed:(id)sender
{
    ToDoData *newToDoItem = [[ToDoData alloc]init];
    newToDoItem.toDoText = self.addToDoTextLabel.text;
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
