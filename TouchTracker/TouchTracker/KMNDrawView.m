//
//  KMNDrawView.m
//  TouchTracker
//
//  Created by Michael Nwani on 9/9/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNDrawView.h"
#import "KMNLine.h"

@interface KMNDrawView () <UIGestureRecognizerDelegate>

//@property (nonatomic, strong) KMNLine *currentLine;
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, weak) KMNLine *selectedLine;

@end

@implementation KMNDrawView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
    }
    
    return self;
}

-(void)strokeLine:(KMNLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end]; //starts at the current point (line.begin), and ends at the point argument (line.end)
    [bp stroke];
}

-(void)drawRect:(CGRect)rect
{
    //Draw finished lines in black
    [[UIColor blackColor] set]; //set sets the color of stroke and fill operations to the specified UIColor color
    for (KMNLine *line in self.finishedLines)
    {
        [self strokeLine:line];
    }
// SINGLE TOUCH IMPLEMENTATION
//    if (self.currentLine) //if it literally exists; when a currentLine finishes, the property is set to nil, and that line is added to the finishedLines array
//    {
//        //If there is a line currently being drawn, do it in red
//        [[UIColor redColor] set];
//        [self strokeLine:self.currentLine];
//    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress)
    {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    if (self.selectedLine)
    {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
    
}

-(void)touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event
{
    
    //Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));

    for (UITouch *t in touches)
    {
        CGPoint location = [t locationInView:self];
        
        KMNLine *line = [[KMNLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line; //if we just said linesInProgress[t], then we'd retain a pointer to the UITouch object
    }
    
// SINGLE TOUCH IMPLEMENTATION
//    UITouch *t = [touches anyObject];
//    
//    //Get a location of the touch in view's coordinate system
//    CGPoint location = [t locationInView:self];
//    
//    self.currentLine = [[KMNLine alloc] init];
//    self.currentLine.begin = location;
//    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        KMNLine *line = self.linesInProgress[key];
        
        line.end = [t locationInView:self]; //locationInView returns a CGPoint
    }
    
// SINGLE TOUCH IMPLEMENTATION
//    UITouch *t = [touches anyObject];
//    
//    CGPoint location = [t locationInView:self]; //send your location as a CGPoint object to a destination view
//    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{ //If we get to this method, from this NSSet object, these are touches that have already finished. That's why we can assume so.
    
    //Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        KMNLine *line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
//SINGLE TOUCH IMPLEMENTATION
//    [self.finishedLines addObject:self.currentLine];
//    
//    self.currentLine = nil;
    
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

-(void)doubleTap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized Double Tap");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

-(void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized tap");
    
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    if (self.selectedLine)
    {
        //Make ourselves the target of menu item action messages
        [self becomeFirstResponder];
        
        //Grab the menu controller
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        //Create a new "Delete" UIMenuItem
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        
        menu.menuItems = @[deleteItem];
        
        //Tell the menu where it should come from and show it
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    else
    {
        //Hide the menu if no line is selected
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

-(KMNLine *)lineAtPoint:(CGPoint)p
{
    //Find a line close to p
    for (KMNLine *l in self.finishedLines)
    {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        //Check a few points on the line
        for (float t = 0.0; t <= 1.0; t += 0.05)
        {
            float x = start.x + t * (end.x - start.x); //x will be gradually increasing...
            float y = start.y + t * (end.y - start.y);
            
            //If the tapped point is within 20 points, let's return this line
            if (hypot(x - p.x, y - p.y) < 20.0)
            {
                return l;
            }
        }
    }
    
    //If nothing is close enough to the tapped point, then we did not select a line
    return nil;
}

-(BOOL)canBecomeFirstResponder //need to override this if you have a custom view class that needs to become first responder
{
    return YES;
}

-(void)deleteLine:(id)sender
{
    //Remove the selected line from the list of finishedLines
    [self.finishedLines removeObject:self.selectedLine];
    
    //Redraw everything
    [self setNeedsDisplay];
}

-(void)longPress:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point]; //if its close to enough to a line (that's what lineAtPoint checks)
        
        if (self.selectedLine)
        {
            [self.linesInProgress removeAllObjects];
        }
        
    }
    else if (gr.state == UIGestureRecognizerStateEnded)
    {
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.moveRecognizer)
    {
        return YES;
    }
    return NO;
}

-(void)moveLine:(UIPanGestureRecognizer *)gr //the argument is a UIPanGestureRecognizer and not UIGestureRecognizer because we're sending a message specific to UIPanGestureRecognizer, translationInView:
{
    //If we have not selected a line, we do not do anything here
    if (!self.selectedLine)
    {
        return;
    }
    
    //When the pan recognizer changes its position...
    if (gr.state == UIGestureRecognizerStateChanged)
    {
        //How far has the pan moved?
        CGPoint translation = [gr translationInView:self];
        
        //Add the translation to the current beginning and end points of the line
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        //Set the new beginning and end points of the line
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        //Redraw the screen
        [self setNeedsDisplay];
        
        [gr setTranslation:CGPointZero inView:self]; //changing the translation value resets the velocity of the pan
        
    }
}
@end