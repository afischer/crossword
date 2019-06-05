//
//  GridCellView.h
//  Crossword
//
//  Created by Andrew Fischer on 1/6/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GridCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GridCellView : NSTableCellView
@property (weak) IBOutlet NSTextField *hintLabel;
@property GridCell *cell;
- (void) setupCell:(GridCell *)cell;
@end

NS_ASSUME_NONNULL_END
