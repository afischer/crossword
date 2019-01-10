//
//  GameGrid.m
//  Crossword
//
//  Created by Andrew Fischer on 1/5/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import "GameGrid.h"

@implementation GameGrid


- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
    self.currDirection = AnswerDirectionAcross;
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
    }
    
    while ([self numberOfRows] < crossword.height) {
        [self insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NO];
    }
    
    [self endUpdates];
}


-(void) createClueArrays {
    NSMutableArray *acrossClueCells = [[NSMutableArray alloc] init];
    NSMutableArray *downClueCells = [[NSMutableArray alloc] init];
    NSMutableArray *clueCells = nil;
    
    // across cells
    for (int row = 0; row < [self numberOfRows]; row++) {
        for (int col = 0; col < [self numberOfColumns]; col++) {
            GridCellView *cell = [self viewAtColumn:col row:row makeIfNecessary:NO];
            if ([self.crossword isBlackAtX:col Y:row]) continue;
            
            if ([self.crossword hasAcrossAtX:col Y:row]) { // new across clue
                if (clueCells) [acrossClueCells addObject:clueCells]; // add to across cell array
                clueCells = [[NSMutableArray alloc] init]; // reset current cell arr
            }

            [clueCells addObject:cell];
        }
    }
    [acrossClueCells addObject:clueCells]; // add last clue
    
    // reset clueCells
    clueCells = nil;

    // across cells
    for (int col = 0; col < [self numberOfColumns]; col++) {
        for (int row = 0; row < [self numberOfRows]; row++) {
            GridCellView *cell = [self viewAtColumn:col row:row makeIfNecessary:NO];
            if ([self.crossword isBlackAtX:col Y:row]) continue;
            
            if ([self.crossword hasDownAtX:col Y:row]) { // new across clue
                if (clueCells) [downClueCells addObject:clueCells]; // add to across cell array
                clueCells = [[NSMutableArray alloc] init]; // reset current cell arr
            }
            
            [clueCells addObject:cell];
        }
    }
    [downClueCells addObject:clueCells]; // add last clue
    
    NSLog(@"Found %lu across clues", (unsigned long)[acrossClueCells count]);
    NSLog(@"Found %lu across clues", (unsigned long)[downClueCells count]);

    self.acrossCells = acrossClueCells;
    self.downCells = downClueCells;
}


# pragma mark - NSTableViewDelegate
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
        [cell.textField setStringValue:@" "];
    }
    return cell;
}



# pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView { return 0; }


# pragma mark - Click handling
- (void)mouseDown:(NSEvent *)event {
    // FIXME: FIND BETTER WAY TO DO THIS
    if (!self.acrossCells) [self createClueArrays];
    
    NSPoint location = [event locationInWindow];
    NSPoint gridLocation = [self convertPoint:location toView:nil];
    NSPoint realLocation = CGPointMake(gridLocation.x - 40, gridLocation.y); // FIXME: Why is the x coordinate off?
    
    [self selectClueForCellLocation:realLocation vertical:NO];
}

- (void) clearSelection{
    for (int col = 0; col < self.crossword.width; col++) {
        for (int row = 0; row < self.crossword.height; row++) {
            if ([self.crossword isBlackAtX:col Y:row]) continue;
            GridCellView *cell = [self viewAtColumn:col row:row makeIfNecessary:NO];
            [cell.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
        }
    }
}

- (void) selectClueForCellLocation:(NSPoint)point vertical:(BOOL)vertical {
    
    NSInteger row = [self rowAtPoint:point];
    NSInteger col = [self columnAtPoint:point];
    
    if ([self.crossword isBlackAtX:col Y:row]) return; // DO nothing, clicked black.
    [self clearSelection]; // Clear board colors
    
    // get clicked cell
    GridCellView *cell = [self viewAtColumn:col row:row makeIfNecessary:NO];
    if ([cell isEqual:self.currentCell]) {
        self.currDirection = self.currDirection ? AnswerDirectionAcross : AnswerDirectionDown;
    }
    
    NSLog(@"Current direction is %u", self.currDirection);
    self.currentCell = cell;

    // find group of cells with same clue
    NSArray *currentCellGroup = nil;
    NSArray *oppositeCellGroup = nil;
    NSArray *cellGroups = self.currDirection ? self.downCells : self.acrossCells;
    NSArray *oppositeGroups = self.currDirection ? self.acrossCells : self.downCells;

    // get cell group for current direction
    for (NSArray *cellGroup in cellGroups) {
        if ([cellGroup containsObject:cell]) {
            currentCellGroup = cellGroup;
            break;
        }
    }
    
    GridCellView *firstCell = currentCellGroup[0];
    NSLog(@"Selected clue %@", firstCell.hintLabel.stringValue);
    
    // set background color of clue
    for (GridCellView *cellView in currentCellGroup) {
        [cellView.layer setBackgroundColor:[[NSColor systemBlueColor] CGColor]];
    }
    
    // Get cell group for opposite direciton
    for (NSArray *cellGroup in oppositeGroups) {
        if ([cellGroup containsObject:cell]) {
            oppositeCellGroup = cellGroup;
            break;
        }
    }
    
    // set background color of opposite drirection
    for (GridCellView *cellView in oppositeCellGroup) {
        [cellView.layer setBackgroundColor:[[NSColor lightGrayColor] CGColor]];
    }
    
    // set backgorund color of clicked cell
    [cell.layer setBackgroundColor:[[NSColor blueColor] CGColor]];
}

- (void)keyDown:(NSEvent *)event {
    if ([event keyCode] > 122 && [event keyCode] < 127) {
        NSLog(@"KEY EVENT");
        return;
    }
    self.currentCell.textField.stringValue = [[event characters] uppercaseString];
}
@end
