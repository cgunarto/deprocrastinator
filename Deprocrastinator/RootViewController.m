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
//ToDoTableView property created in order for classes in the self to access its properties

@end


@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.toDoItemsArray = [NSMutableArray new];
    ToDoData *firstItem = [[ToDoData alloc] init];
    firstItem.toDoText = @"Buy groceries";
    [self.toDoItemsArray addObject:firstItem];

    ToDoData *secondItem = [[ToDoData alloc] init];
    secondItem.toDoText = @"Do laundry";
    [self.toDoItemsArray addObject:secondItem];

}

#pragma mark TABLE VIEW

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.toDoItemsArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoCell" forIndexPath:indexPath];
    ToDoData *toDoItem = self.toDoItemsArray[indexPath.row];

    cell.textLabel.text = toDoItem.toDoText;
    NSString *labelColor = toDoItem.labelColor;

    //setting the color of the background
    if ([labelColor isEqualToString:@"red"])
    {
        cell.textLabel.backgroundColor = [UIColor redColor];
    }

    else if ([labelColor isEqualToString:@"yellow"])
    {
        cell.textLabel.backgroundColor = [UIColor yellowColor];
    }

    else if ([labelColor isEqualToString:@"green"])
    {
        cell.textLabel.backgroundColor = [UIColor greenColor];
    }

    else if ([labelColor isEqualToString:@"white"])
    {
        cell.textLabel.backgroundColor = [UIColor whiteColor];
    }

    else
    {
        cell.textLabel.backgroundColor = [UIColor whiteColor];
    }

    //setting the checkmark bool
    if (toDoItem.boolIsChecked == YES)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;

}


// allowing for tapped tableView cell to be changed from unchecked to checked or vice versa, and updating the Data model
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];

    ToDoData *toDoItemSelected = self.toDoItemsArray[indexPath.row];
    if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
    {
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;

        toDoItemSelected.boolIsChecked = YES;

    }
    else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        selectedCell.accessoryType = UITableViewCellAccessoryNone;

        toDoItemSelected.boolIsChecked = NO;
    }


}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {

        UIAlertController *deleteOrCancelAlert = [UIAlertController alertControllerWithTitle:@"Confirm Delete" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"DELETE" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [self.toDoItemsArray removeObjectAtIndex:indexPath.row];
                                     [self.toDoTableView reloadData];

                                 }];
        [deleteOrCancelAlert addAction:delete];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:nil];
        
        [deleteOrCancelAlert addAction:cancel];
        
        [self presentViewController:deleteOrCancelAlert animated:YES completion:nil];

    }
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    ToDoData *toDoDataToMove = self.toDoItemsArray[sourceIndexPath.row];
    [self.toDoItemsArray removeObjectAtIndex:sourceIndexPath.row];
    [self.toDoItemsArray insertObject:toDoDataToMove atIndex:destinationIndexPath.row];
}


#pragma mark NAVIGATION BUTTON METHODS

- (IBAction)onAddButtonPressed:(id)sender
{
    if (![self.addToDoTextLabel.text isEqualToString: @""])
    {
        ToDoData *newToDoItem = [[ToDoData alloc]init];
        newToDoItem.toDoText = self.addToDoTextLabel.text;
        newToDoItem.labelColor = @"white";

        [self.toDoItemsArray addObject:newToDoItem];
        [self.toDoTableView reloadData]; // WE HAD TO ADD THIS TO RELOAD TABLE VIEW
    }

    self.addToDoTextLabel.text = @"";
    [self.addToDoTextLabel resignFirstResponder];
}

- (IBAction)onEditButtonPressed:(UIBarButtonItem *)editButton
{
//    NSString *buttonTitle = editButton.title;
//    self.toDoTableView.editing = YES;

    self.toDoTableView.editing = !self.toDoTableView.editing; // new way of checking the editing mode and toggling it to the other one

    if (self.toDoTableView.editing)
    {
        [editButton setTitle:@"Done"];
    }

    else
    {
        [editButton setTitle:@"Edit"];
        //Change through data model, not the view.

        UIAlertController *deleteOrCancelAlert = [UIAlertController alertControllerWithTitle:@"Confirm Delete" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"DELETE" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     for (int i = 0; i < [self.toDoItemsArray count]; i++)
                                     {
                                         //UITableViewCell *selectedCell = [[self.toDoTableView] cellForRowAtIndexPath:i];
                                         ToDoData *selectedToDoList = self.toDoItemsArray[i];

                                         if (selectedToDoList.boolIsChecked == YES)
                                         {
                                             [self.toDoItemsArray removeObjectAtIndex:i];

                                             [self.toDoTableView reloadData];
                                         }
                                     }
                                 }];
        [deleteOrCancelAlert addAction:delete];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:nil];
        [deleteOrCancelAlert addAction:cancel];
        
        [self presentViewController:deleteOrCancelAlert animated:YES completion:nil];
        self.toDoTableView.editing = NO;
    }

//    if([buttonTitle isEqualToString: @"Edit"])
//    {
//         [editButton setTitle:@"Done"];
//
//        //can it listen to when a table view is being tapped
//
//
//    }
//    else if ([buttonTitle isEqualToString: @"Done"])
//    {
//        [editButton setTitle:@"Edit"];
//        //Change through data model, not the view.
//
//        UIAlertController *deleteOrCancelAlert = [UIAlertController alertControllerWithTitle:@"Confirm Delete" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"DELETE" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
//        {
//            for (int i = 0; i < [self.toDoItemsArray count]; i++)
//            {
//                //UITableViewCell *selectedCell = [[self.toDoTableView] cellForRowAtIndexPath:i];
//                ToDoData *selectedToDoList = self.toDoItemsArray[i];
//
//                if (selectedToDoList.boolIsChecked == YES)
//                {
//                    [self.toDoItemsArray removeObjectAtIndex:i];
//
//                    [self.toDoTableView reloadData];
//                }
//            }
//        }];
//        [deleteOrCancelAlert addAction:delete];
//
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:nil];
//        [deleteOrCancelAlert addAction:cancel];
//
//        [self presentViewController:deleteOrCancelAlert animated:YES completion:nil];
//        self.toDoTableView.editing = NO;
//
//    }

}

#pragma mark SWIPE HANDLER

//changes the color to red when you swipe once, yellow when you swipe twice, and green when you swipe three times
- (IBAction)swipePriorityHandler:(UISwipeGestureRecognizer *)gesture
{
        CGPoint location = [gesture locationInView:self.toDoTableView]; //instead of self.view, change it to self.toDoTableView
        NSIndexPath *swipedIndexPath = [self.toDoTableView indexPathForRowAtPoint:location];
        UITableViewCell *swipedCell = [self.toDoTableView cellForRowAtIndexPath:swipedIndexPath]; //swipedIndexPath.row

        ToDoData *toDoItemSwiped = self.toDoItemsArray [swipedIndexPath.row];
        NSString *currentLabelColor = toDoItemSwiped.labelColor;

        if ([currentLabelColor isEqualToString:@"white"])
        {
            swipedCell.backgroundColor = [UIColor redColor];
            toDoItemSwiped.labelColor = @"red";
        }

        else if ([currentLabelColor isEqualToString:@"red"])
        {
            swipedCell.backgroundColor = [UIColor yellowColor];
            toDoItemSwiped.labelColor = @"yellow";
        }

        else if ([currentLabelColor isEqualToString:@"yellow"])
        {
            swipedCell.backgroundColor = [UIColor greenColor];
            toDoItemSwiped.labelColor = @"green";
        }

        else if ([currentLabelColor isEqualToString:@"green"])
        {
            swipedCell.backgroundColor = [UIColor whiteColor];
            toDoItemSwiped.labelColor = @"white";
        }
        else
        {
            swipedCell.backgroundColor = [UIColor redColor];
            toDoItemSwiped.labelColor = @"red";
        }
//        [self.toDoTableView reloadData];
}

/*BUGS
 
 When empty cell label is swiped a couple of times and then a new one is added, it changes the color
 Delete button and edit done button prompts the same alert view message

*/



@end
