//
//  WordFreq.m
//
//  Created by Qing-Cheng Li on 12/10/15.
//

#import "WordFreq.h"
#import "ESImageSearchProduct.h"
#import "ESProduct.h"

static NSUInteger const minLength = 2;
static NSUInteger const maxLenght = 8;

@implementation WordFreq


+ (void)test
{
    NSString *testString = @"糖罐子雪紡縮口釦拼接針織衫24H快速出貨長袖T恤多色海狸絨保暖長袖T恤-嘉蒂斯24H快速出貨長袖T恤韓版圓領顯瘦加厚海狸絨長袖T恤-嘉蒂斯24H快速出貨刷毛大學T半高領多色寬鬆抓絨加厚長袖T恤刷毛帽T 學生純色寬鬆連帽厚刷棉質長袖大學T恤";
//    testString = @"糖罐子雪紡縮口釦";
    NSArray *result = [WordFreq getAllSubStrings:testString withMaxLenth:8];
//    NSLog(@"result->%@", result);
    NSDictionary *gg = [WordFreq getPenddingTermsAndCountWithSubstrings:result];
//    NSLog(@"result->%@", gg);
    gg = [WordFreq filterSubStringWithPenddingTerms:gg];
//    NSLog(@"result->%@", gg);
    NSArray *keys = [WordFreq getSortedTerms:gg];
    NSLog(@"RESULT==");
    for (NSString *term in keys) {
        NSLog(@"%@ -> %ld", term, [gg[term] unsignedIntegerValue]);
    }
    
}

+ (NSArray *)getAllSubStrings:(NSString *)string withMaxLenth:(NSUInteger)maxLength
{
//    NSLog(@"string = %@", string);
    NSMutableArray *result = [NSMutableArray array];
    
    NSUInteger i = MIN([string length], maxLength);
    do {
        NSRange range = NSMakeRange(0, i);
        NSString *subString = [string substringWithRange:range];
//        NSLog(@"==> %@", subString);
        [result addObject:subString];
    } while (--i >= minLength);

    if ([string length] > minLength) {
        
        NSArray *subResult = [WordFreq getAllSubStrings:[string substringFromIndex:1] withMaxLenth:maxLength];
        if ([subResult count] > 0) {
            [result addObjectsFromArray:subResult];
        }
    }
    
    return result;
}

+ (NSDictionary *)getPenddingTermsAndCountWithSubstrings:(NSArray *)subStrings
{
    NSMutableDictionary *penddingTerms = [NSMutableDictionary dictionary];
    for (NSString *subString in subStrings) {
        if (!penddingTerms[subString]) {
            penddingTerms[subString] = @(1);
        } else {
            penddingTerms[subString] = @([penddingTerms[subString] unsignedIntegerValue] + 1 );
        }
    }
    return penddingTerms;
}

+ (NSDictionary *)filterSubStringWithPenddingTerms:(NSDictionary *)pendingTerms
{
    NSMutableDictionary *filteredTerms = [pendingTerms mutableCopy];
    [pendingTerms enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *count, BOOL *stop) {
        
        if ([count unsignedIntegerValue] <= 1 || [key length] <= 1) {
            [filteredTerms removeObjectForKey:key];
        }
        
        NSArray *subStrings = [WordFreq getAllSubStrings:key withMaxLenth:8];
        for (NSString *subString in subStrings) {
            if ([subString isEqualToString:key]) {
                continue;
            }
            if (filteredTerms[subString] && [filteredTerms[subString] unsignedIntegerValue] == [count unsignedIntegerValue]) {
//                NSLog(@"remove %@", subString);
                [filteredTerms removeObjectForKey:subString];
            }
        }
    }];
    return filteredTerms;
}

+ (NSArray *)getSortedTerms:(NSDictionary *)pendingTerms
{
    return [pendingTerms keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber *value1, NSNumber *value2) {
        if ([value1 unsignedIntegerValue] < [value2 unsignedIntegerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([value1 unsignedIntegerValue] > [value2 unsignedIntegerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

@end
