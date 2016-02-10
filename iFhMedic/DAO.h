//
//  DAO.h
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DAO : NSObject

+(sqlite3*)openDB:(NSString*) name db:(sqlite3*) dbtype;
+(NSInteger) getCustomerNumber:(sqlite3*) ptrDbType;
+(NSInteger) insertValue:(NSString*) tableName column:(NSString*) colName value:(NSString *) val DB:(sqlite3*) ptrDbType;
+(NSMutableArray*) loadUnits:(sqlite3*)ptrDbType Filter:(NSString*) _filter;
+(NSMutableArray*) loadUsers:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) loadActiveUsers:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) loadAllUsersFromUnit:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableDictionary*) ReadXInputTables:(sqlite3*)ptrDbType Filter:(NSString*) _filter;
+(NSInteger)updateXInputTable:(sqlite3*)ptrDbType Array:(NSMutableArray*)_array;
+(NSInteger)getQueueCount:(sqlite3*)ptrDbType;
+(NSInteger)getNewTicketID:(sqlite3*)ptrDbType;
+(NSInteger)createNewTicket:(sqlite3*)ptrDbType TicketID:(NSInteger) ticketID TicketPractice:(NSInteger) ticketPractice TicketGUID:(NSString*) uuid;
+(NSInteger) insertDataToQueue:(sqlite3*)ptrDbType Table:(NSString*) table TicketID:(NSInteger) ticketID Data:(NSMutableDictionary*) data;
+(NSInteger)addChangeQueEntry:(sqlite3*)ptrDbType TicketID:(NSInteger) ticketID Table:(NSString*) table ColName:(NSString*) colName ColValue:(NSString*) colValue;
+(NSMutableArray*) getQueueItemsToUpload:(sqlite3*)ptrDbType;
+(NSMutableArray*)loadIncidentInfo:(sqlite3*)ptrDbType Sql:(NSString*) querySQL WithExtraInfo:(Boolean) info;
+(NSInteger) ticketIDExist:(sqlite3*)ptrDbType Table:(NSString*) table TicketID:(NSString*) ticketID;

+(NSMutableDictionary*) executeSelectTicketInputsData:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSInteger) executeInsert:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSInteger) executeUpdate:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectTickets:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectTicketInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSInteger) getCount:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectChiefComplaints:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableDictionary*) selectTicketInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectTreatments:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectSignatures:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectDrugs:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+ (id)getViewFromXib:(NSString *)sNibName classname:(Class)ClassName;
+ (NSString*) getPatientName:(NSString*) ticketID db:(sqlite3*) ptrDbType;
+(NSMutableArray*)loadAssesmentInfo:(sqlite3*)ptrDbType Sql:(NSString*) querySQL WithExtraInfo:(Boolean) info;
+ (NSString*) getInsuredName:(NSString*) ticketID db:(sqlite3*) ptrDbType;
+ (NSString*) getInsuredDOB:(NSString*) ticketID db:(sqlite3*) ptrDbType;
+(NSMutableDictionary*) executeSelectTicketAssesmentInputsData:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+ (NSMutableDictionary*) executeSelectInputValue:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+ (NSString*) executeSelectRequiredInput:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+ (NSInteger)executeDelete:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*)loadInputLookupInfo:(sqlite3*)ptrDbType Sql:(NSString*) querySQL WithExtraInfo:(Boolean) info;
+ (NSInteger) saveImage:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectTicketAttachments:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectTicketSignatures:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+ (NSString*) getPatientSSNFromTickeID:(NSString*) ticketID db:(sqlite3*) ptrDbType;
+ (NSString*) getPatientNameFromTickeID:(NSString*) ticketID db:(sqlite3*) ptrDbType;
+(NSInteger) insertCustomer:(NSString*) sql DB:(sqlite3*) ptrDbType;
+(NSMutableArray*) executeSelectTreatmentInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectTicketFormsInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql;

+(NSInteger) getCountWithCheck:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSInteger) getInstance:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(void) executeCleanup:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSString*) executeSelectNarcoticInput:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(void) executeLoadSettings:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSString*) executeSelectInputIds:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSString*) executeSelectScalar:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectTicketNotes:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) executeSelectTicketChanges:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) selectSignatureTypes:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSInteger)createNewTicketForCopy:(sqlite3*)ptrDbType TicketID:(NSInteger)ticketID TicketPractice:(NSInteger) ticketPractice TicketGUID:(NSString*) uuid;
+(NSMutableDictionary*) selectTicketInputsInstance:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) selectInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSInteger) insertUpdate:(sqlite3*)ptrDbType InsertSql:(NSString*) insertSql UpdateSql:(NSString*) updateSql;
+(NSMutableArray*) selectVitalInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) SelectInputsData:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableArray*) SelectInputsAssessment:(sqlite3*)ptrDbType Sql:(NSString*) sql;
+(NSMutableDictionary*) SelectInputsVital:(sqlite3*)ptrDbType Sql:(NSString*) sql;
@end


