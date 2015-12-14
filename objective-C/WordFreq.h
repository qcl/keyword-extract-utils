//
//  WordFreq.h
//
//  Created by Qing-Cheng Li on 12/10/15.
//

#import <Foundation/Foundation.h>

@interface WordFreq : NSObject

+ (void)test;
+ (NSArray *)getAllSubStrings:(NSString *)string withMaxLenth:(NSUInteger)maxLength;
+ (NSDictionary *)getPenddingTermsAndCountWithSubstrings:(NSArray *)subStrings;
+ (NSDictionary *)filterSubStringWithPenddingTerms:(NSDictionary *)pendingTerms;
+ (NSArray *)getSortedTerms:(NSDictionary *)pendingTerms;

@end
