//
//  ANTLRRecognitionException.m
//  ANTLR
//
//  Created by Ian Michell on 24/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRRecognitionException.h"
#import "ANTLRCommonTree.h"
#import "ANTLRCharStream.h"
#import "ANTLRTokenStream.h"
#import "ANTLRTreeNodeStream.h"
#import "ANTLRTreeAdaptor.h"

@implementation ANTLRRecognitionException

+(ANTLRRecognitionException *) exceptionWithStream:(id<ANTLRIntStream>) input
{
	return [[ANTLRRecognitionException alloc] initWithStream:input];
}

-(id) init
{
	return [super init];
}

-(id) initWithStream:(id<ANTLRIntStream>) input
{
	if ((self = [super init]) != nil)
	{
		self.inputStream = input;
		self.index = [input index];
		if ([self.inputStream conformsToProtocol:@protocol(ANTLRTokenStream)])
		{
			self.token = [((id<ANTLRTokenStream>)self.inputStream) LT:1];
			self.line = self.token.line;
			self.charPositionInLine = self.token.charPositionInLine;
		}
		else if ([self.inputStream conformsToProtocol:@protocol(ANTLRTreeNodeStream)])
		{
			[self extractInformationFromTreeNodeStream:(id<ANTLRTreeNodeStream>)self.inputStream];
		}
		else if ([self.inputStream conformsToProtocol:@protocol(ANTLRCharStream)])
		{
			self.currentChar = [self.inputStream LA:1];
			self.line = [((id<ANTLRCharStream>)self.inputStream) line];
			self.charPositionInLine = [((id<ANTLRCharStream>)self.inputStream) charPositionInLine];
		}
		else 
		{
			self.currentChar = [self.inputStream LA:1];
		}

	}
	return self;
}

-(void) extractInformationFromTreeNodeStream:(id<ANTLRTreeNodeStream>) input
{
	self.node = [input LT:1];
	id<ANTLRTreeAdaptor> adaptor = input.treeAdaptor;
	id<ANTLRToken> payload = [adaptor tokenForNode:self.node];
	if (payload != nil)
	{
		self.token = payload;
		if (self.token.line <= 0)
		{
			int i = -1;
			id<ANTLRTree> priorNode = [input LT:i];
			while (priorNode != nil)
			{
				id<ANTLRToken> priorPayload = [adaptor tokenForNode:priorNode];
				if (priorPayload != nil && priorPayload.line > 0)
				{
					self.line = priorPayload.line;
					self.charPositionInLine = priorPayload.charPositionInLine;
					self.approximateLineInfo = YES;
					break;
				}
				--i;
				priorNode = [input LT:i];
			}
		}
		else 
		{
			self.line = payload.line;
			self.charPositionInLine = payload.charPositionInLine;
		}

	}
	else
	{
		self.line = self.node.line;
		self.charPositionInLine = self.node.charPositionInLine;
		if ([self.node isKindOfClass:[ANTLRCommonTree class]])
		{
			self.token = ((ANTLRCommonTree *)self.node).token;
		}
	}

}

@dynamic unexpectedType;
-(NSInteger) unexpectedType
{
	if ([self.inputStream conformsToProtocol:@protocol(ANTLRTokenStream)])
	{
		return self.token.type;
	}
	else if ([self.inputStream conformsToProtocol:@protocol(ANTLRTreeNodeStream)])
	{
		id<ANTLRTreeNodeStream> nodeStream = (id<ANTLRTreeNodeStream>)self.inputStream;
		id<ANTLRTreeAdaptor> adaptor = nodeStream.treeAdaptor;
		return [adaptor tokenTypeForNode:self.node];
	}
	else 
	{
		return self.currentChar;
	}

}

@synthesize inputStream;
@synthesize line;
@synthesize currentChar;
@synthesize charPositionInLine;
@synthesize index;
@synthesize token;
@synthesize approximateLineInfo;
@synthesize node;

@end
