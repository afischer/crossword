//
//  GameGrid.m
//  Crossword
//
//  Created by Andrew Fischer on 1/5/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import "GameGrid.h"
#import "GridCellView.h"

@implementation GameGrid

- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
//    self.acceptsFirstResponder = NO;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setupWithCrossword:(Crossword *)crossword {
    self.crossword = crossword;
    
    [self beginUpdates];
    [self removeTableColumn:[self tableColumns][0]];
    
    while ([self numberOfColumns] < crossword.width) {
        [self addTableColumn:[[NSTableColumn alloc] init]];
        NSLog(@"at %ld columns ", (long)self.numberOfColumns);
    }
    
    while ([self numberOfRows] < crossword.height) {
        [self insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NO];
        NSLog(@"at %ld rows ", (long)self.numberOfRows);
    }
    
    self.rowHeight = 65;
    [self endUpdates];
}



# pragma mark - NSTableViewDelegate
/*
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSUInteger col = [[self tableColumns] indexOfObject:tableColumn];
    [cell setDrawsBackground:YES];
    [cell setAlignment:NSTextAlignmentCenter];
    [cell setFont:[NSFont systemFontOfSize:16 weight:NSFontWeightRegular]];
//    [cell setFrame:NSMakeRect(0, self.rowHeight/2, tableColumn.width, self.rowHeight)];
    
    
//    NSRect(x:0.0, y:myTableView.rowHeight/2, width:tableColumn!.width, height:myTableView.rowHeight
    // NSMakeRect(0, self.rowHeight/2, tableColumn.width, self.rowHeight)
    if ([self.crossword isBlackAtX:(int)col Y:(int)row]) {
        [cell setBackgroundColor:[NSColor blackColor]];
    } else {
        [cell setBackgroundColor:[NSColor whiteColor]];
    }
}*/

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    GridCellView *cell = [tableView makeViewWithIdentifier:@"GridCell" owner:nil];
    cell.wantsLayer = YES;

    NSUInteger col = [[self tableColumns] indexOfObject:tableColumn];
    if ([self.crossword isBlackAtX:(int)col Y:(int)row]) {
        // Set Color
        cell.layer.backgroundColor = [[NSColor blackColor] CGColor];
        [cell.hintLabel setHidden:YES];
        [cell.textField setHidden:YES];

    } else {
        // Set Hint
        // TODO: MAKE GET CLUE METHOD
        if ([self.crossword hasLabelAtX:(int)col Y:(int)row]) {
            NSString *coordString = [NSString stringWithFormat:@"%d,%d", (int)col, (int)row];
            NSString *clueNum = [self.crossword.labelMap valueForKey:coordString];
            [cell.hintLabel setStringValue:clueNum];
        } else {
            [cell.hintLabel setHidden:YES];
        }
        
        // Set text
        [cell.textField setStringValue:@"Z"];
    }
    return cell;
}



# pragma mark - NSTableViewDataSource
//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
////    NSUInteger col = [[self tableColumns] indexOfObject:tableColumn];
////    NSView *view = [self viewAtColumn:col row:row makeIfNecessary:NO];
//    return @"X";
//}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView { return 0; }

//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row



# pragma mark - Click handling
- (void)mouseDown:(NSEvent *)event {
    NSPoint location = [event locationInWindow];
    NSPoint gridLocation = [self convertPoint:location toView:nil];
    NSPoint realLocation = CGPointMake(gridLocation.x - 40, gridLocation.y); // FIXME: Why is the x coordinate off?
    
    [self selectClueForCellLocation:realLocation vertical:NO];
}

//- (GridCellView *)cellForLocation:(NSPoint)location {
//    NSInteger row = [self rowAtPoint:location];
//    NSInteger col = [self columnAtPoint:location];
//    return [self viewAtColumn:col row:row makeIfNecessary:NO];
//}

- (void) selectClueForCellLocation:(NSPoint)point vertical:(BOOL)vertical {
    NSInteger row = [self rowAtPoint:point];
    NSInteger col = [self columnAtPoint:point];

    GridCellView *cell = [self viewAtColumn:col row:row makeIfNecessary:NO];
    if ([self.crossword isBlackAtX:col Y:row]) return; // DO nothing, clicked black.
    [cell.layer setBackgroundColor:[[NSColor systemBlueColor] CGColor]];

    // TODO: Check if cell itself is black
    
    int lCol = (int)col - 1;
    int rCol = (int)col + 1;
    GridCellView *lCell = nil;
    GridCellView *rCell = nil;
    
    // check if in bounds for left and right, set indices
    if (lCol < self.crossword.width && ![self.crossword isBlackAtX:(int)lCol Y:(int)row]) {
        lCell = [self viewAtColumn:lCol row:row makeIfNecessary:NO];
    }
    if (rCol < self.crossword.width && ![self.crossword isBlackAtX:(int)rCol Y:(int)row]) {
        rCell = [self viewAtColumn:rCol row:row makeIfNecessary:NO];
    }
    
    while (rCell) {
        [rCell.layer setBackgroundColor:[[NSColor systemGreenColor] CGColor]];
        if (rCol + 1 < self.crossword.width && ![self.crossword isBlackAtX:rCol + 1 Y:(int)row]) { // not black or OOB
            rCol++;
            rCell = [self viewAtColumn:rCol row:row makeIfNecessary:NO];
        } else { rCell = nil; }
    }
    
    while (lCell) {
        [lCell.layer setBackgroundColor:[[NSColor systemGreenColor] CGColor]];
        if (lCol - 1 >= 0 && ![self.crossword isBlackAtX:lCol - 1 Y:(int)row]) { // not black or OOB
            lCol--;
            lCell = [self viewAtColumn:lCol row:row makeIfNecessary:NO];
        } else { lCell = nil; }
    }
}
@end
