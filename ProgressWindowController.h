//
//  ProgressWindowController.h
//  ListenBooks
//
//  Created by Libor Kučera on 13/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProgressWindowController : NSWindowController

@property (assign, getter = isInProgress) BOOL inProgress;
@property (nonatomic, copy) void (^completionBlock)();

+ (ProgressWindowController *)sharedController;

- (void)openProgressWindowWithTitle:(NSString*)title info:(NSString*)info indicatorMinValue:(double)minValue indicatorMaxValue:(double)maxValue doubleValue:(double)doubleValue indeterminate:(BOOL)indeterminate animating:(BOOL)animating;
- (void)updateProgressWindowWithTitle:(NSString*)title;
- (void)updateProgressWindowWithInfo:(NSString*)info;
- (void)updateProgressWindowWithDoubleValue:(double)doubleValue;
- (void)updateProgressWindowWithMinValue:(double)minValue;
- (void)updateProgressWindowWithMaxValue:(double)maxValue;
- (void)updateProgressWindowWithIndeterminate:(BOOL)indeterminate animating:(BOOL)animating;
- (void)closeProgressWindow;

@end
