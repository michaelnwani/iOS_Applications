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
#import "KMNItemCell.h"
#import "KMNImageStore.h"
#import "KMNImageViewController.h"


@interface KMNItemsViewController () <UIPopoverControllerDelegate>

//@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (strong, nonatomic) UIPopoverController *imagePopover;


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
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath]; OLD IMPLEMENTATION
    
    //Get a new or recycled cell
    KMNItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMNItemCell" forIndexPath:indexPath];
    
    //Set the text on the cell with the description of the item that is at the nth index of items, where n = row this cell
    //will appear in on the tableview
    NSArray *items = [[KMNItemStore sharedStore] allItems];
    MNItem *item = items[indexPath.row];
//    cell.textLabel.text = [item description]; all UITableViewCell's have this textLabel property for its 'main' content area
    
    //Configure the cell with the KMNItem
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;

    __weak KMNItemCell *weakCell = cell;
    
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        
        KMNItemCell *strongCell = weakCell;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            NSString *itemKey = item.itemKey;
            
            //If there is no image, we don't need to display anything
            UIImage *img = [[KMNImageStore sharedStore] imageForKey:itemKey];
            if (!img)
            {
                return;
            }
            
            //Make a rectangle for the frame of the thumbnail relative to our table view
            //Note: there will be a warning on this line that we'll soon discuss
//            CGRect rect = [self.view convertRect:cell.thumbnailView.bounds fromView:cell.thumbnailView]; OLD IMPLEMENTATION
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            //bounds is to get the local coordinate system of the view
            
            //Create a new KMNImageViewController and set its image
            KMNImageViewController *ivc = [[KMNImageViewController alloc] init];
            ivc.image = img;
            
            //Present a 600x600 popover from the rect
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    };
    
    
    return cell;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
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
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"]; OLD IMPLEMENTATION
    
    //Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"KMNItemCell" bundle:nil]; //a container for a NIB (XIB) file
    
    //Register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"KMNItemCell"];
    
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
@end
