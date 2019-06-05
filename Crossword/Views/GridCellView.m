//
//  GridCellView.m
//  Crossword
//
//  Created by Andrew Fischer on 1/6/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import "GridCellView.h"

@implementation GridCellView

- (void)awakeFromNib {
    self.wantsLayer = YES;
}

- (void) setupCell:(GridCell *)cell {
    self.cell = cell;
    
    if (self.cell.isBlack) {
        // Set Color
        self.layer.backgroundColor = [[NSColor blackColor] CGColor];
        [self.hintLabel setHidden:YES];
        [self.textField setHidden:YES];
        
    } else {
        // Set Hint
        // TODO: MAKE GET CLUE METHOD
        [self.hintLabel setStringValue:self.cell.label];
        
        if (self.cell.isIncorrect) {
            [self.textField setTextColor:[NSColor systemRedColor]];
        }
        if (self.cell.isRevealed) {
            [self.textField setTextColor:[NSColor systemBlueColor]];
        }
        
        // Set text
        [self.textField setStringValue:self.cell.currentValue];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

@end
