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
@import CoreData;
#import "KMNAppDelegate.h"

@interface KMNItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;


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
//        _privateItems = [[NSMutableArray alloc] init]; OLD IMPLEMENTATION
//        NSString *path = [self itemArchivePath];
//        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//        
//        //If the array hadn't been saved previously, create a new empty one
//        if (!_privateItems)
//        {
//            _privateItems = [[NSMutableArray alloc] init];
//        }
        
        //Read in Homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: _model];
        
        //Where does the SQLite file go?
        NSString *path = [self itemArchivePath]; //self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            [NSException raise:@"Open Failure" format:[error localizedDescription]];
        }
        
        //Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc; //[context setPersistentStoreCoordinator:psc];
        
        [self loadAllItems];
    }
    
    return self;
}

-(NSArray *)allItems
{
    return [self.privateItems copy];
}

-(MNItem *)createItem
{
//    MNItem *item = [MNItem randomItem]; OLD IMPLEMENTATION
//    MNItem *item = [[MNItem alloc] init];
    
    double order;
    if ([self.allItems count] == 0)
    {
        order = 1.0;
    }
    else
    {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count], order);
    
    MNItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"MNItem" inManagedObjectContext:self.context];
    
    item.orderingValue = order;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    item.valueInDollars = [defaults integerForKey:KMNNextItemValuePrefsKey];
    item.itemName = [defaults objectForKey:KMNNextItemNamePrefsKey];
    
    //Just for fun, list out all the defaults
    NSLog(@"defaults = %@", [defaults dictionaryRepresentation]);
    
    [self.privateItems addObject:item];
    
    return item;
}

-(void)removeItem:(MNItem *)item
{
    NSString *key = item.itemKey;
    [[KMNImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item];
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
    
    //Computing a new orderValue for the object that was moved
    double lowerBound = 0.0;
    
    //Is there an object before it is in the array?
    if (toIndex > 0)
    {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    }
    else
    {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    //Is there an object after it in the array?
    if (toIndex < [self.privateItems count] - 1)
    {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    }
    else
    {
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound)/2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

-(NSString *)itemArchivePath
{
    //Make sure that the first argument is NSDocumentDirectory and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
//    return [documentDirectory stringByAppendingPathComponent:@"items.archive"]; ARCHIVING FILENAME
    return [documentDirectory stringByAppendingPathComponent:@"store.data"]; //CORE DATA FILENAME
    
}

-(BOOL)saveChanges
{
//    NSString *path = [self itemArchivePath];
//    
//    //Returns YES on success
//    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful)
    {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    
    return successful;

}

-(void)loadAllItems
{
    if (!self.privateItems)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"MNItem" inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        
        request.sortDescriptors = @[sd]; //can take an array of sort descriptors
        
        NSError *error;
        
        NSArray *result = [self.context executeFetchRequest:request error:&error]; //returns an array of objects that that meet the criteria given by the fetch request (all 'objects' of the MNItem entity/table)
        
        if (!result)
        {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result]; //magic
    }
}

-(NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"KMNAssetType" inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result)
        {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    //Is this the first time the program is being run?
    if ([_allAssetTypes count] == 0)
    {
        NSManagedObject *type;
        //this is creating new KMNAssetType instances for the entity, and giving each of their label attributes a value
        type = [NSEntityDescription insertNewObjectForEntityForName:@"KMNAssetType" inManagedObjectContext:self.context];
        
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"KMNAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"KMNAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        
    }
    
    return _allAssetTypes;
}
@end
