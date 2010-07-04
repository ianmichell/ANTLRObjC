//
//  ANTLRMismatchedNotSetException.m
//  ANTLR
//
//  Created by Ian Michell on 04/07/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRMismatchedNotSetException.h"


@implementation ANTLRMismatchedNotSetException

-(NSString *) description
{
	return [NSString stringWithFormat:@"MismatchedNotSetException(%d, %@)", self.unexpectedType, [self.expecting description]];
}

@end
