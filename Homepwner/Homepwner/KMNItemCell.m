//
//  KMNItemCell.m
//  Homepwner
//
//  Created by Michael Nwani on 9/12/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNItemCell.h"

@implementation KMNItemCell

-(IBAction)showImage:(id)sender
{
    if (self.actionBlock)
    {
        self.actionBlock();
    }
}
@end
