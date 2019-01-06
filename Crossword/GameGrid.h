//
//  GameGrid.h
//  Crossword
//
//  Created by Andrew Fischer on 1/5/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Crossword.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameGrid : NSTableView <NSTableViewDelegate, NSTableViewDataSource>
@property (strong, nonatomic) Crossword *crossword;
- (void)setupWithCrossword:(Crossword *)crossword;
@end

NS_ASSUME_NONNULL_END
