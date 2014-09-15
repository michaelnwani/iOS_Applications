//
//  MNItem.m
//  Homepwner
//
//  Created by Michael Nwani on 9/14/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "MNItem.h"


@implementation MNItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic itemKey;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;

-(void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    //The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    //Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    //Create a transparent bitmap context with a scaling factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0); //creates a graphics context
    
    //Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    //Make all subsequent drawing clip to this rounded rectangle
    [path addClip]; //makes the resulting shape of this graphics context the current clipping path...
    
    //Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    //Draw the image on it
    [image drawInRect:projectRect]; //draws the entire image in the specified rectangle
    
    //Get the image from the image context; keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext(); //returns an image based on the current context...
    self.thumbnail = smallImage;
    
    //Cleanup image context resources; we're done
    UIGraphicsEndImageContext();
    
}

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date];
    
    //Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key;
}
@end
