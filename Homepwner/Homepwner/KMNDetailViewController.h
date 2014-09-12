//
//  KMNDetailViewController.h
//  Homepwner
//
//  Created by Michael Nwani on 9/8/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MNItem;

@interface KMNDetailViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
//UIImagePickerController's delegate propety is inherited from its superclass, which is UINavigationController

-(instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) MNItem *item;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
