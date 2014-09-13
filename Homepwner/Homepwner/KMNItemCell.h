//
//  KMNItemCell.h
//  Homepwner
//
//  Created by Michael Nwani on 9/12/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMNItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (copy, nonatomic) void (^actionBlock)(void);
@end
