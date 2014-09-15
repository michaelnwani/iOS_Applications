//
//  KMNDetailViewController.m
//  Homepwner
//
//  Created by Michael Nwani on 9/8/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNDetailViewController.h"
#import "MNItem.h"
#import "KMNImageStore.h"
#import "KMNItemStore.h"
#import "KMNAssetTypeViewController.h"
#import "KMNAppDelegate.h"

@interface KMNDetailViewController () <UIViewControllerRestoration>

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

@end

@implementation KMNDetailViewController

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    BOOL isNew = NO;
    if ([identifierComponents count] == 3)
    {
        isNew = YES;
    }
    
    return [[self alloc] initForNewItem:isNew];
}

-(instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if (isNew)
        {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        //Make sure this is NOT in the if (isNew) {} block of code
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(updateFonts)
                              name:UIContentSizeCategoryDidChangeNotification
                            object:nil];
        
    }
    
    return self;
}

-(void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [NSException raise:@"Wrong initializer" format:@"Use initForNewItem:"];
    
    return nil;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES]; //causes the view or one of its subviews (a textfield) to resign its first responder status
    
}
- (IBAction)showAssetTypePicker:(id)sender
{
    [self.view endEditing:YES];
    
    KMNAssetTypeViewController *avc = [[KMNAssetTypeViewController alloc] init];
    avc.item = self.item;
    
    [self.navigationController pushViewController:avc animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage]; //that's the key, returning the value
    
    [self.item setThumbnailFromImage:image];
    
    //Store the image in the KMNImageStore for this key
    [[KMNImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    //Put that image onto the screen in our image view
    self.imageView.image = image;
    
    //Do I have a popover?
    if (self.imagePickerPopover)
    {
        //Dismiss it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    }
    else
    {
        //Take image picker off the screen - you must call this dismiss method
        //Dismiss the modal image picker
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}


- (IBAction)takePicture:(id)sender
{
    if ([self.imagePickerPopover isPopoverVisible])
    {
        //If the popover is already up, get rid of it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    //If the device has a camera, take a picture, otherwise, just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    //Check for iPad device before instantiating the popover controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        //Create a new popover controller that will display the imagePicker
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        self.imagePickerPopover.delegate = self;
        
        //Display the popover controller; sender is the camera bar button item
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        //Place image picker on the screen
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    
    [self prepareViewsForOrientation:io];
    
    MNItem *item = self.item;
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    //You need an NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    //Use filtered NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *itemKey = self.item.itemKey;
    
    //Get the image for its image key from the image store
    UIImage *imageToDisplay = [[KMNImageStore sharedStore] imageForKey:itemKey];

    
    //Use that image to put on the screen in the imageView
    self.imageView.image = imageToDisplay;
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel)
    {
        typeLabel = @"None";
    }
    self.assetTypeButton.title = [NSString stringWithFormat:@"Type: %@", typeLabel];
    
    [self updateFonts];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Clear first responder; causes any and all text fields in the view to resign first responder status
    [self.view endEditing:YES];
    
    //"Save" changes to item
    MNItem *item = self.item; //we're now pointing to the same location in memory. how subtle.
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    
    int newValue = [self.valueField.text intValue];
    
    //Is it changed?
    if (newValue != item.valueInDollars)
    {
        //Put it in the item
        item.valueInDollars = newValue;
        
        //Store it as the default value for the next item
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue forKey:KMNNextItemValuePrefsKey];
    }
}

-(void)setItem:(MNItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    //The contentMode of the image view in the XIB was Aspect Fit:
    iv.contentMode = UIViewContentModeScaleAspectFit; //The default value is ScaleToFill
    
    //Do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    //The image view was a subview of the view
    [self.view addSubview:iv];
    
    //The image view was pointed to by the imageView property
    self.imageView = iv;
    
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolbar" : self.toolbar};
    
    //imageView is 0 pts from superview at left and right edges (or @"H:|-0-[imageView]-0-|"
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:0 views:nameMap];
    
    //imageView is 8 pts from dateLabel at its top edge, and 8 pts from toolbar at its bottom edge
    //8 pts is the default distance between views, so you can leave out the values: [dateLabel]-8-[imageView]-8-[toolbar]
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:0 views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
    //Set the vertical priorities to be less than those of the other subviews
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
}

-(void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    //Is it an iPad? No preparation necessary
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return;
    }
    //Is it landscape?
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    }
    else
    {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

//Sent to a view controller when the interface orientation successfully changes
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                        duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}




-(void)save:(id)sender
{
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];

}

-(void)cancel:(id)sender
{
    //If the user cancelled, then remove the KMNItem from the store
    [[KMNItemStore sharedStore] removeItem:self.item];
    
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];

}

-(void)updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
    
}


-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey forKey:@"item.itemKey"];
    
    //Save changes into item
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = self.valueField.text;
    
    //Have store save changes to disk
    [[KMNItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    
    for (MNItem *item in [[KMNItemStore sharedStore] allItems])
    {
        if ([itemKey isEqualToString:itemKey])
        {
            self.item = item;
            break;
        }
    }
    
    [super decodeRestorableStateWithCoder:coder];
}
@end
