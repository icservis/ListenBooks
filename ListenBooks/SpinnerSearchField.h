//
//  SpinnerSearchField.h
//  ListenBooks
//
//  Created by Libor Kučera on 04.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpinnerSearchField : NSSearchField

- (void)showProgressIndicator;
- (void)hideProgressIndicator;

@end
