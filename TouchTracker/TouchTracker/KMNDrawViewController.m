//
//  KMNDrawViewController.m
//  TouchTracker
//
//  Created by Michael Nwani on 9/9/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNDrawViewController.h"
#import "KMNDrawView.h"

@implementation KMNDrawViewController

-(void)loadView //the view controller calls this method when its view is requested
{
    
    self.view = [[KMNDrawView alloc] initWithFrame:CGRectZero];
    
}


@end
