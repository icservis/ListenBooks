//
//  PDFViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 30.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "BookPDFViewController.h"
#import "ProgressWindowController.h"
#import "KFToolbar.h"
#import "KFToolbarItem.h"
#import "BookPDFView.h"
#import "Book.h"

@interface BookPDFViewController () <NSSplitViewDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *sideBarView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *pageLabel;
@property (weak) IBOutlet NSProgressIndicator *progressIndicatior;
@property (weak) IBOutlet BookPDFView *pdfView;
@property (weak) IBOutlet NSOutlineView *outlineView;

@property (weak) IBOutlet NSLayoutConstraint *toolBarHeightConstraint;

@property (nonatomic, strong) PDFOutline* outline;

@end

@implementation BookPDFViewController {
        CGFloat _toolBarFrameHeight;
        CGFloat _sideBarViewWidth;
}

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
    [self loadPageContent];
    
    [self.pdfView setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pageChanged:)
                                                 name:PDFViewPageChangedNotification
                                               object:self.pdfView];
    
    _toolBarFrameHeight = self.toolBarView.frame.size.height;
    _sideBarViewWidth = self.sideBarView.frame.size.width;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadPageContent
{
    [self.progressIndicatior startAnimation:nil];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do a taks in the background
        
        DDLogVerbose(@"self.book.fileUrl: %@", self.book.fileUrl);
        
        PDFDocument* pdfDoc = [[PDFDocument alloc] initWithURL: self.book.fileUrl];
        
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

- (PDFOutline*)outline
{
    if (_outline == nil) {
        _outline = [[self.pdfView document] outlineRoot];
    }
    return _outline;
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
    DDLogVerbose(@"destination: %@", destination);
    [self.pdfView goToDestination: destination];
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
    numRows = [_outlineView numberOfRows];
    for (i = 0; i < numRows; i++)// 3
    {
        PDFOutline  *outlineItem;
        
        // Get the destination of the given row....
        outlineItem = (PDFOutline *)[_outlineView itemAtRow: i];
        
        if ([[_pdfView document] indexForPage:
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
    DDLogVerbose(@"notification: %@", notification);
    [self takeDestinationFromOutline:notification.object];
}

@end
