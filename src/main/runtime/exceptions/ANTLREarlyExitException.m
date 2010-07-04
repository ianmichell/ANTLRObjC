//
//  ANTLREarlyExitException.m
//  ANTLR
//
//  Created by Ian Michell on 04/07/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLREarlyExitException.h"


@implementation ANTLREarlyExitException


-(id) initWithDecisionNumber:(NSInteger) d withInputStream:(id<ANTLRIntStream>) str
{
	self = [super initWithStream:str];
	if (self)
	{
		self.decisionNumber = d;
	}
	return self;
}

@synthesize decisionNumber;

@end
