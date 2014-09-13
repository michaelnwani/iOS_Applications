//
//  MNItem.h
//  RandomItems
//
//  Created by Michael Nwani on 9/6/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNItem : NSObject <NSCoding>


+(instancetype)randomItem;

//Designated initializer for MNItem
-(instancetype)initWithItemName:(NSString *)name
                 valueInDollars:(int)value
                   serialNumber:(NSString *)sNumber;

-(instancetype)initWithItemName:(NSString *)name;


@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic, strong) UIImage *thumbnail;

-(void)setThumbnailFromImage:(UIImage *)image;


@end
