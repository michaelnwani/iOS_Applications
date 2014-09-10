//
//  KMNItemStore.m
//  Homepwner
//
//  Created by Michael Nwani on 9/7/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNItemStore.h"
#import "MNItem.h"
#import "KMNImageStore.h"

@interface KMNItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation KMNItemStore

+(instancetype)sharedStore
{
    static KMNItemStore *sharedStore; //In Obj-C, a static variable is not destroyed when the method finishes. It isn't kept on the stack
    
    //Do I need to create a sharedStore?
    if (!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

//If a programmer calls [[KMNItemStore alloc] init], let him know the error of his ways
-(instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[KMNItemStore sharedStore]"];
    
    return nil;
}

//Here is the real (secret) initializer
-(instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        _privateItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSArray *)allItems
{
    return [self.privateItems copy];
}

-(MNItem *)createItem
{
    MNItem *item = [MNItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

-(void)removeItem:(MNItem *)item
{
    NSString *key = item.itemKey;
    [[KMNImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex)
    {
        return;
    }
    //Get a pointer to object being moved so you can re-insert it
    MNItem *item = self.privateItems[fromIndex];
    
    //Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    //Insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
}
@end