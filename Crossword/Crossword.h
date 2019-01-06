//
//  Crossword.h
//  Crossword
//
//  Created by Andrew Fischer on 12/26/18.
//  Copyright © 2018 Andrew Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Crossword : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *copyright;

@property (nonatomic) int scrambleType; // TODO: MAKE ENUM
@property (nonatomic) int height;
@property (nonatomic) int width;
@property (nonatomic) int numClues;
@property (nonatomic) NSDictionary *acrossClues;
@property (nonatomic) NSDictionary *downClues;
@property (nonatomic) NSArray *boardLayout;
- (instancetype)initWithData:(NSData *)data;

- (BOOL) isBlackAtX:(int) x Y:(int) y;
- (BOOL) hasAcrossAtX:(int) x Y:(int) y;
- (BOOL) hasDownAtX:(int) x Y:(int) y;
@end

NS_ASSUME_NONNULL_END
