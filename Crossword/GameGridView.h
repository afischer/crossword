//
//  GameGrid.h
//  Crossword
//
//  Created by Andrew Fischer on 1/5/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Crossword.h"
#import "GridCellView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameGridView : NSTableView <NSTableViewDelegate, NSTableViewDataSource>

typedef enum {
    AnswerDirectionAcross,
    AnswerDirectionDown
} AnswerDirection;

@property (strong, nonatomic) Crossword *crossword;
@property (nonatomic) AnswerDirection currDirection;
@property (strong, nonatomic) GridCellView *currentCell;
@property (strong, nonatomic) NSArray *currentCellGroup;
@property (strong, nonatomic) NSArray *acrossCells;
@property (strong, nonatomic) NSArray *downCells;
- (void) setupWithCrossword:(Crossword *)crossword;
- (void) clearSelection;
@end

NS_ASSUME_NONNULL_END
