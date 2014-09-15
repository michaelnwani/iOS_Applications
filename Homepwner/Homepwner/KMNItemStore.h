//
//  KMNItemStore.h
//  Homepwner
//
//  Created by Michael Nwani on 9/7/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MNItem; //the compiler doesn't need to know its details in this current file; only that it exists.

@interface KMNItemStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allItems;

//Notice that this is a class method and prefixed with a + instead of a -
+(instancetype)sharedStore;
-(MNItem *)createItem;
-(void)removeItem:(MNItem *)item;
-(void)moveItemAtIndex:(NSInteger )fromIndex toIndex:(NSInteger)toIndex;
-(BOOL)saveChanges;
-(NSArray *)allAssetTypes;
@end
