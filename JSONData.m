//
//  JSONData.m
//  airthings
//
//  Created by hidden on 11-8-22.
//  Copyright 2011年 zzdhidden@gmail.com . All rights reserved.
//

#import "JSONData.h"

float JSONFloat(id value)
{
    if (value != [NSNull null]) {
        return [value floatValue];
    }else{
        return 0;
    }
}

NSInteger JSONInteger(id value)
{
    if (value != [NSNull null]) {
        return [value integerValue];
    }else{
        return 0;
    }
}

bool JSONBool(id value)
{
    if (value != [NSNull null]) {
        return [value boolValue];
    }else{
        return false;
    }
}

NSString *JSONString(id value)
{
    if (value != [NSNull null]) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        }
        return [value stringValue];
    }else{
        return nil;
    }
}

NSDictionary *JSONDictionary(id value)
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }else{
        return nil;
    }
}

NSArray *JSONArray(id value)
{
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }else{
        return nil;
    }
}

NSDate *JSONdate(id value)
{
    if (value != [NSNull null]) {
        if([value isKindOfClass:[NSString class]] && [value length] != 10){
            NSString *dateString = value;
            // Setup Date & Formatter
            NSDate *date = nil;
            NSDateFormatter *formatter = nil;
            if (!formatter) {
                NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                formatter = [[[NSDateFormatter alloc] init] autorelease];
                [formatter setLocale:en_US_POSIX];
                [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                [en_US_POSIX release];
            }
            
            /*
             *  RFC3339
             */
            
            NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
            RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
            
            // Remove colon in timezone as iOS 4+ NSDateFormatter breaks
            // See https://devforums.apple.com/thread/45837
            if (RFC3339String.length > 20) {
                RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":" 
                                                                         withString:@"" 
                                                                            options:0
                                                                              range:NSMakeRange(20, RFC3339String.length-20)];
            }
            
            if (!date) { // 1996-12-19T16:39:57-0800
                [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"]; 
                date = [formatter dateFromString:RFC3339String];
            }
            if (!date) { // 1937-01-01T12:00:27.87+0020
                [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"]; 
                date = [formatter dateFromString:RFC3339String];
            }
            if (!date) { // 1937-01-01T12:00:27
                [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"]; 
                date = [formatter dateFromString:RFC3339String];
            }
            if (date) return date;
            
            /*
             *  RFC822
             */
            
            NSString *RFC822String = [[NSString stringWithString:dateString] uppercaseString];
            if (!date) { // Sun, 19 May 02 15:21:36 GMT
                [formatter setDateFormat:@"EEE, d MMM yy HH:mm:ss zzz"]; 
                date = [formatter dateFromString:RFC822String];
            }
            if (!date) { // Sun, 19 May 2002 15:21:36 GMT
                [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"]; 
                date = [formatter dateFromString:RFC822String];
            }
            if (!date) {  // Sun, 19 May 2002 15:21 GMT
                [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"]; 
                date = [formatter dateFromString:RFC822String];
            }
            if (!date) {  // 19 May 2002 15:21:36 GMT
                [formatter setDateFormat:@"d MMM yyyy HH:mm:ss zzz"]; 
                date = [formatter dateFromString:RFC822String];
            }
            if (!date) {  // 19 May 2002 15:21 GMT
                [formatter setDateFormat:@"d MMM yyyy HH:mm zzz"]; 
                date = [formatter dateFromString:RFC822String];
            }
            if (!date) {  // 19 May 2002 15:21:36
                [formatter setDateFormat:@"d MMM yyyy HH:mm:ss"]; 
                date = [formatter dateFromString:RFC822String];
            }
            if (!date) {  // 19 May 2002 15:21
                [formatter setDateFormat:@"d MMM yyyy HH:mm"]; 
                date = [formatter dateFromString:RFC822String];
            }
            if (!date) {  // 2011年06月08日
                formatter = [[[NSDateFormatter alloc] init] autorelease];
                [formatter setDateFormat:@"yyyy'年'MM'月'dd'日'"]; 
                date = [formatter dateFromString:RFC822String];
            }
            if (date) return date;
            
            // Failed
            return nil;
        }else if([value isKindOfClass:[NSDate class]]){
            return value;
        }else{
            return [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
        }
        return nil;
    }else{
        return nil;
    }
}
