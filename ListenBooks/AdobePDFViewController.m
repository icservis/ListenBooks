//
//  PDFViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 30.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "AdobePDFViewController.h"
#import "ProgressWindowController.h"
#import "KFToolbar.h"
#import "KFToolbarItem.h"
#import "AdobePDFView.h"
#import "Book.h"
#import "Bookmark.h"
#import "BookBookmarksView.h"
#import "BookSearchView.h"
#import "SpinnerSearchField.h"

@interface AdobePDFViewController () <NSSplitViewDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *sideBarView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *pageLabel;
@property (weak) IBOutlet NSProgressIndicator *progressIndicatior;
@property (weak) IBOutlet AdobePDFView *pdfView;
@property (weak) IBOutlet NSOutlineView *outlineView;

@property (weak) IBOutlet NSTabView *sideBarTabView;
@property (weak) IBOutlet NSTabViewItem *sideBarTabViewBookmarksTab;
@property (weak) IBOutlet BookBookmarksView *bookBookmarksView;
@property (weak) IBOutlet NSTabViewItem *sideBarTabViewSearchTab;
@property (weak) IBOutlet BookSearchView *bookSearchView;
@property (weak) IBOutlet SpinnerSearchField *bookSearchField;
- (IBAction)searchAction:(id)sender;

@property (weak) IBOutlet NSLayoutConstraint *toolBarHeightConstraint;

@property (nonatomic, strong) PDFOutline* outline;

@end

@implementation AdobePDFViewController {
        CGFloat _toolBarFrameHeight;
        CGFloat _sideBarViewWidth;
}

@synthesize book = _book;
@synthesize bookmark = _bookmark;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    AppDelegate* appDelegate = [self appDelegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:appDelegate.managedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pageChanged:)
                                                 name:PDFViewPageChangedNotification
                                               object:self.pdfView];
    
    _toolBarFrameHeight = self.toolBarView.frame.size.height;
    _sideBarViewWidth = self.sideBarView.frame.size.width;
    
    [self.pageLabel setStringValue:@""];
    [self.pdfView setDelegate:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (AppDelegate*)appDelegate
{
    return (AppDelegate*)[[NSApplication sharedApplication] delegate];
}

#pragma mark - Setters

- (void)setBook:(Book *)book
{
    if (![book isEqual:_book]) {
        _bookmark = nil;
        [self resetPageView];
        [self loadPageContent:book];
    }
    _book = book;
    [self.bookBookmarksView reloadData];
}

- (Book*)book
{
    return _book;
}

- (void)setBookmark:(Bookmark *)bookmark
{
    [self loadBookmark:bookmark];
    _bookmark = bookmark;
}

- (Bookmark*)bookmark
{
    return _bookmark;
}

- (PDFOutline*)outline
{
    if (_outline == nil) {
        _outline = [[self.pdfView document] outlineRoot];
    }
    return _outline;
}

#pragma mark - Load Content

- (void)resetPageView
{
    DDLogVerbose(@"resetPageView");
}

- (void)loadPageContent:(Book*)book
{
    DDLogVerbose(@"loadPageContent");
    [self.progressIndicatior startAnimation:nil];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do a taks in the background
        
        DDLogVerbose(@"self.book.fileUrl: %@", book.fileUrl);
        
        PDFDocument* pdfDoc = [[PDFDocument alloc] initWithURL: book.fileUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            
            [self.pdfView setDocument: pdfDoc];
            
            if (self.outline == nil) {
                if ([self isSideBarOpened]) {
                    [self toggleSideBar];
                }
            } else {
                [self.pageLabel setStringValue:[NSString stringWithFormat:@"%@: %i / %li", NSLocalizedString(@"Page", nil), 1, [[self.pdfView document] pageCount]]];
                [self.outlineView reloadData];
            }
            
            [self.progressIndicatior stopAnimation:nil];
        });
    });
}
- (void)loadBookmark:(Bookmark*)bookmark
{
    DDLogDebug(@"loadBookmark: %@", bookmark.title);
}

#pragma mark - TabViewControllerProtocol

- (void)toggleToolBar
{
    if ([[self.toolBarHeightConstraint animator] constant] > 0) {
        [[self.toolBarHeightConstraint animator] setConstant:0];
    } else {
        [[self.toolBarHeightConstraint animator] setConstant:_toolBarFrameHeight];
    }
}

- (BOOL)isToolBarOpened
{
    return (self.sideBarView.frame.size.height > 0) ? YES:NO;
}

- (void)toggleSideBar
{
    [self.splitView adjustSubviews];
    if ([self.splitView isSubviewCollapsed:self.sideBarView] == NO) {
        [self.splitView setPosition:0 ofDividerAtIndex:0];
    } else {
        [self.splitView setPosition:_sideBarViewWidth ofDividerAtIndex:0];
    }
}

- (BOOL)isSideBarOpened
{
    return ![self.splitView isSubviewCollapsed:self.sideBarView];
}

- (IBAction)add:(id)sender
{
    
}

- (IBAction)edit:(id)sender
{
    
}

- (IBAction)remove:(id)sender
{
    
}

- (IBAction)export:(id)sender
{
    
}

#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    if ([splitView isEqualTo:self.splitView] && [subview isEqualTo:self.contentView]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex {
    BOOL result = NO;
    if ([splitView isEqualTo:self.splitView]) {
        result = YES;
    }
    return result;
}

- (void)splitViewDidResizeSubviews:(NSNotification *)notification
{
    NSSplitView* splitView = (NSSplitView*)notification.object;
    
    if ([splitView isEqualTo:self.splitView]) {
        AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        KFToolbarItem *bookmarksItem = appDelegate.toolBar.leftItems[2];
        if ([self.splitView isSubviewCollapsed:self.sideBarView] == NO) {
            _sideBarViewWidth = self.sideBarView.frame.size.width;
            bookmarksItem.state = NSOnState;
        } else {
            bookmarksItem.state = NSOffState;
        }
    }
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    if ([splitView isEqualTo:self.splitView]) {
        CGFloat max = self.splitView.frame.size.width/3;
        if (proposedMaximumPosition > max) {
            proposedMaximumPosition = max;
        }
        return proposedMaximumPosition;
    }
    return CGFLOAT_MAX;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    if ([splitView isEqualTo:self.splitView]) {
        CGFloat min = self.splitView.frame.size.width/5;
        if (proposedMinimumPosition < min) {
            proposedMinimumPosition = min;
        }
        return proposedMinimumPosition;
    }
    return 0;
}

#pragma mark - OutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSInteger numberOfChildrenOfItem = 0;
    if (item == nil) {
        if (self.outline)
            numberOfChildrenOfItem = [self.outline numberOfChildren];
        else
            numberOfChildrenOfItem = 0;
    } else {
        numberOfChildrenOfItem = [(PDFOutline *)item numberOfChildren];
    }
    
    return numberOfChildrenOfItem;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        
        if (self.outline) {
            return [self.outline childAtIndex:index];
        } else {
            return nil;
        }
        
    } else {
        return [(PDFOutline *)item childAtIndex: index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if (item == nil) {
        if (self.outline)
            return ([self.outline numberOfChildren] > 0);
        else
            return NO;
    } else {
        return ([(PDFOutline *)item numberOfChildren] > 0);
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return [(PDFOutline *)item label];
}

- (IBAction) takeDestinationFromOutline: (id) sender
{
    PDFDestination* destination = [[sender itemAtRow:[sender selectedRow]] destination];
    [self.pdfView goToDestination: destination];
}

#pragma mark - Notifications

- (void)contextDidChange:(NSNotification*)notification
{
    
}

- (void) pageChanged: (NSNotification *) notification
{
    NSUInteger    newPageIndex;
    NSInteger     numRows;
    NSInteger     i;
    NSInteger     newlySelectedRow;
    
    if (self.outline == nil) return;
    
    newPageIndex = [[self.pdfView document] indexForPage: [self.pdfView currentPage]];
    
    [self.pageLabel setStringValue:[NSString stringWithFormat:@"%@: %li / %li", NSLocalizedString(@"Page", nil), newPageIndex+1, [[self.pdfView document] pageCount]]];
    
    
    // Walk outline view looking for best firstpage number match.
    newlySelectedRow = -1;
    numRows = [self.outlineView numberOfRows];
    for (i = 0; i < numRows; i++)
    {
        PDFOutline  *outlineItem;
        
        // Get the destination of the given row....
        outlineItem = (PDFOutline *)[self.outlineView itemAtRow: i];
        
        if ([[self.pdfView document] indexForPage:
             [[outlineItem destination] page]] == newPageIndex)
        {
            newlySelectedRow = i;
            NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:newlySelectedRow];
            [self.outlineView selectRowIndexes:indexSet byExtendingSelection:NO];
            break;
        }
        else if ([[self.pdfView document] indexForPage:
                  [[outlineItem destination] page]] > newPageIndex)
        {
            newlySelectedRow = i - 1;
            NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:newlySelectedRow];
            [self.outlineView selectRowIndexes:indexSet byExtendingSelection:NO];
            break;
        }
    }
    
    if (newlySelectedRow != -1)// 4
        [self.outlineView scrollRowToVisible: newlySelectedRow];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    [self takeDestinationFromOutline:notification.object];
}

#pragma mark - IBActions

- (IBAction)searchAction:(id)sender
{
    
}

@end
