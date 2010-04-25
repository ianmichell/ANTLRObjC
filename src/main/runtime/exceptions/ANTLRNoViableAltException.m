//
//  ANTLRNoViableAltException.m
//  ANTLR
//
//  Created by Ian Michell on 25/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//
#import <objc/objc-runtime.h>
#import "ANTLRNoViableAltException.h"
#import "ANTLRCharStream.h"

@implementation ANTLRNoViableAltException

-(id) initWithGrammarDecisionDescription:(NSString *) desc decisionNumber:(NSInteger) num stateNumber:(NSInteger) stateNum forStream:(id<ANTLRIntStream>) input
{
	self = [super initWithStream:input];
	if (self)
	{
		self.grammarDecisionDescription = desc;
		self.decisionNumber = num;
		self.stateNumber = stateNum;
	}
	return self;
}

-(NSString *) description
{
	if ([self.inputStream conformsToProtocol:@protocol(ANTLRCharStream)])
	{
		return [NSString stringWithFormat:@"%s('%c'@[%@])", class_getName([self class]), (char)self.unexpectedType, self.grammarDecisionDescription];
	}
	else 
	{
		return [NSString stringWithFormat:@"%s(%d@[%@])", class_getName([self class]), self.unexpectedType, self.grammarDecisionDescription];
	}

}

@synthesize grammarDecisionDescription;
@synthesize decisionNumber;
@synthesize stateNumber;

@end
