//
//  VoiceControl.m
//  ListenBooks
//
//  Created by Libor Kučera on 15/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "VoiceControl.h"

@interface VoiceControl ()

@property (nonatomic, strong) NSSpeechSynthesizer* speechSynthetizer;

@end

@implementation VoiceControl

@synthesize speechSynthetizer = _speechSynthetizer;


- (NSSpeechSynthesizer*)speechSynthetizer
{
    if (_speechSynthetizer == nil) {
        _speechSynthetizer = [NSSpeechSynthesizer new];
        [_speechSynthetizer setDelegate:self];
    }
    return _speechSynthetizer;
}

- (NSArray*)arrangedObjects
{
    __block NSMutableArray* availableVoices = [NSMutableArray new];
    
    [[NSSpeechSynthesizer availableVoices] enumerateObjectsUsingBlock:^(NSString* voiceIdentifier, NSUInteger idx, BOOL *stop) {
        [availableVoices addObject:[NSSpeechSynthesizer attributesForVoice:voiceIdentifier]];
    }];
    
    NSPredicate* predicate = [self filterPredicate];
    if (predicate != nil) {
        return [availableVoices filteredArrayUsingPredicate:predicate];
    }
    return availableVoices;
}

- (double)sliderMinValue
{
    return -25.0f;
}

- (double)sliderMaxValue
{
    return 25.0f;
}

- (double)sliderDefaultValue
{
    return 0.0f;
}

@end
