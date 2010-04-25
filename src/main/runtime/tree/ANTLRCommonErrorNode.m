//
//  ANTLRCommonErrorNode.m
//  ANTLR
//
//  Created by Ian Michell on 23/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRCommonErrorNode.h"
#import "ANTLRError.h"
#import "ANTLRMismatchedTokenException.h"
#import "ANTLRMissingTokenException.h"
#import "ANTLRUnwantedTokenException.h"
#import "ANTLRNoViableAltException.h"

@implementation ANTLRCommonErrorNode

-(id) initWithStream:(id<ANTLRTokenStream>) input fromToken:(id<ANTLRToken>) start toToken:(id<ANTLRToken>) stop caughtException:(ANTLRRecognitionException *) exception
{
	self = [super init];
	if (self)
	{
		if (stop == nil || (stop.tokenIndex < start.tokenIndex && stop.type != ANTLRTokenTypeEOF))
		{
			stop = start;
		}
		self.inputStream = input;
		self.startToken = start;
		self.stopToken = stop;
		self.trappedException = exception;
	}
	return self;
}

@dynamic isEmpty;
-(BOOL) isEmpty
{
	return NO;
}

@dynamic type;
-(NSInteger) type
{
	return ANTLRTokenTypeInvalid;
}

@dynamic text;
-(NSString *) text
{
	// The java version hasn't caught up with the generics of java 5, but in here
	// we force the type to conform to ANTLRToken, so we only need to make sure
	// it's not nil. The java runtime also has an else if to see if start is an
	// instance
	if (self.startToken != nil)
	{
		NSInteger i = self.startToken.tokenIndex;
		NSInteger j = self.stopToken.tokenIndex;
		if (self.stopToken.type == ANTLRTokenTypeEOF)
		{
			j = [self.inputStream size];
		}
		return [((id<ANTLRTokenStream>)self.inputStream)  stringValueFromPositions:i end:j];
	}
	else 
	{
		return @"<unknown>";
	}

}

-(NSString *) description
{
	if ([self.trappedException isKindOfClass:[ANTLRMissingTokenException class]])
	{
		return [NSString stringWithFormat:@"<missing type: %d>", ((ANTLRMissingTokenException *)self.trappedException).missingType];
	}
	else if ([self.trappedException isKindOfClass:[ANTLRUnwantedTokenException class]])
	{
		return [NSString stringWithFormat:@"<extraneous: %@, resync=%@>", [self.trappedException.token description], self.text];
	}
	else if ([self.trappedException isKindOfClass:[ANTLRMismatchedTokenException class]])
	{
		return [NSString stringWithFormat:@"<mismatched token: %@, resync=%@>", [self.trappedException.token description], self.text];
	}
	else if ([self.trappedException isKindOfClass:[ANTLRNoViableAltException class]])
	{
		return [NSString stringWithFormat:@"<unexpected: %@, resync=%@>", [self.trappedException.token description], self.text];
	}
	return [NSString stringWithFormat:@"<error %@>", self.text];
}

@synthesize inputStream;
@synthesize startToken;
@synthesize stopToken;
@synthesize trappedException;

@end
