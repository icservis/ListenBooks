//
//  BlockAlert.m
//  ListenBooks
//
//  Created by Libor Kučera on 09/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "BlockAlert.h"

@implementation BlockAlert

- (instancetype)initWithStyle:(NSAlertStyle)style buttonTitles:(NSArray *)buttonTitles messageText:(NSString *)messageText alternativeText:(NSString *)alternativeText
{
    self = [super init];
    if (self) {
        [buttonTitles enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL *stop) {
            [self addButtonWithTitle:title];
        }];
        [self setMessageText:messageText];
        [self setInformativeText:alternativeText];
        [self setAlertStyle:style];
        [self setDelegate:self];
        [self beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
    return self;
}

#pragma mark - NSAlertDelegate

-(void)alertDidEnd:(NSAlert*)alert returnCode:(NSInteger)returnCode contextInfo:(void*)contextInfo
{
    if (self.completionBlock != nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            self.completionBlock(returnCode);
        });
    }
}

@end
