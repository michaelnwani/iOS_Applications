//
//  KMNHypnosisView.m
//  Hypnosister
//
//  Created by Michael Nwani on 9/6/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNHypnosisView.h"

@interface KMNHypnosisView ()

@property (strong, nonatomic) UIColor *circleColor;

@end

@implementation KMNHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //All KMNHypnosisViews start with a clear background color
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    //Draw code
    
    CGRect bounds = self.bounds;
    //a CGRect has two members origin and size. Origin is a struct of type CGPoint, and size is a struct of type CGSize
    
    //Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    //The circle will be the largest that will fit in the view.
//    float radius = MIN(bounds.size.width, bounds.size.height) / 2.0;

    //The largest circle will circumscribe the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20)
    {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    //Add an arc to the path at center, with radius of radius, from 0 to 2*PI radians (a circle)
//    [path addArcWithCenter:center
//                    radius:radius
//                startAngle:0
//                  endAngle:M_PI * 2.0
//                 clockwise:YES];
    
    //Configure line width to 10 points
    path.lineWidth = 10;
    
    //Configure the drawing color to light gray
//    [[UIColor purpleColor] setStroke];
    [self.circleColor setStroke];
    
    //Draw the line!
    [path stroke];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched", self);
    
    //Get 3 random numbers between 0 and 1
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    
    self.circleColor = randomColor;
}

-(void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];

}

@end
