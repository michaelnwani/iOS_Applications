//
//  KMNItemsViewController.m
//  Homepwner
//
//  Created by Michael Nwani on 9/7/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNItemsViewController.h"
#import "KMNItemStore.h"
#import "MNItem.h"
#import "KMNDetailViewController.h"

@interface KMNItemsViewController ()

//@property (nonatomic, strong) IBOutlet UIView *headerView;

@end


@implementation KMNItemsViewController

#pragma mark - XIB file implementations
//-(UIView *)headerView
//{
//    //If you have not loaded the heaverView yet...
//    if (!_headerView)
//    {
//        //Load HeaderView.xib
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    
//    return _headerView;
//}

-(IBAction)addNewItem:(id)sender
{
    
    //Create a new MNItem and add it to the store
    MNItem *newItem = [[KMNItemStore sharedStore] createItem];
//
//    //Figure out where that item is in the array
//    NSInteger lastRow = [[[KMNItemStore sharedStore] allItems] indexOfObject:newItem];
//
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    
//    //Insert this new row into the table.
//    [self.tableView insertRowsAtIndexPaths:@[indexPath]
//                          withRowAnimation:UITableViewRowAnimationTop];
    
    KMNDetailViewController *detailViewController = [[KMNDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    
    //That's all. Really. It runs a block of code
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet; //For iPad
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; //A fade-in style for modal view controllers. Default is CoverVertical (slide up from the bottom)
    [self presentViewController:navController animated:YES completion:NULL];
}

//-(IBAction)toggleEditingMode:(id)sender
//{
//    //If you are curently in editing mode...
//    if (self.isEditing)
//    {
//        //Change text of button to inform user of state
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        
//        //Turn off editing mode
//        [self setEditing:NO animated:YES];
//    }
//    else
//    {
//        //Change text of button to inform user of state
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        
//        //Enter editing mode
//        [self setEditing:YES animated:YES];
//    }
//}


#pragma mark - Initializers
-(instancetype)init
{
    //Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        //Create a new bar button item that will send addNewItem: to KMNItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        //Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}











#pragma mark - UITableView delegate methods (some required some optional)

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[KMNItemStore sharedStore] allItems] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    //Set the text on the cell with the description of the item that is at the nth index of items, where n = row this cell
    //will appear in on the tableview
    NSArray *items = [[KMNItemStore sharedStore] allItems];
    MNItem *item = items[indexPath.row];
    cell.textLabel.text = [item description];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray *items = [[KMNItemStore sharedStore] allItems];
        MNItem *item = items[indexPath.row];
        [[KMNItemStore sharedStore] removeItem:item];
        
        //Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[KMNItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    KMNDetailViewController *detailViewController = [[KMNDetailViewController alloc] init];
    
    KMNDetailViewController *detailViewController = [[KMNDetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[KMNItemStore sharedStore] allItems];
    MNItem *selectedItem = items[indexPath.row];
    
    //Give detail view controller a pointer to the item object in row
    detailViewController.item = selectedItem;
    
    //Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController animated:YES];
}




#pragma mark - UIViewController methods: viewDidLoad & viewWillAppear
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
@end
