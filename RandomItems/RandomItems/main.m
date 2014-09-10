//
//  main.m
//  RandomItems
//
//  Created by Michael Nwani on 9/6/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNItem.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        //Create a mutable array object, store its address in items variable
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
//        for (int i = 0; i < 10; i++)
//        {
//            MNItem *item = [MNItem randomItem];
//            [items addObject:item];
//        }
        
        MNItem *backpack = [[MNItem alloc] initWithItemName:@"Backpack"];
        [items addObject:backpack];
        
        MNItem *calculator = [[MNItem alloc] initWithItemName:@"Calculator"];
        [items addObject:calculator];
        
        backpack.containedItem = calculator;
        
        backpack = nil;
        calculator = nil;

        for (MNItem *item in items)
        {
            NSLog(@"%@", item);
        }
        
        //Send the message addObject: to the NSMutableArray pointed to
        //by the variable items, passing a string each time.
//        [items addObject:@"One"];
//        [items addObject:@"Two"];
//        [items addObject:@"Three"];
        
        //Send another message, insertObject:atIndex:, to that same array object
//        [items insertObject:@"Zero" atIndex:0];
        
        
        //For every item in the items array ...
//        for (NSString *item in items)
//        {
//            //Log the description of item
//            NSLog(@"%@", item);
//        }
        
        
//        MNItem *item = [[MNItem alloc] init];
        
        //This creates an NSString, "Red Sofa" and gives it to the MNItem
//        [item setItemName:@"Red Sofa"];
//        item.itemName = @"Red Sofa";
        
        //This creates an NSString, "A1B2C" and gives it to the MNItem
//        [item setSerialNumber:@"A1B2C"];
//        item.serialNumber = @"A1B2C";
        
        //This sends the value 100 to be used as the valueInDollars of this MNItem
        //Set valueInDollars using dot syntax
//        item.valueInDollars = 100;
        
//        MNItem *item = [[MNItem alloc] initWithItemName:@"Red Sofa" valueInDollars:100 serialNumber:@"A1B2C"];
        
        
//        NSLog(@"%@ %@ %@ %d", item.itemName, item.dateCreated, item.serialNumber, item.valueInDollars);
        
        //The %@ token is replaced with the result of sending the description message to the corresponding argument
//        NSLog(@"%@", item);
//        
//        MNItem *itemWithName = [[MNItem alloc] initWithItemName:@"Blue Sofa"];
//        NSLog(@"%@", itemWithName);
//        
//        MNItem *itemWithNoName = [[MNItem alloc] init];
//        NSLog(@"%@", itemWithNoName);
        
        
        //Destroy the mutable array object
        NSLog(@"Setting items to nil...");
        items = nil;
        
    }
    return 0;
}

