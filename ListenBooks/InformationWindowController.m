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

@property (strong) IBOutlet BookObjectController *bookObjectController;

@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSTextField *authorLabel;
@property (weak) IBOutlet NSTextField *authorField;
@property (weak) IBOutlet NSTextField *subjectLabel;
@property (weak) IBOutlet NSTextField *subjectField;

@property (weak) IBOutlet NSPopUpButton *fontNamePopup;
@property (weak) IBOutlet NSSegmentedControl *themeSegmentedControl;
@property (weak) IBOutlet NSSlider *fontSizeTickSlider;
@property (weak) IBOutlet NSPopUpButton *voicePopup;
@property (weak) IBOutlet NSSlider *voiceSpeedSlider;
@property (weak) IBOutlet NSTextField *fontLabel;
@property (weak) IBOutlet NSTextField *themeLabel;
@property (weak) IBOutlet NSTextField *sizeLabel;
@property (weak) IBOutlet NSTextField *voiceLabel;
@property (weak) IBOutlet NSTextField *sppedLabel;

@property (weak) IBOutlet NSTextField *publisherLabel;
@property (weak) IBOutlet NSTextField *rightsLabel;
@property (weak) IBOutlet NSTextField *createdLabel;

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
    
    self.titleLabel.stringValue = NSLocalizedString(@"Title", nil);
    self.authorLabel.stringValue = NSLocalizedString(@"Author", nil);
    self.subjectLabel.stringValue = NSLocalizedString(@"Subject", nil);
    self.fontLabel.stringValue = NSLocalizedString(@"Font Name", nil);
    self.themeLabel.stringValue = NSLocalizedString(@"Theme", nil);
    self.sizeLabel.stringValue = NSLocalizedString(@"Font Size", nil);
    self.voiceLabel.stringValue = NSLocalizedString(@"Voice", nil);
    self.publisherLabel.stringValue = NSLocalizedString(@"Publisher", nil);
    self.rightsLabel.stringValue = NSLocalizedString(@"Rights", nil);
    self.createdLabel.stringValue = NSLocalizedString(@"Created", nil);
    
    [[[self appDelegate] undoManager] beginUndoGrouping];
    [[[self appDelegate] undoManager] setActionName:NSLocalizedString(@"Edit Information", nil)];
}

#pragma mark - IBActions

- (IBAction)saveButtonClicked:(id)sender
{
    [self.window makeFirstResponder:nil];
    [[[self appDelegate] undoManager] endUndoGrouping];
    
    if (self.completionBlock != nil) {
        self.completionBlock(YES);
    }
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self.window makeFirstResponder:nil];
    
    [[[self appDelegate] undoManager] endUndoGrouping];
    [[[self appDelegate] undoManager] disableUndoRegistration];
    [[[self appDelegate] undoManager] undo];
    [[[self appDelegate] undoManager] enableUndoRegistration];
    
    if (self.completionBlock != nil) {
        self.completionBlock(NO);
    }
}

@end
