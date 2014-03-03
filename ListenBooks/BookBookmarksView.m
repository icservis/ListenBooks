//
//  BookBookmarksView.m
//  ListenBooks
//
//  Created by Libor Kučera on 17/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "BookBookmarksView.h"
#import "BookViewController.h"

@interface BookBookmarksView ()

@end

@implementation BookBookmarksView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [self setDoubleAction:@selector(open:)];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

#pragma mark - FirstResponder

- (IBAction)new:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    BookViewController* bookViewController = (BookViewController*)self.dataSource;
    [bookViewController add:sender];
}

- (IBAction)delete:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    BookViewController* bookViewController = (BookViewController*)self.dataSource;
    [bookViewController remove:sender];
}

- (IBAction)open:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    BookViewController* bookViewController = (BookViewController*)self.dataSource;
    NSInteger selectedRow = [self selectedRow];
    if (selectedRow >= 0) {
        Bookmark* bookmark = [self.dataSource tableView:self objectValueForTableColumn:nil row:selectedRow];
        bookViewController.bookmark = bookmark;
    }
}

- (IBAction)export:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    BookViewController* bookViewController = (BookViewController*)self.dataSource;
    [bookViewController export:sender];
}

#pragma mark - Validation menus

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    SEL theAction = [menuItem action];
    
    if (theAction == @selector(new:)) {
        
        return YES;
    }
    
    if (theAction == @selector(open:)) {
        
        if ([[self selectedRowIndexes] count] > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    
    if (theAction == @selector(delete:)) {
        
        if ([[self selectedRowIndexes] count] > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    
    if (theAction == @selector(selectAll:)) {
        
        return NO;
    }
    
    return YES;
}

-(BOOL) validateValue: (id*)ioValue forKeyPath: (NSString*)inKeyPath error: (NSError **)outError
{
    DDLogDebug(@"ioValue: %@", *ioValue);
    return YES;
}

@end
