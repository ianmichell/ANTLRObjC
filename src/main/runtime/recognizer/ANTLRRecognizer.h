//
//  ANTLRRecognizer.h
//  ANTLR
//
//  Created by Ian Michell on 10/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRBitSet.h>
#import <ANTLR/ANTLRToken.h>
#import <ANTLR/ANTLRRecognizerSharedState.h>
#import <ANTLR/ANTLRRecognitionException.h>

#define ANTLR_RECOGNIZER_MEMO_RULE_FAILED -2
#define ANTLR_RECOGNIZER_MEMO_RULE_UNKNOWN -1
#define ANTLR_RECOGNIZER_FOLLOW_STACK_SIZE 100

#define ANTLR_RECOGNIZER_NEXT_TOKEN_RULE_NAME @"nextToken"

#define ANTLR_RECOGNIZER_DEFAULT_TOKEN_CHANNEL ANTLRTokenChannelDefault
#define ANTLR_RECOGNIZER_HIDDEN_TOKEN_CHANNEL ANTLRTokenChannelHidden

@protocol ANTLRRecognizer <NSObject>

-(id) initWithSharedState:(ANTLRRecognizerSharedState *) s;

-(void) reset;
-(id) match:(id<ANTLRIntStream>) input tokenType:(NSInteger) tokenType follow:(ANTLRBitSet *) set;
-(void) matchAny:(id<ANTLRIntStream>) input;
-(BOOL) mismatchIsUnwantedToken:(id<ANTLRIntStream>) input tokenType:(NSInteger) t;
-(BOOL) mismatchIsMissingToken:(id<ANTLRIntStream>) input bitSet:(ANTLRBitSet *) follow;
-(void) reportError:(ANTLRRecognitionException *) e;
-(void) displayRecognitionError:(NSMutableArray *) tokenNames withException:(ANTLRRecognitionException *) e;
-(NSString *) errorMessageForException:(ANTLRRecognitionException *) e withTokens:(NSMutableArray *) tNames;
-(NSInteger) numberOfSyntaxErrors;
-(NSString *) errorHeaderFromException:(ANTLRRecognitionException *) e;
-(NSString *) errorDisplayFromToken:(id<ANTLRToken>) t;
-(void) emitErrorMessage:(NSString *) errMsg;
-(void) recoverInput:(id<ANTLRIntStream>) input withException:(ANTLRRecognitionException *) re;
-(void) beginResync;
-(void) endResync;
-(ANTLRBitSet *) computeErrorRecoverySet;
-(ANTLRBitSet *) computeContextSensitiveRuleFOLLOW;
-(ANTLRBitSet *) combineFollows:(BOOL) exact;
-(id) recoverFromMismatchedToken:(id<ANTLRIntStream>) input tokenType:(NSInteger) ttype follow:(ANTLRBitSet *) follow;
-(id) recoverFromMismatchedSet:(id<ANTLRIntStream>) input exception:(ANTLRRecognitionException *) e follow:(ANTLRBitSet *) follow;

-(void) consumeUntil:(id<ANTLRIntStream>) input tokenType:(NSInteger) tokenType;
-(void) consumeUntil:(id<ANTLRIntStream>) input set:(ANTLRBitSet *) set;

-(NSMutableArray *) ruleInvocationStack;
-(NSMutableArray *) ruleInvocationStackWithException:(NSException *) e recognizerlassName:(NSString *) clsName;
-(BOOL) failed;
-(NSMutableArray *) tokenNames;
-(NSMutableArray *) stringListOfTokens:(NSMutableArray *) tokens;
-(NSInteger) ruleMemorization:(NSInteger) ruleIndex startIndex:(NSInteger) ruleStartIndex;
-(BOOL) alreadyParsedRule:(id<ANTLRIntStream>) input index:(NSInteger) ruleIndex;
-(void) memorize:(id<ANTLRIntStream>) input ruleIndex:(NSInteger) ruleIndex ruleStartIndex:(NSInteger) ruleStartIndex;
-(NSInteger) ruleMemorizeCacheSize;
-(void) traceIn:(NSString *) ruleName ruleIndex:(NSInteger) ruleIndex inputSymbol:(id) inputSymbol;
-(void) traceOut:(NSString *) ruleName ruleIndex:(NSInteger) ruleIndex inputSymbol:(id) inputSymbol;

@property(readonly) BOOL failed;
@property(readwrite) NSInteger backtrackingLevel; // dynamic
@property(readonly, retain) NSMutableArray *tokenNames;
@property(readonly, retain) NSString *sourceName;
@property(readonly) NSInteger numberOfSyntaxErrors;

#pragma mark protected methods
-(id) _currentInputSymbol:(id<ANTLRIntStream>) input;
-(id) _missingSymbolWithInput:(id<ANTLRIntStream>) input withException:(ANTLRRecognitionException *) e withExpectedTokenType:(NSInteger) ttype withBitSet:(ANTLRBitSet *)follow;
-(void) _pushFollow:(ANTLRBitSet *) follow;

@end



@interface ANTLRRecognizer : NSObject <ANTLRRecognizer>
{
	ANTLRRecognizerSharedState *state;
}

@end
