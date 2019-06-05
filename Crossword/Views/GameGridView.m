//
//  GameGridView.m
//  Crossword
//
//  Created by Andrew Fischer on 1/5/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import "GameGridView.h"
#import "ViewController.h"
#import "GridCell.h"

@implementation GameGridView


- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
    self.currDirection = AnswerDirectionAcross;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // must be done after drawing as it iterates over views.
    if (self.crossword && !self.acrossCells) [self createClueArrays];
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
    NSLog(@"Found %lu down clues", (unsigned long)[downClueCells count]);

    self.acrossCells = acrossClueCells;
    self.downCells = downClueCells;
}


# pragma mark - NSTableViewDelegate
- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    GridCellView *cellView = [tableView makeViewWithIdentifier:@"GridCell" owner:nil];
    
    NSUInteger col = [[self tableColumns] indexOfObject:tableColumn];
    
    NSString *cellVal = [self.crossword valueAtX:(int)col Y:(int)row];
    NSString *cellSol = [self.crossword solutionAtX:(int)col Y:(int)row];
    NSString *cellLabel = [self.crossword labelAtX:(int)col Y:(int)row];
    BOOL cellIsBlack = [self.crossword isBlackAtX:col Y:row];
    
    GridCell *cell = [[GridCell alloc] initWithCurrentVal:cellVal
                                                 solution:cellSol
                                                    label:cellLabel
                                                  isBlack:cellIsBlack];
    
    [cellView setupCell:cell];
    return cellView;
}



# pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView { return 0; }


# pragma mark - Click handling
- (void)mouseDown:(NSEvent *)event {
    NSPoint location = [event locationInWindow];
    NSPoint gridLocation = [self convertPoint:location toView:nil];
    NSPoint realLocation = CGPointMake(gridLocation.x - 40, gridLocation.y); // FIXME: Why is the x coordinate off?
    
    [self selectClueForCellLocation:realLocation];
}

- (void) clearSelection{
    for (int col = 0; col < self.crossword.width; col++) {
        for (int row = 0; row < self.crossword.height; row++) {
            if ([self.crossword isBlackAtX:col Y:row]) continue;
            GridCellView *cell = [self viewAtColumn:col row:row makeIfNecessary:NO];
            [cell.layer setBackgroundColor:[[NSColor controlBackgroundColor] CGColor]];
        }
    }
}

- (void) selectClueForCellLocation:(NSPoint)point {
    
    NSInteger row = [self rowAtPoint:point];
    NSInteger col = [self columnAtPoint:point];
    
    if ([self.crossword isBlackAtX:col Y:row]) return; // DO nothing, clicked black.
    
    // get clicked cell
    GridCellView *cell = [self viewAtColumn:col row:row makeIfNecessary:NO];
    [self selectClueForCell:cell];
}

// TODO: Fix this weird broken directional logic. Should just keep track of across
//       and down clues and choose correct one based on direction.
- (void) selectClueForCell:(GridCellView *)cell {
    if (!cell) return; // if cell doesn't exist, do nothing
    
    [self clearSelection]; // Clear board colors
    
    if ([cell isEqual:self.currentCellView]) {
        self.currDirection = self.currDirection ? AnswerDirectionAcross : AnswerDirectionDown;
    }
    
    self.currentCellView = cell;
    
    // find group of cells with same clue
    NSArray *acrossClueCells = nil;
    NSArray *downClueCells = nil;
    
    // get cell group for across direction
    for (NSArray *cellGroup in self.acrossCells) {
        if ([cellGroup containsObject:cell]) {
            acrossClueCells = cellGroup;
            break;
        }
    }
    
    // Get cell group for down direciton
    for (NSArray *cellGroup in self.downCells) {
        if ([cellGroup containsObject:cell]) {
            downClueCells = cellGroup;
            break;
        }
    }
    
    self.currentCellGroup = self.currDirection == AnswerDirectionAcross ? acrossClueCells : downClueCells;
    NSArray *oppositeClueCells = self.currDirection == AnswerDirectionAcross ? downClueCells : acrossClueCells;
    
    // COLORS
    NSColor *currentCellColor = [[NSColor controlAccentColor] colorWithAlphaComponent:0.8];
    NSColor *currentClueColor = [[NSColor controlAccentColor] colorWithAlphaComponent:0.5];
    
    
    // set background color of clue
    for (GridCellView *cellView in self.currentCellGroup) {
        [cellView.layer setBackgroundColor:[currentClueColor CGColor]];
    }
    
    // set background color of opposite drirection
    for (GridCellView *cellView in oppositeClueCells) {
        [cellView.layer setBackgroundColor:[[NSColor lightGrayColor] CGColor]];
    }
    
    // set backgorund color of clicked cell
    [cell.layer setBackgroundColor:[currentCellColor CGColor]];
    
    // select clues in sidebar
    GridCellView *acrossFirstCell = acrossClueCells[0];
    GridCellView *downFirstCell = downClueCells[0];

    // TODO: seems like a dirty way to do this
    ViewController *vc = (ViewController *)self.window.contentViewController;
//    if (self.currDirection == AnswerDirectionAcross) {
    [vc.acrossList selectHintWithKey:acrossFirstCell.hintLabel.stringValue];
    [vc.downList selectHintWithKey:downFirstCell.hintLabel.stringValue];
//    }
}

- (void)keyDown:(NSEvent *)event {
    NSLog(@"KEY CODE IS %hu", [event keyCode]);

    switch ([event keyCode]) {
        case 126: // up
        case 125: // down
        case 124: // right
        case 123: // left
            return [self handleKeyEvent:event];
        case 48: // tab
            return [self selectNextClue];
        case 51: // backspace
            self.currentCellView.textField.stringValue = @"";
            return [self selectPreviousSquare];
        default:
            self.currentCellView.textField.stringValue = [[event characters] uppercaseString];
            return [self selectNextSquare];
    }
}

- (void)handleKeyEvent:(NSEvent *)event {
    switch ([[event characters] characterAtIndex:0]) {
        case NSUpArrowFunctionKey:
            // rotate selection if change dirs
            if (self.currDirection == AnswerDirectionAcross) return [self rotateSelection];
            // get previous cell in column otherwise
            return [self selectPreviousSquare];

        case NSDownArrowFunctionKey:
            // rotate selection if change dirs
            if (self.currDirection == AnswerDirectionAcross) return [self rotateSelection];
            // get next cell in column otherwise
            return [self selectNextSquare];
            
        case NSRightArrowFunctionKey:
            // rotate selection if change dirs
            if (self.currDirection == AnswerDirectionDown) return [self rotateSelection];
            // get next cell in row otherwise
            return [self selectNextSquare];


        case NSLeftArrowFunctionKey:
            // rotate selection if change dirs
            if (self.currDirection == AnswerDirectionDown) return [self rotateSelection];
            // get previous cell in row otherwise
            return [self selectPreviousSquare];

            
        default:
            break;
    }
}

- (void) rotateSelection {
    [self selectClueForCell:self.currentCellView];
}


// TODO: CHECK OOB CONDITIONS
- (void) selectNextSquare {
    NSUInteger currIndex = [self.currentCellGroup indexOfObject:self.currentCellView];
    if (currIndex + 1 >= self.currentCellGroup.count) {
        return [self selectNextClue];
    }
    [self selectClueForCell:[self.currentCellGroup objectAtIndex:currIndex + 1]];
}

// TODO: CHECK OOB CONDITIONS
- (void) selectPreviousSquare {
    NSUInteger currIndex = [self.currentCellGroup indexOfObject:self.currentCellView];
    if (currIndex - 1 == -1) {
        return [self selectPreviousClue];
    }
    [self selectClueForCell:[self.currentCellGroup objectAtIndex:currIndex - 1]];
}

- (void) selectNextClue {
    if (self.currDirection == AnswerDirectionAcross) {
        NSUInteger i = [self.acrossCells indexOfObject:self.currentCellGroup];
        if (i + 1 >= self.acrossCells.count) return; // at last clue, TODO: Switch directions
        self.currentCellGroup = [self.acrossCells objectAtIndex:i + 1];
    } else {
        NSUInteger i = [self.downCells indexOfObject:self.currentCellGroup];
        if (i + 1 >= self.downCells.count) return; // at last clue, TODO: switch directions
        self.currentCellGroup = [self.downCells objectAtIndex:i + 1];
    }
    [self selectClueForCell:self.currentCellGroup[0]];
}

- (void) selectPreviousClue {
    if (self.currDirection == AnswerDirectionAcross) {
        NSUInteger i = [self.acrossCells indexOfObject:self.currentCellGroup];
        if (i - 1 < 0) return; // at first clue, TODO: Switch directions
        self.currentCellGroup = [self.acrossCells objectAtIndex:i - 1];
    } else {
        NSUInteger i = [self.downCells indexOfObject:self.currentCellGroup];
        if (i - 1 < 0) return; // at first clue, TODO: switch directions
        self.currentCellGroup = [self.downCells objectAtIndex:i - 1];
    }
    [self selectClueForCell:self.currentCellGroup[0]];
}


- (void) selectClue:(NSString *)num withDirection:(AnswerDirection)dir {
    NSArray *searchCells = dir == AnswerDirectionAcross ? self.acrossCells : self.downCells;
    for (NSArray *cellGroup in searchCells) {
        GridCellView *cell = cellGroup[0];
        if ([cell.hintLabel.stringValue isEqualToString:num]) {
            [self selectClueForCell:cell];
        }
    }
}

- (GridCell *) currentCell {
    return self.currentCellView.cell;
}

// TODO: IMPLEMENT FOR ALL
- (BOOL) checkSquare {
    // this is extremely ugly, probably override drawWithFrame for GridCellView
    // with something prettier, eventually
    [NSException raise:@"UnimplementedMethod"
                format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return false;
}

// TODO: IMPLEMENT FOR ALL
- (BOOL) revealSquare {
    // this is extremely ugly, probably override drawWithFrame for GridCellView
    // with something prettier, eventually
    self.currentCellView.cell.isRevealed = YES;
    [self.currentCellView.textField setTextColor:[NSColor systemBlueColor]];
    self.currentCellView.textField.stringValue = [self currentCell].correctValue;
    return false;
}
@end
