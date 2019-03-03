//
//  WindowController.h
//  Crossword
//
//  Created by Andrew Fischer on 3/2/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindowController : NSWindowController
@property (weak) IBOutlet NSTextFieldCell *puzzleTitle;

@end

NS_ASSUME_NONNULL_END
