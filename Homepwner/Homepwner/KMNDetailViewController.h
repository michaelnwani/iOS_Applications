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
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
//UIImagePickerController's delegate propety is inherited from its superclass, which is UINavigationController

@property (nonatomic, strong) MNItem *item;

@end
