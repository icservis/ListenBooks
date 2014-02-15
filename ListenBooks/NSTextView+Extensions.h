//
//  NSTextView+Extensions.h
//  ListenBooks
//
//  Created by Libor Kučera on 29/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTextView (Extensions)

- (void)setFontSize:(CGFloat)points;
- (void)changeFontSize:(CGFloat)delta;
- (IBAction)decrementFontSize:(id)sender;
- (IBAction)incrementFontSize:(id)sender;


@end
