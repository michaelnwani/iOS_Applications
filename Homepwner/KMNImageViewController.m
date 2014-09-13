//
//  KMNImageViewController.m
//  Homepwner
//
//  Created by Michael Nwani on 9/12/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNImageViewController.h"
#import "KMNImageStore.h"

@interface KMNImageViewController () 

@end

@implementation KMNImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    //Used to determine how a view lays out its content when its bounds change
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //We must cast the view to UIImageView so the compiler knows it is okay to send it setImage:
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image;
}

@end
