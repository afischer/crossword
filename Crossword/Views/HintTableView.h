//
//  HintTableView.h
//  Crossword
//
//  Created by Andrew Fischer on 1/11/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface HintTableView : NSTableView <NSTableViewDelegate, NSTableViewDataSource>
@property (nonatomic) NSDictionary *clues;
@property (nonatomic) NSArray *clueKeys;
- (void)setClueList:(NSDictionary *)clues;
- (BOOL) selectHintWithKey:(NSString *)key;
@end
NS_ASSUME_NONNULL_END
