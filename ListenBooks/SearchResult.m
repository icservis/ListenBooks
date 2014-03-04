//
//  SearchResult.m
//  ListenBooks
//
//  Created by Libor Kučera on 03.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "SearchResult.h"
#import "Book.h"
#import "Page.h"
#import "Paragraph.h"

@implementation SearchResult

@synthesize title = _title;
@synthesize page = _page;
@synthesize paragraph = _paragraph;
@synthesize positionInParagraph = _positionInParagraph;
@synthesize positionInPage = _positionInPage;
@synthesize pageIndex = _pageIndex;


- (NSAttributedString*)title {
    return _title;
}

- (void)setTitle:(NSAttributedString *)title
{
    _title = title;
}

- (BOOL)validateTitle:(NSAttributedString*)title error:(NSError *__autoreleasing *)error
{
    if ([title length] > 0) {
        return YES;
    }
    return NO;
}

- (Page*)page {
    return _page;
}

- (void)setPage:(Page *)page
{
    _page = page;
}

- (Paragraph*)paragraph
{
    return _paragraph;
}

- (void)setParagraph:(Paragraph *)paragraph
{
    _paragraph = paragraph;
}

- (NSNumber*)positionInParagraph
{
    return _positionInParagraph;
}

- (void)setPositionInParagraph:(NSNumber *)positionInParagraph
{
    _positionInParagraph = positionInParagraph;
}

- (NSNumber*)positionInPage
{
    return _positionInPage;
}

- (void)setPositionInPage:(NSNumber *)positionInPage
{
    _positionInPage = positionInPage;
}

- (NSNumber*)pageIndex
{
    return _pageIndex;
}

- (void)setPageIndex:(NSNumber *)pageIndex
{
    _pageIndex = pageIndex;
}

- (NSComparisonResult)compare:(SearchResult*)object
{
    return [self.pageIndex compare:object.pageIndex];
}

- (BOOL) isEqual: (id) obj
{
    if ([self class] != [obj class])
        return NO;
    
    NSArray *myProperties = @[@"title", @"page", @"paragraph", @"positionInParagraph", @"positionInPage", @"pageIndex"];
    for (NSString *propertyName in myProperties) {
        if (![[self valueForKey:propertyName] isEqual: [obj valueForKey:propertyName]])
            return NO;
    }
    
    return YES;
}

@end
