//
//  BlockAlert.h
//  ListenBooks
//
//  Created by Libor Kučera on 09/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BlockAlert : NSAlert <NSAlertDelegate>

@property (nonatomic, copy) void (^completionBlock)(NSInteger returnCode);

- (instancetype)initWithStyle:(NSAlertStyle)style buttonTitles:(NSArray*)buttons messageText:(NSString*)messageText alternativeText:(NSString*)alternativeText;

@end
