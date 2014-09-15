//
//  MNItem.h
//  Homepwner
//
//  Created by Michael Nwani on 9/14/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MNItem : NSManagedObject

//the retain attribute is the same thing as strong
@property (nonatomic, strong) NSString * itemName;
@property (nonatomic, strong) NSString * serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSDate * dateCreated;
@property (nonatomic, strong) NSString * itemKey;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic) double orderingValue;
@property (nonatomic, strong) NSManagedObject *assetType;

-(void)setThumbnailFromImage:(UIImage *)image;

@end
