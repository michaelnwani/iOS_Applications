//
//  KMNPaletteViewController.m
//  Colorboard
//
//  Created by Michael Nwani on 9/15/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNPaletteViewController.h"
#import "KMNColorViewController.h"
#import "KMNColorDescription.h"

@interface KMNPaletteViewController ()

@property (nonatomic) NSMutableArray *colors;

@end

@implementation KMNPaletteViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.colors count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    KMNColorDescription *color = self.colors[indexPath.row];
    cell.textLabel.text = color.name;
    
    return cell;
}

-(NSMutableArray *)colors
{
    if (!_colors)
    {
        _colors = [NSMutableArray array];
        
        KMNColorDescription *cd = [[KMNColorDescription alloc] init];
        [_colors addObject:cd];
    }
    
    return _colors;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NewColor"])
    {
        //If we are adding a new color, create an instance and add it to the colors array
        KMNColorDescription *color = [[KMNColorDescription alloc]init];
        [self.colors addObject:color];
        
        //Then use the segue to set the color on the view controller
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        
        KMNColorViewController *mvc = (KMNColorViewController *)[nc topViewController];
        mvc.colorDescription = color;
        
    }
    else if ([segue.identifier isEqualToString:@"ExistingColor"])
    {
        //For the push segue, the sender is the UITableViewCell
        NSIndexPath *ip = [self.tableView indexPathForCell:sender];
        KMNColorDescription *color = self.colors[ip.row];
        
        //Set the color, and also tell the view controller that this is an existing color
        KMNColorViewController *cvc = (KMNColorViewController *)segue.destinationViewController;
        cvc.colorDescription = color;
        cvc.existingColor = YES;
    }
}

@end
