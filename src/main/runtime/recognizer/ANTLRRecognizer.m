//
//  ANTLRRecognizer.m
//  ANTLR
//
//  Created by Ian Michell on 10/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRRecognizer.h"
#import "ANTLRUnwantedTokenException.h"
#import "ANTLRMissingTokenException.h"
#import "ANTLRMismatchedTokenException.h"
#import "ANTLRMismatchedTreeNodeException.h"
#import "ANTLRNoViableAltException.h"
#import "ANTLREarlyExitException.h"
#import "ANTLRMismatchedSetException.h"
#import "ANTLRMismatchedNotSetException.h"
#import "ANTLRFailedPredicateException.h"


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
	state.errorRecovery = NO;
	state.failed = NO;
	[input consume];
}

-(BOOL) mismatchIsUnwantedToken:(id<ANTLRIntStream>) input tokenType:(NSInteger) t
{
	return [input LA:2] == t;
}

-(BOOL) mismatchIsMissingToken:(id<ANTLRIntStream>) input bitSet:(ANTLRBitSet *) follow
{
	if (follow == nil)
	{
		return NO;
	}
	if ([follow isMember:ANTLRTokenTypeEOR])
	{
		ANTLRBitSet *viableTokensFollowingThisRule = [self computeContextSensitiveRuleFOLLOW];
		follow = [follow or:viableTokensFollowingThisRule];
		if (state._fsp >= 0)
		{
			[follow remove:ANTLRTokenTypeEOR];
		}
	}
	// if current token is consistent with what could come after set
	// then we know we're missing a token; error recovery is free to
	// "insert" the missing token
	
	// BitSet cannot handle negative numbers like -1 (EOF) so I leave EOR
	// in follow set to indicate that the fall of the start symbol is
	// in the set (EOF can follow).
	if ([follow isMember:[input LA:1]] || [follow isMember:ANTLRTokenTypeEOR])
	{
		return YES;
	}
	return NO;
}

-(void) reportError:(ANTLRRecognitionException *) e
{
	// if we've already reported and error and have not matched a token
	// yet successfully, don't report any errors.
	if (state.errorRecovery)
	{
		return;
	}
	state.syntaxErrors++;
	state.errorRecovery = YES;
	[self displayRecognitionError: self.tokenNames withException:e];
}

-(void) displayRecognitionError:(NSMutableArray *) tokenNames withException:(ANTLRRecognitionException *) e
{
	NSString *hdr = [self errorHeaderFromException:e];
	NSString *msg = [self errorMessageForException:e withTokens:self.tokenNames];
	[self emitErrorMessage: [NSString stringWithFormat:@"%@ %@", hdr, msg]];
}

-(NSString *) errorMessageForException:(ANTLRRecognitionException *) e withTokens:(NSMutableArray *) tNames
{
	NSString *msg = [e reason];
	if ([e isKindOfClass:[ANTLRUnwantedTokenException class]])
	{
		ANTLRUnwantedTokenException *ute = (ANTLRUnwantedTokenException *)e;
		NSString *tokenName = @"<unknown>";
		if (ute.expecting == ANTLRTokenTypeEOF)
		{
			tokenName = @"EOF";
		}
		else 
		{
			tokenName = [tNames objectAtIndex:ute.expecting];
		}
		msg = [NSString stringWithFormat:@"extraneous input %@ expecting %@", 
			   [[self errorDisplayFromToken:ute.unexpectedToken] description], tokenName];

	}
	else if ([e isKindOfClass:[ANTLRMissingTokenException class]])
	{
		ANTLRMissingTokenException *mte = (ANTLRMissingTokenException *)e;
		NSString *tokenName = @"<unknown>";
		if (mte.expecting == ANTLRTokenTypeEOF)
		{
			tokenName = @"EOF";
		}
		else 
		{
			tokenName = [tNames objectAtIndex:mte.expecting];
		}
		msg = [NSString stringWithFormat:@"mising %@ at %@", tokenName, [self errorDisplayFromToken:e.token]];
	}
	else if ([e isKindOfClass:[ANTLRMismatchedTokenException class]])
	{
		ANTLRMismatchedTokenException *mte = (ANTLRMismatchedTokenException *)e;
		NSString *tokenName = @"<unknown>";
		if (mte.expecting == ANTLRTokenTypeEOF)
		{
			tokenName = @"EOF";
		}
		else 
		{
			tokenName = [tNames objectAtIndex:mte.expecting];
		}
		msg = [NSString stringWithFormat:@"mismatched input %@ expecting %@", [self errorDisplayFromToken:e.token], tokenName];
	}
	else if ([e isKindOfClass:[ANTLRMismatchedTreeNodeException class]])
	{
		ANTLRMismatchedTreeNodeException *mte = (ANTLRMismatchedTreeNodeException *)e;
		NSString *tokenName = @"<unknown>";
		if (mte.expecting == ANTLRTokenTypeEOF)
		{
			tokenName = @"EOF";
		}
		else 
		{
			tokenName = [tNames objectAtIndex:mte.expecting];
		}
		msg = [NSString stringWithFormat:@"mismatched tree node: %@ expecting %@", [mte.node description], tokenName];
	}
	else if ([e isKindOfClass:[ANTLRNoViableAltException class]])
	{
		msg = [NSString stringWithFormat:@"No viable alternative at input %@", [self errorDisplayFromToken:e.token]];
	}
	else if ([e isKindOfClass:[ANTLREarlyExitException class]])
	{
		msg = [NSString stringWithFormat:@"required (...)+ loop did not match anything at input %@", [self errorDisplayFromToken:e.token]];
	}
	else if ([e isKindOfClass:[ANTLRMismatchedSetException class]])
	{
		ANTLRMismatchedSetException *mse = (ANTLRMismatchedSetException *)e;
		msg = [NSString stringWithFormat:@"mismatched input %@ expecting set %@", [self errorDisplayFromToken:e.token], [mse.expecting description]];
	}
	else if ([e isKindOfClass:[ANTLRMismatchedNotSetException class]])
	{
		ANTLRMismatchedNotSetException *mse = (ANTLRMismatchedNotSetException *)e;
		msg = [NSString stringWithFormat:@"mismatched input %@ expecting set %@", [self errorDisplayFromToken:e.token], [mse.expecting description]];
	}
	else if ([e isKindOfClass:[ANTLRFailedPredicateException class]])
	{
		ANTLRFailedPredicateException *fpe = (ANTLRFailedPredicateException *)e;
		msg = [NSString stringWithFormat:@"rule %@ failed predicate {%@}?", fpe.ruleName, fpe.predicateText];
	}
	return msg;
}

-(NSInteger) numberOfSyntaxErrors
{
	return state.syntaxErrors;
}

-(NSString *) errorHeaderFromException:(ANTLRRecognitionException *) e
{
	return [NSString stringWithFormat:@"line %d:%d", e.line, e.charPositionInLine];
}

-(NSString *) errorDisplayFromToken:(id<ANTLRToken>) t
{
	NSString *s = t.text;
	if (s == nil)
	{
		if (t.type == ANTLRTokenTypeEOF)
		{
			s = @"<EOF>";
		}
		else 
		{
			s = [NSString stringWithFormat:@"<%d>", t.type];
		}
	}
	s = [s stringByReplacingOccurrencesOfString:@"\r" withString:@"\\\\r"];
	s = [s stringByReplacingOccurrencesOfString:@"\n" withString:@"\\\\n"];
	s = [s stringByReplacingOccurrencesOfString:@"\t" withString:@"\\\\t"];
	return [NSString stringWithFormat:@"'%@'", s];
}

/* Override this method from subclass */
-(void) emitErrorMessage:(NSString *) errMsg
{
	// FIXME: Add proper logging mechanism...
	NSLog(errMsg);
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
