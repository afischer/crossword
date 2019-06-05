//
//  GridCell.h
//  Crossword
//
//  Created by Andrew Fischer on 6/5/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GridCell : NSObject
@property (nonatomic) NSString *currentValue;
@property (nonatomic) NSString *correctValue;
@property (nonatomic) NSString *label;

@property (nonatomic) BOOL isBlack;
@property (nonatomic) BOOL isRevealed;
@property (nonatomic) BOOL isIncorrect;

- (instancetype)initWithCurrentVal:(NSString *)val
                          solution:(NSString *)solution
                            label:(NSString *)label
                           isBlack:(BOOL)isBlack;

@end

NS_ASSUME_NONNULL_END
