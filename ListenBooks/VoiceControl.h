//
//  VoiceControl.h
//  ListenBooks
//
//  Created by Libor Kučera on 15/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceControl : NSArrayController <NSSpeechSynthesizerDelegate>

- (double)sliderMinValue;
- (double)sliderMaxValue;
- (double)sliderDefaultValue;

@end
