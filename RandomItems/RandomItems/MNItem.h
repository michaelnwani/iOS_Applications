//
//  MNItem.h
//  RandomItems
//
//  Created by Michael Nwani on 9/6/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNItem : NSObject


+(instancetype)randomItem;

//Designated initializer for MNItem
-(instancetype)initWithItemName:(NSString *)name
                 valueInDollars:(int)value
                   serialNumber:(NSString *)sNumber;

-(instancetype)initWithItemName:(NSString *)name;


@property (nonatomic, strong) MNItem *containedItem;
@property (nonatomic, weak) MNItem *container; //think of it like this; container has to be the weak one, because it resides in Calculator. containedItem resides in backpack.
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;




@end
