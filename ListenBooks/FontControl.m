//
//  FontControl.m
//  ListenBooks
//
//  Created by Libor Kučera on 15/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "FontControl.h"

@implementation FontControl

- (NSArray*)arrangedObjects
{
    return [[NSFontManager sharedFontManager] availableFontFamilies];
}


- (double)sliderMinValue
{
    return -3.0f;
}

- (double)sliderMaxValue
{
    return 7.0f;
}

- (double)sliderDefaultValue
{
    return 0.0f;
}

- (double)sliderMagnifiedValue
{
    return 4.0f;
}

@end
