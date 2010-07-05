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

/** Recover from an error found on the input stream.  This is
 *  for NoViableAlt and mismatched symbol exceptions.  If you enable
 *  single token insertion and deletion, this will usually not
 *  handle mismatched symbol exceptions but there could be a mismatched
 *  token that the match() routine could not recover from.
 */
-(void) recoverInput:(id<ANTLRIntStream>) input withException:(ANTLRRecognitionException *) re
{
	if (state.lastErrorIndex == [input index])
	{
		// uh oh, another error at same token index; must be a case
		// where LT(1) is in the recovery token set so nothing is
		// consumed; consume a single token so at least to prevent
		// an infinite loop; this is a failsafe.
		[input consume];
	}
	state.lastErrorIndex = [input index];
	ANTLRBitSet *followSet = [self computeErrorRecoverySet];
	[self beginResync];
	[self consumeUntil:input set:followSet];
	[self endResync];
}

/** A hook to listen in on the token consumption during error recovery.
 *  The DebugParser subclasses this to fire events to the listenter.
 */
-(void) beginResync
{
	
}

-(void) endResync
{
	
}

/*  Compute the error recovery set for the current rule.  During
 *  rule invocation, the parser pushes the set of tokens that can
 *  follow that rule reference on the stack; this amounts to
 *  computing FIRST of what follows the rule reference in the
 *  enclosing rule. This local follow set only includes tokens
 *  from within the rule; i.e., the FIRST computation done by
 *  ANTLR stops at the end of a rule.
 *
 *  EXAMPLE
 *
 *  When you find a "no viable alt exception", the input is not
 *  consistent with any of the alternatives for rule r.  The best
 *  thing to do is to consume tokens until you see something that
 *  can legally follow a call to r *or* any rule that called r.
 *  You don't want the exact set of viable next tokens because the
 *  input might just be missing a token--you might consume the
 *  rest of the input looking for one of the missing tokens.
 *
 *  Consider grammar:
 *
 *  a : '[' b ']'
 *    | '(' b ')'
 *    ;
 *  b : c '^' INT ;
 *  c : ID
 *    | INT
 *    ;
 *
 *  At each rule invocation, the set of tokens that could follow
 *  that rule is pushed on a stack.  Here are the various "local"
 *  follow sets:
 *
 *  FOLLOW(b1_in_a) = FIRST(']') = ']'
 *  FOLLOW(b2_in_a) = FIRST(')') = ')'
 *  FOLLOW(c_in_b) = FIRST('^') = '^'
 *
 *  Upon erroneous input "[]", the call chain is
 *
 *  a -> b -> c
 *
 *  and, hence, the follow context stack is:
 *
 *  depth  local follow set     after call to rule
 *    0         <EOF>                    a (from main())
 *    1          ']'                     b
 *    3          '^'                     c
 *
 *  Notice that ')' is not included, because b would have to have
 *  been called from a different context in rule a for ')' to be
 *  included.
 *
 *  For error recovery, we cannot consider FOLLOW(c)
 *  (context-sensitive or otherwise).  We need the combined set of
 *  all context-sensitive FOLLOW sets--the set of all tokens that
 *  could follow any reference in the call chain.  We need to
 *  resync to one of those tokens.  Note that FOLLOW(c)='^' and if
 *  we resync'd to that token, we'd consume until EOF.  We need to
 *  sync to context-sensitive FOLLOWs for a, b, and c: {']','^'}.
 *  In this case, for input "[]", LA(1) is in this set so we would
 *  not consume anything and after printing an error rule c would
 *  return normally.  It would not find the required '^' though.
 *  At this point, it gets a mismatched token error and throws an
 *  exception (since LA(1) is not in the viable following token
 *  set).  The rule exception handler tries to recover, but finds
 *  the same recovery set and doesn't consume anything.  Rule b
 *  exits normally returning to rule a.  Now it finds the ']' (and
 *  with the successful match exits errorRecovery mode).
 *
 *  So, you cna see that the parser walks up call chain looking
 *  for the token that was a member of the recovery set.
 *
 *  Errors are not generated in errorRecovery mode.
 *
 *  ANTLR's error recovery mechanism is based upon original ideas:
 *
 *  "Algorithms + Data Structures = Programs" by Niklaus Wirth
 *
 *  and
 *
 *  "A note on error recovery in recursive descent parsers":
 *  http://portal.acm.org/citation.cfm?id=947902.947905
 *
 *  Later, Josef Grosch had some good ideas:
 *
 *  "Efficient and Comfortable Error Recovery in Recursive Descent
 *  Parsers":
 *  ftp://www.cocolab.com/products/cocktail/doca4.ps/ell.ps.zip
 *
 *  Like Grosch I implemented local FOLLOW sets that are combined
 *  at run-time upon error to avoid overhead during parsing.
 */
-(ANTLRBitSet *) computeErrorRecoverySet
{
	return [self combineFollows:NO];
}

/** Compute the context-sensitive FOLLOW set for current rule.
 *  This is set of token types that can follow a specific rule
 *  reference given a specific call chain.  You get the set of
 *  viable tokens that can possibly come next (lookahead depth 1)
 *  given the current call chain.  Contrast this with the
 *  definition of plain FOLLOW for rule r:
 *
 *   FOLLOW(r)={x | S=>*alpha r beta in G and x in FIRST(beta)}
 *
 *  where x in T* and alpha, beta in V*; T is set of terminals and
 *  V is the set of terminals and nonterminals.  In other words,
 *  FOLLOW(r) is the set of all tokens that can possibly follow
 *  references to r in *any* sentential form (context).  At
 *  runtime, however, we know precisely which context applies as
 *  we have the call chain.  We may compute the exact (rather
 *  than covering superset) set of following tokens.
 *
 *  For example, consider grammar:
 *
 *  stat : ID '=' expr ';'      // FOLLOW(stat)=={EOF}
 *       | "return" expr '.'
 *       ;
 *  expr : atom ('+' atom)* ;   // FOLLOW(expr)=={';','.',')'}
 *  atom : INT                  // FOLLOW(atom)=={'+',')',';','.'}
 *       | '(' expr ')'
 *       ;
 *
 *  The FOLLOW sets are all inclusive whereas context-sensitive
 *  FOLLOW sets are precisely what could follow a rule reference.
 *  For input input "i=(3);", here is the derivation:
 *
 *  stat => ID '=' expr ';'
 *       => ID '=' atom ('+' atom)* ';'
 *       => ID '=' '(' expr ')' ('+' atom)* ';'
 *       => ID '=' '(' atom ')' ('+' atom)* ';'
 *       => ID '=' '(' INT ')' ('+' atom)* ';'
 *       => ID '=' '(' INT ')' ';'
 *
 *  At the "3" token, you'd have a call chain of
 *
 *    stat -> expr -> atom -> expr -> atom
 *
 *  What can follow that specific nested ref to atom?  Exactly ')'
 *  as you can see by looking at the derivation of this specific
 *  input.  Contrast this with the FOLLOW(atom)={'+',')',';','.'}.
 *
 *  You want the exact viable token set when recovering from a
 *  token mismatch.  Upon token mismatch, if LA(1) is member of
 *  the viable next token set, then you know there is most likely
 *  a missing token in the input stream.  "Insert" one by just not
 *  throwing an exception.
 */
-(ANTLRBitSet *) computeContextSensitiveRuleFOLLOW
{
	return [self combineFollows:YES];
}

-(ANTLRBitSet *) combineFollows:(BOOL) exact
{
	NSInteger top = state._fsp;
	ANTLRBitSet *followSet = [[ANTLRBitSet alloc] init];
	for (NSInteger i = top; i >=0; i--)
	{
		ANTLRBitSet *localFollowSet = (ANTLRBitSet *)[state.following objectAtIndex:i];
		[followSet orInPlace:localFollowSet];
		if (exact)
		{
			// can we see end of rule?
			if ([localFollowSet isMember:ANTLRTokenTypeEOR])
			{
				// Only leave EOR in set if at top (start rule); this lets
				// us know if have to include follow(start rule); i.e., EOF
				if (i > 0)
				{
					[followSet remove:ANTLRTokenTypeEOR];
				}
			}
			// can't see end of rule, quit
			else
			{
				break;
			}
		}
	}
	return followSet;
}

/** Attempt to recover from a single missing or extra token.
 *
 *  EXTRA TOKEN
 *
 *  LA(1) is not what we are looking for.  If LA(2) has the right token,
 *  however, then assume LA(1) is some extra spurious token.  Delete it
 *  and LA(2) as if we were doing a normal match(), which advances the
 *  input.
 *
 *  MISSING TOKEN
 *
 *  If current token is consistent with what could come after
 *  ttype then it is ok to "insert" the missing token, else throw
 *  exception For example, Input "i=(3;" is clearly missing the
 *  ')'.  When the parser returns from the nested call to expr, it
 *  will have call chain:
 *
 *    stat -> expr -> atom
 *
 *  and it will be trying to match the ')' at this point in the
 *  derivation:
 *
 *       => ID '=' '(' INT ')' ('+' atom)* ';'
 *                          ^
 *  match() will see that ';' doesn't match ')' and report a
 *  mismatched token error.  To recover, it sees that LA(1)==';'
 *  is in the set of tokens that can follow the ')' token
 *  reference in rule atom.  It can assume that you forgot the ')'.
 */
-(id) recoverFromMismatchedToken:(id<ANTLRIntStream>) input tokenType:(NSInteger) ttype follow:(ANTLRBitSet *) follow
{
	ANTLRRecognitionException *e = nil;
	if ([self mismatchIsUnwantedToken:input tokenType:ttype])
	{
		e = [[ANTLRUnwantedTokenException alloc] initWithExpectedType:ttype forStream:input];
		[self beginResync];
		[input consume];
		[self endResync];
		[self reportError:e];
		id matchedSymbol = [self _currentInputSymbol:input];
		[input consume];
		return matchedSymbol;
	}
	if ([self mismatchIsMissingToken:input bitSet:follow])
	{
		id inserted = [self _missingSymbolWithInput:input withException:e withExpectedTokenType:ttype withBitSet:follow];
		e = [[ANTLRMissingTokenException alloc] initWithExpectedType:ttype forInputStream:input withObject:inserted];
		[self reportError:e];
		return inserted;
	}
	// if none of the above worked, throw an exception
	e = [[ANTLRMismatchedTokenException alloc] initWithExpectedType:ttype forStream:input];
	@throw e;
}

-(id) recoverFromMismatchedSet:(id<ANTLRIntStream>) input exception:(ANTLRRecognitionException *) e follow:(ANTLRBitSet *) follow
{
	if ([self mismatchIsMissingToken:input bitSet:follow])
	{
		[self reportError:e];
		return [self _missingSymbolWithInput:input withException:e withExpectedTokenType:ANTLRTokenTypeInvalid withBitSet:follow];
	}
	@throw e;
}

-(void) consumeUntil:(id<ANTLRIntStream>) input tokenType:(NSInteger) tokenType
{
	NSInteger ttype = [input LA:1];
	while (ttype != ANTLRTokenTypeEOF && ttype != tokenType)
	{
		[input consume];
		ttype = [input LA:1];
	}
}

-(void) consumeUntil:(id<ANTLRIntStream>) input set:(ANTLRBitSet *) set
{
	NSInteger ttype = [input LA:1];
	while (ttype != ANTLRTokenTypeEOF && ![set isMember:ttype])
	{
		[input consume];
		ttype = [input LA:1];
	}
}

-(NSMutableArray *) ruleInvocationStack
{
	NSString *parserClassName;
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
/** Match needs to return the current input symbol, which gets put
 *  into the label for the associated token ref; e.g., x=ID.  Token
 *  and tree parsers need to return different objects. Rather than test
 *  for input stream type or change the IntStream interface, I use
 *  a simple method to ask the recognizer to tell me what the current
 *  input symbol is.
 * 
 *  This is ignored for lexers.
 */
-(id) _currentInputSymbol:(id<ANTLRIntStream>) input;
{
	return nil;
}

/** Conjure up a missing token during error recovery.
 *
 *  The recognizer attempts to recover from single missing
 *  symbols. But, actions might refer to that missing symbol.
 *  For example, x=ID {f($x);}. The action clearly assumes
 *  that there has been an identifier matched previously and that
 *  $x points at that token. If that token is missing, but
 *  the next token in the stream is what we want we assume that
 *  this token is missing and we keep going. Because we
 *  have to return some token to replace the missing token,
 *  we have to conjure one up. This method gives the user control
 *  over the tokens returned for missing tokens. Mostly,
 *  you will want to create something special for identifier
 *  tokens. For literals such as '{' and ',', the default
 *  action in the parser or tree parser works. It simply creates
 *  a CommonToken of the appropriate type. The text will be the token.
 *  If you change what tokens must be created by the lexer,
 *  override this method to create the appropriate tokens.
 */
-(id) _missingSymbolWithInput:(id<ANTLRIntStream>) input withException:(ANTLRRecognitionException *) e withExpectedTokenType:(NSInteger) ttype withBitSet:(ANTLRBitSet *)follow
{
	return nil;
}

-(void) _pushFollow:(ANTLRBitSet *) follow
{
	if ((state._fsp + 1) >= [state.following count])
	{
		NSMutableArray *f = [NSMutableArray arrayWithCapacity:([state.following count] * 2)];
		[f addObjectsFromArray:state.following];
		state.following = f;
	}
}

@end
