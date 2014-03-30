//
//  PDFViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 30.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "PDFViewController.h"
#import "ProgressWindowController.h"
#import "KFToolbar.h"
#import "KFToolbarItem.h"
#import "BookPDFView.h"

@interface PDFViewController () 

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *sideBarView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *pageLabel;
@property (weak) IBOutlet NSProgressIndicator *progressIndicatior;
@property (weak) IBOutlet BookPDFView *pdfView;

@property (weak) IBOutlet NSLayoutConstraint *toolBarHeightConstraint;

@end

@implementation PDFViewController {
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
    
    _toolBarFrameHeight = self.toolBarView.frame.size.height;
    _sideBarViewWidth = self.sideBarView.frame.size.width;
}
- (void)loadPageContent
{
    DDLogVerbose(@"setupPdfPageControllerContent");
    NSURL *dirURL = [[NSBundle mainBundle] resourceURL];
    NSURL *pdfURL = [dirURL URLByAppendingPathComponent:@"MobileHIG.pdf"];
    DDLogVerbose(@"pdfURL: %@", pdfURL);
    
    // load all the necessary image files by enumerating through the bundle's Resources folder,
    // this will only load images of type "kUTTypeImage"
    //
    [self.progressIndicatior startAnimation:nil];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do a taks in the background
        
        PDFDocument* pdfDoc = [[PDFDocument alloc] initWithURL: pdfURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            
            [self.pdfView setDocument: pdfDoc];
            
            [self.progressIndicatior stopAnimation:nil];
        });
    });
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

@end
