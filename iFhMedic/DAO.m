//  DAO.m
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "global.h"
#import "DAO.h"
#import "ServiceSvc.h"
#import "ClsUnits.h"
#import "ClsUsers.h"
#import "ClsXInputTables.h"
#import "ClsChangeQue.h"
#import "ClsTableKey.h"
#import "ClsTickets.h"
#import "ClsTicketInputs.h"
#import "ClsChiefComplaints.h"
#import "ClsTreatments.h"
#import "ClsSignatureImages.h"
#import "ClsDrugs.h"
#import "ClsInputLookup.h"
#import "ClsTicketAttachments.h"
#import "ClsTicketSignatures.h"
#import "ClsCrewInfo.h"
#import "ClsTreatmentInputs.h"
#import "ClsTicketFormsInputs.h"
#import "ClsTicketNotes.h"
#import "ClsTicketChanges.h"
#import "ClsSignatureTypes.h"
#import "ClsInputs.h"

extern NSMutableDictionary* g_SETTINGS;

@implementation DAO


+(sqlite3*)openDB:(NSString*) name db:(sqlite3*) ptrDbtype;
{
    NSError *error = nil;   
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString* docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:name]];

    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:databasePath]];

    const char *dbpath = [databasePath UTF8String];
    NSFileManager*  filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:databasePath] == NO)
    {
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:name
                                                                  ofType:nil];
        BOOL success = [filemgr copyItemAtPath:defaultDBPath
                                            toPath:databasePath
                                             error:&error];
        if (!success)
        {
            NSCAssert1(0, @"Failed to create writable database file with message '%@'.", [  error localizedDescription]);
            return 0;
        }
        
    }

    sqlite3_open(dbpath, &ptrDbtype);
 
    return ptrDbtype;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL

{
    
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    
    
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                    
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
        
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        
    }
    
    return success;
    
}

+(NSInteger) insertValue:(NSString*) tableName column:(NSString*) colName value:(NSString *) val DB:(sqlite3*) ptrDbType
{
    sqlite3_stmt    *statement;
    NSInteger customerNum = 0;
    
    NSString *querySQL = [NSString stringWithFormat:
                          @"Insert into %@(%@) values(\"%@\")", tableName, colName, val];
    
    const char *query_stmt = [querySQL UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);

    if (result == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_DONE)
        {

        }
    }
    sqlite3_finalize(statement);
    return customerNum;
    
}

+(NSInteger) insertCustomer:(NSString*) sql DB:(sqlite3*) ptrDbType
{
    sqlite3_stmt    *statement;
    NSInteger customerNum = 0;

    
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    
    if (result == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
        }
    }
    sqlite3_finalize(statement);
    return customerNum;
}

+(NSInteger) getCustomerNumber:(sqlite3*) ptrDbType
{
    sqlite3_stmt    *statement;
    NSInteger customerNum = 0;
    
    NSString *querySQL = [NSString stringWithFormat:
                          @"select max(CustomerNumber) as CustomerNumber from Customer Limit 1"];
    
    const char *query_stmt = [querySQL UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            customerNum = (int)sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    return customerNum;
}

+(NSMutableArray*) loadUnits:(sqlite3*)ptrDbType Filter:(NSString*) _filter
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;

    @try {
        NSMutableString *querySQL = [NSMutableString stringWithString:@"select * from Units"];
        
        if ([_filter length] != 0)
        {
            [querySQL appendString:[NSString stringWithFormat:@" %@ %@", @" where " , _filter]];
        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ClsUnits* unit= [[ClsUnits alloc] init];
                unit.unitID = (int)sqlite3_column_int(statement, 0);
                unit.unitDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                unit.stationID = (int)sqlite3_column_int(statement, 2);
                unit.regionID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                unit.unitType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                [array addObject:unit];
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {

    }
    @finally {

    }
    return array;
    
}

//----------------------------------------------------------------------------
+(NSMutableArray*) loadTicketCrew:(sqlite3*)ptrDbType Filter:(NSString*) _filter
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    
    @try {
        NSMutableString *querySQL = [NSMutableString stringWithString:@"select * from Units"];
        
        if ([_filter length] != 0)
        {
            [querySQL appendString:[NSString stringWithFormat:@" %@ %@", @" where " , _filter]];
        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString* strTicketCrew = [[NSString alloc] init];
                strTicketCrew = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [array addObject:strTicketCrew];
                strTicketCrew = nil;
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return array;
    
}
//----------------------------------------------------------------------------

+(NSMutableArray*) loadUsers:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    
    @try {
        const char *query_stmt = [sql UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ClsUsers* user = [[ClsUsers alloc] init];
                user.userID = (int)sqlite3_column_int(statement, 0);
                user.userFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                user.userLastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                user.userUnit = (int)sqlite3_column_int(statement, 8);
                user.userPassword = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                
                char* localityChars = (char *)sqlite3_column_text(statement, 16);
                if (localityChars == NULL)
                    user.userIDNumber = @"";
                else
                    user.userIDNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                [array addObject:user];
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return array;
    
}

//@"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserUnit, u.UserActive from users where UserUnit = %d", unitSelected];
//loadAllUsersFromUnit
+(NSMutableArray*) loadAllUsersFromUnit:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    
    @try {
        const char *query_stmt = [sql UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ClsUsers* user = [[ClsUsers alloc] init];
                user.userID = (int)sqlite3_column_int(statement, 0);
                user.userFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                user.userLastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                user.userUnit = (int)sqlite3_column_int(statement, 3);
                user.userActive    = (int)sqlite3_column_int(statement, 4);
                [array addObject:user];
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return array;
    
}




// UserID, UserFirstname, UserLastName, UserUnit, UserActive from users where UserUnit
+(NSMutableArray*) loadActiveUsers:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    
    @try {
        const char *query_stmt = [sql UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ClsUsers* user = [[ClsUsers alloc] init];
                user.userID = (int)sqlite3_column_int(statement, 0);
                user.userFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                user.userLastName  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                user.userUnit      = (int)sqlite3_column_int(statement, 3);
                user.userActive    = (int)sqlite3_column_int(statement, 4);
                [array addObject:user];
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return array;
    
}



+(NSMutableArray*)loadIncidentInfo:(sqlite3*)ptrDbType Sql:(NSString*) querySQL WithExtraInfo:(Boolean) info
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    
    @try {
        
        const char *query_stmt = [querySQL UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ClsTableKey* table = [[ClsTableKey alloc] init];
                table.key = (int)sqlite3_column_int(statement, 0);
                table.tableName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                //NSString *ad = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                table.desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                if (info == YES)
                {
                    NSMutableArray* additionalInfo = [[NSMutableArray alloc] init];
                    if ((char *)sqlite3_column_text(statement, 3) != NULL)
                    {
                        [additionalInfo addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                    }
                    if ((char *)sqlite3_column_text(statement, 4) != NULL)
                    {
                        [additionalInfo addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                    }
                    if ((char *)sqlite3_column_text(statement, 5) != NULL)
                    {
                        [additionalInfo addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
                    }
                    if ((char *)sqlite3_column_text(statement, 6) != NULL)
                    {
                        [additionalInfo addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                    }
                    table.additionalInfo = additionalInfo;
                }
                [array addObject:table];
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return array;
}



+(NSMutableArray*)loadAssesmentInfo:(sqlite3*)ptrDbType Sql:(NSString*) querySQL WithExtraInfo:(Boolean) info
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    
    @try {
        
        const char *query_stmt = [querySQL UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ClsTableKey* table = [[ClsTableKey alloc] init];
                table.key = (int)sqlite3_column_int(statement, 0);
                table.tableName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                //NSString *ad = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                table.desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                table.tableID =  (int)sqlite3_column_int(statement, 3);
                if (info == YES)
                {
                    NSMutableArray* additionalInfo = [[NSMutableArray alloc] init];
                    if ((char *)sqlite3_column_text(statement, 4) != NULL)
                    {
                        [additionalInfo addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                    }
                    if ((char *)sqlite3_column_text(statement, 5) != NULL)
                    {
                        [additionalInfo addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                    }
                    if ((char *)sqlite3_column_text(statement, 6) != NULL)
                    {
                        [additionalInfo addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
                    }
                    if ((char *)sqlite3_column_text(statement, 7) != NULL)
                    {
                        [additionalInfo addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                    }
                    table.additionalInfo = additionalInfo;
                }
                [array addObject:table];
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return array;
}



+(NSMutableDictionary*) ReadXInputTables:(sqlite3*)ptrDbType Filter:(NSString*) _filter
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    sqlite3_stmt    *statement;
    
    @try {
        NSMutableString *querySQL = [NSMutableString stringWithString:@"select * from xInputTables"];
        
        if ([_filter length] != 0)
        {
            [querySQL appendString:[NSString stringWithFormat:@" %@ %@", @" where " , _filter]];
        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ClsXInputTables* table = [[ClsXInputTables alloc] init];

                table.it_TableName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                table.it_HashCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                if (table.it_HashCode.length < 1)
                {
                    table.it_HashCode = @" ";
                }
                [dict setObject:table.it_HashCode forKey:table.it_TableName];
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return dict;
    
}

+(NSInteger)updateXInputTable:(sqlite3*)ptrDbType Array:(NSMutableArray*)_array
{
    int result = 0;
    sqlite3_stmt    *statement;
    
    @try
    {
        for (int i=0; i < [_array count]; i++)
        {
            ServiceSvc_ClsXInputTables* record = [_array objectAtIndex:i];
            NSString* tableName = [record valueForKey:@"IT_TableName"];
            NSString* hashCode = [record valueForKey:@"IT_HashCode"];
            NSMutableString *querySQL = [NSMutableString stringWithFormat:@"Update XINPUTTABLES set %@ = %@", tableName, hashCode];

            
            const char *query_stmt = [querySQL UTF8String];
            
            int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
            if (result == SQLITE_OK)
            {
                sqlite3_step(statement);

            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
    }
    @catch (NSException *exception)
    {
        result = -1;
    }
    @finally
    {
        
    }
   
    return result;
}


+(NSInteger)getQueueCount:(sqlite3*)ptrDbType
{
    int count = 0;
    sqlite3_stmt    *statement;
    
    NSString *querySQL = [NSString stringWithFormat:
                          @"select count(ChangeID) from ChangeQue"];
    
    const char *query_stmt = [querySQL UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            count = (int)sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    return count;
}

+(NSInteger)getNewTicketID:(sqlite3 *)ptrDbType
{
    int count = 0;
    sqlite3_stmt    *statement;
    @try {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select SeqID from TicketSequence where TableName = 'Tickets'"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                count = (int)sqlite3_column_int(statement, 0);
            }
        }
        sqlite3_finalize(statement);
        
        querySQL = [NSString stringWithFormat:
                    @"Update TicketSequence set SEQID = %d where TableName = 'Tickets'", count + 1];
        query_stmt = [querySQL UTF8String];
        
        result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            sqlite3_step(statement);
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    @catch (NSException *exception) {
        
    }
    
    return -count;
}

+(NSInteger) getCount:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    int count = 0;
    sqlite3_stmt    *statement;
    @try {

        const char *query_stmt = [sql UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                count = (int)sqlite3_column_int(statement, 0);
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    return count;
}


+(NSInteger)createNewTicket:(sqlite3*)ptrDbType TicketID:(NSInteger)ticketID TicketPractice:(NSInteger) ticketPractice TicketGUID:(NSString*) uuid
{
    NSInteger result = 0;
    
    
    @try {
        sqlite3_stmt *statement;
        
        NSString* header = @"INSERT INTO TICKETS (TICKETID,TICKETGUID,TICKETINCIDENTNUMBER,TICKETDESC,TICKETDOS,TICKETSTATUS,TICKETOWNER,TICKETCREATOR,TICKETUNITNUMBER,TICKETFINALIZED, TICKETCREW,TICKETPRACTICE,TICKETCREATEDTIME, TicketShift, IsUploaded) Values(";
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
        
        NSString* ticketOwner = [g_SETTINGS objectForKey:@"UserID"];
        NSString* unit = [g_SETTINGS objectForKey:@"Unit"];
        NSMutableString* crewIDs = [[NSMutableString alloc] init];
        for (int i = 0; i< [g_CREWARRAY count]; i++ )
        {
            ClsCrewInfo* crew = [g_CREWARRAY objectAtIndex:i];

            if (i == [g_CREWARRAY count] - 1)
            {
                [crewIDs appendString:[NSString stringWithFormat:@"%@", crew.id]];
            }
            else
            {
                [crewIDs appendString:[NSString stringWithFormat:@"%@|", crew.id]];
            }
            
        }
        NSString* ticketCrew = [NSString stringWithFormat:@"%@", ticketOwner];
        
        NSString* shift = [g_SETTINGS objectForKey:@"ShiftID"];
        if ([shift length] < 1)
        {
            shift = 0;
        }
        
        NSString* querySQL = [NSString stringWithFormat:@"%@ %d, '%@', '%@', '%@', '%@', %d, %d, %d, %d, %d, '%@', %d, '%@', %@, 0)", header, ticketID, uuid, @"", @"", dateString,  1, [ticketOwner intValue], [ticketOwner intValue], [unit intValue], 0, crewIDs, ticketPractice, dateString, shift];
        
        const char *query_stmt = [querySQL UTF8String];
        
        result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        
        if (result == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                
            }
        }
        sqlite3_finalize(statement);
        

        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

    
    return result;
}

+(NSInteger)createNewTicketForCopy:(sqlite3*)ptrDbType TicketID:(NSInteger)ticketID TicketPractice:(NSInteger) ticketPractice TicketGUID:(NSString*) uuid
{
    NSInteger result = 0;
    
    
    @try {
        sqlite3_stmt *statement;
        
        NSString* header = @"INSERT INTO TICKETS (TICKETID,TICKETGUID,TICKETINCIDENTNUMBER,TICKETDESC,TICKETDOS,TICKETSTATUS,TICKETOWNER,TICKETCREATOR,TICKETUNITNUMBER,TICKETFINALIZED, TICKETCREW,TICKETPRACTICE,TICKETCREATEDTIME, TicketShift, IsUploaded) Values(";
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
        
        NSString* ticketOwner = [g_SETTINGS objectForKey:@"UserID"];
        NSString* unit = [g_SETTINGS objectForKey:@"Unit"];
        NSMutableString* crewIDs = [[NSMutableString alloc] init];
        for (int i = 0; i< [g_CREWARRAY count]; i++ )
        {
            ClsCrewInfo* crew = [g_CREWARRAY objectAtIndex:i];
            
            if (i == [g_CREWARRAY count] - 1)
            {
                [crewIDs appendString:[NSString stringWithFormat:@"%@", crew.id]];
            }
            else
            {
                [crewIDs appendString:[NSString stringWithFormat:@"%@|", crew.id]];
            }
            
        }
        
        NSString* shift = [g_SETTINGS objectForKey:@"Shift"];
        if ([shift length] < 1)
        {
            shift = 0;
        }
        
        NSString* querySQL = [NSString stringWithFormat:@"%@ %ld, '%@', '%@', '%@', '%@', %d, %d, %d, %d, %d, '%@', %ld, '%@', %@, 1)", header, ticketID, uuid, @"", @"", dateString,  1, [ticketOwner intValue], [ticketOwner intValue], [unit intValue], 0, crewIDs, ticketPractice, dateString, shift];
        
        const char *query_stmt = [querySQL UTF8String];
        
        result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        
        if (result == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                
            }
        }
        sqlite3_finalize(statement);
        
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    return result;
}



+(NSInteger) insertDataToQueue:(sqlite3*)ptrDbType Table:(NSString*) table TicketID:(NSInteger) ticketID Data:(NSMutableDictionary*) data
{
    NSInteger result = 0;
    
    for (id key in data)
    {
        [self addChangeQueEntry:ptrDbType TicketID:ticketID Table:table ColName:key ColValue:[data objectForKey:key]];
    }
        
    return result;
}

+(NSInteger)addChangeQueEntry:(sqlite3*)ptrDbType TicketID:(NSInteger) ticketID Table:(NSString*) table ColName:(NSString*) colName ColValue:(NSString*) colValue
{
    NSInteger result = 0;
    
    sqlite3_stmt    *statement;
    
    NSString* header = @"INSERT INTO ChangeQue(TABLENAME,TICKETID,TICKETGUID,IDX1,IDX2,IDX3,FIELDNAME,VALUE, DEL,DATEMODIFIED) Values(";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    NSInteger IDX1 = 0;
    NSInteger IDX2 = 0;
    NSInteger IDX3 = 0;
    
    NSString* ticketGUID = [g_SETTINGS objectForKey:@"currentTicketGUID"];
    if ([table isEqualToString:@"Tickets"])
    {
        IDX1 = 0;
        IDX2 = 0;
    }
    
    NSString* DEL = @"";
    
    NSString *querySQL = [NSString stringWithFormat:@"%@ '%@', %d, '%@', %d, %d, %d, '%@', '%@', '%@', '%@')", header, table, ticketID, ticketGUID, IDX1, IDX2, IDX3, colName, colValue,DEL,dateString];
    
    const char *query_stmt = [querySQL UTF8String];
    
    result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    
    if (result == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
        }
    }
    sqlite3_finalize(statement);
    
    
    
    return result;
}


+(NSMutableArray*) getQueueItemsToUpload:(sqlite3*)ptrDbType
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    
    @try {
        NSMutableString *querySQL = [NSMutableString stringWithString:@"select * from ChangeQue"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ClsChangeQue* changeQue = [[ClsChangeQue alloc] init];
                changeQue.changeID = (int)sqlite3_column_int(statement, 0);
                changeQue.tableName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                changeQue.localTicketID = (int)sqlite3_column_int(statement, 2);
                changeQue.ticketID = (int)sqlite3_column_int(statement, 3);
                changeQue.ticketGUID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                changeQue.iDX1 = (int)sqlite3_column_int(statement, 5);
                changeQue.iDX2 = (int)sqlite3_column_int(statement, 6);
                changeQue.iDX3 = (int)sqlite3_column_int(statement, 7);
                changeQue.fieldName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                changeQue.value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                changeQue.inputInstance = (int)sqlite3_column_int(statement, 10);
                changeQue.inputSubID= (int)sqlite3_column_int(statement, 11);
                
                
                char *localityChars = (char *)sqlite3_column_text(statement, 12);
                
                if (localityChars == NULL)
                    changeQue.inputPage = nil;
                else
                    changeQue.inputPage = [NSString stringWithUTF8String: localityChars];
                
                changeQue.del = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                changeQue.dataModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                [array addObject:changeQue];
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return array;
}

+(NSInteger) ticketIDExist:(sqlite3*)ptrDbType Table:(NSString*) table TicketID:(NSString*) ticketID
{
    sqlite3_stmt    *statement;
    NSInteger result = 0;
    
    NSString *querySQL = [NSString stringWithFormat:
                          @"select count(*) from %@ where TicketID = %@", table, ticketID];
    
    const char *query_stmt = [querySQL UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            result = (int)sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    return result;
}


+ (NSInteger)executeDelete:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt *deleteStatement;
    NSInteger result = 0;
    
    
    const char *query_stmt = [sql UTF8String];
    
    result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &deleteStatement, NULL);
    if (result == SQLITE_OK)
    {
        if (sqlite3_step(deleteStatement) == SQLITE_DONE)
        {
            
        }
    }
    sqlite3_finalize(deleteStatement);
    return result;

  

}


+(NSInteger) executeInsert:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSInteger result = 0;
    
    
    const char *query_stmt = [sql UTF8String];
    
    result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    
    if (result == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
        }
    }
    sqlite3_finalize(statement);
    return result;
}

+(NSInteger) executeUpdate:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSInteger result = 0;
    
    
    const char *query_stmt = [sql UTF8String];
    
    result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    
    if (result == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
        }
    }
    sqlite3_finalize(statement);
    return result;
}

+(NSInteger) insertUpdate:(sqlite3*)ptrDbType InsertSql:(NSString*) insertSql UpdateSql:(NSString*) updateSql
{
    sqlite3_stmt    *statement;
    NSInteger result = 0;
    
    
    const char *query_stmt = [insertSql UTF8String];
    
    result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    
    if (result == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
        }
    }
    sqlite3_finalize(statement);
    result = sqlite3_changes(ptrDbType);
    if (result == 0)
    {
        sqlite3_stmt    *statementUpdate;
        
        const char *query_stmtUpdate = [updateSql UTF8String];
        
        result = sqlite3_prepare_v2(ptrDbType, query_stmtUpdate, -1, &statementUpdate, NULL);
        
        if (result == SQLITE_OK)
        {
            if (sqlite3_step(statementUpdate) == SQLITE_DONE)
            {
                
            }
        }
        sqlite3_finalize(statementUpdate);
    }
    return result;
}

+(NSMutableArray*)loadInputLookupInfo:(sqlite3*)ptrDbType Sql:(NSString*) querySQL WithExtraInfo:(Boolean) info
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    
    @try {
        
        const char *query_stmt = [querySQL UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ClsInputLookup* table = [[ClsInputLookup alloc] init];
                table.inputId = (int)sqlite3_column_int(statement, 0);
                table.valueId = (int)sqlite3_column_int(statement, 1);

                table.valueName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                table.excludeAllCC = (int)sqlite3_column_int(statement, 3);
                table.sortIndex = (int)sqlite3_column_int(statement, 4);
                
                [array addObject:table];
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return array;
}


+(NSMutableDictionary*) executeSelectTicketInputsData:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        int rowCount = 0;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            if (rowCount == 0)
            {
                NSInteger ticketID = sqlite3_column_int(statement, 1);
                NSString* ticketGUID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSInteger ticketPractice = sqlite3_column_int(statement, 7);
                NSString* ticketCrew = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [dict setObject:[NSString stringWithFormat:@"%d", ticketID] forKey:@"TicketID"];
                if (ticketGUID != nil)
                    [dict setObject:ticketGUID forKey:@"TicketGUID"];
                if (ticketCrew != nil)
                    [dict setObject:ticketCrew forKey:@"TicketCrew"];
                if (ticketPractice == 1)
                {
                    [dict setObject:@"Practice:"forKey:@"TicketPractice"];
                }
                
                rowCount++;
            }
            
            NSInteger inputID = sqlite3_column_int(statement, 10);
            NSInteger inputSubID = sqlite3_column_int(statement, 11);
            NSInteger inputInstance = sqlite3_column_int(statement, 12);
            NSString* value;
            char *localityChars = (char *)sqlite3_column_text(statement, 15);
            if (localityChars == NULL)
                value = @" ";
            else
                value = [NSString stringWithUTF8String: localityChars];
            
            if ((inputID >= 2001) && (inputID < 2099) && (inputSubID == -1) )
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 13);
                if (localityChars == NULL)
                    value = @" ";
                else
                    value = [NSString stringWithUTF8String: localityChars];
                [dict setObject:value forKey:[NSString stringWithFormat:@"%d:%d:%d", inputID, inputSubID, inputInstance]];

            }
            else
            {
                [dict setObject:value forKey:[NSString stringWithFormat:@"%d:%d:%d", inputID, inputSubID, inputInstance]];

            }
        }
    }
    sqlite3_finalize(statement);
    return dict;
}

+(NSMutableDictionary*) executeSelectTicketAssesmentInputsData:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        int rowCount = 0;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            if (rowCount == 0)
            {
                NSInteger ticketID = sqlite3_column_int(statement, 1);
                NSString* ticketGUID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSInteger ticketPractice = sqlite3_column_int(statement, 7);
                NSString* ticketCrew = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [dict setObject:[NSString stringWithFormat:@"%d", ticketID] forKey:@"TicketID"];
                if (ticketGUID != nil)
                   [dict setObject:ticketGUID forKey:@"TicketGUID"];
                if (ticketCrew != nil)
                    [dict setObject:ticketCrew forKey:@"TicketCrew"];
                if (ticketPractice == 1)
                {
                    [dict setObject:@"Practice:"forKey:@"TicketPractice"];
                }
                
                rowCount++;
            }
            
            NSInteger inputID = sqlite3_column_int(statement, 10);
            NSInteger inputSubID = sqlite3_column_int(statement, 11);
            NSInteger inputInstance = sqlite3_column_int(statement, 12);
            NSString* value;
            char *localityChars = (char *)sqlite3_column_text(statement, 15);
            if (localityChars == NULL)
                value = @" ";
            else
                value = [NSString stringWithUTF8String: localityChars];
            
            if ((inputID >= 2001) && (inputID < 2099) && (inputSubID == -1) )
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 13);
                if (localityChars == NULL)
                    value = @" ";
                else
                    value = [NSString stringWithUTF8String: localityChars];
                //[dict setObject:value forKey:[NSString stringWithFormat:@"%d:%d:%d", inputID, inputSubID, inputInstance]];
                [dict setObject:value forKey:[NSString stringWithFormat:@"%d", inputID]];
                
            }
            else
            {
                //[dict setObject:value forKey:[NSString stringWithFormat:@"%d:%d:%d", inputID, inputSubID, inputInstance]];
                [dict setObject:value forKey:[NSString stringWithFormat:@"%d", inputID]];
                
            }
        }
    }
    sqlite3_finalize(statement);
    return dict;
}


+(NSMutableArray*) executeSelectTickets:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {   //TicketID, TicketIncidentNumber, TicketDesc, TicketDOS, TicketStatus, TicketUnitNumber
            ClsTickets* ticket = [[ClsTickets alloc] init];
            ticket.ticketID = (int)sqlite3_column_int(statement, 1);

            char *localityChars = (char *)sqlite3_column_text(statement, 2);
            if (localityChars == NULL)
                ticket.TicketGUID = nil;
            else
                ticket.TicketGUID = [NSString stringWithUTF8String: localityChars];

            localityChars = (char *)sqlite3_column_text(statement, 3);
            if (localityChars == NULL)
                ticket.ticketIncidentNumber = nil;
            else
                ticket.ticketIncidentNumber = [NSString stringWithUTF8String: localityChars];
            
            
            localityChars = (char *)sqlite3_column_text(statement, 4);
            if (localityChars == NULL)
                ticket.ticketDesc = nil;
            else
                ticket.ticketDesc = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 5);
            if (localityChars == NULL)
                ticket.ticketDOS = nil;
            else
                ticket.ticketDOS = [NSString stringWithUTF8String: localityChars];
 
            
            ticket.ticketStatus = (int)sqlite3_column_int(statement, 6);
            
            ticket.ticketOwner = (int)sqlite3_column_int(statement, 7);
            
            ticket.ticketCreator = (int)sqlite3_column_int(statement, 8);

            ticket.ticketUnitNumber = (int)sqlite3_column_int(statement, 9);

            ticket.ticketFinalized = (int)sqlite3_column_int(statement, 10);
            
            localityChars = (char *)sqlite3_column_text(statement, 11);
            if (localityChars == NULL)
                ticket.ticketDateFinalized = nil;
            else
                ticket.ticketDateFinalized = [NSString stringWithUTF8String: localityChars];
 
            localityChars = (char *)sqlite3_column_text(statement, 12);
            if (localityChars == NULL)
                ticket.ticketCrew = nil;
            else
                ticket.ticketCrew = [NSString stringWithUTF8String: localityChars];

            ticket.ticketPractice = (int)sqlite3_column_int(statement, 13);

            localityChars = (char *)sqlite3_column_text(statement, 14);
            if (localityChars == NULL)
                ticket.ticketCreatedTime = nil;
            else
                ticket.ticketCreatedTime = [NSString stringWithUTF8String: localityChars];
            
            
            localityChars = (char*) sqlite3_column_text(statement, 15);
            if (localityChars == NULL)
            {
                
            }
            else
                ticket.TicketShift = (int)sqlite3_column_int(statement, 15);
            
            localityChars = (char*) sqlite3_column_text(statement, 16);
            if (localityChars == NULL)
            {
                
            }
            else
                ticket.ticketLocked = (int)sqlite3_column_int(statement, 16);
            
            localityChars = (char*) sqlite3_column_text(statement, 17);
            if (localityChars == NULL)
            {
                
            }
            else
                ticket.ticketReviewed = (int)sqlite3_column_int(statement, 17);

            localityChars = (char*) sqlite3_column_text(statement, 18);
            if (localityChars == NULL)
            {
                
            }
            else
                ticket.ticketAccount = (int)sqlite3_column_int(statement, 18);
            
            localityChars = (char *)sqlite3_column_text(statement, 19);
            if (localityChars == NULL)
                ticket.ticketAdminNotes= nil;
            else
                ticket.ticketAdminNotes = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 20);
            if (localityChars == NULL)
                ticket.ticketType= nil;
            else
                ticket.ticketType = [NSString stringWithUTF8String: localityChars];
            
            [array addObject:ticket];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}


+(NSMutableArray*) executeSelectTicketInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsTicketInputs* ticketInputs = [[ClsTicketInputs alloc] init];
            ticketInputs.localTicketId = (int)sqlite3_column_int(statement, 0);
            ticketInputs.ticketId = (int)sqlite3_column_int(statement, 1);
            ticketInputs.inputId = (int)sqlite3_column_int(statement, 2);
            ticketInputs.inputSubId = (int)sqlite3_column_int(statement, 3);
            ticketInputs.inputInstance = (int)sqlite3_column_int(statement, 4);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 5);
            if (localityChars == NULL)
                ticketInputs.inputPage = nil;
            else
                ticketInputs.inputPage = [NSString stringWithUTF8String: localityChars];
           
            localityChars = (char *)sqlite3_column_text(statement, 6);
            if (localityChars == NULL)
                ticketInputs.inputName = nil;
            else
                ticketInputs.inputName = [NSString stringWithUTF8String: localityChars];
 
            localityChars = (char *)sqlite3_column_text(statement, 7);
            if (localityChars == NULL)
                ticketInputs.inputValue = nil;
            else
                ticketInputs.inputValue = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char*) sqlite3_column_text(statement, 8);
            if (localityChars == NULL)
            {
                
            }
            else
                ticketInputs.deleted = (int)sqlite3_column_int(statement, 9);
            
            localityChars = (char*) sqlite3_column_text(statement, 10);
            if (localityChars == NULL)
            {
                
            }
            else
                ticketInputs.modified = (int)sqlite3_column_int(statement, 10);
            
            [array addObject:ticketInputs];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableArray*) executeSelectTreatmentInputValues:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsTicketInputs* ticketInputs = [[ClsTicketInputs alloc] init];
            ticketInputs.localTicketId = (int)sqlite3_column_int(statement, 0);
            ticketInputs.ticketId = (int)sqlite3_column_int(statement, 1);
            ticketInputs.inputId = (int)sqlite3_column_int(statement, 2);
            ticketInputs.inputSubId = (int)sqlite3_column_int(statement, 3);
            ticketInputs.inputInstance = (int)sqlite3_column_int(statement, 4);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 5);
            if (localityChars == NULL)
                ticketInputs.inputPage = nil;
            else
                ticketInputs.inputPage = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 6);
            if (localityChars == NULL)
                ticketInputs.inputName = nil;
            else
                ticketInputs.inputName = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 7);
            if (localityChars == NULL)
                ticketInputs.inputValue = nil;
            else
                ticketInputs.inputValue = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char*) sqlite3_column_text(statement, 8);
            if (localityChars == NULL)
            {
                
            }
            else
                ticketInputs.deleted = (int)sqlite3_column_int(statement, 9);
            
            localityChars = (char*) sqlite3_column_text(statement, 10);
            if (localityChars == NULL)
            {
                
            }
            else
                ticketInputs.modified = (int)sqlite3_column_int(statement, 10);
            
            [array addObject:ticketInputs];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}



+(NSMutableArray*) executeSelectChiefComplaints:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsChiefComplaints* complaints = [[ClsChiefComplaints alloc] init];
            complaints.ccID = (int)sqlite3_column_int(statement, 0);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                complaints.ccDescription = nil;
            else
                complaints.ccDescription = [NSString stringWithUTF8String: localityChars];
            
            complaints.ccUserDefined = (int)sqlite3_column_int(statement, 2);
            
            complaints.ccType = (int)sqlite3_column_int(statement, 3);
            
            [array addObject:complaints];
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableArray*) executeSelectTreatments:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsTreatments* treatment = [[ClsTreatments alloc] init];
            treatment.treatmentID = (int)sqlite3_column_int(statement, 0);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                treatment.treatmentDesc = nil;
            else
                treatment.treatmentDesc = [NSString stringWithUTF8String: localityChars];
            localityChars = (char *)sqlite3_column_text(statement, 2);
            if (localityChars == NULL)
                treatment.drugName = nil;
            else
                treatment.drugName = [NSString stringWithUTF8String: localityChars];
            treatment.treatmentFilter = (int)sqlite3_column_int(statement, 2);
            treatment.Active = (int)sqlite3_column_int(statement, 3);
            treatment.SortIndex = (int)sqlite3_column_int(statement, 4);
            
            [array addObject:treatment];
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableArray*) executeSelectTreatmentInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsTreatmentInputs* treatment = [[ClsTreatmentInputs alloc] init];
            treatment.inputID = (int)sqlite3_column_int(statement, 0);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                treatment.inputName = nil;
            else
                treatment.inputName = [NSString stringWithUTF8String: localityChars];
            
            treatment.inputDataType = (int)sqlite3_column_int(statement, 2);
            treatment.inputRequired = (int)sqlite3_column_int(statement, 3);
            [array addObject:treatment];
        }
    }
    sqlite3_finalize(statement);
    return array;
}


+(NSMutableArray*) executeSelectDrugs:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsDrugs* drug = [[ClsDrugs alloc] init];
            drug.drugID = (int)sqlite3_column_int(statement, 0);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                drug.drugName = nil;
            else
                drug.drugName = [NSString stringWithUTF8String: localityChars];
            
            drug.narcotic = (int)sqlite3_column_int(statement, 2);
            
            [array addObject:drug];
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableDictionary*) selectTicketInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        int rowCount = 0;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            if (rowCount == 0)
            {
                NSInteger ticketID = sqlite3_column_int(statement, 1);
                [dict setObject:[NSString stringWithFormat:@"%d", ticketID] forKey:@"TicketID"];
                
                NSString* value;
                char *localityChars = (char *)sqlite3_column_text(statement, 8);
                if (localityChars == NULL)
                    value = @" ";
                else
                    value = [NSString stringWithUTF8String: localityChars];
                [dict setObject:[NSString stringWithFormat:@"%@", value] forKey:@"Deleted"];
                rowCount++;
            }
            
            NSInteger inputID = sqlite3_column_int(statement, 2);
            //NSInteger inputSubID = sqlite3_column_int(statement, 3);
            //NSInteger inputInstance = sqlite3_column_int(statement, 4);
            NSString* value;
            char *localityChars = (char *)sqlite3_column_text(statement, 7);
            if (localityChars == NULL)
                value = @" ";
            else
                value = [NSString stringWithUTF8String: localityChars];
            
//            [dict setObject:value forKey:[NSString stringWithFormat:@"%d:%d:%d", inputID, inputSubID, inputInstance]];
            [dict setObject:value forKey:[NSString stringWithFormat:@"%d", inputID]];
            
        }
    }
    sqlite3_finalize(statement);
    return dict;
}


+(NSMutableDictionary*) selectTicketInputsInstance:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        int rowCount = 0;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            if (rowCount == 0)
            {
                NSInteger ticketID = sqlite3_column_int(statement, 1);
                [dict setObject:[NSString stringWithFormat:@"%d", ticketID] forKey:@"TicketID"];
                
                NSString* value;
                char *localityChars = (char *)sqlite3_column_text(statement, 8);
                if (localityChars == NULL)
                    value = @" ";
                else
                    value = [NSString stringWithUTF8String: localityChars];
                [dict setObject:[NSString stringWithFormat:@"%@", value] forKey:@"Deleted"];
                rowCount++;
            }
            
            NSInteger inputID = sqlite3_column_int(statement, 2);
            NSInteger inputSubID = sqlite3_column_int(statement, 3);
            NSInteger inputInstance = sqlite3_column_int(statement, 4);
            NSString* value;
            char *localityChars = (char *)sqlite3_column_text(statement, 7);
            if (localityChars == NULL)
                value = @" ";
            else
                value = [NSString stringWithUTF8String: localityChars];
            
             [dict setObject:value forKey:[NSString stringWithFormat:@"%d:%d:%d", inputID, inputSubID, inputInstance]];
           // [dict setObject:value forKey:[NSString stringWithFormat:@"%d", inputID]];
            
        }
    }
    sqlite3_finalize(statement);
    return dict;
}

+(NSMutableArray*) executeSelectSignatures:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsSignatureImages* sig = [[ClsSignatureImages alloc] init];
            
            sig.signatureID = (int)sqlite3_column_int(statement, 2);
            sig.type = (int)sqlite3_column_int(statement, 3);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 4);
            if (localityChars == NULL)
                sig.name = nil;
            else
                sig.name = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 5);
            if (localityChars == NULL)
                sig.image = nil;
            else
                sig.imageStr = [NSString stringWithUTF8String: localityChars];
            
            [array addObject:sig];
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+ (id)getViewFromXib:(NSString *)sNibName classname:(Class)ClassName
{
	id View = nil;
	NSArray *arrViews = [[NSBundle mainBundle] loadNibNamed:sNibName owner:nil options:nil];
	for(id view in arrViews)
	{
		if([view isKindOfClass:ClassName])
		{
			View = view;
		}
	}
	return View;
}

+ (NSString*) getPatientNameFromTickeID:(NSString*) ticketID db:(sqlite3*) ptrDbType
{
    sqlite3_stmt    *statement;
    NSString* lName = @"";
    NSString* fName = @"";
    NSString* patientName = @"";
    NSString *querySQL = [NSString stringWithFormat:@"Select InputID, InputValue from ticketInputs where TicketID = %@ and InputID in (1101, 1102)", ticketID ];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            NSString *inputId = [NSString stringWithUTF8String: (char *)sqlite3_column_text(statement, 0)];
            
            if ([inputId isEqualToString:@"1101"])
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 1);
                if (localityChars == NULL)
                    lName = nil;
                else
                    lName = [NSString stringWithUTF8String: localityChars];
                
            }
            else if ([inputId isEqualToString:@"1102"])
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 1);
                if (localityChars == NULL)
                    fName = nil;
                else
                    fName = [NSString stringWithUTF8String: localityChars];
            }
        }
    }
    sqlite3_finalize(statement);
    patientName = [NSString stringWithFormat:@"%@ %@ ", fName, lName];
    return patientName;
}

+ (NSString*) getPatientSSNFromTickeID:(NSString*) ticketID db:(sqlite3*) ptrDbType
{
    sqlite3_stmt    *statement;
    NSString* ssn = @"";
    NSString *querySQL = [NSString stringWithFormat:@"Select InputID, InputValue from ticketInputs where TicketID = %@ and InputID in (1133)", ticketID ];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            NSString *inputId = [NSString stringWithUTF8String: (char *)sqlite3_column_text(statement, 0)];
            
            if ([inputId isEqualToString:@"1133"])
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 1);
                if (localityChars == NULL)
                    ssn = nil;
                else
                    ssn = [NSString stringWithUTF8String: localityChars];
                
            }
        }
    }
    sqlite3_finalize(statement);
    return ssn;
}





+ (NSString*) getPatientName:(NSString*) ticketID db:(sqlite3*) ptrDbType
{
    sqlite3_stmt    *statement;
    NSString* lName = @"";
    NSString* fName = @"";
    NSString* sex = @"";
    NSString* cc = @"";
    NSString* patientName = @"";
    NSString *querySQL = [NSString stringWithFormat:@"Select InputID, InputValue from ticketInputs where TicketID = %@ and InputID in (1101, 1102)", ticketID ];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {

            NSString *inputId = [NSString stringWithUTF8String: (char *)sqlite3_column_text(statement, 0)];
            
            if ([inputId isEqualToString:@"1101"])
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 1);
                if (localityChars == NULL)
                    lName = nil;
                else
                    lName = [NSString stringWithUTF8String: localityChars];
                
            }
            else if ([inputId isEqualToString:@"1102"])
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 1);
                if (localityChars == NULL)
                    fName = nil;
                else
                    fName = [NSString stringWithUTF8String: localityChars];
            }
     /*       else if ([inputId isEqualToString:@"1105"])
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 1);
                if (localityChars == NULL || strcmp(localityChars, "(null)") == 0 || (strlen(localityChars) == 0) )
                    sex = nil;
                else
                    sex = [[NSString stringWithUTF8String: localityChars] substringToIndex:1];
            }
            
            else if ([inputId isEqualToString:@"1008"])
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 1);
                if (localityChars == NULL || strcmp(localityChars, "(null)") == 0)
                    cc = @"";
                else
                    cc = [NSString stringWithUTF8String: localityChars];
            }   */
 
        }
    }
    sqlite3_finalize(statement);
    patientName = [NSString stringWithFormat:@"Patient: %@ %@ ", fName, lName];
 /*   if ([sex length] > 0 && ([sex rangeOfString:@"(null)"].location == NSNotFound ))
    {
         patientName = [NSString stringWithFormat:@"%@ (%@) ", patientName, sex];
             
    }

    patientName = [NSString stringWithFormat:@"%@ Primary Impression: %@", patientName, cc]; */
    
    return patientName;
}

+ (NSString*) getInsuredName:(NSString*) ticketID db:(sqlite3*) ptrDbType
{
    sqlite3_stmt    *statement;
    NSString* lName = @"";
    NSString* fName = @"";
    NSString* patientName = @"";
    NSString *querySQL = [NSString stringWithFormat:@"Select InputID, InputValue from ticketInputs where TicketID = %@ and InputID in (1101, 1102)", ticketID ];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            NSString *inputId = [NSString stringWithUTF8String: (char *)sqlite3_column_text(statement, 0)];
            
            if ([inputId isEqualToString:@"1101"])
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 1);
                if (localityChars == NULL)
                    lName = nil;
                else
                    lName = [NSString stringWithUTF8String: localityChars];
                
            }
            else if ([inputId isEqualToString:@"1102"])
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 1);
                if (localityChars == NULL)
                    fName = nil;
                else
                    fName = [NSString stringWithUTF8String: localityChars];
            }
        }
    }
    sqlite3_finalize(statement);
    patientName = [NSString stringWithFormat:@"%@ %@ ", fName, lName];
    
    return patientName;
}

+ (NSString*) getInsuredDOB:(NSString*) ticketID db:(sqlite3*) ptrDbType
{
    sqlite3_stmt    *statement;
    NSString* DOB = @"";
    NSString *querySQL = [NSString stringWithFormat:@"Select InputID, InputValue from ticketInputs where TicketID = %@ and InputID in (1103)", ticketID ];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            NSString *inputId = [NSString stringWithUTF8String: (char *)sqlite3_column_text(statement, 0)];
            
            if ([inputId isEqualToString:@"1103"])
            {
                char *localityChars = (char *)sqlite3_column_text(statement, 1);
                if (localityChars == NULL)
                    DOB = nil;
                else
                    DOB = [NSString stringWithUTF8String: localityChars];
                
            }
           
        }
    }
    sqlite3_finalize(statement);
    
    return DOB;
}

+ (NSMutableDictionary*) executeSelectInputValue:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            NSInteger inputID = sqlite3_column_int(statement, 0);
            NSString* value;
            char *localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                value = @" ";
            else
                value = [NSString stringWithUTF8String: localityChars];
            
            //            [dict setObject:value forKey:[NSString stringWithFormat:@"%d:%d:%d", inputID, inputSubID, inputInstance]];
            [dict setObject:value forKey:[NSString stringWithFormat:@"%d", inputID]];
        }
    }
    
    sqlite3_finalize(statement);

    return dict;
    
}

+ (NSString*) executeSelectRequiredInput:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableString* inputIDStr = [[NSMutableString alloc] init];
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            NSString *inputId = [NSString stringWithUTF8String: (char *)sqlite3_column_text(statement, 0)];
            
            [inputIDStr appendString:inputId];
            [inputIDStr appendString:@","];
        }
    }
    
    sqlite3_finalize(statement);
    if ([inputIDStr length] > 1)
    {
       [inputIDStr deleteCharactersInRange:NSMakeRange([inputIDStr length]-1, 1)];
    }
    return inputIDStr;
}

+ (NSString*) executeSelectNarcoticInput:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableString* inputIDStr = [[NSMutableString alloc] init];
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            NSString *inputId = [NSString stringWithUTF8String: (char *)sqlite3_column_text(statement, 0)];
            
            [inputIDStr appendString:[NSString stringWithFormat:@"'%@'", inputId]];
            [inputIDStr appendString:@","];
        }
    }
    
    sqlite3_finalize(statement);
    if ([inputIDStr length] > 1)
    {
        [inputIDStr deleteCharactersInRange:NSMakeRange([inputIDStr length]-1, 1)];
    }
    return inputIDStr;
}

+ (NSInteger) saveImage:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    int success = 0;
    sqlite3_stmt    *statement;
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    
    if (result == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = 1;
        }
    }
    sqlite3_finalize(statement);
    return success;
}

+(NSMutableArray*) executeSelectTicketAttachments:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsTicketAttachments* ticketAttachment = [[ClsTicketAttachments alloc] init];
            ticketAttachment.localTicketID = (int)sqlite3_column_int(statement, 0);
            ticketAttachment.ticketID = (int)sqlite3_column_int(statement, 1);
            ticketAttachment.attachmentID = (int)sqlite3_column_int(statement, 2);

            char* localityChars = (char *)sqlite3_column_text(statement, 3);
            if (localityChars == NULL)
                ticketAttachment.fileType = nil;
            else
                ticketAttachment.fileType = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 4);
            if (localityChars == NULL)
                ticketAttachment.fileStr = nil;
            else
                ticketAttachment.fileStr = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 5);
            if (localityChars == NULL)
                ticketAttachment.fileName = nil;
            else
                ticketAttachment.fileName = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char*) sqlite3_column_text(statement, 6);
            if (localityChars == NULL)
            {
                ticketAttachment.timeAdded = nil;
            }
            else
                ticketAttachment.timeAdded = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char*) sqlite3_column_text(statement, 7);
            if (localityChars == NULL)
            {
                
            }
            else
                ticketAttachment.deleted = (int)sqlite3_column_int(statement, 7);
            
            [array addObject:ticketAttachment];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableArray*) executeSelectTicketSignatures:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsTicketSignatures* ticketSignature = [[ClsTicketSignatures alloc] init];
            ticketSignature.localTicketID = (int)sqlite3_column_int(statement, 0);
            ticketSignature.ticketID = (int)sqlite3_column_int(statement, 1);
            ticketSignature.signatureID = (int)sqlite3_column_int(statement, 2);
            ticketSignature.signatureType = (int)sqlite3_column_int(statement, 3);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 4);
            if (localityChars == NULL)
                ticketSignature.signatureText = nil;
            else
                ticketSignature.signatureText = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 5);
            if (localityChars == NULL)
                ticketSignature.signatureString = nil;
            else
                ticketSignature.signatureString = [NSString stringWithUTF8String: localityChars];

            
            localityChars = (char*) sqlite3_column_text(statement, 6);
            if (localityChars == NULL)
            {
                ticketSignature.signatureTime = nil;
            }
            else
                ticketSignature.signatureTime = [NSString stringWithUTF8String: localityChars];
            
            
            localityChars = (char*) sqlite3_column_text(statement, 7);
            if (localityChars == NULL)
            {
                
            }
            else
                ticketSignature.deleted = (int)sqlite3_column_int(statement, 7);
            
            [array addObject:ticketSignature];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableArray*) executeSelectTicketFormsInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsTicketFormsInputs* ticketFormsInputs = [[ClsTicketFormsInputs alloc] init];
            ticketFormsInputs.localTicketID = (int)sqlite3_column_int(statement, 0);
            ticketFormsInputs.ticketID = (int)sqlite3_column_int(statement, 1);
            ticketFormsInputs.formID = (int)sqlite3_column_int(statement, 2);
            ticketFormsInputs.formInputID = (int)sqlite3_column_int(statement, 3);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 4);
            if (localityChars == NULL)
                ticketFormsInputs.formInputValue = nil;
            else
                ticketFormsInputs.formInputValue = [NSString stringWithUTF8String: localityChars];
            
            
            localityChars = (char*) sqlite3_column_text(statement, 5);
            if (localityChars == NULL)
            {
                
            }
            else
                ticketFormsInputs.deleted = (int)sqlite3_column_int(statement, 5);
            
            localityChars = (char*) sqlite3_column_text(statement, 6);
            if (localityChars == NULL)
            {
                
            }
            else
                ticketFormsInputs.modified = (int)sqlite3_column_int(statement, 6);
            
            
            [array addObject:ticketFormsInputs];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}


+(NSInteger) getCountWithCheck:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    int count = 0;
    sqlite3_stmt    *statement;
    @try {
        
        const char *query_stmt = [sql UTF8String];
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                char* localityChars = (char*) sqlite3_column_text(statement, 1);
                if (localityChars == NULL)
                {
                    char* localityChars1 = (char*) sqlite3_column_text(statement, 0);
                    if (localityChars1 == NULL)
                    {
                        count = 0;
                    }
                    else
                    {
                        count = 1;
                    }
                }
                else
                {
                    NSInteger test   = (int)sqlite3_column_int(statement, 1);
                    if (test == 1)
                    {
                        count = -1;
                    }
                    else
                    {
                        count = 1;
                    }
                }
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        count = 0;
    }
    return count;
}

+(NSInteger) getInstance:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    int instance = 0;
    sqlite3_stmt    *statement;
    @try {
        
        const char *query_stmt = [sql UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                char* localityChars = (char*) sqlite3_column_text(statement, 0);
                    if (localityChars == NULL)
                    {
                        instance = 0;
                    }
                    else
                    {
                        instance  = (int)sqlite3_column_int(statement, 0);
                    }

            }

        }
       sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
            instance = 0;
    }
    return instance;
}

+(void) executeCleanup:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    @try
    {
        const char *query_stmt = [sql UTF8String];
        
        int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result1 == SQLITE_OK)
        {
            NSDate* today = [NSDate date];
            NSDateFormatter* format = [[NSDateFormatter alloc] init];
      //      NSLocale* usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
      //      [format setLocale:usLocale];
            [format setDateFormat:@"MM/dd/yyyy HH:mm"];
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSInteger ticketID = (int)sqlite3_column_int(statement, 0);
                NSString* dateCreatedStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                dateCreatedStr = [dateCreatedStr substringToIndex:dateCreatedStr.length - 6];
                NSDate* dateCreated = [format dateFromString:dateCreatedStr];
                NSDateComponents* diff = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:dateCreated toDate:today options:0];
                if ([diff day]> 10)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketInputs where ticketID = %d and isUploaded = 0", ticketID];
                    NSInteger count = [DAO getCount:ptrDbType Sql:sqlStr];
                    if (count < 1)
                    {
                        sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketFormsInputs where ticketID = %d and isUploaded = 0", ticketID];
                        count = [DAO getCount:ptrDbType Sql:sqlStr];
                        if (count < 1)
                        {
                            sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %d and isUploaded = 0", ticketID];
                            @synchronized(g_SYNCBLOBSDB)
                            {
                                count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                            }
                            if (count < 1)
                            {
                                sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketAttachments where ticketID = %d and isUploaded = 0", ticketID];
                                @synchronized(g_SYNCBLOBSDB)
                                {
                                    count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                                }
                                if (count < 1)
                                {
                                    NSString* sql = [NSString stringWithFormat:@"Delete from tickets where ticketID = %d", ticketID];
                                    [DAO executeDelete:ptrDbType Sql:sql];

                                    sql = [NSString stringWithFormat:@"Delete from ticketInputs where ticketID = %d", ticketID];

                                    [DAO executeDelete:ptrDbType Sql:sql];
                                    
                                    sql = [NSString stringWithFormat:@"Delete from ticketNotes where ticketID = %d", ticketID];
                                    [DAO executeDelete:ptrDbType Sql:sql];
                                    
                                    sql = [NSString stringWithFormat:@"Delete from ticketChanges where ticketID = %d", ticketID];
                                    [DAO executeDelete:ptrDbType Sql:sql];

                                    sql = [NSString stringWithFormat:@"Delete from ticketFormsInputs where ticketID = %d", ticketID];

                                    [DAO executeDelete:ptrDbType Sql:sql];

                                    sql = [NSString stringWithFormat:@"Delete from ticketSignatures where ticketID = %d", ticketID];
                                    @synchronized(g_SYNCBLOBSDB)
                                    {
                                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                                    }
                                    sql = [NSString stringWithFormat:@"Delete from TicketAttachments where ticketID = %d", ticketID];
                                    @synchronized(g_SYNCBLOBSDB)
                                    {
                                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                
            }
        }
        sqlite3_finalize(statement);

    }
    @catch (NSException *exception) {
    }
    return;
    
}

+(void) executeLoadSettings:(sqlite3*)ptrDbType Sql:(NSString*) sql
{

    sqlite3_stmt    *statement;
    
    @try {
        const char *query_stmt = [sql UTF8String];
        
        int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
        if (result == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString* desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString* value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                if (value.length < 1)
                {
                    value = @" ";
                }
                [g_SETTINGS setObject:value forKey:desc];
            }
        }
        sqlite3_finalize(statement);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

+(NSString*) executeSelectInputIds:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableString* inputIDStr = [[NSMutableString alloc] init];
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            NSString *inputId = [NSString stringWithUTF8String: (char *)sqlite3_column_text(statement, 0)];
            
            [inputIDStr appendString:[NSString stringWithFormat:@"%@", inputId]];
            [inputIDStr appendString:@","];
        }
    }
    
    sqlite3_finalize(statement);
    if ([inputIDStr length] > 1)
    {
        [inputIDStr deleteCharactersInRange:NSMakeRange([inputIDStr length]-1, 1)];
    }
    return inputIDStr;
}

+ (NSString*) executeSelectScalar:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableString* inputIDStr = [[NSMutableString alloc] init];
    const char *query_stmt = [sql UTF8String];
    
    int result = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result == SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_ROW)
        {
            char* localityChars = (char*) sqlite3_column_text(statement, 0);
            if (localityChars == NULL)
            {
                
            }
            else
            {
                [inputIDStr  appendString:[NSString stringWithUTF8String: (char *)sqlite3_column_text(statement, 0)]];
            }

            
        }
    }
    
    sqlite3_finalize(statement);

    return inputIDStr;
}

+(NSMutableArray*) executeSelectTicketNotes:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsTicketNotes* ticketNotes = [[ClsTicketNotes alloc] init];
            ticketNotes.ticketID = (int)sqlite3_column_int(statement, 1);
            ticketNotes.noteUID = (int)sqlite3_column_int(statement, 2);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 3);
            if (localityChars == NULL)
                ticketNotes.note = nil;
            else
                ticketNotes.note = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 4);
            if (localityChars == NULL)
                ticketNotes.userID = nil;
            else
                ticketNotes.userID = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 5);
            if (localityChars == NULL)
                ticketNotes.noteTime = nil;
            else
                ticketNotes.noteTime = [NSString stringWithUTF8String: localityChars];
 
            [array addObject:ticketNotes];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableArray*) executeSelectTicketChanges:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsTicketChanges* ticketChanges = [[ClsTicketChanges alloc] init];
            ticketChanges.ticketID = (int)sqlite3_column_int(statement, 0);
            ticketChanges.changeID = (int)sqlite3_column_int(statement, 1);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 2);
            if (localityChars == NULL)
                ticketChanges.changeMade = nil;
            else
                ticketChanges.changeMade = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 3);
            if (localityChars == NULL)
                ticketChanges.changeTime = nil;
            else
                ticketChanges.changeTime = [NSString stringWithUTF8String: localityChars];
            
            ticketChanges.modifiedBy = (int)sqlite3_column_int(statement, 4);
            ticketChanges.changeInputID = (int)sqlite3_column_int(statement, 5);
            
            localityChars = (char *)sqlite3_column_text(statement, 6);
            if (localityChars == NULL)
                ticketChanges.originalValue = nil;
            else
                ticketChanges.originalValue = [NSString stringWithUTF8String: localityChars];
            
            [array addObject:ticketChanges];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableArray*) selectSignatureTypes:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsSignatureTypes* sigType = [[ClsSignatureTypes alloc] init];
            sigType.signatureType = (int)sqlite3_column_int(statement, 0);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                sigType.signatureTypeDesc = nil;
            else
                sigType.signatureTypeDesc = [NSString stringWithUTF8String: localityChars];
            
            localityChars = (char *)sqlite3_column_text(statement, 2);
            if (localityChars == NULL)
                sigType.disclaimerText = nil;
            else
                sigType.disclaimerText = [NSString stringWithUTF8String: localityChars];

            
            localityChars = (char *)sqlite3_column_text(statement, 3);
            if (localityChars == NULL)
                sigType.signatureGroup = nil;
            else
                sigType.signatureGroup = [NSString stringWithUTF8String: localityChars];
            
            [array addObject:sigType];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableArray*) selectInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsInputs* input = [[ClsInputs alloc] init];
            input.inputID = (int)sqlite3_column_int(statement, 0);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                input.inputName = nil;
            else
                input.inputName = [NSString stringWithUTF8String: localityChars];
            
            input.inputDataType = (int)sqlite3_column_int(statement, 2);
            
            localityChars = (char *)sqlite3_column_text(statement, 3);
            if (localityChars == NULL)
                input.inputGroup = nil;
            else
                input.inputGroup = [NSString stringWithUTF8String: localityChars];
            
             input.inputRequiredField = (int)sqlite3_column_int(statement, 4);
            
            [array addObject:input];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableArray*) selectVitalInputs:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            ClsInputs* input = [[ClsInputs alloc] init];
            input.inputID = (int)sqlite3_column_int(statement, 0);
            
            char* localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                input.inputName = nil;
            else
                input.inputName = [NSString stringWithUTF8String: localityChars];
            
            input.inputDataType = (int)sqlite3_column_int(statement, 2);
            
            localityChars = (char *)sqlite3_column_text(statement, 3);
            if (localityChars == NULL)
                input.inputGroup = nil;
            else
                input.inputGroup = [NSString stringWithUTF8String: localityChars];
            
            input.inputRequiredField = (int)sqlite3_column_int(statement, 4);
            
            localityChars = (char *)sqlite3_column_text(statement, 5);
            if (localityChars == NULL)
                input.inputShortDesc = nil;
            else
                input.inputShortDesc = [NSString stringWithUTF8String: localityChars];
            [array addObject:input];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}

+(NSMutableArray*) SelectInputsData:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            
            NSInteger inputId = (int)sqlite3_column_int(statement, 0);
            
            NSString* inputValue;
            char* localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                inputValue = nil;
            else
                inputValue = [NSString stringWithUTF8String: localityChars];
            
            if (inputId == 1430)
            {
                NSString* newStr1 = [inputValue stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
                NSString* newStr2 = [newStr1 stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
                NSString* newStr3 = [newStr2 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
                int asciiCode1 = 13;
                NSString *string1 = [NSString stringWithFormat:@"%c", asciiCode1];
                NSString* newStr4 = [newStr3 stringByReplacingOccurrencesOfString:string1 withString:@"|CRLF|"];
                int asciiCode = 3;
                NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
                inputValue = [newStr4 stringByReplacingOccurrencesOfString:string withString:@"&amp;"];  // end of text
            }
            else
            {
                NSString* newStr1 = [inputValue stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
                NSString* newStr2 = [newStr1 stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
                NSString* newStr3 = [newStr2 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
                int asciiCode1 = 13;
                NSString *string1 = [NSString stringWithFormat:@"%c", asciiCode1];
                NSString* newStr4 = [newStr3 stringByReplacingOccurrencesOfString:string1 withString:@"&amp;"];
                int asciiCode = 3;
                NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
                inputValue = [newStr4 stringByReplacingOccurrencesOfString:string withString:@"&amp;"];  // end of text
            }
            NSString* data = [NSString stringWithFormat:@"<ID%d>%@</ID%d>", inputId, inputValue, inputId];
            [array addObject:data];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}


+(NSMutableArray*) SelectInputsAssessment:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            
            NSInteger inputId = (int)sqlite3_column_int(statement, 0);
            
            NSString* inputValue;
            char* localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                inputValue = nil;
            else
                inputValue = [NSString stringWithUTF8String: localityChars];
            NSString* data = [NSString stringWithFormat:@"<A%d>%@</A%d>", inputId, inputValue, inputId];
            [array addObject:data];
            
        }
    }
    sqlite3_finalize(statement);
    return array;
}


+(NSMutableDictionary*) SelectInputsVital:(sqlite3*)ptrDbType Sql:(NSString*) sql
{
    sqlite3_stmt    *statement;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    const char *query_stmt = [sql UTF8String];
    
    int result1 = sqlite3_prepare_v2(ptrDbType, query_stmt, -1, &statement, NULL);
    if (result1 == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {

            NSString* inputName;
            char* localityChars = (char *)sqlite3_column_text(statement, 0);
            if (localityChars == NULL)
                inputName = nil;
            else
                inputName = [NSString stringWithUTF8String: localityChars];
            
            NSString* inputValue;
            localityChars = (char *)sqlite3_column_text(statement, 1);
            if (localityChars == NULL)
                inputValue = nil;
            else
                inputValue = [NSString stringWithUTF8String: localityChars];

            [dict setObject:inputValue forKey:inputName];
            
        }
    }
    sqlite3_finalize(statement);
    return dict;
}
@end
