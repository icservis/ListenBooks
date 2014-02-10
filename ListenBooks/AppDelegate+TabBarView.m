//
//  CFGAppDelegate+TabBarView.m
//  TimeFrogMac
//
//  Created by Libor Kučera on 16.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+TabBarView.h"
#import <MMTabBarView/MMTabBarView.h>
#import <MMTabBarView/MMTabStyle.h>

@implementation AppDelegate (TabBarView)

#pragma mark - TabBar Config

- (void)configStyle:(id)sender {
	[self.tabBar setStyleNamed:[sender titleOfSelectedItem]];
}

- (void)configOnlyShowCloseOnHover:(id)sender {
	[self.tabBar setOnlyShowCloseOnHover:[sender state]];
}

- (void)configCanCloseOnlyTab:(id)sender {
	[self.tabBar setCanCloseOnlyTab:[sender state]];
}

- (void)configDisableTabClose:(id)sender {
	[self.tabBar setDisableTabClose:[sender state]];
}

- (void)configAllowBackgroundClosing:(id)sender {
	[self.tabBar setAllowsBackgroundTabClosing:[sender state]];
}

- (void)configHideForSingleTab:(id)sender {
	[self.tabBar setHideForSingleTab:[sender state]];
}

- (void)configAddTabButton:(id)sender {
	[self.tabBar setShowAddTabButton:[sender state]];
}

- (void)configTabMinWidth:(id)sender {
	if ([self.tabBar buttonOptimumWidth] < [sender integerValue]) {
		[self.tabBar setButtonMinWidth:[self.tabBar buttonOptimumWidth]];
		[sender setIntegerValue:[self.tabBar buttonOptimumWidth]];
		return;
	}
    
	[self.tabBar setButtonMinWidth:[sender integerValue]];
}

- (void)configTabMaxWidth:(id)sender {
	if ([self.tabBar buttonOptimumWidth] > [sender integerValue]) {
		[self.tabBar setButtonMaxWidth:[self.tabBar buttonOptimumWidth]];
		[sender setIntegerValue:[self.tabBar buttonOptimumWidth]];
		return;
	}
    
	[self.tabBar setButtonMaxWidth:[sender integerValue]];
}

- (void)configTabOptimumWidth:(id)sender {
	if ([self.tabBar buttonMaxWidth] < [sender integerValue]) {
		[self.tabBar setButtonOptimumWidth:[self.tabBar buttonMaxWidth]];
		[sender setIntegerValue:[self.tabBar buttonMaxWidth]];
		return;
	}
    
	if ([self.tabBar buttonMinWidth] > [sender integerValue]) {
		[self.tabBar setButtonOptimumWidth:[self.tabBar buttonMinWidth]];
		[sender setIntegerValue:[self.tabBar buttonMinWidth]];
		return;
	}
    
	[self.tabBar setButtonOptimumWidth:[sender integerValue]];
}

- (void)configTabSizeToFit:(id)sender {
	[self.tabBar setSizeButtonsToFit:[sender state]];
}

- (void)configTearOffStyle:(id)sender {
	[self.tabBar setTearOffStyle:([sender indexOfSelectedItem] == 0) ? MMTabBarTearOffAlphaWindow : MMTabBarTearOffMiniwindow];
}

- (void)configUseOverflowMenu:(id)sender {
	[self.tabBar setUseOverflowMenu:[sender state]];
}

- (void)configAutomaticallyAnimates:(id)sender {
	[self.tabBar setAutomaticallyAnimates:[sender state]];
}

- (void)configAllowsScrubbing:(id)sender {
	[self.tabBar setAllowsScrubbing:[sender state]];
}

- (void)addNewTabToTabView:(NSTabView *)aTabView {
    DDLogVerbose(@"addNewTabToTabView");
    [self addNewTab:aTabView];
}

#pragma mark - TabView Delegate

- (void)tabView:(NSTabView *)aTabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    DDLogVerbose(@"tabViewItem: %@", [tabViewItem label]);
}

- (void)tabView:(NSTabView *)aTabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	// need to update bound values to match the selected tab
    DDLogVerbose(@"tabViewItem: %@", [tabViewItem label]);
    if ([[tabViewItem identifier] respondsToSelector:@selector(title)]) {
        [self.tabField setStringValue:[[tabViewItem identifier] title]];
    }
    //self.window.title = [[tabViewItem identifier] title];
    [self updateToolBarContentForTabView:tabViewItem];
}

- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)tabView
{
    NSUInteger tabsCount = [[tabView tabViewItems] count];
    DDLogVerbose(@"tabViewDidChangeNumberOfTabViewItems: %lu", (unsigned long)tabsCount);
    DDLogVerbose(@"tabViewControllers: %@", self.tabViewControllers);
    
    if (tabsCount > 1) {
        [self.menuItemCloseTab setEnabled:YES];
    } else {
        [self.menuItemCloseTab setEnabled:NO];
    }
}

- (BOOL)tabView:(NSTabView *)aTabView shouldCloseTabViewItem:(NSTabViewItem *)tabViewItem {
	return YES;
}

- (void)tabView:(NSTabView *)aTabView didCloseTabViewItem:(NSTabViewItem *)tabViewItem {
	DDLogVerbose(@"tabViewItem: %@", [tabViewItem label]);
}

- (void)tabView:(NSTabView *)aTabView didDetachTabViewItem:(NSTabViewItem *)tabViewItem
{
    DDLogVerbose(@"tabViewItem: %@", [tabViewItem label]);
    
}

- (void)tabView:(NSTabView *)aTabView didMoveTabViewItem:(NSTabViewItem *)tabViewItem toIndex:(NSUInteger)index
{
    DDLogVerbose(@"tab view did move tab view item %@ to index:%ld",[tabViewItem label],index);
}

- (NSArray *)allowedDraggedTypesForTabView:(NSTabView *)aTabView {
	return [NSArray arrayWithObjects:NSFilenamesPboardType, NSStringPboardType, nil];
}

- (BOOL)tabView:(NSTabView *)aTabView acceptedDraggingInfo:(id <NSDraggingInfo>)draggingInfo onTabViewItem:(NSTabViewItem *)tabViewItem {
	NSLog(@"acceptedDraggingInfo: %@ onTabViewItem: %@", [[draggingInfo draggingPasteboard] stringForType:[[[draggingInfo draggingPasteboard] types] objectAtIndex:0]], [tabViewItem label]);
    return YES;
}

- (NSMenu *)tabView:(NSTabView *)aTabView menuForTabViewItem:(NSTabViewItem *)tabViewItem {
	DDLogVerbose(@"menuForTabViewItem: %@", [tabViewItem label]);
	return nil;
}

- (BOOL)tabView:(NSTabView *)aTabView shouldAllowTabViewItem:(NSTabViewItem *)tabViewItem toLeaveTabBarView:(MMTabBarView *)tabBarView {
    return NO;
}

- (BOOL)tabView:(NSTabView*)aTabView shouldDragTabViewItem:(NSTabViewItem *)tabViewItem inTabBarView:(MMTabBarView *)tabBarView {
	return YES;
}

- (NSDragOperation)tabView:(NSTabView*)aTabView validateDrop:(id<NSDraggingInfo>)sender proposedItem:(NSTabViewItem *)tabViewItem proposedIndex:(NSUInteger)proposedIndex inTabBarView:(MMTabBarView *)tabBarView {
    
    return NSDragOperationMove;
}

- (NSDragOperation)tabView:(NSTabView *)aTabView validateSlideOfProposedItem:(NSTabViewItem *)tabViewItem proposedIndex:(NSUInteger)proposedIndex inTabBarView:(MMTabBarView *)tabBarView {
    
    return NSDragOperationMove;
}

- (void)tabView:(NSTabView*)aTabView didDropTabViewItem:(NSTabViewItem *)tabViewItem inTabBarView:(MMTabBarView *)tabBarView {
	DDLogVerbose(@"didDropTabViewItem: %@ inTabBarView: %@", [tabViewItem label], tabBarView);
}

- (NSImage *)tabView:(NSTabView *)aTabView imageForTabViewItem:(NSTabViewItem *)tabViewItem offset:(NSSize *)offset styleMask:(NSUInteger *)styleMask {
	// grabs whole window image
	NSImage *viewImage = [[NSImage alloc] init];
	NSRect contentFrame = [[[self window] contentView] frame];
	[[[self window] contentView] lockFocus];
	NSBitmapImageRep *viewRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:contentFrame];
	[viewImage addRepresentation:viewRep];
	[[[self window] contentView] unlockFocus];
    
	// grabs snapshot of dragged tabViewItem's view (represents content being dragged)
	NSView *viewForImage = [tabViewItem view];
	NSRect viewRect = [viewForImage frame];
	NSImage *tabViewImage = [[NSImage alloc] initWithSize:viewRect.size];
	[tabViewImage lockFocus];
	[viewForImage drawRect:[viewForImage bounds]];
	[tabViewImage unlockFocus];
    
	[viewImage lockFocus];
	NSPoint tabOrigin = [self.tabView frame].origin;
	tabOrigin.x += 10;
	tabOrigin.y += kTabBarFrameHeight/2+2;
    [tabViewImage drawAtPoint:tabOrigin fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    [tabViewImage compositeToPoint:tabOrigin operation:NSCompositeSourceOver];
	[viewImage unlockFocus];
    
    MMTabBarView *tabBarView = (MMTabBarView *)[aTabView delegate];
    
	//draw over where the tab bar would usually be
	NSRect tabFrame = [self.tabBar frame];
	[viewImage lockFocus];
	[[NSColor windowBackgroundColor] set];
	NSRectFill(tabFrame);
	//draw the background flipped, which is actually the right way up
	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform scaleXBy:1.0 yBy:-1.0];
	[transform concat];
	tabFrame.origin.y = -tabFrame.origin.y - tabFrame.size.height;
	[[tabBarView style] drawBezelOfTabBarView:tabBarView inRect:tabFrame];
	[transform invert];
	[transform concat];
	[viewImage unlockFocus];
    
	if ([tabBarView orientation] == MMTabBarHorizontalOrientation) {
		offset->width = [tabBarView leftMargin];
		offset->height = kTabBarFrameHeight;
	} else {
		offset->width = 0;
		offset->height = kTabBarFrameHeight + [tabBarView topMargin];
	}
    
	if (styleMask) {
		*styleMask = NSTitledWindowMask | NSTexturedBackgroundWindowMask;
	}
    
	return viewImage;
}

- (MMTabBarView *)tabView:(NSTabView *)aTabView newTabBarViewForDraggedTabViewItem:(NSTabViewItem *)tabViewItem atPoint:(NSPoint)point {
	NSLog(@"newTabBarViewForDraggedTabViewItem: %@ atPoint: %@", [tabViewItem label], NSStringFromPoint(point));
    
	//create a new window controller with no tab items
    return nil;
}

- (void)tabView:(NSTabView *)aTabView closeWindowForLastTabViewItem:(NSTabViewItem *)tabViewItem {
	NSLog(@"closeWindowForLastTabViewItem: %@", [tabViewItem label]);
	[[self window] close];
}

- (void)tabView:(NSTabView *)aTabView tabBarViewDidHide:(MMTabBarView *)tabBarView {
	//NSLog(@"tabBarViewDidHide: %@", NSStringFromRect(tabBarView.frame));
    
    NSArray *constraints = tabBarView.constraints;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
    NSArray* filteredArray = [constraints filteredArrayUsingPredicate:predicate];
    if (filteredArray.count != 0) {
        NSLayoutConstraint *constraint =  [constraints firstObject];
        [[constraint animator] setConstant:0];
    }
}

- (void)tabView:(NSTabView *)aTabView tabBarViewDidUnhide:(MMTabBarView *)tabBarView {
	//NSLog(@"tabBarViewDidUnhide: %@", NSStringFromRect(tabBarView.frame));
    
    NSArray *constraints = tabBarView.constraints;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
    NSArray* filteredArray = [constraints filteredArrayUsingPredicate:predicate];
    if (filteredArray.count != 0) {
        NSLayoutConstraint *constraint =  [constraints firstObject];
        [[constraint animator] setConstant:kTabBarFrameHeight];
    }
}

- (NSString *)tabView:(NSTabView *)aTabView toolTipForTabViewItem:(NSTabViewItem *)tabViewItem {
	return [tabViewItem label];
}

- (NSString *)accessibilityStringForTabView:(NSTabView *)aTabView objectCount:(NSInteger)objectCount {
	return (objectCount == 1) ? @"item" : @"items";
}


@end
