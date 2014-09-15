//
//  KMNItemCell.m
//  Homepwner
//
//  Created by Michael Nwani on 9/12/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNItemCell.h"

@interface KMNItemCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewWidthConstraint; OLD IMPLEMENTATION

@end

@implementation KMNItemCell

-(IBAction)showImage:(id)sender
{
    if (self.actionBlock)
    {
        self.actionBlock();
    }
}

-(void)updateInterfaceForDynamicTypeSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    
    static NSDictionary *imageSizeDictionary;
    
    if (!imageSizeDictionary)
    {
        imageSizeDictionary = @{ UIContentSizeCategoryExtraSmall : @44,
                                 UIContentSizeCategorySmall : @44,
                                 UIContentSizeCategoryMedium : @44,
                                 UIContentSizeCategoryLarge : @44,
                                 UIContentSizeCategoryExtraLarge : @55,
                                 UIContentSizeCategoryExtraExtraLarge : @65,
                                 UIContentSizeCategoryExtraExtraExtraLarge : @75
                                
                                };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
//    self.imageViewWidthConstraint.constant = imageSize.floatValue; Handled by [NSLayoutConstraint constraintWithItem]
}

-(void)awakeFromNib //kind of like viewWillAppear, but for table view cell's.
{
    [super awakeFromNib];
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateInterfaceForDynamicTypeSize)
               name:UIContentSizeCategoryDidChangeNotification
             object:nil];
    
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.thumbnailView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.thumbnailView
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:0];
    [self.thumbnailView addConstraint:constraint];
}

-(void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

@end
