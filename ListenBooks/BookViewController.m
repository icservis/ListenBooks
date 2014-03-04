//
//  BookViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "BookViewController.h"
#import "BookPageViewController.h"
#import "TabBarControllerProtocol.h"
#import "NSTextView+Extensions.h"
#import "Book.h"
#import "Bookmark.h"
#import "Page.h"
#import "Paragraph.h"
#import "ProgressWindowController.h"
#import "KFToolbar.h"
#import "KFToolbarItem.h"
#import "FontControl.h"
#import "VoiceControl.h"
#import "ThemeControl.h"
#import "BookBookmarksView.h"
#import "BookSearchView.h"
#import "BookPageView.h"
#import "SearchResult.h"
#import "SpinnerSearchField.h"

static NSInteger const ProposedLeght = 42;

@interface BookViewController () <NSTabViewDelegate>

@property (strong) id initialSelectedObject;
@property (strong) IBOutlet NSPageController *pageController;
@property (strong, nonatomic) IBOutlet FontControl* fontControl;
@property (strong, nonatomic) IBOutlet VoiceControl* voiceControl;
@property (strong, nonatomic) IBOutlet ThemeControl *themeControl;

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *sideBarView;
@property (weak) IBOutlet NSTabView *sideBarTabView;
@property (weak) IBOutlet NSTabViewItem *sideBarTabViewBookmarksTab;
@property (weak) IBOutlet BookBookmarksView *bookBookmarksView;
@property (weak) IBOutlet NSTabViewItem *sideBarTabViewSearchTab;
@property (weak) IBOutlet BookSearchView *bookSearchView;
@property (weak) IBOutlet SpinnerSearchField *bookSearchField;
- (IBAction)searchAction:(id)sender;

#pragma mark - Internal Outlets

@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSLayoutConstraint *toolBarHeightConstraint;
@property (weak) IBOutlet NSTextField *pageLabel;
@property (weak) IBOutlet BookPageView *pageView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

#pragma mark - Font Panel

@property (weak) IBOutlet NSButton *fontPanelButton;
- (IBAction)fontPanelButtonClicked:(id)sender;
@property (weak) IBOutlet NSPanel *fontPanel;
@property (weak) IBOutlet NSSlider *fontSizeSlider;
- (IBAction)fontSizeSliderChange:(id)sender;
@property (weak) IBOutlet NSPopUpButton *fontNamePopup;
- (IBAction)fontNamePopupChanged:(id)sender;

#pragma mark - Themes Panel

@property (weak) IBOutlet NSButton *themePanelButton;
- (IBAction)themePanelButtonClicked:(id)sender;
@property (strong) IBOutlet NSPanel *themePanel;
@property (weak) IBOutlet NSSegmentedControl *themeSegmentedControl;
- (IBAction)themeSegmentedControlDidChange:(id)sender;

#pragma mark - Voice Panel

@property (weak) IBOutlet NSButton *voicePanelButton;
- (IBAction)voicePanelButtonClicked:(id)sender;
@property (strong) IBOutlet NSPanel *voicePanel;
@property (weak) IBOutlet NSSlider *voiceSpeedSlider;
- (IBAction)voiceSpeedSliderChanged:(id)sender;
@property (weak) IBOutlet NSPopUpButton *voiceNamePopup;
- (IBAction)voiceNamePopupChanged:(id)sender;

@end

@implementation BookViewController {
    CGFloat _toolBarFrameHeight;
    CGFloat _sideBarViewWidth;
    NSMutableArray* searchResults;
}

@synthesize book = _book;
@synthesize bookmark = _bookmark;
@synthesize searchResult = _searchResult;

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
    
    _toolBarFrameHeight = self.toolBarView.frame.size.height;
    _sideBarViewWidth = self.sideBarView.frame.size.width;
    
    [self.bookBookmarksView setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]]];
    [self.bookSearchView setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pageIndex" ascending:YES]]];
    [self.pageView setDelegate:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.initialSelectedObject = nil;
}

- (AppDelegate*)appDelegate
{
    return (AppDelegate*)[[NSApplication sharedApplication] delegate];
}

#pragma mark - Notifications

- (void)contextDidChange:(NSNotification*)notification
{
    [self.bookBookmarksView reloadData];
}

- (IBAction)fontSizeSliderChange:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FontSizeDidChangeNotificaton object:sender];
}

- (IBAction)fontNamePopupChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FontNameDidChangeNotificaton object:sender];
}

- (IBAction)themeSegmentedControlDidChange:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ThemeDidChangeNotificaton object:sender];
}

- (IBAction)voiceSpeedSliderChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VoiceSpeedDidChangeNotificaton object:sender];
}

- (IBAction)voiceNamePopupChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VoiceNameDidChangeNotificaton object:sender];
}

#pragma mark - Setters

- (void)setBook:(Book *)book
{
    DDLogVerbose(@"self: %@", self);
    if (![book isEqual:_book]) {
        _bookmark = nil;
        [self resetPageView];
        if ([book.pages count] > 0) {
            [self loadPageContent:book];
        }
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
    if ([self.pageController.arrangedObjects count] > 0) {
        [self loadBookmark:bookmark];
    }
    _bookmark = bookmark;
}

- (Bookmark*)bookmark
{
    return _bookmark;
}

- (void)setSearchResult:(SearchResult *)searchResult
{
    if ([self.pageController.arrangedObjects count] > 0) {
        [self loadSearchResult:searchResult];
    }
    _searchResult = searchResult;
}

- (SearchResult*)searchResult
{
    return _searchResult;
}

- (FontControl*)fontControl
{
    if (_fontControl == nil) {
        _fontControl = [[FontControl alloc] init];
    }
    return _fontControl;
}

- (VoiceControl*)voiceControl
{
    if (_voiceControl == nil) {
        _voiceControl = [[VoiceControl alloc] init];
    }
    return _voiceControl;
}

- (ThemeControl*)themeControl
{
    if (_themeControl == nil) {
        _themeControl = [[ThemeControl alloc] init];
    }
    return _themeControl;
}

#pragma mark - Actions

- (IBAction)fontPanelButtonClicked:(id)sender
{
    if ([self.fontPanel isVisible]) {
        [self.fontPanel close];
    } else {
        [self.fontPanel makeKeyAndOrderFront:sender];
    }
}

- (IBAction)themePanelButtonClicked:(id)sender
{
    if ([self.themePanel isVisible]) {
        [self.themePanel close];
    } else {
        [self.themePanel makeKeyAndOrderFront:sender];
    }
}

- (IBAction)voicePanelButtonClicked:(id)sender
{
    if ([self.voicePanel isVisible]) {
        [self.voicePanel close];
    } else {
        [self.voicePanel makeKeyAndOrderFront:sender];
    }
}

- (void)resetPageView
{
    DDLogVerbose(@"resetPageView");
    
    self.initialSelectedObject = nil;
    self.pageController.arrangedObjects = nil;
    [[self.pageView subviews] enumerateObjectsUsingBlock:^(NSView* subView, NSUInteger idx, BOOL *stop) {
        if (![subView isKindOfClass:[NSProgressIndicator class]]) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)loadPageContent:(Book*)book
{
    DDLogInfo(@"loadBookPageControllerContent");
    
    [self.progressIndicator startAnimation:nil];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do a taks in the background
        __block NSMutableArray* spinedData = [[NSMutableArray alloc] init];
        [book.pages enumerateObjectsUsingBlock:^(Page* page, NSUInteger idx, BOOL *stop) {
            [spinedData addObject:page.data];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            [self.pageController setArrangedObjects:spinedData];
            if (self.bookmark != nil) {
                [self loadBookmark:self.bookmark];
            }
            [self.progressIndicator stopAnimation:nil];
        });
    });
}

- (void)loadBookmark:(Bookmark*)bookmark
{
    DDLogDebug(@"bookmark: %@", bookmark.title);
    
    NSInteger pageIndex = [bookmark.pageIndex integerValue];
    if (pageIndex >= 0 && pageIndex < [self.pageController.arrangedObjects count]) {
        bookmark.timestamp = [NSDate date];
        self.pageController.selectedIndex = pageIndex;
        
        BookPageViewController* bookPageViewController = (BookPageViewController*)self.pageController.selectedViewController;
        NSTextView* textView = bookPageViewController.textView;
        NSRange range = NSMakeRange([bookmark.rangeLocation integerValue], [bookmark.rangeLength integerValue]);
        textView.selectedRanges = @[[NSValue valueWithRange:range]];
        [textView scrollRangeToVisible:range];
    }
}

- (void)loadSearchResult:(SearchResult*)searchResult
{
    DDLogDebug(@"searchResult: %@", searchResult.title);
    if (searchResult.pageIndex >= 0 && searchResult.pageIndex < [self.pageController.arrangedObjects count]) {
        self.pageController.selectedIndex = searchResult.pageIndex;
        BookPageViewController* bookPageViewController = (BookPageViewController*)self.pageController.selectedViewController;
        NSTextView* textView = bookPageViewController.textView;
        textView.selectedRanges = @[[NSValue valueWithRange:searchResult.range]];
        [textView scrollRangeToVisible:searchResult.range];
    }
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
    return (self.toolBarView.frame.size.height > 0) ? YES:NO;
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
    DDLogVerbose(@"sender: %@", sender);
    
    [[[self appDelegate] undoManager] beginUndoGrouping];
    [[[self appDelegate] undoManager] setActionName:NSLocalizedString(@"New Bookmark", nil)];
    
    BookPageViewController* selectedBookPageViewController = (BookPageViewController*)self.pageController.selectedViewController;
    NSTextView* selectedTextView = selectedBookPageViewController.textView;
    [selectedTextView.selectedRanges enumerateObjectsUsingBlock:^(NSValue* rangeObject, NSUInteger idx, BOOL *stop) {
        NSRange range = [rangeObject rangeValue];
        
        Bookmark* bookmark = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Bookmark class]) inManagedObjectContext:self.managedObjectContext];
        bookmark.book = self.book;
        bookmark.created = [NSDate date];
        NSInteger index = self.pageController.selectedIndex;
        Page* page = [self.book.pages objectAtIndex:index];
        bookmark.page = page;
        bookmark.pageIndex = [NSNumber numberWithInteger:index];
        NSString* title;
        
        if (range.location != NSNotFound && range.location != [[page.data string] length]) {
            bookmark.rangeLocation = [NSNumber numberWithInteger:range.location];
            bookmark.rangeLength = [NSNumber numberWithInteger:range.length];
            if (range.length > 0) {
                title = [[page.data string] substringWithRange:range];
            } else {
                if (range.location + ProposedLeght < [[page.data string] length]) {
                    range.length = ProposedLeght;
                } else {
                    range.length = [[page.data string] length] - range.location;
                }
                
                title = [[page.data string] substringWithRange:range];
            }
            
        } else {
            NSRange range = NSMakeRange(0, ProposedLeght);
            title = [[page.data string] substringWithRange:range];
        }
        title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([title length] == 0){
            title = NSLocalizedString(@"Unnamed Bookmark", nil);
        }
        bookmark.title = title;
    }];
    
    [[[self appDelegate] undoManager] endUndoGrouping];
}

- (IBAction)edit:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
}

- (IBAction)remove:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    
    [[[self appDelegate] undoManager] beginUndoGrouping];
    [[[self appDelegate] undoManager] setActionName:NSLocalizedString(@"Delete Bookmark", nil)];
    
    [[self.bookBookmarksView selectedRowIndexes] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        Bookmark* bookmark = [self tableView:self.bookBookmarksView objectValueForTableColumn:nil row:idx];
        [self.managedObjectContext deleteObject:bookmark];
    }];
    
    [[[self appDelegate] undoManager] endUndoGrouping];
}

- (IBAction)export:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    [[self appDelegate] exportBook:self.book];
}

#pragma mark - PageControllerDelegate

- (NSString *)pageController:(NSPageController *)pageController identifierForObject:(id)object
{
    NSString *identifier = @"BookPage";
    return identifier;
}

- (NSViewController *)pageController:(NSPageController *)pageController viewControllerForIdentifier:(NSString *)identifier
{
    BookPageViewController* bookPageViewController = [[BookPageViewController alloc] initWithNibName:@"BookPageViewController" bundle:nil];
    
    return bookPageViewController;
}

-(void)pageController:(NSPageController *)pageController prepareViewController:(NSViewController *)viewController withObject:(id)object
{
    // viewControllers may be reused... make sure to reset important stuff like the current magnification factor.
    
    self.pageLabel.stringValue = [NSString stringWithFormat:@"%@: %li / %li", NSLocalizedString(@"Page", nil), (long)pageController.selectedIndex+1, [self.pageController.arrangedObjects count]];
    
    // Since we implement this delegate method, we are reponsible for setting the representedObject.
    viewController.representedObject = object;
    
    // Normally, we want to reset the magnification value to 1 as the user swipes to other images. However if the user cancels the swipe, we want to leave the original magnificaiton and scroll position alone.
    BookPageViewController* bookPageViewController = (BookPageViewController*)viewController;
    
    BOOL isRepreparingOriginalView = (self.initialSelectedObject && self.initialSelectedObject == object) ? YES : NO;
    if (!isRepreparingOriginalView) {
        NSScrollView* scrollView = (NSScrollView*)bookPageViewController.view;
        scrollView.magnification = 1;
        
        [bookPageViewController.textView changeFontSize:[self.book.fontSizeDelta doubleValue]];
        [bookPageViewController.textView setFontFamily:self.book.fontName];
        NSDictionary* selectedTheme = [[self.themeControl arrangedObjects] objectAtIndex:[self.book.themeIndex integerValue]];
        [bookPageViewController.textView setBackgroundColor:[selectedTheme valueForKey:@"BackgroundColor"]];
        [bookPageViewController.textView setForegroundColor:[selectedTheme valueForKey:@"ForegroundColor"]];
    }
}

- (void)pageControllerWillStartLiveTransition:(NSPageController *)pageController
{
    // Remember the initial selected object so we can determine when a cancel occurred.
    self.initialSelectedObject = [pageController.arrangedObjects objectAtIndex:pageController.selectedIndex];
}

- (void)pageControllerDidEndLiveTransition:(NSPageController *)pageController {
    [pageController completeTransition];
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
        AppDelegate* appDelegate = [self appDelegate];
        KFToolbarItem *bookmarksItem = appDelegate.toolBar.leftItems[2];
        if ([self.splitView isSubviewCollapsed:self.sideBarView] == NO) {
            _sideBarViewWidth = self.sideBarView.frame.size.width;
            bookmarksItem.state = NSOnState;
        } else {
            bookmarksItem.state = NSOffState;
        }
    }
}

#pragma mark - NSTabViewDelegate

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    DDLogVerbose(@"tabViewItem: %@", tabViewItem);
}


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if ([tableView isEqualTo:self.bookBookmarksView]) {
        return [self.book.bookmarks count];
    }
    if ([tableView isEqualTo:self.bookSearchView]) {
        return [searchResults count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([tableView isEqualTo:self.bookBookmarksView]) {
        NSArray* bookmarks = [[self.book.bookmarks allObjects] sortedArrayUsingDescriptors:[tableView sortDescriptors]];
        return bookmarks[row];
    }
    if ([tableView isEqualTo:self.bookSearchView]) {
        [searchResults sortUsingDescriptors:[tableView sortDescriptors]];
        return searchResults[row];
    }
    return nil;
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    [tableView reloadData];
}

#pragma mark - NSSearchField Delegate

- (IBAction)searchAction:(id)sender
{
    NSSearchField* searchField = (NSSearchField*)sender;
    
    NSString* subString = [searchField stringValue];
    DDLogDebug(@"sender: %@", [searchField stringValue]);
    searchResults = [NSMutableArray array];
    if ([subString length] == 0) {
        [self.bookSearchView reloadData];
        return;
    }
    
    [self.bookSearchField showProgressIndicator];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do a taks in the background
        
        [self.book.pages enumerateObjectsUsingBlock:^(Page* page, NSUInteger idx, BOOL *stop) {
            
            NSString* string = [page.data string];
            NSRange searchRange = NSMakeRange(0,string.length);
            NSRange foundRange;
            while (searchRange.location < string.length) {
                searchRange.length = string.length - searchRange.location;
                foundRange = [string rangeOfString:subString options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch range:searchRange];
                if (foundRange.location != NSNotFound) {
                    // found an occurrence of the substring! do stuff here
                    SearchResult* searchResult = [[SearchResult alloc] init];
                    
                    NSMutableAttributedString* title;
                    
                    NSInteger location = (foundRange.location > ProposedLeght/3) ? foundRange.location - ProposedLeght/3: 0;
                    NSInteger suggestedLenght = ([string length] - location > ProposedLeght) ? ProposedLeght : [string length] - location;
                    
                    NSRange extendedRange = NSMakeRange(location, suggestedLenght);
                    DDLogVerbose(@"extendedRange: %@", NSStringFromRange(extendedRange));
                    
                    title = [[NSMutableAttributedString alloc] initWithString:[string substringWithRange:extendedRange] attributes:@{NSForegroundColorAttributeName:[NSColor lightGrayColor]}];
                    
                    NSRange boldedRange = NSMakeRange(foundRange.location-extendedRange.location, foundRange.length);
                    
                    [title beginEditing];
                    [title addAttribute:NSForegroundColorAttributeName value:[NSColor blackColor] range:boldedRange];
                    [title endEditing];
                    
                    searchResult.title = title;
                    searchResult.page = page;
                    NSInteger pageIndex = [self.book.pages indexOfObject:page];
                    searchResult.pageIndex = pageIndex;
                    searchResult.range = foundRange;
                    [searchResults addObject:searchResult];
                    
                    searchRange.location = foundRange.location + foundRange.length;
                } else {
                    // no more substring to find
                    break;
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            [self.bookSearchView reloadData];
            [self.bookSearchField hideProgressIndicator];
        });
    });
}
@end
