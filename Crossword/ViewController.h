//
//  ViewController.h
//  Crossword
//
//  Created by Andrew Fischer on 12/25/18.
//  Copyright © 2018 Andrew Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Crossword.h"
#import "GameGridView.h"
#import "HintTableView.h"

@interface ViewController : NSViewController
@property (weak) IBOutlet HintTableView *acrossList;
@property (weak) IBOutlet HintTableView *downList;
@property (weak) IBOutlet NSTextField *titleText;
@property (weak) IBOutlet NSTextField *authorText;
@property (weak) IBOutlet NSTextField *copyrightText;
@property (weak) IBOutlet GameGridView *gameTable;
@property (strong, nonatomic) Crossword *crossword;
@end

