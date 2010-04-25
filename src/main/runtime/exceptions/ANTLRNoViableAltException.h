//
//  ANTLRNoViableAltException.h
//  ANTLR
//
//  Created by Ian Michell on 25/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRRecognitionException.h>
#import <ANTLR/ANTLRIntStream.h>

@interface ANTLRNoViableAltException : ANTLRRecognitionException 
{
	NSString *grammarDecisionDescription;
	NSInteger decisionNumber;
	NSInteger stateNumber;
}

-(id) initWithGrammarDecisionDescription:(NSString *) desc decisionNumber:(NSInteger) num stateNumber:(NSInteger) stateNum forStream:(id<ANTLRIntStream>) input;

@property(readwrite, retain) NSString *grammarDecisionDescription;
@property(readwrite) NSInteger decisionNumber;
@property(readwrite) NSInteger stateNumber;

@end
