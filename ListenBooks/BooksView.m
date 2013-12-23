//
//  SourceView.m
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "BooksView.h"
#import "BooksController.h"

@implementation BooksView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setDoubleAction:@selector(doubleClick:)];
}

#pragma mark - Event Handling methods

// Intercept key presses
- (void)keyDown:(NSEvent *)theEvent
{
	if(theEvent) {
		switch([[theEvent characters] characterAtIndex:0])
		{
			case NSDeleteCharacter:
                [self alertSheet];
				break;
                
			default:
				[super keyDown:theEvent];
				break;
		}
	}
}

- (IBAction)copy:(id)sender;
{
    [self.booksController copy];
}

- (IBAction)paste:(id)sender
{
    [self.booksController paste];
}

- (IBAction)cut:(id)sender
{
    [self.booksController cut];
}

- (IBAction)delete:(id)sender
{
    [self alertSheet];
}

- (void)doubleClick:(id)object
{
    [self.booksController edit];
}

- (void)selectAll:(id)sender
{
    [self.booksController selectAll];
}

#pragma mark - NSAlertViewDelegate

- (void)alertSheet
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:NSLocalizedString(@"Delete", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [alert setMessageText:NSLocalizedString(@"Do you really want to delete this item(s)?", nil)];
    [alert setInformativeText:NSLocalizedString(@"Deleting an item cannot be undone.", nil)];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert setDelegate:self];
    [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

-(void)alertDidEnd:(NSAlert*)alert returnCode:(NSInteger)returnCode contextInfo:(void*)contextInfo
{
    if (returnCode ==  NSAlertFirstButtonReturn)
    {
        [self.booksController deleteItems];
        
    }
}

@end
