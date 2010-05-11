//
//  ANTLRRecognizer.m
//  ANTLR
//
//  Created by Ian Michell on 10/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRRecognizer.h"


@implementation ANTLRRecognizer

-(id) init
{
	self = [super init];
	if (self)
	{
		state = [ANTLRRecognizerSharedState new];
	}
	return self;
}

-(id) initWithSharedState:(ANTLRRecognizerSharedState *) s
{
	if (s == nil)
	{
		return [self init];
	}
	self = [super init];
	if (self)
	{
		state = s;
	}
	return self;
}

-(void) reset
{
	if (state == nil)
	{
		return;
	}
	state._fsp = -1;
	state.errorRecovery = NO;
	state.lastErrorIndex = -1;
	state.failed = NO;
	state.syntaxErrors = 0;
	state.backtracking = 0;
	for (NSInteger i = 0; state.ruleMemo != nil && i < [state.ruleMemo count]; i++)
	{
		[state.ruleMemo replaceObjectAtIndex:i withObject:nil];
	}
}

-(id) match:(id<ANTLRIntStream>) input tokenType:(NSInteger) tokenType follow:(ANTLRBitSet *) set
{
	id matchedSymbol = [self _currentInputSymbol:input];
	if ([input LA:1] == tokenType)
	{
		[input consume];
		state.errorRecovery = NO;
		state.failed = NO;
		return matchedSymbol;
	}
	if (state.backtracking > 0)
	{
		state.failed = YES;
		return matchedSymbol;
	}
	matchedSymbol = [self recoverFromMismatchedToken:input tokenType:tokenType follow:set];
	return matchedSymbol;
}

-(void) matchAny:(id<ANTLRIntStream>) input
{
	
}

-(BOOL) mismatchIsUnwantedToken:(id<ANTLRIntStream>) input tokenType:(NSInteger) t
{
	
}

-(BOOL) mismatchIsMissingToken:(id<ANTLRIntStream>) input bitSet:(ANTLRBitSet *) follow
{
	
}

-(void) reportError:(ANTLRRecognitionException *) e
{
	
}

-(void) displayRecognitionError:(NSMutableArray *) tokenNames withException:(ANTLRRecognitionException *) e
{
	
}

-(NSString *) errorMessageForException:(ANTLRRecognitionException *) e withTokens:(NSMutableArray *) tokenNames
{
	
}

-(NSInteger) numberOfSyntaxErrors
{
	
}

-(NSString *) errorHeaderFromException:(ANTLRRecognitionException *) e
{
	
}

-(NSString *) errorDisplayFromToken:(id<ANTLRToken>) t
{
	
}

-(void) emitErrorMessage:(NSString *) errMsg
{
	
}

-(void) recoverInput:(id<ANTLRIntStream>) input withException:(ANTLRRecognitionException *) re
{
	
}

-(void) beginResync
{
	
}

-(void) endResync
{
	
}

-(ANTLRBitSet *) computeErrorRecoverySet
{
	
}

-(ANTLRBitSet *) computeContextSensitiveRuleFOLLOW
{
	
}

-(ANTLRBitSet *) combineFollows:(BOOL) exact
{
	
}

-(id) recoverFromMismatchedToken:(id<ANTLRIntStream>) input tokenType:(NSInteger) ttype follow:(ANTLRBitSet *) follow
{
	
}

-(id) recoverFromMismatchedSet:(id<ANTLRIntStream>) input exception:(ANTLRRecognitionException *) e follow:(ANTLRBitSet *) follow
{
	
}

-(void) consumeUntil:(id<ANTLRIntStream>) input tokenType:(NSInteger) tokenType
{
	
}

-(void) consumeUntil:(id<ANTLRIntStream>) input set:(ANTLRBitSet *) set
{
	
}

-(NSMutableArray *) ruleInvocationStack
{
	
}

-(NSMutableArray *) ruleInvocationStackWithException:(NSException *) e recognizerlassName:(NSString *) clsName
{
	
}

-(NSMutableArray *) stringListOfTokens:(NSMutableArray *) tokens
{
	
}

-(NSInteger) ruleMemorization:(NSInteger) ruleIndex startIndex:(NSInteger) ruleStartIndex
{
	
}

-(BOOL) alreadyParsedRule:(id<ANTLRIntStream>) input index:(NSInteger) ruleIndex
{
	
}

-(void) memorize:(id<ANTLRIntStream>) input ruleIndex:(NSInteger) ruleIndex ruleStartIndex:(NSInteger) ruleStartIndex;
{
	
}

-(NSInteger) ruleMemorizeCacheSize
{
	
}

-(void) traceIn:(NSString *) ruleName ruleIndex:(NSInteger) ruleIndex inputSymbol:(id) inputSymbol
{
	
}

-(void) traceOut:(NSString *) ruleName ruleIndex:(NSInteger) ruleIndex inputSymbol:(id) inputSymbol
{
	
}

@dynamic failed;
-(BOOL) failed
{
	
}

@dynamic backtrackingLevel;
-(void) setBacktrackingLevel:(NSInteger) level
{
	
}

-(NSInteger) backtrackingLevel
{
	
}


@dynamic tokenNames;
-(NSMutableArray *) tokenNames
{
	
}

@dynamic sourceName;
-(NSString *) sourceName
{
	
}

#pragma mark protected methods
-(id) _currentInputSymbol:(id<ANTLRIntStream>) input;
{
	
}

-(id) _missingSymbol:(id<ANTLRIntStream>) input
{
	
}

-(id) _pushFollow:(ANTLRBitSet *) follow
{
	
}

@end
