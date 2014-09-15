//
//  KMNAssetTypeViewController.m
//  Homepwner
//
//  Created by Michael Nwani on 9/14/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNAssetTypeViewController.h"

#import "KMNItemStore.h"
#import "MNItem.h"

@implementation KMNAssetTypeViewController

-(instancetype)init
{
    return [super initWithStyle:UITableViewStylePlain];
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[KMNItemStore sharedStore] allAssetTypes] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    NSArray *allAssets = [[KMNItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row]; //NSManagedObject is a generic type, acting like NSDictionary
    
    //Use key-value coding to get the asset type's label
    NSString *assetLabel = [assetType valueForKey:@"label"];
    cell.textLabel.text = assetLabel;
    
    //Checkmark the one that is currently selected
    if (assetType == self.item.assetType)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[KMNItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
