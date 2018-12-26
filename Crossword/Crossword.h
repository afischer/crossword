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
@property (nonatomic) NSArray *acrossClues;
@property (nonatomic) NSArray *downClues;

- (instancetype)initWithData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
