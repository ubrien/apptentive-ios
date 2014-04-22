//
//  ATSurvey.h
//  ApptentiveSurveys
//
//  Created by Andrew Wooster on 11/5/11.
//  Copyright (c) 2011 Apptentive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATSurveyQuestion.h"

@interface ATSurvey : NSObject <NSCoding> {
@private
	NSMutableArray *questions;
}
@property (nonatomic, getter=isActive) BOOL active;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSDate *startTime;
@property (nonatomic, copy) NSDate *endTime;
@property (nonatomic, copy) NSNumber *viewCount;
@property (nonatomic, copy) NSNumber *viewPeriod;
@property (nonatomic, getter=responseIsRequired) BOOL responseRequired;
@property (nonatomic) BOOL multipleResponsesAllowed;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *surveyDescription;
@property (nonatomic, readonly) NSArray *questions;
@property (nonatomic, copy) NSString *successMessage;

- (void)addQuestion:(ATSurveyQuestion *)question;

- (BOOL)isEligibleToBeShown;

- (BOOL)isStarted;
- (BOOL)isEnded;
- (BOOL)isWithinViewLimits;

- (NSArray *)viewDates;
- (void)addViewDate:(NSDate *)viewDate;
- (void)removeAllViewDates;

- (void)reset;

@end
