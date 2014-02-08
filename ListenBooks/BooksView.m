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
    [self setDoubleAction:@selector(open:)];
}

#pragma mark - Event Handling methods

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
    [self.booksController delete];
}

- (IBAction)edit:(id)object
{
    [self.booksController edit];
}

- (IBAction)open:(id)object
{
    [self.booksController open];
}

/*
- (void)selectAll:(id)sender
{
    [self.booksController selectAll];
}
 */

@end
