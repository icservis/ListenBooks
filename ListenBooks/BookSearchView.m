//
//  BookSearchView.m
//  ListenBooks
//
//  Created by Libor Kučera on 03.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "BookSearchView.h"
#import "BookViewController.h"
#import "SearchResult.h"
#import "Paragraph.h"

@implementation BookSearchView

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
    [self setDoubleAction:@selector(open:)];
}

- (IBAction)open:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    BookViewController* bookViewController = (BookViewController*)self.dataSource;
    NSInteger selectedRow = [self selectedRow];
    if (selectedRow >= 0) {
        Paragraph* paragraph = [self.dataSource tableView:self objectValueForTableColumn:nil row:selectedRow];
        SearchResult* searchResult = [[SearchResult alloc] init];
        searchResult.title = paragraph.text;
        searchResult.paragraph = paragraph;
        searchResult.page = paragraph.page;
        searchResult.position = 0;
        bookViewController.searchResult = searchResult;
    }
}

@end
