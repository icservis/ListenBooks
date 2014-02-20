//
//  ProgressWindowController.m
//  ListenBooks
//
//  Created by Libor Kučera on 13/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "ProgressWindowController.h"

static NSTimeInterval const kModalSheetDelay = 1.0f;

@interface ProgressWindowController ()

@property (weak) IBOutlet NSView *view;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSTextField *infoField;

@end

@implementation ProgressWindowController

+ (ProgressWindowController *)sharedController
{
    static ProgressWindowController* _sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedController = [[self alloc] initWithWindowNibName:@"ProgressWindowController"];
    });
    
    return _sharedController;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        NSLog(@"initWithWindow");
        self.inProgress = NO;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)dealloc
{
    
}

#pragma mark - ProgressWindow

- (void)openProgressWindowWithTitle:(NSString*)title info:(NSString*)info indicatorMinValue:(double)minValue indicatorMaxValue:(double)maxValue doubleValue:(double)doubleValue indeterminate:(BOOL)indeterminate animating:(BOOL)animating
{
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    if (self.inProgress == NO) {
        [[NSApplication sharedApplication] beginSheet:self.window
                                       modalForWindow: appDelegate.window
                                        modalDelegate:self
                                       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
                                          contextInfo:nil];
        self.inProgress = YES;
    }
    
    self.titleField.stringValue = title;
    self.infoField.stringValue = info;
    self.progressIndicator.doubleValue = doubleValue;
    self.progressIndicator.minValue = minValue;
    self.progressIndicator.maxValue = maxValue;
    self.progressIndicator.indeterminate = indeterminate;
    if (indeterminate == YES) {
        if (animating) {
            [self.progressIndicator startAnimation:nil];
        } else {
            [self.progressIndicator stopAnimation:nil];
        }
    }
}

- (void)updateProgressWindowWithTitle:(NSString*)title
{
    self.titleField.stringValue = title;
}

- (void)updateProgressWindowWithInfo:(NSString*)info
{
    self.infoField.stringValue = info;
}

- (void)updateProgressWindowWithDoubleValue:(double)doubleValue
{
    self.progressIndicator.doubleValue = doubleValue;
    [self.progressIndicator setNeedsDisplay:YES];
}

- (void)updateProgressWindowWithMinValue:(double)minValue
{
    self.progressIndicator.minValue = minValue;
    [self.progressIndicator setNeedsDisplay:YES];
}

- (void)updateProgressWindowWithMaxValue:(double)maxValue
{
    self.progressIndicator.maxValue = maxValue;
    [self.progressIndicator setNeedsDisplay:YES];
}

- (void)updateProgressWindowWithIndeterminate:(BOOL)indeterminate animating:(BOOL)animating
{
    if (indeterminate == YES) {
        if (animating) {
            [self.progressIndicator startAnimation:nil];
        } else {
            [self.progressIndicator stopAnimation:nil];
        }
    }
    [self.progressIndicator setNeedsDisplay:YES];
}

- (void)closeProgressWindow
{
    self.inProgress = NO;
    /*
    self.titleField.stringValue = nil;
    self.infoField.stringValue = nil;
    self.progressIndicator.doubleValue = 0;
    self.progressIndicator.indeterminate = YES;
    [self.progressIndicator stopAnimation:nil];
     */
    
    [NSApp endSheet:self.window];
    if (self.completionBlock != nil) {
        self.completionBlock();
    };
}

#pragma mark - ProgressWindowDelegate

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [sheet performSelector:@selector(orderOut:) withObject:self afterDelay:kModalSheetDelay];
}

@end
