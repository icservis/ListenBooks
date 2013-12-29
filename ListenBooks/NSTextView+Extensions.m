//
//  NSTextView+Extensions.m
//  ListenBooks
//
//  Created by Libor Kučera on 29/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "NSTextView+Extensions.h"

@implementation NSTextView (Extensions)

- (void)setFontSize:(CGFloat)points
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSTextStorage * textStorage = [self textStorage];
    [textStorage beginEditing];
    [textStorage enumerateAttribute:NSFontAttributeName
                            inRange:NSMakeRange(0, [textStorage length])
                            options:0
                         usingBlock:^(id value,
                                      NSRange range,
                                      BOOL * stop)
     {
         NSFont * font = value;
         font = [fontManager convertFont:font
                                  toSize:points];
         if (font != nil) {
             [textStorage removeAttribute:NSFontAttributeName
                                    range:range];
             [textStorage addAttribute:NSFontAttributeName
                                 value:font
                                 range:range];
         }
     }];
    [textStorage endEditing];
    [self didChangeText];
}

- (void)changeFontSize:(CGFloat)delta
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSTextStorage * textStorage = [self textStorage];
    [textStorage beginEditing];
    [textStorage enumerateAttribute:NSFontAttributeName
                            inRange:NSMakeRange(0, [textStorage length])
                            options:0
                         usingBlock:^(id value,
                                      NSRange range,
                                      BOOL * stop)
     {
         NSFont * font = value;
         font = [fontManager convertFont:font
                                  toSize:[font pointSize] + delta];
         if (font != nil) {
             [textStorage removeAttribute:NSFontAttributeName
                                    range:range];
             [textStorage addAttribute:NSFontAttributeName
                                 value:font
                                 range:range];
         }
     }];
    [textStorage endEditing];
    [self didChangeText];
}

-  (IBAction)decrementFontSize:(id)sender
{
    [self changeFontSize:-1.0];
}

-  (IBAction)incrementFontSize:(id)sender
{
    [self changeFontSize:1.0];
}

@end
