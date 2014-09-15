//
//  KMNColorViewController.m
//  Colorboard
//
//  Created by Michael Nwani on 9/15/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNColorViewController.h"

@interface KMNColorViewController ()

@property (nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic, weak) IBOutlet UISlider *redSlider;

@property (nonatomic, weak) IBOutlet UISlider *greenSlider;

@property (nonatomic, weak) IBOutlet UISlider *blueSlider;

@end

@implementation KMNColorViewController

-(IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)changeColor:(id)sender
{
    float red = self.redSlider.value;
    float green = self.greenSlider.value;
    float blue = self.blueSlider.value;
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.view.backgroundColor = newColor; //[self.view setBackgroundColor: newColor]
    
}

-(void)viewWillAppear:(BOOL)animated //called when this view is going to be 'put' on a view hierarchy
{
    [super viewWillAppear:animated];
    
    //Remove the 'Done' button if this is an existing color
    if (self.existingColor)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *color = self.colorDescription.color;
    
    //Get the RGB values out of the UIColor object
    float red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil]; //they've already been set depending on the view's background color, we're copying the rgb values into red, green and blue's addresses.
    
    //Set the initial slider values
    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
    
    //Set the background color and text field value
    self.view.backgroundColor = color;
    self.textField.text = self.colorDescription.name;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.colorDescription.name = self.textField.text;
    self.colorDescription.color = self.view.backgroundColor;
}

@end
