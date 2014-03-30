//
//  CustomMagnificationScrollView.m
//  ListenBooks
//
//  Created by Libor Kučera on 29.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "CustomDelegateScrollView.h"

@implementation CustomDelegateScrollView

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

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)magnifyWithEvent:(NSEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(customDelegateScrollView:didChangeMagnitication:)]) {
        [self.delegate customDelegateScrollView:self didChangeMagnitication:event.magnification];
    }
}

- (void)rotateWithEvent:(NSEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(customDelegateScrollView:didChangeRotation:)]) {
        [self.delegate customDelegateScrollView:self didChangeRotation:event.rotation];
    }
}

- (void)smartMagnifyWithEvent:(NSEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(customDelegateScrollViewDidChangeSmartMagnification:)]) {
        [self.delegate customDelegateScrollViewDidChangeSmartMagnification:self];
    }
}

@end
