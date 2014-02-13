//
//  InformationWindowController.m
//  ListenBooks
//
//  Created by Libor Kučera on 09/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "InformationWindowController.h"
#import "ListArrayController.h"
#import "BookObjectController.h"
#import "Book.h"

@interface InformationWindowController ()
@property (weak) IBOutlet NSView *view;
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSButton *saveButton;
@property (weak) IBOutlet NSButton *closeButton;
- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;

@end

@implementation InformationWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (AppDelegate*)appDelegate
{
    return (AppDelegate*)[[NSApplication sharedApplication] delegate];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    ListArrayController* listArrayController = appDelegate.listArrayController;
    [self.bookObjectController bind:NSContentObjectBinding toObject:listArrayController withKeyPath:@"selection" options:nil];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [[[self appDelegate] undoManager] beginUndoGrouping];
    [[[self appDelegate] undoManager] setActionName:NSLocalizedString(@"Edit Information", nil)];
}

- (IBAction)saveButtonClicked:(id)sender
{
    [self.window makeFirstResponder:nil];

    if (self.completionBlock != nil) {
        self.completionBlock(YES);
    }
    
    [[[self appDelegate] undoManager] endUndoGrouping];
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self.window makeFirstResponder:nil];
    
    if (self.completionBlock != nil) {
        self.completionBlock(NO);
    }
    
    [[[self appDelegate] undoManager] endUndoGrouping];
    [[[self appDelegate] undoManager] disableUndoRegistration];
    [[[self appDelegate] undoManager] undo];
    [[[self appDelegate] undoManager] enableUndoRegistration];
}

@end
