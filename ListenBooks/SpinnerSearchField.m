//
//  SpinnerSearchField.m
//  ListenBooks
//
//  Created by Libor Kučera on 04.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "SpinnerSearchField.h"

@implementation SpinnerSearchField

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)showProgressIndicator
{
    NSArray *subviews = [self.superview subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSProgressIndicator class]])
        {
            [obj removeFromSuperview];
            *stop = YES;
            return;
        }
    }];
    
    int xPos = NSMaxX(self.frame) - 16;
    int yPos = NSMidY(self.frame) - 6;
    CGRect spinnerFrame = CGRectMake(xPos, yPos, 13, 13);
    NSProgressIndicator *spinner = [[NSProgressIndicator alloc] initWithFrame:spinnerFrame];
    spinner.style = NSProgressIndicatorSpinningStyle;
    if ([self.cell controlSize] == NSRegularControlSize)
    {
        spinner.controlSize = NSSmallControlSize;
    }
    else
    {
        spinner.controlSize = NSMiniControlSize;
    }
    ((NSSearchFieldCell *)self.cell).cancelButtonCell = nil;
    [spinner startAnimation:self];
    [self.superview addSubview:spinner positioned:NSWindowAbove relativeTo:self];
}


- (void)hideProgressIndicator
{
    NSArray *subviews = [self.superview subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSProgressIndicator class]])
        {
            [obj removeFromSuperview];
            NSString* content = [self.cell stringValue];
            [self.cell resetCancelButtonCell];
            [self.cell setStringValue:content];
            *stop = YES;
        }
    }];
}

@end
