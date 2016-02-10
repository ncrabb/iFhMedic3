#import <Foundation/Foundation.h>
#import "USAdditions.h"
#import <libxml/tree.h>
#import "USGlobals.h"
#import <objc/runtime.h>
@class ServiceSvc_GetCustomerID;
@class ServiceSvc_GetCustomerIDResponse;
@class ServiceSvc_GetInputsTable;
@class ServiceSvc_GetInputsTableResponse;
@class ServiceSvc_ArrayOfClsInputs;
@class ServiceSvc_ClsInputs;
@class ServiceSvc_GetInputLookupTable;
@class ServiceSvc_GetInputLookupTableResponse;
@class ServiceSvc_ArrayOfClsInputLookup;
@class ServiceSvc_ClsInputLookup;
@class ServiceSvc_GetTreatmentsTable;
@class ServiceSvc_GetTreatmentsTableResponse;
@class ServiceSvc_ArrayOfClsTreatments;
@class ServiceSvc_ClsTreatments;
@class ServiceSvc_GetTreatmentInputsTable;
@class ServiceSvc_GetTreatmentInputsTableResponse;
@class ServiceSvc_ArrayOfClsTreatmentInputs;
@class ServiceSvc_ClsTreatmentInputs;
@class ServiceSvc_GetTreatmentInputLookupTable;
@class ServiceSvc_GetTreatmentInputLookupTableResponse;
@class ServiceSvc_ArrayOfClsTreatmentInputLookup;
@class ServiceSvc_ClsTreatmentInputLookup;
@class ServiceSvc_GetCertificationTable;
@class ServiceSvc_GetCertificationTableResponse;
@class ServiceSvc_ArrayOfClsCertification;
@class ServiceSvc_ClsCertification;
@class ServiceSvc_GetChiefComplaintsTable;
@class ServiceSvc_GetChiefComplaintsTableResponse;
@class ServiceSvc_ArrayOfClsChiefComplaints;
@class ServiceSvc_ClsChiefComplaints;
@class ServiceSvc_GetCitiesTable;
@class ServiceSvc_GetCitiesTableResponse;
@class ServiceSvc_ArrayOfClsCities;
@class ServiceSvc_ClsCities;
@class ServiceSvc_GetControlFiltersTable;
@class ServiceSvc_GetControlFiltersTableResponse;
@class ServiceSvc_ArrayOfClsControlFilters;
@class ServiceSvc_ClsControlFilters;
@class ServiceSvc_GetCountiesTable;
@class ServiceSvc_GetCountiesTableResponse;
@class ServiceSvc_ArrayOfClsCounties;
@class ServiceSvc_ClsCounties;
@class ServiceSvc_GetCrewRideTypesTable;
@class ServiceSvc_GetCrewRideTypesTableResponse;
@class ServiceSvc_ArrayOfClsCrewRideTypes;
@class ServiceSvc_ClsCrewRideTypes;
@class ServiceSvc_GetCustomerContentTable;
@class ServiceSvc_GetCustomerContentTableResponse;
@class ServiceSvc_ArrayOfClsCustomerContent;
@class ServiceSvc_ClsCustomerContent;
@class ServiceSvc_GetCustomFormExclusion;
@class ServiceSvc_GetCustomFormExclusionResponse;
@class ServiceSvc_ArrayOfClsCustomFormExclusions;
@class ServiceSvc_ClsCustomFormExclusions;
@class ServiceSvc_GetCustomFormInputLookUp;
@class ServiceSvc_GetCustomFormInputLookUpResponse;
@class ServiceSvc_ArrayOfClsCustomFormInputLookup;
@class ServiceSvc_ClsCustomFormInputLookup;
@class ServiceSvc_GetCustomForms;
@class ServiceSvc_GetCustomFormsResponse;
@class ServiceSvc_ArrayOfClsCustomForms;
@class ServiceSvc_ClsCustomForms;
@class ServiceSvc_GetCustomFormInputs;
@class ServiceSvc_GetCustomFormInputsResponse;
@class ServiceSvc_ArrayOfClsCustomFormInputs;
@class ServiceSvc_ClsCustomFormInputs;
@class ServiceSvc_GetDrugDosages;
@class ServiceSvc_GetDrugDosagesResponse;
@class ServiceSvc_ArrayOfClsDrugDosages;
@class ServiceSvc_ClsDrugDosages;
@class ServiceSvc_GetDrugs;
@class ServiceSvc_GetDrugsResponse;
@class ServiceSvc_ArrayOfClsDrugs;
@class ServiceSvc_ClsDrugs;
@class ServiceSvc_GetForms;
@class ServiceSvc_GetFormsResponse;
@class ServiceSvc_ArrayOfClsForms;
@class ServiceSvc_ClsForms;
@class ServiceSvc_GetGroups;
@class ServiceSvc_GetGroupsResponse;
@class ServiceSvc_ArrayOfClsGroups;
@class ServiceSvc_ClsGroups;
@class ServiceSvc_GetInjuryTypes;
@class ServiceSvc_GetInjuryTypesResponse;
@class ServiceSvc_ArrayOfClsInjuryTypes;
@class ServiceSvc_ClsInjuryTypes;
@class ServiceSvc_GetInsurance;
@class ServiceSvc_GetInsuranceResponse;
@class ServiceSvc_ArrayOfClsInsurance;
@class ServiceSvc_ClsInsurance;
@class ServiceSvc_GetInsuranceInputLookup;
@class ServiceSvc_GetInsuranceInputLookupResponse;
@class ServiceSvc_ArrayOfClsInsuranceInputLookup;
@class ServiceSvc_ClsInsuranceInputLookup;
@class ServiceSvc_GetInsuranceInputs;
@class ServiceSvc_GetInsuranceInputsResponse;
@class ServiceSvc_ArrayOfClsInsuranceInputs;
@class ServiceSvc_ClsInsuranceInputs;
@class ServiceSvc_GetInsuranceTypes;
@class ServiceSvc_GetInsuranceTypesResponse;
@class ServiceSvc_ArrayOfClsInsuranceTypes;
@class ServiceSvc_ClsInsuranceTypes;
@class ServiceSvc_GetLocations;
@class ServiceSvc_GetLocationsResponse;
@class ServiceSvc_ArrayOfClsLocations;
@class ServiceSvc_ClsLocations;
@class ServiceSvc_GetMedications;
@class ServiceSvc_GetMedicationsResponse;
@class ServiceSvc_ArrayOfClsMedications;
@class ServiceSvc_ClsMedications;
@class ServiceSvc_GetPages;
@class ServiceSvc_GetPagesResponse;
@class ServiceSvc_ArrayOfClsPages;
@class ServiceSvc_ClsPages;
@class ServiceSvc_GetProtocolFiles;
@class ServiceSvc_GetProtocolFilesResponse;
@class ServiceSvc_ArrayOfClsProtocolFiles;
@class ServiceSvc_ClsProtocolFiles;
@class ServiceSvc_GetProtocolGroups;
@class ServiceSvc_GetProtocolGroupsResponse;
@class ServiceSvc_ArrayOfClsProtocolGroups;
@class ServiceSvc_ClsProtocolGroups;
@class ServiceSvc_GetQuickButtons;
@class ServiceSvc_GetQuickButtonsResponse;
@class ServiceSvc_ArrayOfClsQuickButtons;
@class ServiceSvc_ClsQuickButtons;
@class ServiceSvc_GetShifts;
@class ServiceSvc_GetShiftsResponse;
@class ServiceSvc_ArrayOfClsShifts;
@class ServiceSvc_ClsShifts;
@class ServiceSvc_GetSignatureTypes;
@class ServiceSvc_GetSignatureTypesResponse;
@class ServiceSvc_ArrayOfClsSignatureTypes;
@class ServiceSvc_ClsSignatureTypes;
@class ServiceSvc_GetStates;
@class ServiceSvc_GetStatesResponse;
@class ServiceSvc_ArrayOfClsStates;
@class ServiceSvc_ClsStates;
@class ServiceSvc_GetStations;
@class ServiceSvc_GetStationsResponse;
@class ServiceSvc_ArrayOfClsStations;
@class ServiceSvc_ClsStations;
@class ServiceSvc_GetStatus;
@class ServiceSvc_GetStatusResponse;
@class ServiceSvc_ArrayOfClsStatus;
@class ServiceSvc_ClsStatus;
@class ServiceSvc_GetUsers;
@class ServiceSvc_GetUsersResponse;
@class ServiceSvc_ArrayOfClsUsers;
@class ServiceSvc_ClsUsers;
@class ServiceSvc_GetZips;
@class ServiceSvc_GetZipsResponse;
@class ServiceSvc_ArrayOfClsZips;
@class ServiceSvc_ClsZips;
@class ServiceSvc_GetVitalsTable;
@class ServiceSvc_GetVitalsTableResponse;
@class ServiceSvc_ArrayOfClsVitals;
@class ServiceSvc_ClsVitals;
@class ServiceSvc_GetVitalInputLookupTable;
@class ServiceSvc_GetVitalInputLookupTableResponse;
@class ServiceSvc_ArrayOfClsVitalInputLookup;
@class ServiceSvc_ClsVitalInputLookup;
@class ServiceSvc_GetUnits;
@class ServiceSvc_GetUnitsResponse;
@class ServiceSvc_ArrayOfClsUnits;
@class ServiceSvc_ClsUnits;
@class ServiceSvc_GetSettings;
@class ServiceSvc_GetSettingsResponse;
@class ServiceSvc_ArrayOfClsSettings;
@class ServiceSvc_ClsSettings;
@class ServiceSvc_GetxInputTables;
@class ServiceSvc_GetxInputTablesResponse;
@class ServiceSvc_ArrayOfClsXInputTables;
@class ServiceSvc_ClsXInputTables;
@class ServiceSvc_GetOutcomes;
@class ServiceSvc_GetOutcomesResponse;
@class ServiceSvc_ArrayOfClsOutcomes;
@class ServiceSvc_ClsOutcomes;
@class ServiceSvc_GetOutcomeTypes;
@class ServiceSvc_GetOutcomeTypesResponse;
@class ServiceSvc_ArrayOfClsOutcomeTypes;
@class ServiceSvc_ClsOutcomeTypes;
@class ServiceSvc_GetOutcomeRequiredItems;
@class ServiceSvc_GetOutcomeRequiredItemsResponse;
@class ServiceSvc_ArrayOfClsOutcomeRequiredItems;
@class ServiceSvc_ClsOutcomeRequiredItems;
@class ServiceSvc_GetOutcomeRequiredSignatures;
@class ServiceSvc_GetOutcomeRequiredSignaturesResponse;
@class ServiceSvc_ArrayOfClsOutcomeRequiredSignatures;
@class ServiceSvc_ClsOutcomeRequiredSignatures;
@class ServiceSvc_UpdateChange6;
@class ServiceSvc_ArrayOfClsChangeQue;
@class ServiceSvc_ClsChangeQue;
@class ServiceSvc_UpdateChange6Response;
@class ServiceSvc_ClsTicketUpdate;
@class ServiceSvc_BackupTicket;
@class ServiceSvc_ArrayOfClsTickets;
@class ServiceSvc_ClsTickets;
@class ServiceSvc_BackupTicketResponse;
@class ServiceSvc_BackupTicketInputs;
@class ServiceSvc_ArrayOfClsTicketInputs;
@class ServiceSvc_ClsTicketInputs;
@class ServiceSvc_BackupTicketInputsResponse;
@class ServiceSvc_BackupTicketNotes;
@class ServiceSvc_ArrayOfClsTicketNotes;
@class ServiceSvc_ClsTicketNotes;
@class ServiceSvc_BackupTicketNotesResponse;
@class ServiceSvc_BackupTicketChanges;
@class ServiceSvc_ArrayOfClsTicketChanges;
@class ServiceSvc_ClsTicketChanges;
@class ServiceSvc_BackupTicketChangesResponse;
@class ServiceSvc_BackupTicketAttachments;
@class ServiceSvc_ArrayOfClsTicketAttachments;
@class ServiceSvc_ClsTicketAttachments;
@class ServiceSvc_BackupTicketAttachmentsResponse;
@class ServiceSvc_BackupTicketSignatures;
@class ServiceSvc_ArrayOfClsTicketSignatures;
@class ServiceSvc_ClsTicketSignatures;
@class ServiceSvc_BackupTicketSignaturesResponse;
@class ServiceSvc_GetReviewTransferTickets;
@class ServiceSvc_GetReviewTransferTicketsResponse;
@class ServiceSvc_GetReviewTransferTicketInputs;
@class ServiceSvc_GetReviewTransferTicketInputsResponse;
@class ServiceSvc_GetReviewTransferTicketForms;
@class ServiceSvc_GetReviewTransferTicketFormsResponse;
@class ServiceSvc_ArrayOfClsTicketFormsInputs;
@class ServiceSvc_ClsTicketFormsInputs;
@class ServiceSvc_GetReviewTransferTicketChanges;
@class ServiceSvc_GetReviewTransferTicketChangesResponse;
@class ServiceSvc_GetReviewTransferTicketAttachments;
@class ServiceSvc_GetReviewTransferTicketAttachmentsResponse;
@class ServiceSvc_GetReviewTransferTicketSignatures;
@class ServiceSvc_GetReviewTransferTicketSignaturesResponse;
@class ServiceSvc_GetReviewTransferTicketNotes;
@class ServiceSvc_GetReviewTransferTicketNotesResponse;
@class ServiceSvc_BackupTicketFormsInput;
@class ServiceSvc_BackupTicketFormsInputResponse;
@class ServiceSvc_SearchForPatientByName;
@class ServiceSvc_SearchForPatientByNameResponse;
@class ServiceSvc_ArrayOfClsSearchName;
@class ServiceSvc_ClsSearchName;
@class ServiceSvc_SearchForPatientBySSN;
@class ServiceSvc_SearchForPatientBySSNResponse;
@class ServiceSvc_DoAdminUnitIpad;
@class ServiceSvc_DoAdminUnitIpadResponse;
@class ServiceSvc_ArrayOfClsUnitMsgs;
@class ServiceSvc_ClsUnitMsgs;
@class ServiceSvc_DoAdminMachineIpad;
@class ServiceSvc_DoAdminMachineIpadResponse;
@class ServiceSvc_ArrayOfClsMachineMsgs;
@class ServiceSvc_ClsMachineMsgs;
@class ServiceSvc_GetIncompleteTickets;
@class ServiceSvc_GetIncompleteTicketsResponse;
@class ServiceSvc_GetIncompleteTicketInputs;
@class ServiceSvc_GetIncompleteTicketInputsResponse;
@class ServiceSvc_GetIncompleteTicketAttachments;
@class ServiceSvc_GetIncompleteTicketAttachmentsResponse;
@class ServiceSvc_GetIncompleteTicketSignatures;
@class ServiceSvc_GetIncompleteTicketSignaturesResponse;
@class ServiceSvc_GetIncompleteTicketNotes;
@class ServiceSvc_GetIncompleteTicketNotesResponse;
@class ServiceSvc_GetIncompTickets;
@class ServiceSvc_GetIncompTicketsResponse;
@class ServiceSvc_GetIncompTicketInputs;
@class ServiceSvc_GetIncompTicketInputsResponse;
@class ServiceSvc_GetIncompTicketForms;
@class ServiceSvc_GetIncompTicketFormsResponse;
@class ServiceSvc_GetIncompTicketChanges;
@class ServiceSvc_GetIncompTicketChangesResponse;
@class ServiceSvc_GetIncompTicketAttachments;
@class ServiceSvc_GetIncompTicketAttachmentsResponse;
@class ServiceSvc_GetIncompTicketSignatures;
@class ServiceSvc_GetIncompTicketSignaturesResponse;
@class ServiceSvc_GetIncompTicketNotes;
@class ServiceSvc_GetIncompTicketNotesResponse;
@class ServiceSvc_GetMonitors;
@class ServiceSvc_GetMonitorsResponse;
@class ServiceSvc_ArrayOfClsMonitor;
@class ServiceSvc_ClsMonitor;
@class ServiceSvc_GetMonitorVitals;
@class ServiceSvc_GetMonitorVitalsResponse;
@class ServiceSvc_ArrayOfClsMonitorVital;
@class ServiceSvc_ClsMonitorVital;
@class ServiceSvc_GetMonitorProcedure;
@class ServiceSvc_GetMonitorProcedureResponse;
@class ServiceSvc_ArrayOfClsMonitorProc;
@class ServiceSvc_ClsMonitorProc;
@class ServiceSvc_GetMonitorMed;
@class ServiceSvc_GetMonitorMedResponse;
@class ServiceSvc_ArrayOfClsMonitorMed;
@class ServiceSvc_ClsMonitorMed;
@class ServiceSvc_GetMonitorImage;
@class ServiceSvc_GetMonitorImageResponse;
@class ServiceSvc_GetZoll;
@class ServiceSvc_GetZollResponse;
@class ServiceSvc_GetZollVitals;
@class ServiceSvc_GetZollVitalsResponse;
@class ServiceSvc_ArrayOfClsTableKey;
@class ServiceSvc_ClsTableKey;
@class ServiceSvc_GetZollProcs;
@class ServiceSvc_GetZollProcsResponse;
@class ServiceSvc_GetPCR;
@class ServiceSvc_GetPCRResponse;
@interface ServiceSvc_GetCustomerID : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * MachineID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomerID *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * MachineID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomerIDResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * GetCustomerIDResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomerIDResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * GetCustomerIDResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInputsTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInputsTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * InputID;
	// NSString * InputName;
	// NSString * InputDefault;
	// NSString * InputPage;
	// NSString * InputGroup;
	// NSNumber * InputGroupIndex;
	// NSString * InputForm;
	// NSString * InputLongDesc;
	// NSString * InputShortDesc;
	// NSNumber * InputDataType;
	// NSString * InputAlternateLabel;
	// NSString * InputAlternateDesc;
	// NSNumber * InputIndex;
	// NSString * InputApplyRule;
	// NSString * InputApplyRuleToInputs;
	// NSNumber * InputRequiredField;
	// NSNumber * InputDefaultable;
	// NSNumber * InputVisible;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSString * InputName;
@property (nonatomic, strong) NSString * InputDefault;
@property (nonatomic, strong) NSString * InputPage;
@property (nonatomic, strong) NSString * InputGroup;
@property (nonatomic, strong) NSNumber * InputGroupIndex;
@property (nonatomic, strong) NSString * InputForm;
@property (nonatomic, strong) NSString * InputLongDesc;
@property (nonatomic, strong) NSString * InputShortDesc;
@property (nonatomic, strong) NSNumber * InputDataType;
@property (nonatomic, strong) NSString * InputAlternateLabel;
@property (nonatomic, strong) NSString * InputAlternateDesc;
@property (nonatomic, strong) NSNumber * InputIndex;
@property (nonatomic, strong) NSString * InputApplyRule;
@property (nonatomic, strong) NSString * InputApplyRuleToInputs;
@property (nonatomic, strong) NSNumber * InputRequiredField;
@property (nonatomic, strong) NSNumber * InputDefaultable;
@property (nonatomic, strong) NSNumber * InputVisible;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsInputs;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsInputs:(ServiceSvc_ClsInputs *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsInputs;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInputsTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsInputs * GetInputsTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInputsTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsInputs * GetInputsTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInputLookupTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInputLookupTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * InputID;
	// NSNumber * ValueID;
	// NSString * ValueName;
	// NSString * Page;
	// NSString * ExcludedCCIDs;
	// NSNumber * ExcludeAllCC;
	// NSNumber * SortIndex;
	// NSString * Code;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSNumber * ValueID;
@property (nonatomic, strong) NSString * ValueName;
@property (nonatomic, strong) NSString * Page;
@property (nonatomic, strong) NSString * ExcludedCCIDs;
@property (nonatomic, strong) NSNumber * ExcludeAllCC;
@property (nonatomic, strong) NSNumber * SortIndex;
@property (nonatomic, strong) NSString * Code;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsInputLookup;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsInputLookup:(ServiceSvc_ClsInputLookup *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsInputLookup;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInputLookupTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsInputLookup * GetInputLookupTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInputLookupTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsInputLookup * GetInputLookupTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetTreatmentsTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetTreatmentsTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTreatments : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TreatmentID;
	// NSString * TreatmentDesc;
	// NSNumber * TreatmentFilter;
	// NSNumber * Active;
	// NSNumber * SortIndex;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTreatments *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TreatmentID;
@property (nonatomic, strong) NSString * TreatmentDesc;
@property (nonatomic, strong) NSNumber * TreatmentFilter;
@property (nonatomic, strong) NSNumber * Active;
@property (nonatomic, strong) NSNumber * SortIndex;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTreatments : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTreatments;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTreatments *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTreatments:(ServiceSvc_ClsTreatments *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTreatments;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetTreatmentsTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTreatments * GetTreatmentsTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetTreatmentsTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTreatments * GetTreatmentsTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetTreatmentInputsTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetTreatmentInputsTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTreatmentInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TreatmentID;
	// NSNumber * InputID;
	// NSString * InputName;
	// NSNumber * InputIndex;
	// NSNumber * InputDataType;
	// NSNumber * Active;
	// NSNumber * InputRequired;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTreatmentInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TreatmentID;
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSString * InputName;
@property (nonatomic, strong) NSNumber * InputIndex;
@property (nonatomic, strong) NSNumber * InputDataType;
@property (nonatomic, strong) NSNumber * Active;
@property (nonatomic, strong) NSNumber * InputRequired;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTreatmentInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTreatmentInputs;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTreatmentInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTreatmentInputs:(ServiceSvc_ClsTreatmentInputs *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTreatmentInputs;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetTreatmentInputsTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTreatmentInputs * GetTreatmentInputsTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetTreatmentInputsTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTreatmentInputs * GetTreatmentInputsTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetTreatmentInputLookupTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetTreatmentInputLookupTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTreatmentInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TreatmentID;
	// NSNumber * InputID;
	// NSNumber * InputLookupID;
	// NSString * LookupName;
	// NSNumber * Active;
	// NSString * Code;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTreatmentInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TreatmentID;
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSNumber * InputLookupID;
@property (nonatomic, strong) NSString * LookupName;
@property (nonatomic, strong) NSNumber * Active;
@property (nonatomic, strong) NSString * Code;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTreatmentInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTreatmentInputLookup;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTreatmentInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTreatmentInputLookup:(ServiceSvc_ClsTreatmentInputLookup *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTreatmentInputLookup;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetTreatmentInputLookupTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTreatmentInputLookup * GetTreatmentInputLookupTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetTreatmentInputLookupTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTreatmentInputLookup * GetTreatmentInputLookupTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCertificationTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCertificationTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsCertification : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * CertUID;
	// NSString * CertName;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsCertification *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * CertUID;
@property (nonatomic, strong) NSString * CertName;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsCertification : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsCertification;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsCertification *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsCertification:(ServiceSvc_ClsCertification *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsCertification;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCertificationTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsCertification * GetCertificationTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCertificationTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsCertification * GetCertificationTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetChiefComplaintsTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetChiefComplaintsTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsChiefComplaints : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * CCID;
	// NSString * CCDescription;
	// NSNumber * CCType;
	// NSNumber * CCUserDefined;
	// NSNumber * CCActive;
	// NSString * CCClarify;
	// NSString * CCFilter;
	// NSString * CustomCode;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsChiefComplaints *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * CCID;
@property (nonatomic, strong) NSString * CCDescription;
@property (nonatomic, strong) NSNumber * CCType;
@property (nonatomic, strong) NSNumber * CCUserDefined;
@property (nonatomic, strong) NSNumber * CCActive;
@property (nonatomic, strong) NSString * CCClarify;
@property (nonatomic, strong) NSString * CCFilter;
@property (nonatomic, strong) NSString * CustomCode;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsChiefComplaints : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsChiefComplaints;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsChiefComplaints *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsChiefComplaints:(ServiceSvc_ClsChiefComplaints *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsChiefComplaints;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetChiefComplaintsTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsChiefComplaints * GetChiefComplaintsTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetChiefComplaintsTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsChiefComplaints * GetChiefComplaintsTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCitiesTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCitiesTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsCities : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * CityID;
	// NSString * CityName;
	// NSNumber * CountyID;
	// NSNumber * ListIndex;
	// NSNumber * Active;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsCities *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * CityID;
@property (nonatomic, strong) NSString * CityName;
@property (nonatomic, strong) NSNumber * CountyID;
@property (nonatomic, strong) NSNumber * ListIndex;
@property (nonatomic, strong) NSNumber * Active;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsCities : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsCities;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsCities *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsCities:(ServiceSvc_ClsCities *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsCities;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCitiesTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsCities * GetCitiesTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCitiesTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsCities * GetCitiesTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetControlFiltersTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetControlFiltersTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsControlFilters : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * CCID;
	// NSNumber * ControlID;
	// NSString * ControlType;
	// NSNumber * RequiredField;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsControlFilters *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * CCID;
@property (nonatomic, strong) NSNumber * ControlID;
@property (nonatomic, strong) NSString * ControlType;
@property (nonatomic, strong) NSNumber * RequiredField;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsControlFilters : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsControlFilters;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsControlFilters *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsControlFilters:(ServiceSvc_ClsControlFilters *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsControlFilters;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetControlFiltersTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsControlFilters * GetControlFiltersTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetControlFiltersTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsControlFilters * GetControlFiltersTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCountiesTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCountiesTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsCounties : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * CountyID;
	// NSString * CountyName;
	// NSNumber * StateID;
	// NSNumber * ListIndex;
	// NSNumber * Active;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsCounties *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * CountyID;
@property (nonatomic, strong) NSString * CountyName;
@property (nonatomic, strong) NSNumber * StateID;
@property (nonatomic, strong) NSNumber * ListIndex;
@property (nonatomic, strong) NSNumber * Active;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsCounties : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsCounties;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsCounties *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsCounties:(ServiceSvc_ClsCounties *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsCounties;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCountiesTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsCounties * GetCountiesTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCountiesTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsCounties * GetCountiesTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCrewRideTypesTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCrewRideTypesTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsCrewRideTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * RideID;
	// NSString * Description;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsCrewRideTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * RideID;
@property (nonatomic, strong) NSString * Description;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsCrewRideTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsCrewRideTypes;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsCrewRideTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsCrewRideTypes:(ServiceSvc_ClsCrewRideTypes *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsCrewRideTypes;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCrewRideTypesTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsCrewRideTypes * GetCrewRideTypesTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCrewRideTypesTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsCrewRideTypes * GetCrewRideTypesTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomerContentTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomerContentTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsCustomerContent : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * FileType;
	// NSString * FileName;
	// NSString * FileString;
	// NSNumber * FileSize;
	// NSNumber * FileID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsCustomerContent *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * FileType;
@property (nonatomic, strong) NSString * FileName;
@property (nonatomic, strong) NSString * FileString;
@property (nonatomic, strong) NSNumber * FileSize;
@property (nonatomic, strong) NSNumber * FileID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsCustomerContent : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsCustomerContent;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsCustomerContent *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsCustomerContent:(ServiceSvc_ClsCustomerContent *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsCustomerContent;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomerContentTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsCustomerContent * GetCustomerContentTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomerContentTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsCustomerContent * GetCustomerContentTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomFormExclusion : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomFormExclusion *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsCustomFormExclusions : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * FormID;
	// NSNumber * ExclusionID;
	// NSNumber * InputID;
	// NSString * InputValue;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsCustomFormExclusions *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * FormID;
@property (nonatomic, strong) NSNumber * ExclusionID;
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSString * InputValue;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsCustomFormExclusions : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsCustomFormExclusions;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsCustomFormExclusions *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsCustomFormExclusions:(ServiceSvc_ClsCustomFormExclusions *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsCustomFormExclusions;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomFormExclusionResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsCustomFormExclusions * GetCustomFormExclusionResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomFormExclusionResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsCustomFormExclusions * GetCustomFormExclusionResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomFormInputLookUp : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomFormInputLookUp *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsCustomFormInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * FormID;
	// NSNumber * InputID;
	// NSNumber * InputLookupID;
	// NSString * LookupName;
	// NSNumber * Active;
	// NSString * Code;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsCustomFormInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * FormID;
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSNumber * InputLookupID;
@property (nonatomic, strong) NSString * LookupName;
@property (nonatomic, strong) NSNumber * Active;
@property (nonatomic, strong) NSString * Code;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsCustomFormInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsCustomFormInputLookup;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsCustomFormInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsCustomFormInputLookup:(ServiceSvc_ClsCustomFormInputLookup *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsCustomFormInputLookup;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomFormInputLookUpResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsCustomFormInputLookup * GetCustomFormInputLookUpResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomFormInputLookUpResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsCustomFormInputLookup * GetCustomFormInputLookUpResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomForms : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomForms *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsCustomForms : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * FormID;
	// NSString * FormDescription;
	// NSString * DateAdded;
	// NSNumber * Active;
	// NSString * TriggerAndOr;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsCustomForms *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * FormID;
@property (nonatomic, strong) NSString * FormDescription;
@property (nonatomic, strong) NSString * DateAdded;
@property (nonatomic, strong) NSNumber * Active;
@property (nonatomic, strong) NSString * TriggerAndOr;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsCustomForms : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsCustomForms;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsCustomForms *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsCustomForms:(ServiceSvc_ClsCustomForms *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsCustomForms;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomFormsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsCustomForms * GetCustomFormsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomFormsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsCustomForms * GetCustomFormsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomFormInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomFormInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsCustomFormInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * FormID;
	// NSNumber * InputID;
	// NSString * InputName;
	// NSString * InputDescription;
	// NSNumber * InputDataType;
	// NSString * InputGroup;
	// NSNumber * InputRequired;
	// NSNumber * InputIndex;
	// NSNumber * Active;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsCustomFormInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * FormID;
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSString * InputName;
@property (nonatomic, strong) NSString * InputDescription;
@property (nonatomic, strong) NSNumber * InputDataType;
@property (nonatomic, strong) NSString * InputGroup;
@property (nonatomic, strong) NSNumber * InputRequired;
@property (nonatomic, strong) NSNumber * InputIndex;
@property (nonatomic, strong) NSNumber * Active;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsCustomFormInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsCustomFormInputs;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsCustomFormInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsCustomFormInputs:(ServiceSvc_ClsCustomFormInputs *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsCustomFormInputs;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetCustomFormInputsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsCustomFormInputs * GetCustomFormInputsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetCustomFormInputsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsCustomFormInputs * GetCustomFormInputsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetDrugDosages : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetDrugDosages *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsDrugDosages : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * DrugID;
	// NSNumber * DosageID;
	// NSNumber * Units;
	// NSString * Dosage;
	// NSString * Route;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsDrugDosages *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * DrugID;
@property (nonatomic, strong) NSNumber * DosageID;
@property (nonatomic, strong) NSNumber * Units;
@property (nonatomic, strong) NSString * Dosage;
@property (nonatomic, strong) NSString * Route;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsDrugDosages : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsDrugDosages;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsDrugDosages *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsDrugDosages:(ServiceSvc_ClsDrugDosages *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsDrugDosages;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetDrugDosagesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsDrugDosages * GetDrugDosagesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetDrugDosagesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsDrugDosages * GetDrugDosagesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetDrugs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetDrugs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsDrugs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * DrugID;
	// NSString * DrugName;
	// NSNumber * Narcotic;
	// NSNumber * DefaultDosage;
	// NSNumber * SortIndex;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsDrugs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * DrugID;
@property (nonatomic, strong) NSString * DrugName;
@property (nonatomic, strong) NSNumber * Narcotic;
@property (nonatomic, strong) NSNumber * DefaultDosage;
@property (nonatomic, strong) NSNumber * SortIndex;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsDrugs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsDrugs;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsDrugs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsDrugs:(ServiceSvc_ClsDrugs *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsDrugs;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetDrugsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsDrugs * GetDrugsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetDrugsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsDrugs * GetDrugsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetForms : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetForms *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsForms : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * FormID;
	// NSString * FormDescription;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsForms *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * FormID;
@property (nonatomic, strong) NSString * FormDescription;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsForms : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsForms;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsForms *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsForms:(ServiceSvc_ClsForms *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsForms;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetFormsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsForms * GetFormsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetFormsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsForms * GetFormsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetGroups : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetGroups *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsGroups : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * GroupID;
	// NSString * GroupDescription;
	// NSNumber * GroupAccessLevel;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsGroups *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * GroupID;
@property (nonatomic, strong) NSString * GroupDescription;
@property (nonatomic, strong) NSNumber * GroupAccessLevel;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsGroups : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsGroups;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsGroups *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsGroups:(ServiceSvc_ClsGroups *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsGroups;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetGroupsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsGroups * GetGroupsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetGroupsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsGroups * GetGroupsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInjuryTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInjuryTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsInjuryTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * InjuryTypeID;
	// NSString * InjuryTypeName;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsInjuryTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * InjuryTypeID;
@property (nonatomic, strong) NSString * InjuryTypeName;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsInjuryTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsInjuryTypes;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsInjuryTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsInjuryTypes:(ServiceSvc_ClsInjuryTypes *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsInjuryTypes;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInjuryTypesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsInjuryTypes * GetInjuryTypesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInjuryTypesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsInjuryTypes * GetInjuryTypesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInsurance : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInsurance *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsInsurance : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * InsuranceID;
	// NSString * InsuranceName;
	// NSString * InsuranceAddress;
	// NSString * InsurancePhone;
	// NSString * InsuranceCode;
	// NSString * InsuranceType;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsInsurance *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * InsuranceID;
@property (nonatomic, strong) NSString * InsuranceName;
@property (nonatomic, strong) NSString * InsuranceAddress;
@property (nonatomic, strong) NSString * InsurancePhone;
@property (nonatomic, strong) NSString * InsuranceCode;
@property (nonatomic, strong) NSString * InsuranceType;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsInsurance : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsInsurance;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsInsurance *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsInsurance:(ServiceSvc_ClsInsurance *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsInsurance;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInsuranceResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsInsurance * GetInsuranceResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInsuranceResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsInsurance * GetInsuranceResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInsuranceInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInsuranceInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsInsuranceInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * InsID;
	// NSNumber * InputID;
	// NSNumber * InputLookupID;
	// NSString * LookupName;
	// NSNumber * Active;
	// NSString * Code;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsInsuranceInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * InsID;
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSNumber * InputLookupID;
@property (nonatomic, strong) NSString * LookupName;
@property (nonatomic, strong) NSNumber * Active;
@property (nonatomic, strong) NSString * Code;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsInsuranceInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsInsuranceInputLookup;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsInsuranceInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsInsuranceInputLookup:(ServiceSvc_ClsInsuranceInputLookup *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsInsuranceInputLookup;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInsuranceInputLookupResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsInsuranceInputLookup * GetInsuranceInputLookupResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInsuranceInputLookupResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsInsuranceInputLookup * GetInsuranceInputLookupResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInsuranceInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInsuranceInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsInsuranceInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * InsID;
	// NSNumber * InputID;
	// NSString * InputName;
	// NSString * InputAltName;
	// NSNumber * InputIndex;
	// NSNumber * InputDataType;
	// NSNumber * Active;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsInsuranceInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * InsID;
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSString * InputName;
@property (nonatomic, strong) NSString * InputAltName;
@property (nonatomic, strong) NSNumber * InputIndex;
@property (nonatomic, strong) NSNumber * InputDataType;
@property (nonatomic, strong) NSNumber * Active;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsInsuranceInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsInsuranceInputs;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsInsuranceInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsInsuranceInputs:(ServiceSvc_ClsInsuranceInputs *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsInsuranceInputs;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInsuranceInputsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsInsuranceInputs * GetInsuranceInputsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInsuranceInputsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsInsuranceInputs * GetInsuranceInputsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInsuranceTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInsuranceTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsInsuranceTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * InsID;
	// NSString * InsDescription;
	// NSString * InsAltDescription;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsInsuranceTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * InsID;
@property (nonatomic, strong) NSString * InsDescription;
@property (nonatomic, strong) NSString * InsAltDescription;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsInsuranceTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsInsuranceTypes;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsInsuranceTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsInsuranceTypes:(ServiceSvc_ClsInsuranceTypes *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsInsuranceTypes;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetInsuranceTypesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsInsuranceTypes * GetInsuranceTypesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetInsuranceTypesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsInsuranceTypes * GetInsuranceTypesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetLocations : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetLocations *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsLocations : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * LocationID;
	// NSString * LocationName;
	// NSString * LocationAddress1;
	// NSString * LocationAddress2;
	// NSString * LocationCity;
	// NSString * LocationZip;
	// NSString * LocationPhone;
	// NSString * LocationPhone2;
	// NSString * LocationFax;
	// NSString * LocationFax2;
	// NSString * LocationState;
	// NSNumber * SortIndex;
	// NSString * LocationCode;
	// NSNumber * LocationType;
	// NSString * SystemNumber;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsLocations *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * LocationID;
@property (nonatomic, strong) NSString * LocationName;
@property (nonatomic, strong) NSString * LocationAddress1;
@property (nonatomic, strong) NSString * LocationAddress2;
@property (nonatomic, strong) NSString * LocationCity;
@property (nonatomic, strong) NSString * LocationZip;
@property (nonatomic, strong) NSString * LocationPhone;
@property (nonatomic, strong) NSString * LocationPhone2;
@property (nonatomic, strong) NSString * LocationFax;
@property (nonatomic, strong) NSString * LocationFax2;
@property (nonatomic, strong) NSString * LocationState;
@property (nonatomic, strong) NSNumber * SortIndex;
@property (nonatomic, strong) NSString * LocationCode;
@property (nonatomic, strong) NSNumber * LocationType;
@property (nonatomic, strong) NSString * SystemNumber;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsLocations : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsLocations;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsLocations *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsLocations:(ServiceSvc_ClsLocations *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsLocations;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetLocationsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsLocations * GetLocationsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetLocationsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsLocations * GetLocationsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMedications : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMedications *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsMedications : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * MedicationID;
	// NSString * MedicationName;
	// NSNumber * MedicationType;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsMedications *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * MedicationID;
@property (nonatomic, strong) NSString * MedicationName;
@property (nonatomic, strong) NSNumber * MedicationType;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsMedications : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsMedications;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsMedications *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsMedications:(ServiceSvc_ClsMedications *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsMedications;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMedicationsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsMedications * GetMedicationsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMedicationsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsMedications * GetMedicationsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetPages : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetPages *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsPages : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TabID;
	// NSNumber * FormID;
	// NSString * TabDescription;
	// NSString * TabName;
	// NSNumber * InitialTab;
	// NSNumber * Visible;
	// NSNumber * SortIndex;
	// NSString * AltDescription;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsPages *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TabID;
@property (nonatomic, strong) NSNumber * FormID;
@property (nonatomic, strong) NSString * TabDescription;
@property (nonatomic, strong) NSString * TabName;
@property (nonatomic, strong) NSNumber * InitialTab;
@property (nonatomic, strong) NSNumber * Visible;
@property (nonatomic, strong) NSNumber * SortIndex;
@property (nonatomic, strong) NSString * AltDescription;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsPages : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsPages;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsPages *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsPages:(ServiceSvc_ClsPages *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsPages;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetPagesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsPages * GetPagesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetPagesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsPages * GetPagesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetProtocolFiles : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetProtocolFiles *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsProtocolFiles : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * ProtocolID;
	// NSString * ProtocolButtonText;
	// NSString * ProtocolFileString;
	// NSNumber * ProtocolFileVersion;
	// NSString * ProtocolFileName;
	// NSNumber * ProtocolGroup;
	// NSNumber * SortIndex;
	// NSNumber * Active;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsProtocolFiles *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * ProtocolID;
@property (nonatomic, strong) NSString * ProtocolButtonText;
@property (nonatomic, strong) NSString * ProtocolFileString;
@property (nonatomic, strong) NSNumber * ProtocolFileVersion;
@property (nonatomic, strong) NSString * ProtocolFileName;
@property (nonatomic, strong) NSNumber * ProtocolGroup;
@property (nonatomic, strong) NSNumber * SortIndex;
@property (nonatomic, strong) NSNumber * Active;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsProtocolFiles : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsProtocolFiles;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsProtocolFiles *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsProtocolFiles:(ServiceSvc_ClsProtocolFiles *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsProtocolFiles;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetProtocolFilesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsProtocolFiles * GetProtocolFilesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetProtocolFilesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsProtocolFiles * GetProtocolFilesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetProtocolGroups : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetProtocolGroups *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsProtocolGroups : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * ProtocolGroupID;
	// NSString * ProtocolGroupDesc;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsProtocolGroups *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * ProtocolGroupID;
@property (nonatomic, strong) NSString * ProtocolGroupDesc;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsProtocolGroups : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsProtocolGroups;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsProtocolGroups *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsProtocolGroups:(ServiceSvc_ClsProtocolGroups *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsProtocolGroups;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetProtocolGroupsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsProtocolGroups * GetProtocolGroupsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetProtocolGroupsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsProtocolGroups * GetProtocolGroupsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetQuickButtons : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetQuickButtons *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsQuickButtons : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * CCID;
	// NSNumber * InputType;
	// NSNumber * InputID;
	// NSNumber * Type;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsQuickButtons *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * CCID;
@property (nonatomic, strong) NSNumber * InputType;
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSNumber * Type;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsQuickButtons : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsQuickButtons;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsQuickButtons *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsQuickButtons:(ServiceSvc_ClsQuickButtons *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsQuickButtons;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetQuickButtonsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsQuickButtons * GetQuickButtonsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetQuickButtonsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsQuickButtons * GetQuickButtonsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetShifts : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetShifts *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsShifts : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * ShiftID;
	// NSString * ShiftName;
	// NSNumber * ShiftHours;
	// NSString * ShiftStart;
	// NSString * ShiftRefDate;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsShifts *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * ShiftID;
@property (nonatomic, strong) NSString * ShiftName;
@property (nonatomic, strong) NSNumber * ShiftHours;
@property (nonatomic, strong) NSString * ShiftStart;
@property (nonatomic, strong) NSString * ShiftRefDate;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsShifts : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsShifts;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsShifts *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsShifts:(ServiceSvc_ClsShifts *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsShifts;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetShiftsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsShifts * GetShiftsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetShiftsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsShifts * GetShiftsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetSignatureTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetSignatureTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsSignatureTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * SignatureType;
	// NSString * SignatureTypeDesc;
	// NSString * DisclaimerText;
	// NSString * SignatureGroup;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsSignatureTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * SignatureType;
@property (nonatomic, strong) NSString * SignatureTypeDesc;
@property (nonatomic, strong) NSString * DisclaimerText;
@property (nonatomic, strong) NSString * SignatureGroup;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsSignatureTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsSignatureTypes;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsSignatureTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsSignatureTypes:(ServiceSvc_ClsSignatureTypes *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsSignatureTypes;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetSignatureTypesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsSignatureTypes * GetSignatureTypesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetSignatureTypesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsSignatureTypes * GetSignatureTypesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetStates : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetStates *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsStates : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * StateID;
	// NSString * StateName;
	// NSNumber * ListIndex;
	// NSNumber * Active;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsStates *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * StateID;
@property (nonatomic, strong) NSString * StateName;
@property (nonatomic, strong) NSNumber * ListIndex;
@property (nonatomic, strong) NSNumber * Active;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsStates : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsStates;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsStates *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsStates:(ServiceSvc_ClsStates *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsStates;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetStatesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsStates * GetStatesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetStatesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsStates * GetStatesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetStations : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetStations *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsStations : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * StationID;
	// NSString * StationDescription;
	// NSString * StationAddress;
	// NSString * StationCity;
	// NSString * StationState;
	// NSString * StationZip;
	// NSString * StationPhone;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsStations *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * StationID;
@property (nonatomic, strong) NSString * StationDescription;
@property (nonatomic, strong) NSString * StationAddress;
@property (nonatomic, strong) NSString * StationCity;
@property (nonatomic, strong) NSString * StationState;
@property (nonatomic, strong) NSString * StationZip;
@property (nonatomic, strong) NSString * StationPhone;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsStations : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsStations;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsStations *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsStations:(ServiceSvc_ClsStations *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsStations;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetStationsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsStations * GetStationsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetStationsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsStations * GetStationsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetStatus : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetStatus *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsStatus : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * StatusID;
	// NSString * StatusDescription;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsStatus *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * StatusID;
@property (nonatomic, strong) NSString * StatusDescription;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsStatus : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsStatus;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsStatus *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsStatus:(ServiceSvc_ClsStatus *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetStatusResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsStatus * GetStatusResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetStatusResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsStatus * GetStatusResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetUsers : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetUsers *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsUsers : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * UserID;
	// NSString * UserFirstName;
	// NSString * UserLastName;
	// NSString * UserAddress;
	// NSNumber * UserCity;
	// NSNumber * UserState;
	// NSString * UserZip;
	// NSNumber * UserAge;
	// NSNumber * UserUnit;
	// NSNumber * UserActive;
	// NSNumber * UserCertification;
	// NSString * UserCertStart;
	// NSString * UserCertEnd;
	// NSString * UserCertNum;
	// NSString * UserPassword;
	// NSNumber * UserGroup;
	// NSString * UserIDNumber;
	// NSString * City;
	// NSString * State;
	// NSString * UserEmailAddress;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsUsers *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * UserID;
@property (nonatomic, strong) NSString * UserFirstName;
@property (nonatomic, strong) NSString * UserLastName;
@property (nonatomic, strong) NSString * UserAddress;
@property (nonatomic, strong) NSNumber * UserCity;
@property (nonatomic, strong) NSNumber * UserState;
@property (nonatomic, strong) NSString * UserZip;
@property (nonatomic, strong) NSNumber * UserAge;
@property (nonatomic, strong) NSNumber * UserUnit;
@property (nonatomic, strong) NSNumber * UserActive;
@property (nonatomic, strong) NSNumber * UserCertification;
@property (nonatomic, strong) NSString * UserCertStart;
@property (nonatomic, strong) NSString * UserCertEnd;
@property (nonatomic, strong) NSString * UserCertNum;
@property (nonatomic, strong) NSString * UserPassword;
@property (nonatomic, strong) NSNumber * UserGroup;
@property (nonatomic, strong) NSString * UserIDNumber;
@property (nonatomic, strong) NSString * City;
@property (nonatomic, strong) NSString * State;
@property (nonatomic, strong) NSString * UserEmailAddress;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsUsers : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsUsers;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsUsers *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsUsers:(ServiceSvc_ClsUsers *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsUsers;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetUsersResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsUsers * GetUsersResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetUsersResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsUsers * GetUsersResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetZips : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetZips *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsZips : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * ZipText;
	// NSNumber * CityID;
	// NSNumber * ListIndex;
	// NSNumber * Active;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsZips *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * ZipText;
@property (nonatomic, strong) NSNumber * CityID;
@property (nonatomic, strong) NSNumber * ListIndex;
@property (nonatomic, strong) NSNumber * Active;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsZips : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsZips;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsZips *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsZips:(ServiceSvc_ClsZips *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsZips;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetZipsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsZips * GetZipsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetZipsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsZips * GetZipsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetVitalsTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetVitalsTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsVitals : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * InputID;
	// NSString * InputDesc;
	// NSString * VitalName;
	// NSNumber * VitalRequired;
	// NSNumber * VitalVisible;
	// NSNumber * VitalDataType;
	// NSNumber * DetailsID;
	// NSString * DetailsName;
	// NSString * DetailsButtons;
	// NSNumber * VitalsIndex;
	// NSString * VitalsGroup;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsVitals *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSString * InputDesc;
@property (nonatomic, strong) NSString * VitalName;
@property (nonatomic, strong) NSNumber * VitalRequired;
@property (nonatomic, strong) NSNumber * VitalVisible;
@property (nonatomic, strong) NSNumber * VitalDataType;
@property (nonatomic, strong) NSNumber * DetailsID;
@property (nonatomic, strong) NSString * DetailsName;
@property (nonatomic, strong) NSString * DetailsButtons;
@property (nonatomic, strong) NSNumber * VitalsIndex;
@property (nonatomic, strong) NSString * VitalsGroup;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsVitals : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsVitals;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsVitals *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsVitals:(ServiceSvc_ClsVitals *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsVitals;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetVitalsTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsVitals * GetVitalsTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetVitalsTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsVitals * GetVitalsTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetVitalInputLookupTable : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetVitalInputLookupTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsVitalInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * VitalInputID;
	// NSNumber * VitalInputIndex;
	// NSString * VitalInputDesc;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsVitalInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * VitalInputID;
@property (nonatomic, strong) NSNumber * VitalInputIndex;
@property (nonatomic, strong) NSString * VitalInputDesc;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsVitalInputLookup : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsVitalInputLookup;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsVitalInputLookup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsVitalInputLookup:(ServiceSvc_ClsVitalInputLookup *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsVitalInputLookup;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetVitalInputLookupTableResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsVitalInputLookup * GetVitalInputLookupTableResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetVitalInputLookupTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsVitalInputLookup * GetVitalInputLookupTableResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetUnits : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetUnits *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsUnits : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * UnitID;
	// NSString * UnitDescription;
	// NSNumber * StationID;
	// NSString * RegionID;
	// NSString * UnitType;
	// NSNumber * VehicleType;
	// NSNumber * CADDispatchable;
	// NSString * CADUnitDescription;
	// NSNumber * InterAgency;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsUnits *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * UnitID;
@property (nonatomic, strong) NSString * UnitDescription;
@property (nonatomic, strong) NSNumber * StationID;
@property (nonatomic, strong) NSString * RegionID;
@property (nonatomic, strong) NSString * UnitType;
@property (nonatomic, strong) NSNumber * VehicleType;
@property (nonatomic, strong) NSNumber * CADDispatchable;
@property (nonatomic, strong) NSString * CADUnitDescription;
@property (nonatomic, strong) NSNumber * InterAgency;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsUnits : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsUnits;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsUnits *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsUnits:(ServiceSvc_ClsUnits *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsUnits;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetUnitsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsUnits * GetUnitsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetUnitsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsUnits * GetUnitsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetSettings : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetSettings *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsSettings : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * SettingID;
	// NSString * SettingDesc;
	// NSString * SettingValue;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsSettings *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * SettingID;
@property (nonatomic, strong) NSString * SettingDesc;
@property (nonatomic, strong) NSString * SettingValue;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsSettings : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsSettings;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsSettings *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsSettings:(ServiceSvc_ClsSettings *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsSettings;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetSettingsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsSettings * GetSettingsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetSettingsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsSettings * GetSettingsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetxInputTables : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetxInputTables *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsXInputTables : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * IT_TableName;
	// NSString * IT_HashCode;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsXInputTables *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * IT_TableName;
@property (nonatomic, strong) NSString * IT_HashCode;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsXInputTables : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsXInputTables;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsXInputTables *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsXInputTables:(ServiceSvc_ClsXInputTables *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsXInputTables;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetxInputTablesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsXInputTables * GetxInputTablesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetxInputTablesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsXInputTables * GetxInputTablesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetOutcomes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetOutcomes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsOutcomes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * OutcomeID;
	// NSNumber * TransportType;
	// NSString * Description;
	// NSNumber * SortIndex;
	// NSNumber * Active;
	// NSString * AltDescription;
	// NSNumber * TriggerID;
	// NSNumber * CustomFlag;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsOutcomes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * OutcomeID;
@property (nonatomic, strong) NSNumber * TransportType;
@property (nonatomic, strong) NSString * Description;
@property (nonatomic, strong) NSNumber * SortIndex;
@property (nonatomic, strong) NSNumber * Active;
@property (nonatomic, strong) NSString * AltDescription;
@property (nonatomic, strong) NSNumber * TriggerID;
@property (nonatomic, strong) NSNumber * CustomFlag;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsOutcomes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsOutcomes;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsOutcomes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsOutcomes:(ServiceSvc_ClsOutcomes *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsOutcomes;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetOutcomesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsOutcomes * GetOutcomesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetOutcomesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsOutcomes * GetOutcomesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetOutcomeTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetOutcomeTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsOutcomeTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * OutcomeTypeID;
	// NSString * OutcomeTypeDesc;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsOutcomeTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * OutcomeTypeID;
@property (nonatomic, strong) NSString * OutcomeTypeDesc;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsOutcomeTypes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsOutcomeTypes;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsOutcomeTypes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsOutcomeTypes:(ServiceSvc_ClsOutcomeTypes *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsOutcomeTypes;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetOutcomeTypesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsOutcomeTypes * GetOutcomeTypesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetOutcomeTypesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsOutcomeTypes * GetOutcomeTypesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetOutcomeRequiredItems : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetOutcomeRequiredItems *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsOutcomeRequiredItems : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * OutcomeID;
	// NSNumber * OutcomeReqID;
	// NSNumber * InputID;
	// NSString * OutcomeReqDescription;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsOutcomeRequiredItems *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * OutcomeID;
@property (nonatomic, strong) NSNumber * OutcomeReqID;
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSString * OutcomeReqDescription;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsOutcomeRequiredItems : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsOutcomeRequiredItems;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsOutcomeRequiredItems *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsOutcomeRequiredItems:(ServiceSvc_ClsOutcomeRequiredItems *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsOutcomeRequiredItems;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetOutcomeRequiredItemsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsOutcomeRequiredItems * GetOutcomeRequiredItemsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetOutcomeRequiredItemsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsOutcomeRequiredItems * GetOutcomeRequiredItemsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetOutcomeRequiredSignatures : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetOutcomeRequiredSignatures *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsOutcomeRequiredSignatures : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * OutcomeID;
	// NSString * SignatureGroupID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsOutcomeRequiredSignatures *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * OutcomeID;
@property (nonatomic, strong) NSString * SignatureGroupID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsOutcomeRequiredSignatures : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsOutcomeRequiredSignatures;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsOutcomeRequiredSignatures *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsOutcomeRequiredSignatures:(ServiceSvc_ClsOutcomeRequiredSignatures *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsOutcomeRequiredSignatures;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetOutcomeRequiredSignaturesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsOutcomeRequiredSignatures * GetOutcomeRequiredSignaturesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetOutcomeRequiredSignaturesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsOutcomeRequiredSignatures * GetOutcomeRequiredSignaturesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsChangeQue : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * ChangeID;
	// NSString * TableName;
	// NSNumber * LocalTicketID;
	// NSNumber * TicketID;
	// NSString * TicketGUID;
	// NSNumber * IDX1;
	// NSNumber * IDX2;
	// NSNumber * IDX3;
	// NSString * FieldName;
	// NSString * Value;
	// NSNumber * InputInstance;
	// NSNumber * InputSubID;
	// NSString * InputPage;
	// NSString * DEL;
	// NSString * DateModified;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsChangeQue *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * ChangeID;
@property (nonatomic, strong) NSString * TableName;
@property (nonatomic, strong) NSNumber * LocalTicketID;
@property (nonatomic, strong) NSNumber * TicketID;
@property (nonatomic, strong) NSString * TicketGUID;
@property (nonatomic, strong) NSNumber * IDX1;
@property (nonatomic, strong) NSNumber * IDX2;
@property (nonatomic, strong) NSNumber * IDX3;
@property (nonatomic, strong) NSString * FieldName;
@property (nonatomic, strong) NSString * Value;
@property (nonatomic, strong) NSNumber * InputInstance;
@property (nonatomic, strong) NSNumber * InputSubID;
@property (nonatomic, strong) NSString * InputPage;
@property (nonatomic, strong) NSString * DEL;
@property (nonatomic, strong) NSString * DateModified;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsChangeQue : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsChangeQue;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsChangeQue *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsChangeQue:(ServiceSvc_ClsChangeQue *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsChangeQue;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_UpdateChange6 : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsChangeQue * dsChangesMade;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * locationInfo;
	// USBoolean * lockedOut;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_UpdateChange6 *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsChangeQue * dsChangesMade;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * locationInfo;
@property (nonatomic, strong) USBoolean * lockedOut;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTicketUpdate : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CompletedChanges;
	// NSNumber * ServerTicketID;
	// NSString * StrRecvHash;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTicketUpdate *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CompletedChanges;
@property (nonatomic, strong) NSNumber * ServerTicketID;
@property (nonatomic, strong) NSString * StrRecvHash;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_UpdateChange6Response : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ClsTicketUpdate * UpdateChange6Result;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_UpdateChange6Response *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ClsTicketUpdate * UpdateChange6Result;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTickets : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TicketID;
	// NSString * TicketGUID;
	// NSString * TicketIncidentNumber;
	// NSString * TicketDesc;
	// NSString * TicketDOS;
	// NSNumber * TicketStatus;
	// NSNumber * TicketOwner;
	// NSNumber * TicketCreator;
	// NSNumber * TicketUnitNumber;
	// NSNumber * TicketFinalized;
	// NSString * TicketDateFinalized;
	// NSString * TicketCrew;
	// NSNumber * TicketPractice;
	// NSString * TicketCreatedTime;
	// NSNumber * TicketShift;
	// NSNumber * TicketLocked;
	// NSNumber * TicketReviewed;
	// NSString * TicketAdminNotes;
	// NSNumber * TicketAccount;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTickets *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TicketID;
@property (nonatomic, strong) NSString * TicketGUID;
@property (nonatomic, strong) NSString * TicketIncidentNumber;
@property (nonatomic, strong) NSString * TicketDesc;
@property (nonatomic, strong) NSString * TicketDOS;
@property (nonatomic, strong) NSNumber * TicketStatus;
@property (nonatomic, strong) NSNumber * TicketOwner;
@property (nonatomic, strong) NSNumber * TicketCreator;
@property (nonatomic, strong) NSNumber * TicketUnitNumber;
@property (nonatomic, strong) NSNumber * TicketFinalized;
@property (nonatomic, strong) NSString * TicketDateFinalized;
@property (nonatomic, strong) NSString * TicketCrew;
@property (nonatomic, strong) NSNumber * TicketPractice;
@property (nonatomic, strong) NSString * TicketCreatedTime;
@property (nonatomic, strong) NSNumber * TicketShift;
@property (nonatomic, strong) NSNumber * TicketLocked;
@property (nonatomic, strong) NSNumber * TicketReviewed;
@property (nonatomic, strong) NSString * TicketAdminNotes;
@property (nonatomic, strong) NSNumber * TicketAccount;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTickets : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTickets;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTickets *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTickets:(ServiceSvc_ClsTickets *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTickets;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicket : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTickets * dsChangesMade;
	// NSString * CustomerID;
	// NSString * MachineID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicket *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTickets * dsChangesMade;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ClsTicketUpdate * BackupTicketResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ClsTicketUpdate * BackupTicketResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTicketInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TicketID;
	// NSNumber * InputID;
	// NSNumber * InputSubID;
	// NSNumber * InputInstance;
	// NSString * InputPage;
	// NSString * InputName;
	// NSString * InputValue;
	// NSNumber * Deleted;
	// NSNumber * Modified;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTicketInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TicketID;
@property (nonatomic, strong) NSNumber * InputID;
@property (nonatomic, strong) NSNumber * InputSubID;
@property (nonatomic, strong) NSNumber * InputInstance;
@property (nonatomic, strong) NSString * InputPage;
@property (nonatomic, strong) NSString * InputName;
@property (nonatomic, strong) NSString * InputValue;
@property (nonatomic, strong) NSNumber * Deleted;
@property (nonatomic, strong) NSNumber * Modified;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTicketInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTicketInputs;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTicketInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTicketInputs:(ServiceSvc_ClsTicketInputs *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTicketInputs;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketInputs * dsChangesMade;
	// NSString * CustomerID;
	// NSString * MachineID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketInputs * dsChangesMade;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketInputsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ClsTicketUpdate * BackupTicketInputsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketInputsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ClsTicketUpdate * BackupTicketInputsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTicketNotes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TicketID;
	// NSNumber * NoteUID;
	// NSString * Note;
	// NSString * UserID;
	// NSString * NoteTime;
	// USBoolean * NoteRead;
	// USBoolean * ForAdmin;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTicketNotes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TicketID;
@property (nonatomic, strong) NSNumber * NoteUID;
@property (nonatomic, strong) NSString * Note;
@property (nonatomic, strong) NSString * UserID;
@property (nonatomic, strong) NSString * NoteTime;
@property (nonatomic, strong) USBoolean * NoteRead;
@property (nonatomic, strong) USBoolean * ForAdmin;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTicketNotes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTicketNotes;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTicketNotes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTicketNotes:(ServiceSvc_ClsTicketNotes *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTicketNotes;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketNotes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketNotes * dsChangesMade;
	// NSString * CustomerID;
	// NSString * MachineID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketNotes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketNotes * dsChangesMade;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketNotesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ClsTicketUpdate * BackupTicketNotesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketNotesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ClsTicketUpdate * BackupTicketNotesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTicketChanges : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TicketID;
	// NSNumber * ChangeID;
	// NSString * ChangeMade;
	// NSString * ChangeTime;
	// NSNumber * ModifiedBy;
	// NSNumber * ChangeInputID;
	// NSString * OriginalValue;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTicketChanges *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TicketID;
@property (nonatomic, strong) NSNumber * ChangeID;
@property (nonatomic, strong) NSString * ChangeMade;
@property (nonatomic, strong) NSString * ChangeTime;
@property (nonatomic, strong) NSNumber * ModifiedBy;
@property (nonatomic, strong) NSNumber * ChangeInputID;
@property (nonatomic, strong) NSString * OriginalValue;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTicketChanges : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTicketChanges;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTicketChanges *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTicketChanges:(ServiceSvc_ClsTicketChanges *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTicketChanges;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketChanges : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketChanges * dsChangesMade;
	// NSString * CustomerID;
	// NSString * MachineID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketChanges *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketChanges * dsChangesMade;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketChangesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ClsTicketUpdate * BackupTicketChangesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketChangesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ClsTicketUpdate * BackupTicketChangesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTicketAttachments : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TicketID;
	// NSNumber * AttachmentID;
	// NSString * FileType;
	// NSString * FileStr;
	// NSString * FileName;
	// NSString * TimeAdded;
	// NSNumber * Deleted;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTicketAttachments *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TicketID;
@property (nonatomic, strong) NSNumber * AttachmentID;
@property (nonatomic, strong) NSString * FileType;
@property (nonatomic, strong) NSString * FileStr;
@property (nonatomic, strong) NSString * FileName;
@property (nonatomic, strong) NSString * TimeAdded;
@property (nonatomic, strong) NSNumber * Deleted;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTicketAttachments : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTicketAttachments;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTicketAttachments *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTicketAttachments:(ServiceSvc_ClsTicketAttachments *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTicketAttachments;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketAttachments : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketAttachments * dsChangesMade;
	// NSString * CustomerID;
	// NSString * MachineID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketAttachments *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketAttachments * dsChangesMade;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketAttachmentsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ClsTicketUpdate * BackupTicketAttachmentsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketAttachmentsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ClsTicketUpdate * BackupTicketAttachmentsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTicketSignatures : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TicketID;
	// NSNumber * SignatureID;
	// NSNumber * SignatureType;
	// NSString * SignatureString;
	// NSString * SignatureTime;
	// NSString * SignatureText;
	// NSNumber * Deleted;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTicketSignatures *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TicketID;
@property (nonatomic, strong) NSNumber * SignatureID;
@property (nonatomic, strong) NSNumber * SignatureType;
@property (nonatomic, strong) NSString * SignatureString;
@property (nonatomic, strong) NSString * SignatureTime;
@property (nonatomic, strong) NSString * SignatureText;
@property (nonatomic, strong) NSNumber * Deleted;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTicketSignatures : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTicketSignatures;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTicketSignatures *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTicketSignatures:(ServiceSvc_ClsTicketSignatures *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTicketSignatures;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketSignatures : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketSignatures * dsChangesMade;
	// NSString * CustomerID;
	// NSString * MachineID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketSignatures *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketSignatures * dsChangesMade;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketSignaturesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ClsTicketUpdate * BackupTicketSignaturesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketSignaturesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ClsTicketUpdate * BackupTicketSignaturesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTickets : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTickets *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTickets * GetReviewTransferTicketsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTickets * GetReviewTransferTicketsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketInputsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketInputs * GetReviewTransferTicketInputsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketInputsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketInputs * GetReviewTransferTicketInputsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketForms : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketForms *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTicketFormsInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TicketID;
	// NSNumber * FormID;
	// NSNumber * FormInputID;
	// NSString * FormInputValue;
	// NSNumber * Deleted;
	// NSNumber * Modified;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTicketFormsInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TicketID;
@property (nonatomic, strong) NSNumber * FormID;
@property (nonatomic, strong) NSNumber * FormInputID;
@property (nonatomic, strong) NSString * FormInputValue;
@property (nonatomic, strong) NSNumber * Deleted;
@property (nonatomic, strong) NSNumber * Modified;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTicketFormsInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTicketFormsInputs;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTicketFormsInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTicketFormsInputs:(ServiceSvc_ClsTicketFormsInputs *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTicketFormsInputs;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketFormsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketFormsInputs * GetReviewTransferTicketFormsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketFormsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketFormsInputs * GetReviewTransferTicketFormsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketChanges : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketChanges *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketChangesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketChanges * GetReviewTransferTicketChangesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketChangesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketChanges * GetReviewTransferTicketChangesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketAttachments : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketAttachments *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketAttachmentsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketAttachments * GetReviewTransferTicketAttachmentsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketAttachmentsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketAttachments * GetReviewTransferTicketAttachmentsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketSignatures : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketSignatures *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketSignaturesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketSignatures * GetReviewTransferTicketSignaturesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketSignaturesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketSignatures * GetReviewTransferTicketSignaturesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketNotes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketNotes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetReviewTransferTicketNotesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketNotes * GetReviewTransferTicketNotesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetReviewTransferTicketNotesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketNotes * GetReviewTransferTicketNotesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketFormsInput : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketFormsInputs * dsChangesMade;
	// NSString * CustomerID;
	// NSString * MachineID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketFormsInput *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketFormsInputs * dsChangesMade;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_BackupTicketFormsInputResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ClsTicketUpdate * BackupTicketFormsInputResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_BackupTicketFormsInputResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ClsTicketUpdate * BackupTicketFormsInputResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_SearchForPatientByName : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * LastName;
	// NSString * FirstName;
	// NSString * DOB;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_SearchForPatientByName *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * LastName;
@property (nonatomic, strong) NSString * FirstName;
@property (nonatomic, strong) NSString * DOB;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsSearchName : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TicketID;
	// NSString * FirstName;
	// NSString * LastName;
	// NSString * Mi;
	// NSString * Dob;
	// NSString * Race;
	// NSString * Sex;
	// NSString * Phone;
	// NSString * Height;
	// NSString * Weight;
	// NSString * DlNumber;
	// NSString * Ssn;
	// NSString * Address1;
	// NSString * Address2;
	// NSString * Zip;
	// NSString * City;
	// NSString * State;
	// NSString * County;
	// NSString * Meds;
	// NSString * Dos;
	// NSString * Allenv;
	// NSString * Allfood;
	// NSString * Allinsects;
	// NSString * Allmeds;
	// NSString * Allalerts;
	// NSString * HistCardio;
	// NSString * HistCancer;
	// NSString * HistNeuro;
	// NSString * HistGastro;
	// NSString * HistGenit;
	// NSString * HistInfect;
	// NSString * HistEndo;
	// NSString * HistResp;
	// NSString * HistPsych;
	// NSString * HistWomen;
	// NSString * HistMusc;
	// NSString * InsMedid;
	// NSString * InsMaid;
	// NSString * InsConame;
	// NSString * InsId;
	// NSString * InsGroup;
	// NSString * InsName;
	// NSString * InsDob;
	// NSString * InsSSN;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsSearchName *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TicketID;
@property (nonatomic, strong) NSString * FirstName;
@property (nonatomic, strong) NSString * LastName;
@property (nonatomic, strong) NSString * Mi;
@property (nonatomic, strong) NSString * Dob;
@property (nonatomic, strong) NSString * Race;
@property (nonatomic, strong) NSString * Sex;
@property (nonatomic, strong) NSString * Phone;
@property (nonatomic, strong) NSString * Height;
@property (nonatomic, strong) NSString * Weight;
@property (nonatomic, strong) NSString * DlNumber;
@property (nonatomic, strong) NSString * Ssn;
@property (nonatomic, strong) NSString * Address1;
@property (nonatomic, strong) NSString * Address2;
@property (nonatomic, strong) NSString * Zip;
@property (nonatomic, strong) NSString * City;
@property (nonatomic, strong) NSString * State;
@property (nonatomic, strong) NSString * County;
@property (nonatomic, strong) NSString * Meds;
@property (nonatomic, strong) NSString * Dos;
@property (nonatomic, strong) NSString * Allenv;
@property (nonatomic, strong) NSString * Allfood;
@property (nonatomic, strong) NSString * Allinsects;
@property (nonatomic, strong) NSString * Allmeds;
@property (nonatomic, strong) NSString * Allalerts;
@property (nonatomic, strong) NSString * HistCardio;
@property (nonatomic, strong) NSString * HistCancer;
@property (nonatomic, strong) NSString * HistNeuro;
@property (nonatomic, strong) NSString * HistGastro;
@property (nonatomic, strong) NSString * HistGenit;
@property (nonatomic, strong) NSString * HistInfect;
@property (nonatomic, strong) NSString * HistEndo;
@property (nonatomic, strong) NSString * HistResp;
@property (nonatomic, strong) NSString * HistPsych;
@property (nonatomic, strong) NSString * HistWomen;
@property (nonatomic, strong) NSString * HistMusc;
@property (nonatomic, strong) NSString * InsMedid;
@property (nonatomic, strong) NSString * InsMaid;
@property (nonatomic, strong) NSString * InsConame;
@property (nonatomic, strong) NSString * InsId;
@property (nonatomic, strong) NSString * InsGroup;
@property (nonatomic, strong) NSString * InsName;
@property (nonatomic, strong) NSString * InsDob;
@property (nonatomic, strong) NSString * InsSSN;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsSearchName : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsSearchName;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsSearchName *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsSearchName:(ServiceSvc_ClsSearchName *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsSearchName;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_SearchForPatientByNameResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsSearchName * SearchForPatientByNameResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_SearchForPatientByNameResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsSearchName * SearchForPatientByNameResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_SearchForPatientBySSN : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * SSN;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_SearchForPatientBySSN *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * SSN;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_SearchForPatientBySSNResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsSearchName * SearchForPatientBySSNResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_SearchForPatientBySSNResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsSearchName * SearchForPatientBySSNResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_DoAdminUnitIpad : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * UnitID;
	// NSString * UnitDesc;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * GPSData;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_DoAdminUnitIpad *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * UnitID;
@property (nonatomic, strong) NSString * UnitDesc;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * GPSData;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsUnitMsgs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * UnitMsgsID;
	// NSString * UnitID;
	// NSString * SentTo;
	// NSString * SentBy;
	// NSString * TimeStamp;
	// NSString * Msg;
	// NSNumber * RefID;
	// NSNumber * Deleted;
	// NSNumber * MsgRead;
	// NSNumber * IsAdminMsg;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsUnitMsgs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * UnitMsgsID;
@property (nonatomic, strong) NSString * UnitID;
@property (nonatomic, strong) NSString * SentTo;
@property (nonatomic, strong) NSString * SentBy;
@property (nonatomic, strong) NSString * TimeStamp;
@property (nonatomic, strong) NSString * Msg;
@property (nonatomic, strong) NSNumber * RefID;
@property (nonatomic, strong) NSNumber * Deleted;
@property (nonatomic, strong) NSNumber * MsgRead;
@property (nonatomic, strong) NSNumber * IsAdminMsg;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsUnitMsgs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsUnitMsgs;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsUnitMsgs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsUnitMsgs:(ServiceSvc_ClsUnitMsgs *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsUnitMsgs;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_DoAdminUnitIpadResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsUnitMsgs * DoAdminUnitIpadResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_DoAdminUnitIpadResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsUnitMsgs * DoAdminUnitIpadResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_DoAdminMachineIpad : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * UnitID;
	// NSString * UnitDesc;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * GPSData;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_DoAdminMachineIpad *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * UnitID;
@property (nonatomic, strong) NSString * UnitDesc;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * GPSData;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsMachineMsgs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * MachineMsgsID;
	// NSString * MachineID;
	// NSString * SentTo;
	// NSString * SentBy;
	// NSString * TimeStamp;
	// NSString * Msg;
	// NSNumber * RefID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsMachineMsgs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * MachineMsgsID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * SentTo;
@property (nonatomic, strong) NSString * SentBy;
@property (nonatomic, strong) NSString * TimeStamp;
@property (nonatomic, strong) NSString * Msg;
@property (nonatomic, strong) NSNumber * RefID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsMachineMsgs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsMachineMsgs;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsMachineMsgs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsMachineMsgs:(ServiceSvc_ClsMachineMsgs *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsMachineMsgs;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_DoAdminMachineIpadResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsMachineMsgs * DoAdminMachineIpadResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_DoAdminMachineIpadResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsMachineMsgs * DoAdminMachineIpadResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompleteTickets : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompleteTickets *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompleteTicketsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTickets * GetIncompleteTicketsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompleteTicketsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTickets * GetIncompleteTicketsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompleteTicketInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompleteTicketInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompleteTicketInputsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketInputs * GetIncompleteTicketInputsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompleteTicketInputsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketInputs * GetIncompleteTicketInputsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompleteTicketAttachments : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompleteTicketAttachments *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompleteTicketAttachmentsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketAttachments * GetIncompleteTicketAttachmentsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompleteTicketAttachmentsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketAttachments * GetIncompleteTicketAttachmentsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompleteTicketSignatures : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompleteTicketSignatures *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompleteTicketSignaturesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketSignatures * GetIncompleteTicketSignaturesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompleteTicketSignaturesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketSignatures * GetIncompleteTicketSignaturesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompleteTicketNotes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompleteTicketNotes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompleteTicketNotesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketNotes * GetIncompleteTicketNotesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompleteTicketNotesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketNotes * GetIncompleteTicketNotesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTickets : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTickets *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTickets * GetIncompTicketsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTickets * GetIncompTicketsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketInputs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketInputs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketInputsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketInputs * GetIncompTicketInputsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketInputsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketInputs * GetIncompTicketInputsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketForms : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketForms *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketFormsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketFormsInputs * GetIncompTicketFormsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketFormsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketFormsInputs * GetIncompTicketFormsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketChanges : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketChanges *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketChangesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketChanges * GetIncompTicketChangesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketChangesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketChanges * GetIncompTicketChangesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketAttachments : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketAttachments *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketAttachmentsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketAttachments * GetIncompTicketAttachmentsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketAttachmentsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketAttachments * GetIncompTicketAttachmentsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketSignatures : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketSignatures *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketSignaturesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketSignatures * GetIncompTicketSignaturesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketSignaturesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketSignatures * GetIncompTicketSignaturesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketNotes : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * User;
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * Unit;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketNotes *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * User;
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * Unit;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetIncompTicketNotesResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketNotes * GetIncompTicketNotesResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetIncompTicketNotesResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketNotes * GetIncompTicketNotesResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMonitors : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSString * MachineID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMonitors *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsMonitor : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * MonitorID;
	// NSString * PatientID;
	// NSString * IncidentID;
	// NSString * DeviceTime;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsMonitor *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * MonitorID;
@property (nonatomic, strong) NSString * PatientID;
@property (nonatomic, strong) NSString * IncidentID;
@property (nonatomic, strong) NSString * DeviceTime;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsMonitor : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsMonitor;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsMonitor *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsMonitor:(ServiceSvc_ClsMonitor *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsMonitor;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMonitorsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsMonitor * GetMonitorsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMonitorsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsMonitor * GetMonitorsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMonitorVitals : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * PatientID;
	// NSString * TicketID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMonitorVitals *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * PatientID;
@property (nonatomic, strong) NSString * TicketID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsMonitorVital : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * MonitorVitalsID;
	// NSString * PatientID;
	// NSString * DeviceTime;
	// NSString * Co2;
	// NSString * Diagtolic;
	// NSString * PulseRate;
	// NSString * Systolic;
	// NSString * RespRate;
	// NSString * Spo2Sat;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsMonitorVital *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * MonitorVitalsID;
@property (nonatomic, strong) NSString * PatientID;
@property (nonatomic, strong) NSString * DeviceTime;
@property (nonatomic, strong) NSString * Co2;
@property (nonatomic, strong) NSString * Diagtolic;
@property (nonatomic, strong) NSString * PulseRate;
@property (nonatomic, strong) NSString * Systolic;
@property (nonatomic, strong) NSString * RespRate;
@property (nonatomic, strong) NSString * Spo2Sat;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsMonitorVital : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsMonitorVital;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsMonitorVital *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsMonitorVital:(ServiceSvc_ClsMonitorVital *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsMonitorVital;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMonitorVitalsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsMonitorVital * GetMonitorVitalsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMonitorVitalsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsMonitorVital * GetMonitorVitalsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMonitorProcedure : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * PatientID;
	// NSString * TicketID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMonitorProcedure *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * PatientID;
@property (nonatomic, strong) NSString * TicketID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsMonitorProc : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * MonitorEventID;
	// NSNumber * TreatmentID;
	// NSString * ProcedureName;
	// NSString * DeviceTime;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsMonitorProc *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * MonitorEventID;
@property (nonatomic, strong) NSNumber * TreatmentID;
@property (nonatomic, strong) NSString * ProcedureName;
@property (nonatomic, strong) NSString * DeviceTime;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsMonitorProc : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsMonitorProc;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsMonitorProc *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsMonitorProc:(ServiceSvc_ClsMonitorProc *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsMonitorProc;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMonitorProcedureResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsMonitorProc * GetMonitorProcedureResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMonitorProcedureResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsMonitorProc * GetMonitorProcedureResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMonitorMed : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * PatientID;
	// NSString * TicketID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMonitorMed *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * PatientID;
@property (nonatomic, strong) NSString * TicketID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsMonitorMed : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * MonitorEventID;
	// NSNumber * MedicationID;
	// NSString * Medication;
	// NSString * DeviceTime;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsMonitorMed *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * MonitorEventID;
@property (nonatomic, strong) NSNumber * MedicationID;
@property (nonatomic, strong) NSString * Medication;
@property (nonatomic, strong) NSString * DeviceTime;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsMonitorMed : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsMonitorMed;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsMonitorMed *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsMonitorMed:(ServiceSvc_ClsMonitorMed *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsMonitorMed;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMonitorMedResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsMonitorMed * GetMonitorMedResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMonitorMedResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsMonitorMed * GetMonitorMedResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMonitorImage : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * PatientID;
	// NSString * TicketID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMonitorImage *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * PatientID;
@property (nonatomic, strong) NSString * TicketID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetMonitorImageResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTicketAttachments * GetMonitorImageResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetMonitorImageResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTicketAttachments * GetMonitorImageResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetZoll : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSString * MachineID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetZoll *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetZollResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsMonitor * GetZollResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetZollResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsMonitor * GetZollResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetZollVitals : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * MonitorID;
	// NSString * TicketID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetZollVitals *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * MonitorID;
@property (nonatomic, strong) NSString * TicketID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ClsTableKey : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSNumber * TableID;
	// NSString * Key;
	// NSString * Desc;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ClsTableKey *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSNumber * TableID;
@property (nonatomic, strong) NSString * Key;
@property (nonatomic, strong) NSString * Desc;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_ArrayOfClsTableKey : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSMutableArray *ClsTableKey;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_ArrayOfClsTableKey *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
- (void)addClsTableKey:(ServiceSvc_ClsTableKey *)toAdd;
@property (nonatomic, readonly) NSMutableArray * ClsTableKey;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetZollVitalsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsTableKey * GetZollVitalsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetZollVitalsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsTableKey * GetZollVitalsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetZollProcs : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSString * MachineID;
	// NSString * DeviceID;
	// NSString * TicketID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetZollProcs *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSString * MachineID;
@property (nonatomic, strong) NSString * DeviceID;
@property (nonatomic, strong) NSString * TicketID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetZollProcsResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// ServiceSvc_ArrayOfClsMonitorProc * GetZollProcsResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetZollProcsResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) ServiceSvc_ArrayOfClsMonitorProc * GetZollProcsResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetPCR : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * CustomerID;
	// NSNumber * TicketID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetPCR *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * CustomerID;
@property (nonatomic, strong) NSNumber * TicketID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface ServiceSvc_GetPCRResponse : NSObject <NSCoding> {
// SOAPSigner *soapSigner;
/* elements */
	// NSString * GetPCRResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (ServiceSvc_GetPCRResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (strong) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, strong) NSString * GetPCRResult;
/* attributes */
- (NSDictionary *)attributes;
@end
/* Cookies handling provided by http://en.wikibooks.org/wiki/Programming:WebObjects/Web_Services/Web_Service_Provider */
#import <libxml/parser.h>
#import "xsd.h"
#import "ServiceSvc.h"
@class ServiceSoapBinding;
@class ServiceSoap12Binding;
@interface ServiceSvc : NSObject {
	
}
+ (ServiceSoapBinding *)ServiceSoapBinding;
+ (ServiceSoap12Binding *)ServiceSoap12Binding;
@end
@class ServiceSoapBindingResponse;
@class ServiceSoapBindingOperation;
@protocol ServiceSoapBindingResponseDelegate <NSObject>
- (void) operation:(ServiceSoapBindingOperation *)operation completedWithResponse:(ServiceSoapBindingResponse *)response;
@end
#define kServerAnchorCertificates   @"kServerAnchorCertificates"
#define kServerAnchorsOnly          @"kServerAnchorsOnly"
#define kClientIdentity             @"kClientIdentity"
#define kClientCertificates         @"kClientCertificates"
#define kClientUsername             @"kClientUsername"
#define kClientPassword             @"kClientPassword"
#define kNSURLCredentialPersistence @"kNSURLCredentialPersistence"
#define kValidateResult             @"kValidateResult"
@interface ServiceSoapBinding : NSObject <ServiceSoapBindingResponseDelegate> {
	NSURL *address;
	NSTimeInterval timeout;
	NSMutableArray *cookies;
	NSMutableDictionary *customHeaders;
	BOOL logXMLInOut;
	BOOL ignoreEmptyResponse;
	BOOL synchronousOperationComplete;
	id<SSLCredentialsManaging> sslManager;
	SOAPSigner *soapSigner;
}
@property (nonatomic, copy) NSURL *address;
@property (nonatomic) BOOL logXMLInOut;
@property (nonatomic) BOOL ignoreEmptyResponse;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic) NSMutableArray *cookies;
@property (nonatomic) NSMutableDictionary *customHeaders;
@property (nonatomic) id<SSLCredentialsManaging> sslManager;
@property (nonatomic) SOAPSigner *soapSigner;
+ (NSTimeInterval) defaultTimeout;
- (id)initWithAddress:(NSString *)anAddress;
- (void)sendHTTPCallUsingBody:(NSString *)body soapAction:(NSString *)soapAction forOperation:(ServiceSoapBindingOperation *)operation;
- (void)addCookie:(NSHTTPCookie *)toAdd;
- (NSString *)MIMEType;
- (ServiceSoapBindingResponse *)GetCustomerIDUsingParameters:(ServiceSvc_GetCustomerID *)aParameters ;
- (void)GetCustomerIDAsyncUsingParameters:(ServiceSvc_GetCustomerID *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetInputsTableUsingParameters:(ServiceSvc_GetInputsTable *)aParameters ;
- (void)GetInputsTableAsyncUsingParameters:(ServiceSvc_GetInputsTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetInputLookupTableUsingParameters:(ServiceSvc_GetInputLookupTable *)aParameters ;
- (void)GetInputLookupTableAsyncUsingParameters:(ServiceSvc_GetInputLookupTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetTreatmentsTableUsingParameters:(ServiceSvc_GetTreatmentsTable *)aParameters ;
- (void)GetTreatmentsTableAsyncUsingParameters:(ServiceSvc_GetTreatmentsTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetTreatmentInputsTableUsingParameters:(ServiceSvc_GetTreatmentInputsTable *)aParameters ;
- (void)GetTreatmentInputsTableAsyncUsingParameters:(ServiceSvc_GetTreatmentInputsTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetTreatmentInputLookupTableUsingParameters:(ServiceSvc_GetTreatmentInputLookupTable *)aParameters ;
- (void)GetTreatmentInputLookupTableAsyncUsingParameters:(ServiceSvc_GetTreatmentInputLookupTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetCertificationTableUsingParameters:(ServiceSvc_GetCertificationTable *)aParameters ;
- (void)GetCertificationTableAsyncUsingParameters:(ServiceSvc_GetCertificationTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetChiefComplaintsTableUsingParameters:(ServiceSvc_GetChiefComplaintsTable *)aParameters ;
- (void)GetChiefComplaintsTableAsyncUsingParameters:(ServiceSvc_GetChiefComplaintsTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetCitiesTableUsingParameters:(ServiceSvc_GetCitiesTable *)aParameters ;
- (void)GetCitiesTableAsyncUsingParameters:(ServiceSvc_GetCitiesTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetControlFiltersTableUsingParameters:(ServiceSvc_GetControlFiltersTable *)aParameters ;
- (void)GetControlFiltersTableAsyncUsingParameters:(ServiceSvc_GetControlFiltersTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetCountiesTableUsingParameters:(ServiceSvc_GetCountiesTable *)aParameters ;
- (void)GetCountiesTableAsyncUsingParameters:(ServiceSvc_GetCountiesTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetCrewRideTypesTableUsingParameters:(ServiceSvc_GetCrewRideTypesTable *)aParameters ;
- (void)GetCrewRideTypesTableAsyncUsingParameters:(ServiceSvc_GetCrewRideTypesTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetCustomerContentTableUsingParameters:(ServiceSvc_GetCustomerContentTable *)aParameters ;
- (void)GetCustomerContentTableAsyncUsingParameters:(ServiceSvc_GetCustomerContentTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetCustomFormExclusionUsingParameters:(ServiceSvc_GetCustomFormExclusion *)aParameters ;
- (void)GetCustomFormExclusionAsyncUsingParameters:(ServiceSvc_GetCustomFormExclusion *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetCustomFormInputLookUpUsingParameters:(ServiceSvc_GetCustomFormInputLookUp *)aParameters ;
- (void)GetCustomFormInputLookUpAsyncUsingParameters:(ServiceSvc_GetCustomFormInputLookUp *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetCustomFormsUsingParameters:(ServiceSvc_GetCustomForms *)aParameters ;
- (void)GetCustomFormsAsyncUsingParameters:(ServiceSvc_GetCustomForms *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetCustomFormInputsUsingParameters:(ServiceSvc_GetCustomFormInputs *)aParameters ;
- (void)GetCustomFormInputsAsyncUsingParameters:(ServiceSvc_GetCustomFormInputs *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetDrugDosagesUsingParameters:(ServiceSvc_GetDrugDosages *)aParameters ;
- (void)GetDrugDosagesAsyncUsingParameters:(ServiceSvc_GetDrugDosages *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetDrugsUsingParameters:(ServiceSvc_GetDrugs *)aParameters ;
- (void)GetDrugsAsyncUsingParameters:(ServiceSvc_GetDrugs *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetFormsUsingParameters:(ServiceSvc_GetForms *)aParameters ;
- (void)GetFormsAsyncUsingParameters:(ServiceSvc_GetForms *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetGroupsUsingParameters:(ServiceSvc_GetGroups *)aParameters ;
- (void)GetGroupsAsyncUsingParameters:(ServiceSvc_GetGroups *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetInjuryTypesUsingParameters:(ServiceSvc_GetInjuryTypes *)aParameters ;
- (void)GetInjuryTypesAsyncUsingParameters:(ServiceSvc_GetInjuryTypes *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetInsuranceUsingParameters:(ServiceSvc_GetInsurance *)aParameters ;
- (void)GetInsuranceAsyncUsingParameters:(ServiceSvc_GetInsurance *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetInsuranceInputLookupUsingParameters:(ServiceSvc_GetInsuranceInputLookup *)aParameters ;
- (void)GetInsuranceInputLookupAsyncUsingParameters:(ServiceSvc_GetInsuranceInputLookup *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetInsuranceInputsUsingParameters:(ServiceSvc_GetInsuranceInputs *)aParameters ;
- (void)GetInsuranceInputsAsyncUsingParameters:(ServiceSvc_GetInsuranceInputs *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetInsuranceTypesUsingParameters:(ServiceSvc_GetInsuranceTypes *)aParameters ;
- (void)GetInsuranceTypesAsyncUsingParameters:(ServiceSvc_GetInsuranceTypes *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetLocationsUsingParameters:(ServiceSvc_GetLocations *)aParameters ;
- (void)GetLocationsAsyncUsingParameters:(ServiceSvc_GetLocations *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetMedicationsUsingParameters:(ServiceSvc_GetMedications *)aParameters ;
- (void)GetMedicationsAsyncUsingParameters:(ServiceSvc_GetMedications *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetPagesUsingParameters:(ServiceSvc_GetPages *)aParameters ;
- (void)GetPagesAsyncUsingParameters:(ServiceSvc_GetPages *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetProtocolFilesUsingParameters:(ServiceSvc_GetProtocolFiles *)aParameters ;
- (void)GetProtocolFilesAsyncUsingParameters:(ServiceSvc_GetProtocolFiles *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetProtocolGroupsUsingParameters:(ServiceSvc_GetProtocolGroups *)aParameters ;
- (void)GetProtocolGroupsAsyncUsingParameters:(ServiceSvc_GetProtocolGroups *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetQuickButtonsUsingParameters:(ServiceSvc_GetQuickButtons *)aParameters ;
- (void)GetQuickButtonsAsyncUsingParameters:(ServiceSvc_GetQuickButtons *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetShiftsUsingParameters:(ServiceSvc_GetShifts *)aParameters ;
- (void)GetShiftsAsyncUsingParameters:(ServiceSvc_GetShifts *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetSignatureTypesUsingParameters:(ServiceSvc_GetSignatureTypes *)aParameters ;
- (void)GetSignatureTypesAsyncUsingParameters:(ServiceSvc_GetSignatureTypes *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetStatesUsingParameters:(ServiceSvc_GetStates *)aParameters ;
- (void)GetStatesAsyncUsingParameters:(ServiceSvc_GetStates *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetStationsUsingParameters:(ServiceSvc_GetStations *)aParameters ;
- (void)GetStationsAsyncUsingParameters:(ServiceSvc_GetStations *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetStatusUsingParameters:(ServiceSvc_GetStatus *)aParameters ;
- (void)GetStatusAsyncUsingParameters:(ServiceSvc_GetStatus *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetUsersUsingParameters:(ServiceSvc_GetUsers *)aParameters ;
- (void)GetUsersAsyncUsingParameters:(ServiceSvc_GetUsers *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetZipsUsingParameters:(ServiceSvc_GetZips *)aParameters ;
- (void)GetZipsAsyncUsingParameters:(ServiceSvc_GetZips *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetVitalsTableUsingParameters:(ServiceSvc_GetVitalsTable *)aParameters ;
- (void)GetVitalsTableAsyncUsingParameters:(ServiceSvc_GetVitalsTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetVitalInputLookupTableUsingParameters:(ServiceSvc_GetVitalInputLookupTable *)aParameters ;
- (void)GetVitalInputLookupTableAsyncUsingParameters:(ServiceSvc_GetVitalInputLookupTable *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetUnitsUsingParameters:(ServiceSvc_GetUnits *)aParameters ;
- (void)GetUnitsAsyncUsingParameters:(ServiceSvc_GetUnits *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetSettingsUsingParameters:(ServiceSvc_GetSettings *)aParameters ;
- (void)GetSettingsAsyncUsingParameters:(ServiceSvc_GetSettings *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetxInputTablesUsingParameters:(ServiceSvc_GetxInputTables *)aParameters ;
- (void)GetxInputTablesAsyncUsingParameters:(ServiceSvc_GetxInputTables *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetOutcomesUsingParameters:(ServiceSvc_GetOutcomes *)aParameters ;
- (void)GetOutcomesAsyncUsingParameters:(ServiceSvc_GetOutcomes *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetOutcomeTypesUsingParameters:(ServiceSvc_GetOutcomeTypes *)aParameters ;
- (void)GetOutcomeTypesAsyncUsingParameters:(ServiceSvc_GetOutcomeTypes *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetOutcomeRequiredItemsUsingParameters:(ServiceSvc_GetOutcomeRequiredItems *)aParameters ;
- (void)GetOutcomeRequiredItemsAsyncUsingParameters:(ServiceSvc_GetOutcomeRequiredItems *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetOutcomeRequiredSignaturesUsingParameters:(ServiceSvc_GetOutcomeRequiredSignatures *)aParameters ;
- (void)GetOutcomeRequiredSignaturesAsyncUsingParameters:(ServiceSvc_GetOutcomeRequiredSignatures *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)UpdateChange6UsingParameters:(ServiceSvc_UpdateChange6 *)aParameters ;
- (void)UpdateChange6AsyncUsingParameters:(ServiceSvc_UpdateChange6 *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)BackupTicketUsingParameters:(ServiceSvc_BackupTicket *)aParameters ;
- (void)BackupTicketAsyncUsingParameters:(ServiceSvc_BackupTicket *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)BackupTicketInputsUsingParameters:(ServiceSvc_BackupTicketInputs *)aParameters ;
- (void)BackupTicketInputsAsyncUsingParameters:(ServiceSvc_BackupTicketInputs *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)BackupTicketNotesUsingParameters:(ServiceSvc_BackupTicketNotes *)aParameters ;
- (void)BackupTicketNotesAsyncUsingParameters:(ServiceSvc_BackupTicketNotes *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)BackupTicketChangesUsingParameters:(ServiceSvc_BackupTicketChanges *)aParameters ;
- (void)BackupTicketChangesAsyncUsingParameters:(ServiceSvc_BackupTicketChanges *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)BackupTicketAttachmentsUsingParameters:(ServiceSvc_BackupTicketAttachments *)aParameters ;
- (void)BackupTicketAttachmentsAsyncUsingParameters:(ServiceSvc_BackupTicketAttachments *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)BackupTicketSignaturesUsingParameters:(ServiceSvc_BackupTicketSignatures *)aParameters ;
- (void)BackupTicketSignaturesAsyncUsingParameters:(ServiceSvc_BackupTicketSignatures *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetReviewTransferTicketsUsingParameters:(ServiceSvc_GetReviewTransferTickets *)aParameters ;
- (void)GetReviewTransferTicketsAsyncUsingParameters:(ServiceSvc_GetReviewTransferTickets *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetReviewTransferTicketInputsUsingParameters:(ServiceSvc_GetReviewTransferTicketInputs *)aParameters ;
- (void)GetReviewTransferTicketInputsAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketInputs *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetReviewTransferTicketFormsUsingParameters:(ServiceSvc_GetReviewTransferTicketForms *)aParameters ;
- (void)GetReviewTransferTicketFormsAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketForms *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetReviewTransferTicketChangesUsingParameters:(ServiceSvc_GetReviewTransferTicketChanges *)aParameters ;
- (void)GetReviewTransferTicketChangesAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketChanges *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetReviewTransferTicketAttachmentsUsingParameters:(ServiceSvc_GetReviewTransferTicketAttachments *)aParameters ;
- (void)GetReviewTransferTicketAttachmentsAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketAttachments *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetReviewTransferTicketSignaturesUsingParameters:(ServiceSvc_GetReviewTransferTicketSignatures *)aParameters ;
- (void)GetReviewTransferTicketSignaturesAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketSignatures *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetReviewTransferTicketNotesUsingParameters:(ServiceSvc_GetReviewTransferTicketNotes *)aParameters ;
- (void)GetReviewTransferTicketNotesAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketNotes *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)BackupTicketFormsInputUsingParameters:(ServiceSvc_BackupTicketFormsInput *)aParameters ;
- (void)BackupTicketFormsInputAsyncUsingParameters:(ServiceSvc_BackupTicketFormsInput *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)SearchForPatientByNameUsingParameters:(ServiceSvc_SearchForPatientByName *)aParameters ;
- (void)SearchForPatientByNameAsyncUsingParameters:(ServiceSvc_SearchForPatientByName *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)SearchForPatientBySSNUsingParameters:(ServiceSvc_SearchForPatientBySSN *)aParameters ;
- (void)SearchForPatientBySSNAsyncUsingParameters:(ServiceSvc_SearchForPatientBySSN *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)DoAdminUnitIpadUsingParameters:(ServiceSvc_DoAdminUnitIpad *)aParameters ;
- (void)DoAdminUnitIpadAsyncUsingParameters:(ServiceSvc_DoAdminUnitIpad *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)DoAdminMachineIpadUsingParameters:(ServiceSvc_DoAdminMachineIpad *)aParameters ;
- (void)DoAdminMachineIpadAsyncUsingParameters:(ServiceSvc_DoAdminMachineIpad *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompleteTicketsUsingParameters:(ServiceSvc_GetIncompleteTickets *)aParameters ;
- (void)GetIncompleteTicketsAsyncUsingParameters:(ServiceSvc_GetIncompleteTickets *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompleteTicketInputsUsingParameters:(ServiceSvc_GetIncompleteTicketInputs *)aParameters ;
- (void)GetIncompleteTicketInputsAsyncUsingParameters:(ServiceSvc_GetIncompleteTicketInputs *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompleteTicketAttachmentsUsingParameters:(ServiceSvc_GetIncompleteTicketAttachments *)aParameters ;
- (void)GetIncompleteTicketAttachmentsAsyncUsingParameters:(ServiceSvc_GetIncompleteTicketAttachments *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompleteTicketSignaturesUsingParameters:(ServiceSvc_GetIncompleteTicketSignatures *)aParameters ;
- (void)GetIncompleteTicketSignaturesAsyncUsingParameters:(ServiceSvc_GetIncompleteTicketSignatures *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompleteTicketNotesUsingParameters:(ServiceSvc_GetIncompleteTicketNotes *)aParameters ;
- (void)GetIncompleteTicketNotesAsyncUsingParameters:(ServiceSvc_GetIncompleteTicketNotes *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompTicketsUsingParameters:(ServiceSvc_GetIncompTickets *)aParameters ;
- (void)GetIncompTicketsAsyncUsingParameters:(ServiceSvc_GetIncompTickets *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompTicketInputsUsingParameters:(ServiceSvc_GetIncompTicketInputs *)aParameters ;
- (void)GetIncompTicketInputsAsyncUsingParameters:(ServiceSvc_GetIncompTicketInputs *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompTicketFormsUsingParameters:(ServiceSvc_GetIncompTicketForms *)aParameters ;
- (void)GetIncompTicketFormsAsyncUsingParameters:(ServiceSvc_GetIncompTicketForms *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompTicketChangesUsingParameters:(ServiceSvc_GetIncompTicketChanges *)aParameters ;
- (void)GetIncompTicketChangesAsyncUsingParameters:(ServiceSvc_GetIncompTicketChanges *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompTicketAttachmentsUsingParameters:(ServiceSvc_GetIncompTicketAttachments *)aParameters ;
- (void)GetIncompTicketAttachmentsAsyncUsingParameters:(ServiceSvc_GetIncompTicketAttachments *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompTicketSignaturesUsingParameters:(ServiceSvc_GetIncompTicketSignatures *)aParameters ;
- (void)GetIncompTicketSignaturesAsyncUsingParameters:(ServiceSvc_GetIncompTicketSignatures *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetIncompTicketNotesUsingParameters:(ServiceSvc_GetIncompTicketNotes *)aParameters ;
- (void)GetIncompTicketNotesAsyncUsingParameters:(ServiceSvc_GetIncompTicketNotes *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetMonitorsUsingParameters:(ServiceSvc_GetMonitors *)aParameters ;
- (void)GetMonitorsAsyncUsingParameters:(ServiceSvc_GetMonitors *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetMonitorVitalsUsingParameters:(ServiceSvc_GetMonitorVitals *)aParameters ;
- (void)GetMonitorVitalsAsyncUsingParameters:(ServiceSvc_GetMonitorVitals *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetMonitorProcedureUsingParameters:(ServiceSvc_GetMonitorProcedure *)aParameters ;
- (void)GetMonitorProcedureAsyncUsingParameters:(ServiceSvc_GetMonitorProcedure *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetMonitorMedUsingParameters:(ServiceSvc_GetMonitorMed *)aParameters ;
- (void)GetMonitorMedAsyncUsingParameters:(ServiceSvc_GetMonitorMed *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetMonitorImageUsingParameters:(ServiceSvc_GetMonitorImage *)aParameters ;
- (void)GetMonitorImageAsyncUsingParameters:(ServiceSvc_GetMonitorImage *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetZollUsingParameters:(ServiceSvc_GetZoll *)aParameters ;
- (void)GetZollAsyncUsingParameters:(ServiceSvc_GetZoll *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetZollVitalsUsingParameters:(ServiceSvc_GetZollVitals *)aParameters ;
- (void)GetZollVitalsAsyncUsingParameters:(ServiceSvc_GetZollVitals *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetZollProcsUsingParameters:(ServiceSvc_GetZollProcs *)aParameters ;
- (void)GetZollProcsAsyncUsingParameters:(ServiceSvc_GetZollProcs *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
- (ServiceSoapBindingResponse *)GetPCRUsingParameters:(ServiceSvc_GetPCR *)aParameters ;
- (void)GetPCRAsyncUsingParameters:(ServiceSvc_GetPCR *)aParameters  delegate:(id<ServiceSoapBindingResponseDelegate>)responseDelegate;
@end
@interface ServiceSoapBindingOperation : NSOperation {
	ServiceSoapBinding *binding;
	ServiceSoapBindingResponse *response;
	__weak id<ServiceSoapBindingResponseDelegate> delegate;
	NSMutableData *responseData;
	NSURLConnection *urlConnection;
}
@property (nonatomic) ServiceSoapBinding *binding;
@property (nonatomic, readonly) ServiceSoapBindingResponse *response;
@property (nonatomic, weak) id<ServiceSoapBindingResponseDelegate> delegate;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSURLConnection *urlConnection;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
@interface ServiceSoapBinding_GetCustomerID : ServiceSoapBindingOperation {
	ServiceSvc_GetCustomerID * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomerID * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomerID *)aParameters
;
@end
@interface ServiceSoapBinding_GetInputsTable : ServiceSoapBindingOperation {
	ServiceSvc_GetInputsTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInputsTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInputsTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetInputLookupTable : ServiceSoapBindingOperation {
	ServiceSvc_GetInputLookupTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInputLookupTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInputLookupTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetTreatmentsTable : ServiceSoapBindingOperation {
	ServiceSvc_GetTreatmentsTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetTreatmentsTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetTreatmentsTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetTreatmentInputsTable : ServiceSoapBindingOperation {
	ServiceSvc_GetTreatmentInputsTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetTreatmentInputsTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetTreatmentInputsTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetTreatmentInputLookupTable : ServiceSoapBindingOperation {
	ServiceSvc_GetTreatmentInputLookupTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetTreatmentInputLookupTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetTreatmentInputLookupTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetCertificationTable : ServiceSoapBindingOperation {
	ServiceSvc_GetCertificationTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCertificationTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCertificationTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetChiefComplaintsTable : ServiceSoapBindingOperation {
	ServiceSvc_GetChiefComplaintsTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetChiefComplaintsTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetChiefComplaintsTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetCitiesTable : ServiceSoapBindingOperation {
	ServiceSvc_GetCitiesTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCitiesTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCitiesTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetControlFiltersTable : ServiceSoapBindingOperation {
	ServiceSvc_GetControlFiltersTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetControlFiltersTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetControlFiltersTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetCountiesTable : ServiceSoapBindingOperation {
	ServiceSvc_GetCountiesTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCountiesTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCountiesTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetCrewRideTypesTable : ServiceSoapBindingOperation {
	ServiceSvc_GetCrewRideTypesTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCrewRideTypesTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCrewRideTypesTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetCustomerContentTable : ServiceSoapBindingOperation {
	ServiceSvc_GetCustomerContentTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomerContentTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomerContentTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetCustomFormExclusion : ServiceSoapBindingOperation {
	ServiceSvc_GetCustomFormExclusion * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomFormExclusion * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomFormExclusion *)aParameters
;
@end
@interface ServiceSoapBinding_GetCustomFormInputLookUp : ServiceSoapBindingOperation {
	ServiceSvc_GetCustomFormInputLookUp * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomFormInputLookUp * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomFormInputLookUp *)aParameters
;
@end
@interface ServiceSoapBinding_GetCustomForms : ServiceSoapBindingOperation {
	ServiceSvc_GetCustomForms * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomForms * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomForms *)aParameters
;
@end
@interface ServiceSoapBinding_GetCustomFormInputs : ServiceSoapBindingOperation {
	ServiceSvc_GetCustomFormInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomFormInputs * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomFormInputs *)aParameters
;
@end
@interface ServiceSoapBinding_GetDrugDosages : ServiceSoapBindingOperation {
	ServiceSvc_GetDrugDosages * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetDrugDosages * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetDrugDosages *)aParameters
;
@end
@interface ServiceSoapBinding_GetDrugs : ServiceSoapBindingOperation {
	ServiceSvc_GetDrugs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetDrugs * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetDrugs *)aParameters
;
@end
@interface ServiceSoapBinding_GetForms : ServiceSoapBindingOperation {
	ServiceSvc_GetForms * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetForms * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetForms *)aParameters
;
@end
@interface ServiceSoapBinding_GetGroups : ServiceSoapBindingOperation {
	ServiceSvc_GetGroups * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetGroups * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetGroups *)aParameters
;
@end
@interface ServiceSoapBinding_GetInjuryTypes : ServiceSoapBindingOperation {
	ServiceSvc_GetInjuryTypes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInjuryTypes * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInjuryTypes *)aParameters
;
@end
@interface ServiceSoapBinding_GetInsurance : ServiceSoapBindingOperation {
	ServiceSvc_GetInsurance * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInsurance * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInsurance *)aParameters
;
@end
@interface ServiceSoapBinding_GetInsuranceInputLookup : ServiceSoapBindingOperation {
	ServiceSvc_GetInsuranceInputLookup * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInsuranceInputLookup * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInsuranceInputLookup *)aParameters
;
@end
@interface ServiceSoapBinding_GetInsuranceInputs : ServiceSoapBindingOperation {
	ServiceSvc_GetInsuranceInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInsuranceInputs * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInsuranceInputs *)aParameters
;
@end
@interface ServiceSoapBinding_GetInsuranceTypes : ServiceSoapBindingOperation {
	ServiceSvc_GetInsuranceTypes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInsuranceTypes * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInsuranceTypes *)aParameters
;
@end
@interface ServiceSoapBinding_GetLocations : ServiceSoapBindingOperation {
	ServiceSvc_GetLocations * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetLocations * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetLocations *)aParameters
;
@end
@interface ServiceSoapBinding_GetMedications : ServiceSoapBindingOperation {
	ServiceSvc_GetMedications * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMedications * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMedications *)aParameters
;
@end
@interface ServiceSoapBinding_GetPages : ServiceSoapBindingOperation {
	ServiceSvc_GetPages * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetPages * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetPages *)aParameters
;
@end
@interface ServiceSoapBinding_GetProtocolFiles : ServiceSoapBindingOperation {
	ServiceSvc_GetProtocolFiles * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetProtocolFiles * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetProtocolFiles *)aParameters
;
@end
@interface ServiceSoapBinding_GetProtocolGroups : ServiceSoapBindingOperation {
	ServiceSvc_GetProtocolGroups * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetProtocolGroups * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetProtocolGroups *)aParameters
;
@end
@interface ServiceSoapBinding_GetQuickButtons : ServiceSoapBindingOperation {
	ServiceSvc_GetQuickButtons * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetQuickButtons * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetQuickButtons *)aParameters
;
@end
@interface ServiceSoapBinding_GetShifts : ServiceSoapBindingOperation {
	ServiceSvc_GetShifts * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetShifts * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetShifts *)aParameters
;
@end
@interface ServiceSoapBinding_GetSignatureTypes : ServiceSoapBindingOperation {
	ServiceSvc_GetSignatureTypes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetSignatureTypes * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetSignatureTypes *)aParameters
;
@end
@interface ServiceSoapBinding_GetStates : ServiceSoapBindingOperation {
	ServiceSvc_GetStates * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetStates * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetStates *)aParameters
;
@end
@interface ServiceSoapBinding_GetStations : ServiceSoapBindingOperation {
	ServiceSvc_GetStations * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetStations * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetStations *)aParameters
;
@end
@interface ServiceSoapBinding_GetStatus : ServiceSoapBindingOperation {
	ServiceSvc_GetStatus * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetStatus * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetStatus *)aParameters
;
@end
@interface ServiceSoapBinding_GetUsers : ServiceSoapBindingOperation {
	ServiceSvc_GetUsers * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetUsers * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetUsers *)aParameters
;
@end
@interface ServiceSoapBinding_GetZips : ServiceSoapBindingOperation {
	ServiceSvc_GetZips * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetZips * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetZips *)aParameters
;
@end
@interface ServiceSoapBinding_GetVitalsTable : ServiceSoapBindingOperation {
	ServiceSvc_GetVitalsTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetVitalsTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetVitalsTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetVitalInputLookupTable : ServiceSoapBindingOperation {
	ServiceSvc_GetVitalInputLookupTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetVitalInputLookupTable * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetVitalInputLookupTable *)aParameters
;
@end
@interface ServiceSoapBinding_GetUnits : ServiceSoapBindingOperation {
	ServiceSvc_GetUnits * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetUnits * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetUnits *)aParameters
;
@end
@interface ServiceSoapBinding_GetSettings : ServiceSoapBindingOperation {
	ServiceSvc_GetSettings * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetSettings * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetSettings *)aParameters
;
@end
@interface ServiceSoapBinding_GetxInputTables : ServiceSoapBindingOperation {
	ServiceSvc_GetxInputTables * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetxInputTables * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetxInputTables *)aParameters
;
@end
@interface ServiceSoapBinding_GetOutcomes : ServiceSoapBindingOperation {
	ServiceSvc_GetOutcomes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetOutcomes * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetOutcomes *)aParameters
;
@end
@interface ServiceSoapBinding_GetOutcomeTypes : ServiceSoapBindingOperation {
	ServiceSvc_GetOutcomeTypes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetOutcomeTypes * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetOutcomeTypes *)aParameters
;
@end
@interface ServiceSoapBinding_GetOutcomeRequiredItems : ServiceSoapBindingOperation {
	ServiceSvc_GetOutcomeRequiredItems * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetOutcomeRequiredItems * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetOutcomeRequiredItems *)aParameters
;
@end
@interface ServiceSoapBinding_GetOutcomeRequiredSignatures : ServiceSoapBindingOperation {
	ServiceSvc_GetOutcomeRequiredSignatures * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetOutcomeRequiredSignatures * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetOutcomeRequiredSignatures *)aParameters
;
@end
@interface ServiceSoapBinding_UpdateChange6 : ServiceSoapBindingOperation {
	ServiceSvc_UpdateChange6 * parameters;
}
@property (nonatomic, strong) ServiceSvc_UpdateChange6 * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_UpdateChange6 *)aParameters
;
@end
@interface ServiceSoapBinding_BackupTicket : ServiceSoapBindingOperation {
	ServiceSvc_BackupTicket * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicket * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicket *)aParameters
;
@end
@interface ServiceSoapBinding_BackupTicketInputs : ServiceSoapBindingOperation {
	ServiceSvc_BackupTicketInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketInputs * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketInputs *)aParameters
;
@end
@interface ServiceSoapBinding_BackupTicketNotes : ServiceSoapBindingOperation {
	ServiceSvc_BackupTicketNotes * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketNotes * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketNotes *)aParameters
;
@end
@interface ServiceSoapBinding_BackupTicketChanges : ServiceSoapBindingOperation {
	ServiceSvc_BackupTicketChanges * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketChanges * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketChanges *)aParameters
;
@end
@interface ServiceSoapBinding_BackupTicketAttachments : ServiceSoapBindingOperation {
	ServiceSvc_BackupTicketAttachments * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketAttachments * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketAttachments *)aParameters
;
@end
@interface ServiceSoapBinding_BackupTicketSignatures : ServiceSoapBindingOperation {
	ServiceSvc_BackupTicketSignatures * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketSignatures * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketSignatures *)aParameters
;
@end
@interface ServiceSoapBinding_GetReviewTransferTickets : ServiceSoapBindingOperation {
	ServiceSvc_GetReviewTransferTickets * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTickets * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTickets *)aParameters
;
@end
@interface ServiceSoapBinding_GetReviewTransferTicketInputs : ServiceSoapBindingOperation {
	ServiceSvc_GetReviewTransferTicketInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketInputs * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketInputs *)aParameters
;
@end
@interface ServiceSoapBinding_GetReviewTransferTicketForms : ServiceSoapBindingOperation {
	ServiceSvc_GetReviewTransferTicketForms * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketForms * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketForms *)aParameters
;
@end
@interface ServiceSoapBinding_GetReviewTransferTicketChanges : ServiceSoapBindingOperation {
	ServiceSvc_GetReviewTransferTicketChanges * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketChanges * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketChanges *)aParameters
;
@end
@interface ServiceSoapBinding_GetReviewTransferTicketAttachments : ServiceSoapBindingOperation {
	ServiceSvc_GetReviewTransferTicketAttachments * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketAttachments * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketAttachments *)aParameters
;
@end
@interface ServiceSoapBinding_GetReviewTransferTicketSignatures : ServiceSoapBindingOperation {
	ServiceSvc_GetReviewTransferTicketSignatures * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketSignatures * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketSignatures *)aParameters
;
@end
@interface ServiceSoapBinding_GetReviewTransferTicketNotes : ServiceSoapBindingOperation {
	ServiceSvc_GetReviewTransferTicketNotes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketNotes * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketNotes *)aParameters
;
@end
@interface ServiceSoapBinding_BackupTicketFormsInput : ServiceSoapBindingOperation {
	ServiceSvc_BackupTicketFormsInput * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketFormsInput * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketFormsInput *)aParameters
;
@end
@interface ServiceSoapBinding_SearchForPatientByName : ServiceSoapBindingOperation {
	ServiceSvc_SearchForPatientByName * parameters;
}
@property (nonatomic, strong) ServiceSvc_SearchForPatientByName * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_SearchForPatientByName *)aParameters
;
@end
@interface ServiceSoapBinding_SearchForPatientBySSN : ServiceSoapBindingOperation {
	ServiceSvc_SearchForPatientBySSN * parameters;
}
@property (nonatomic, strong) ServiceSvc_SearchForPatientBySSN * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_SearchForPatientBySSN *)aParameters
;
@end
@interface ServiceSoapBinding_DoAdminUnitIpad : ServiceSoapBindingOperation {
	ServiceSvc_DoAdminUnitIpad * parameters;
}
@property (nonatomic, strong) ServiceSvc_DoAdminUnitIpad * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_DoAdminUnitIpad *)aParameters
;
@end
@interface ServiceSoapBinding_DoAdminMachineIpad : ServiceSoapBindingOperation {
	ServiceSvc_DoAdminMachineIpad * parameters;
}
@property (nonatomic, strong) ServiceSvc_DoAdminMachineIpad * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_DoAdminMachineIpad *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompleteTickets : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompleteTickets * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompleteTickets * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompleteTickets *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompleteTicketInputs : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompleteTicketInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompleteTicketInputs * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompleteTicketInputs *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompleteTicketAttachments : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompleteTicketAttachments * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompleteTicketAttachments * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompleteTicketAttachments *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompleteTicketSignatures : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompleteTicketSignatures * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompleteTicketSignatures * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompleteTicketSignatures *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompleteTicketNotes : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompleteTicketNotes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompleteTicketNotes * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompleteTicketNotes *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompTickets : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompTickets * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTickets * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTickets *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompTicketInputs : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompTicketInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketInputs * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketInputs *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompTicketForms : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompTicketForms * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketForms * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketForms *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompTicketChanges : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompTicketChanges * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketChanges * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketChanges *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompTicketAttachments : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompTicketAttachments * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketAttachments * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketAttachments *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompTicketSignatures : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompTicketSignatures * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketSignatures * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketSignatures *)aParameters
;
@end
@interface ServiceSoapBinding_GetIncompTicketNotes : ServiceSoapBindingOperation {
	ServiceSvc_GetIncompTicketNotes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketNotes * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketNotes *)aParameters
;
@end
@interface ServiceSoapBinding_GetMonitors : ServiceSoapBindingOperation {
	ServiceSvc_GetMonitors * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMonitors * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMonitors *)aParameters
;
@end
@interface ServiceSoapBinding_GetMonitorVitals : ServiceSoapBindingOperation {
	ServiceSvc_GetMonitorVitals * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMonitorVitals * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMonitorVitals *)aParameters
;
@end
@interface ServiceSoapBinding_GetMonitorProcedure : ServiceSoapBindingOperation {
	ServiceSvc_GetMonitorProcedure * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMonitorProcedure * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMonitorProcedure *)aParameters
;
@end
@interface ServiceSoapBinding_GetMonitorMed : ServiceSoapBindingOperation {
	ServiceSvc_GetMonitorMed * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMonitorMed * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMonitorMed *)aParameters
;
@end
@interface ServiceSoapBinding_GetMonitorImage : ServiceSoapBindingOperation {
	ServiceSvc_GetMonitorImage * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMonitorImage * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMonitorImage *)aParameters
;
@end
@interface ServiceSoapBinding_GetZoll : ServiceSoapBindingOperation {
	ServiceSvc_GetZoll * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetZoll * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetZoll *)aParameters
;
@end
@interface ServiceSoapBinding_GetZollVitals : ServiceSoapBindingOperation {
	ServiceSvc_GetZollVitals * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetZollVitals * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetZollVitals *)aParameters
;
@end
@interface ServiceSoapBinding_GetZollProcs : ServiceSoapBindingOperation {
	ServiceSvc_GetZollProcs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetZollProcs * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetZollProcs *)aParameters
;
@end
@interface ServiceSoapBinding_GetPCR : ServiceSoapBindingOperation {
	ServiceSvc_GetPCR * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetPCR * parameters;
- (id)initWithBinding:(ServiceSoapBinding *)aBinding delegate:(id<ServiceSoapBindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetPCR *)aParameters
;
@end
@interface ServiceSoapBinding_envelope : NSObject {
}
+ (ServiceSoapBinding_envelope *)sharedInstance;
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements bodyKeys:(NSArray *)bodyKeys;
@end
@interface ServiceSoapBindingResponse : NSObject {
	NSArray *headers;
	NSArray *bodyParts;
	NSError *error;
}
@property (nonatomic) NSArray *headers;
@property (nonatomic) NSArray *bodyParts;
@property (nonatomic) NSError *error;
@end
@class ServiceSoap12BindingResponse;
@class ServiceSoap12BindingOperation;
@protocol ServiceSoap12BindingResponseDelegate <NSObject>
- (void) operation:(ServiceSoap12BindingOperation *)operation completedWithResponse:(ServiceSoap12BindingResponse *)response;
@end
#define kServerAnchorCertificates   @"kServerAnchorCertificates"
#define kServerAnchorsOnly          @"kServerAnchorsOnly"
#define kClientIdentity             @"kClientIdentity"
#define kClientCertificates         @"kClientCertificates"
#define kClientUsername             @"kClientUsername"
#define kClientPassword             @"kClientPassword"
#define kNSURLCredentialPersistence @"kNSURLCredentialPersistence"
#define kValidateResult             @"kValidateResult"
@interface ServiceSoap12Binding : NSObject <ServiceSoap12BindingResponseDelegate> {
	NSURL *address;
	NSTimeInterval timeout;
	NSMutableArray *cookies;
	NSMutableDictionary *customHeaders;
	BOOL logXMLInOut;
	BOOL ignoreEmptyResponse;
	BOOL synchronousOperationComplete;
	id<SSLCredentialsManaging> sslManager;
	SOAPSigner *soapSigner;
}
@property (nonatomic, copy) NSURL *address;
@property (nonatomic) BOOL logXMLInOut;
@property (nonatomic) BOOL ignoreEmptyResponse;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic) NSMutableArray *cookies;
@property (nonatomic) NSMutableDictionary *customHeaders;
@property (nonatomic) id<SSLCredentialsManaging> sslManager;
@property (nonatomic) SOAPSigner *soapSigner;
+ (NSTimeInterval) defaultTimeout;
- (id)initWithAddress:(NSString *)anAddress;
- (void)sendHTTPCallUsingBody:(NSString *)body soapAction:(NSString *)soapAction forOperation:(ServiceSoap12BindingOperation *)operation;
- (void)addCookie:(NSHTTPCookie *)toAdd;
- (NSString *)MIMEType;
- (ServiceSoap12BindingResponse *)GetCustomerIDUsingParameters:(ServiceSvc_GetCustomerID *)aParameters ;
- (void)GetCustomerIDAsyncUsingParameters:(ServiceSvc_GetCustomerID *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetInputsTableUsingParameters:(ServiceSvc_GetInputsTable *)aParameters ;
- (void)GetInputsTableAsyncUsingParameters:(ServiceSvc_GetInputsTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetInputLookupTableUsingParameters:(ServiceSvc_GetInputLookupTable *)aParameters ;
- (void)GetInputLookupTableAsyncUsingParameters:(ServiceSvc_GetInputLookupTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetTreatmentsTableUsingParameters:(ServiceSvc_GetTreatmentsTable *)aParameters ;
- (void)GetTreatmentsTableAsyncUsingParameters:(ServiceSvc_GetTreatmentsTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetTreatmentInputsTableUsingParameters:(ServiceSvc_GetTreatmentInputsTable *)aParameters ;
- (void)GetTreatmentInputsTableAsyncUsingParameters:(ServiceSvc_GetTreatmentInputsTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetTreatmentInputLookupTableUsingParameters:(ServiceSvc_GetTreatmentInputLookupTable *)aParameters ;
- (void)GetTreatmentInputLookupTableAsyncUsingParameters:(ServiceSvc_GetTreatmentInputLookupTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetCertificationTableUsingParameters:(ServiceSvc_GetCertificationTable *)aParameters ;
- (void)GetCertificationTableAsyncUsingParameters:(ServiceSvc_GetCertificationTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetChiefComplaintsTableUsingParameters:(ServiceSvc_GetChiefComplaintsTable *)aParameters ;
- (void)GetChiefComplaintsTableAsyncUsingParameters:(ServiceSvc_GetChiefComplaintsTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetCitiesTableUsingParameters:(ServiceSvc_GetCitiesTable *)aParameters ;
- (void)GetCitiesTableAsyncUsingParameters:(ServiceSvc_GetCitiesTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetControlFiltersTableUsingParameters:(ServiceSvc_GetControlFiltersTable *)aParameters ;
- (void)GetControlFiltersTableAsyncUsingParameters:(ServiceSvc_GetControlFiltersTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetCountiesTableUsingParameters:(ServiceSvc_GetCountiesTable *)aParameters ;
- (void)GetCountiesTableAsyncUsingParameters:(ServiceSvc_GetCountiesTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetCrewRideTypesTableUsingParameters:(ServiceSvc_GetCrewRideTypesTable *)aParameters ;
- (void)GetCrewRideTypesTableAsyncUsingParameters:(ServiceSvc_GetCrewRideTypesTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetCustomerContentTableUsingParameters:(ServiceSvc_GetCustomerContentTable *)aParameters ;
- (void)GetCustomerContentTableAsyncUsingParameters:(ServiceSvc_GetCustomerContentTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetCustomFormExclusionUsingParameters:(ServiceSvc_GetCustomFormExclusion *)aParameters ;
- (void)GetCustomFormExclusionAsyncUsingParameters:(ServiceSvc_GetCustomFormExclusion *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetCustomFormInputLookUpUsingParameters:(ServiceSvc_GetCustomFormInputLookUp *)aParameters ;
- (void)GetCustomFormInputLookUpAsyncUsingParameters:(ServiceSvc_GetCustomFormInputLookUp *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetCustomFormsUsingParameters:(ServiceSvc_GetCustomForms *)aParameters ;
- (void)GetCustomFormsAsyncUsingParameters:(ServiceSvc_GetCustomForms *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetCustomFormInputsUsingParameters:(ServiceSvc_GetCustomFormInputs *)aParameters ;
- (void)GetCustomFormInputsAsyncUsingParameters:(ServiceSvc_GetCustomFormInputs *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetDrugDosagesUsingParameters:(ServiceSvc_GetDrugDosages *)aParameters ;
- (void)GetDrugDosagesAsyncUsingParameters:(ServiceSvc_GetDrugDosages *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetDrugsUsingParameters:(ServiceSvc_GetDrugs *)aParameters ;
- (void)GetDrugsAsyncUsingParameters:(ServiceSvc_GetDrugs *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetFormsUsingParameters:(ServiceSvc_GetForms *)aParameters ;
- (void)GetFormsAsyncUsingParameters:(ServiceSvc_GetForms *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetGroupsUsingParameters:(ServiceSvc_GetGroups *)aParameters ;
- (void)GetGroupsAsyncUsingParameters:(ServiceSvc_GetGroups *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetInjuryTypesUsingParameters:(ServiceSvc_GetInjuryTypes *)aParameters ;
- (void)GetInjuryTypesAsyncUsingParameters:(ServiceSvc_GetInjuryTypes *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetInsuranceUsingParameters:(ServiceSvc_GetInsurance *)aParameters ;
- (void)GetInsuranceAsyncUsingParameters:(ServiceSvc_GetInsurance *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetInsuranceInputLookupUsingParameters:(ServiceSvc_GetInsuranceInputLookup *)aParameters ;
- (void)GetInsuranceInputLookupAsyncUsingParameters:(ServiceSvc_GetInsuranceInputLookup *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetInsuranceInputsUsingParameters:(ServiceSvc_GetInsuranceInputs *)aParameters ;
- (void)GetInsuranceInputsAsyncUsingParameters:(ServiceSvc_GetInsuranceInputs *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetInsuranceTypesUsingParameters:(ServiceSvc_GetInsuranceTypes *)aParameters ;
- (void)GetInsuranceTypesAsyncUsingParameters:(ServiceSvc_GetInsuranceTypes *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetLocationsUsingParameters:(ServiceSvc_GetLocations *)aParameters ;
- (void)GetLocationsAsyncUsingParameters:(ServiceSvc_GetLocations *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetMedicationsUsingParameters:(ServiceSvc_GetMedications *)aParameters ;
- (void)GetMedicationsAsyncUsingParameters:(ServiceSvc_GetMedications *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetPagesUsingParameters:(ServiceSvc_GetPages *)aParameters ;
- (void)GetPagesAsyncUsingParameters:(ServiceSvc_GetPages *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetProtocolFilesUsingParameters:(ServiceSvc_GetProtocolFiles *)aParameters ;
- (void)GetProtocolFilesAsyncUsingParameters:(ServiceSvc_GetProtocolFiles *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetProtocolGroupsUsingParameters:(ServiceSvc_GetProtocolGroups *)aParameters ;
- (void)GetProtocolGroupsAsyncUsingParameters:(ServiceSvc_GetProtocolGroups *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetQuickButtonsUsingParameters:(ServiceSvc_GetQuickButtons *)aParameters ;
- (void)GetQuickButtonsAsyncUsingParameters:(ServiceSvc_GetQuickButtons *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetShiftsUsingParameters:(ServiceSvc_GetShifts *)aParameters ;
- (void)GetShiftsAsyncUsingParameters:(ServiceSvc_GetShifts *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetSignatureTypesUsingParameters:(ServiceSvc_GetSignatureTypes *)aParameters ;
- (void)GetSignatureTypesAsyncUsingParameters:(ServiceSvc_GetSignatureTypes *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetStatesUsingParameters:(ServiceSvc_GetStates *)aParameters ;
- (void)GetStatesAsyncUsingParameters:(ServiceSvc_GetStates *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetStationsUsingParameters:(ServiceSvc_GetStations *)aParameters ;
- (void)GetStationsAsyncUsingParameters:(ServiceSvc_GetStations *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetStatusUsingParameters:(ServiceSvc_GetStatus *)aParameters ;
- (void)GetStatusAsyncUsingParameters:(ServiceSvc_GetStatus *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetUsersUsingParameters:(ServiceSvc_GetUsers *)aParameters ;
- (void)GetUsersAsyncUsingParameters:(ServiceSvc_GetUsers *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetZipsUsingParameters:(ServiceSvc_GetZips *)aParameters ;
- (void)GetZipsAsyncUsingParameters:(ServiceSvc_GetZips *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetVitalsTableUsingParameters:(ServiceSvc_GetVitalsTable *)aParameters ;
- (void)GetVitalsTableAsyncUsingParameters:(ServiceSvc_GetVitalsTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetVitalInputLookupTableUsingParameters:(ServiceSvc_GetVitalInputLookupTable *)aParameters ;
- (void)GetVitalInputLookupTableAsyncUsingParameters:(ServiceSvc_GetVitalInputLookupTable *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetUnitsUsingParameters:(ServiceSvc_GetUnits *)aParameters ;
- (void)GetUnitsAsyncUsingParameters:(ServiceSvc_GetUnits *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetSettingsUsingParameters:(ServiceSvc_GetSettings *)aParameters ;
- (void)GetSettingsAsyncUsingParameters:(ServiceSvc_GetSettings *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetxInputTablesUsingParameters:(ServiceSvc_GetxInputTables *)aParameters ;
- (void)GetxInputTablesAsyncUsingParameters:(ServiceSvc_GetxInputTables *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetOutcomesUsingParameters:(ServiceSvc_GetOutcomes *)aParameters ;
- (void)GetOutcomesAsyncUsingParameters:(ServiceSvc_GetOutcomes *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetOutcomeTypesUsingParameters:(ServiceSvc_GetOutcomeTypes *)aParameters ;
- (void)GetOutcomeTypesAsyncUsingParameters:(ServiceSvc_GetOutcomeTypes *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetOutcomeRequiredItemsUsingParameters:(ServiceSvc_GetOutcomeRequiredItems *)aParameters ;
- (void)GetOutcomeRequiredItemsAsyncUsingParameters:(ServiceSvc_GetOutcomeRequiredItems *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetOutcomeRequiredSignaturesUsingParameters:(ServiceSvc_GetOutcomeRequiredSignatures *)aParameters ;
- (void)GetOutcomeRequiredSignaturesAsyncUsingParameters:(ServiceSvc_GetOutcomeRequiredSignatures *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)UpdateChange6UsingParameters:(ServiceSvc_UpdateChange6 *)aParameters ;
- (void)UpdateChange6AsyncUsingParameters:(ServiceSvc_UpdateChange6 *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)BackupTicketUsingParameters:(ServiceSvc_BackupTicket *)aParameters ;
- (void)BackupTicketAsyncUsingParameters:(ServiceSvc_BackupTicket *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)BackupTicketInputsUsingParameters:(ServiceSvc_BackupTicketInputs *)aParameters ;
- (void)BackupTicketInputsAsyncUsingParameters:(ServiceSvc_BackupTicketInputs *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)BackupTicketNotesUsingParameters:(ServiceSvc_BackupTicketNotes *)aParameters ;
- (void)BackupTicketNotesAsyncUsingParameters:(ServiceSvc_BackupTicketNotes *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)BackupTicketChangesUsingParameters:(ServiceSvc_BackupTicketChanges *)aParameters ;
- (void)BackupTicketChangesAsyncUsingParameters:(ServiceSvc_BackupTicketChanges *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)BackupTicketAttachmentsUsingParameters:(ServiceSvc_BackupTicketAttachments *)aParameters ;
- (void)BackupTicketAttachmentsAsyncUsingParameters:(ServiceSvc_BackupTicketAttachments *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)BackupTicketSignaturesUsingParameters:(ServiceSvc_BackupTicketSignatures *)aParameters ;
- (void)BackupTicketSignaturesAsyncUsingParameters:(ServiceSvc_BackupTicketSignatures *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetReviewTransferTicketsUsingParameters:(ServiceSvc_GetReviewTransferTickets *)aParameters ;
- (void)GetReviewTransferTicketsAsyncUsingParameters:(ServiceSvc_GetReviewTransferTickets *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetReviewTransferTicketInputsUsingParameters:(ServiceSvc_GetReviewTransferTicketInputs *)aParameters ;
- (void)GetReviewTransferTicketInputsAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketInputs *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetReviewTransferTicketFormsUsingParameters:(ServiceSvc_GetReviewTransferTicketForms *)aParameters ;
- (void)GetReviewTransferTicketFormsAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketForms *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetReviewTransferTicketChangesUsingParameters:(ServiceSvc_GetReviewTransferTicketChanges *)aParameters ;
- (void)GetReviewTransferTicketChangesAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketChanges *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetReviewTransferTicketAttachmentsUsingParameters:(ServiceSvc_GetReviewTransferTicketAttachments *)aParameters ;
- (void)GetReviewTransferTicketAttachmentsAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketAttachments *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetReviewTransferTicketSignaturesUsingParameters:(ServiceSvc_GetReviewTransferTicketSignatures *)aParameters ;
- (void)GetReviewTransferTicketSignaturesAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketSignatures *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetReviewTransferTicketNotesUsingParameters:(ServiceSvc_GetReviewTransferTicketNotes *)aParameters ;
- (void)GetReviewTransferTicketNotesAsyncUsingParameters:(ServiceSvc_GetReviewTransferTicketNotes *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)BackupTicketFormsInputUsingParameters:(ServiceSvc_BackupTicketFormsInput *)aParameters ;
- (void)BackupTicketFormsInputAsyncUsingParameters:(ServiceSvc_BackupTicketFormsInput *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)SearchForPatientByNameUsingParameters:(ServiceSvc_SearchForPatientByName *)aParameters ;
- (void)SearchForPatientByNameAsyncUsingParameters:(ServiceSvc_SearchForPatientByName *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)SearchForPatientBySSNUsingParameters:(ServiceSvc_SearchForPatientBySSN *)aParameters ;
- (void)SearchForPatientBySSNAsyncUsingParameters:(ServiceSvc_SearchForPatientBySSN *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)DoAdminUnitIpadUsingParameters:(ServiceSvc_DoAdminUnitIpad *)aParameters ;
- (void)DoAdminUnitIpadAsyncUsingParameters:(ServiceSvc_DoAdminUnitIpad *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)DoAdminMachineIpadUsingParameters:(ServiceSvc_DoAdminMachineIpad *)aParameters ;
- (void)DoAdminMachineIpadAsyncUsingParameters:(ServiceSvc_DoAdminMachineIpad *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompleteTicketsUsingParameters:(ServiceSvc_GetIncompleteTickets *)aParameters ;
- (void)GetIncompleteTicketsAsyncUsingParameters:(ServiceSvc_GetIncompleteTickets *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompleteTicketInputsUsingParameters:(ServiceSvc_GetIncompleteTicketInputs *)aParameters ;
- (void)GetIncompleteTicketInputsAsyncUsingParameters:(ServiceSvc_GetIncompleteTicketInputs *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompleteTicketAttachmentsUsingParameters:(ServiceSvc_GetIncompleteTicketAttachments *)aParameters ;
- (void)GetIncompleteTicketAttachmentsAsyncUsingParameters:(ServiceSvc_GetIncompleteTicketAttachments *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompleteTicketSignaturesUsingParameters:(ServiceSvc_GetIncompleteTicketSignatures *)aParameters ;
- (void)GetIncompleteTicketSignaturesAsyncUsingParameters:(ServiceSvc_GetIncompleteTicketSignatures *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompleteTicketNotesUsingParameters:(ServiceSvc_GetIncompleteTicketNotes *)aParameters ;
- (void)GetIncompleteTicketNotesAsyncUsingParameters:(ServiceSvc_GetIncompleteTicketNotes *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompTicketsUsingParameters:(ServiceSvc_GetIncompTickets *)aParameters ;
- (void)GetIncompTicketsAsyncUsingParameters:(ServiceSvc_GetIncompTickets *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompTicketInputsUsingParameters:(ServiceSvc_GetIncompTicketInputs *)aParameters ;
- (void)GetIncompTicketInputsAsyncUsingParameters:(ServiceSvc_GetIncompTicketInputs *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompTicketFormsUsingParameters:(ServiceSvc_GetIncompTicketForms *)aParameters ;
- (void)GetIncompTicketFormsAsyncUsingParameters:(ServiceSvc_GetIncompTicketForms *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompTicketChangesUsingParameters:(ServiceSvc_GetIncompTicketChanges *)aParameters ;
- (void)GetIncompTicketChangesAsyncUsingParameters:(ServiceSvc_GetIncompTicketChanges *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompTicketAttachmentsUsingParameters:(ServiceSvc_GetIncompTicketAttachments *)aParameters ;
- (void)GetIncompTicketAttachmentsAsyncUsingParameters:(ServiceSvc_GetIncompTicketAttachments *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompTicketSignaturesUsingParameters:(ServiceSvc_GetIncompTicketSignatures *)aParameters ;
- (void)GetIncompTicketSignaturesAsyncUsingParameters:(ServiceSvc_GetIncompTicketSignatures *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetIncompTicketNotesUsingParameters:(ServiceSvc_GetIncompTicketNotes *)aParameters ;
- (void)GetIncompTicketNotesAsyncUsingParameters:(ServiceSvc_GetIncompTicketNotes *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetMonitorsUsingParameters:(ServiceSvc_GetMonitors *)aParameters ;
- (void)GetMonitorsAsyncUsingParameters:(ServiceSvc_GetMonitors *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetMonitorVitalsUsingParameters:(ServiceSvc_GetMonitorVitals *)aParameters ;
- (void)GetMonitorVitalsAsyncUsingParameters:(ServiceSvc_GetMonitorVitals *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetMonitorProcedureUsingParameters:(ServiceSvc_GetMonitorProcedure *)aParameters ;
- (void)GetMonitorProcedureAsyncUsingParameters:(ServiceSvc_GetMonitorProcedure *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetMonitorMedUsingParameters:(ServiceSvc_GetMonitorMed *)aParameters ;
- (void)GetMonitorMedAsyncUsingParameters:(ServiceSvc_GetMonitorMed *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetMonitorImageUsingParameters:(ServiceSvc_GetMonitorImage *)aParameters ;
- (void)GetMonitorImageAsyncUsingParameters:(ServiceSvc_GetMonitorImage *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetZollUsingParameters:(ServiceSvc_GetZoll *)aParameters ;
- (void)GetZollAsyncUsingParameters:(ServiceSvc_GetZoll *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetZollVitalsUsingParameters:(ServiceSvc_GetZollVitals *)aParameters ;
- (void)GetZollVitalsAsyncUsingParameters:(ServiceSvc_GetZollVitals *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetZollProcsUsingParameters:(ServiceSvc_GetZollProcs *)aParameters ;
- (void)GetZollProcsAsyncUsingParameters:(ServiceSvc_GetZollProcs *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
- (ServiceSoap12BindingResponse *)GetPCRUsingParameters:(ServiceSvc_GetPCR *)aParameters ;
- (void)GetPCRAsyncUsingParameters:(ServiceSvc_GetPCR *)aParameters  delegate:(id<ServiceSoap12BindingResponseDelegate>)responseDelegate;
@end
@interface ServiceSoap12BindingOperation : NSOperation {
	ServiceSoap12Binding *binding;
	ServiceSoap12BindingResponse *response;
	__weak id<ServiceSoap12BindingResponseDelegate> delegate;
	NSMutableData *responseData;
	NSURLConnection *urlConnection;
}
@property (nonatomic) ServiceSoap12Binding *binding;
@property (nonatomic, readonly) ServiceSoap12BindingResponse *response;
@property (nonatomic, weak) id<ServiceSoap12BindingResponseDelegate> delegate;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSURLConnection *urlConnection;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
@interface ServiceSoap12Binding_GetCustomerID : ServiceSoap12BindingOperation {
	ServiceSvc_GetCustomerID * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomerID * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomerID *)aParameters
;
@end
@interface ServiceSoap12Binding_GetInputsTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetInputsTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInputsTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInputsTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetInputLookupTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetInputLookupTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInputLookupTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInputLookupTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetTreatmentsTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetTreatmentsTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetTreatmentsTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetTreatmentsTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetTreatmentInputsTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetTreatmentInputsTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetTreatmentInputsTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetTreatmentInputsTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetTreatmentInputLookupTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetTreatmentInputLookupTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetTreatmentInputLookupTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetTreatmentInputLookupTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetCertificationTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetCertificationTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCertificationTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCertificationTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetChiefComplaintsTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetChiefComplaintsTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetChiefComplaintsTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetChiefComplaintsTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetCitiesTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetCitiesTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCitiesTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCitiesTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetControlFiltersTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetControlFiltersTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetControlFiltersTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetControlFiltersTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetCountiesTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetCountiesTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCountiesTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCountiesTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetCrewRideTypesTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetCrewRideTypesTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCrewRideTypesTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCrewRideTypesTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetCustomerContentTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetCustomerContentTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomerContentTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomerContentTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetCustomFormExclusion : ServiceSoap12BindingOperation {
	ServiceSvc_GetCustomFormExclusion * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomFormExclusion * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomFormExclusion *)aParameters
;
@end
@interface ServiceSoap12Binding_GetCustomFormInputLookUp : ServiceSoap12BindingOperation {
	ServiceSvc_GetCustomFormInputLookUp * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomFormInputLookUp * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomFormInputLookUp *)aParameters
;
@end
@interface ServiceSoap12Binding_GetCustomForms : ServiceSoap12BindingOperation {
	ServiceSvc_GetCustomForms * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomForms * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomForms *)aParameters
;
@end
@interface ServiceSoap12Binding_GetCustomFormInputs : ServiceSoap12BindingOperation {
	ServiceSvc_GetCustomFormInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetCustomFormInputs * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetCustomFormInputs *)aParameters
;
@end
@interface ServiceSoap12Binding_GetDrugDosages : ServiceSoap12BindingOperation {
	ServiceSvc_GetDrugDosages * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetDrugDosages * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetDrugDosages *)aParameters
;
@end
@interface ServiceSoap12Binding_GetDrugs : ServiceSoap12BindingOperation {
	ServiceSvc_GetDrugs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetDrugs * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetDrugs *)aParameters
;
@end
@interface ServiceSoap12Binding_GetForms : ServiceSoap12BindingOperation {
	ServiceSvc_GetForms * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetForms * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetForms *)aParameters
;
@end
@interface ServiceSoap12Binding_GetGroups : ServiceSoap12BindingOperation {
	ServiceSvc_GetGroups * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetGroups * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetGroups *)aParameters
;
@end
@interface ServiceSoap12Binding_GetInjuryTypes : ServiceSoap12BindingOperation {
	ServiceSvc_GetInjuryTypes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInjuryTypes * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInjuryTypes *)aParameters
;
@end
@interface ServiceSoap12Binding_GetInsurance : ServiceSoap12BindingOperation {
	ServiceSvc_GetInsurance * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInsurance * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInsurance *)aParameters
;
@end
@interface ServiceSoap12Binding_GetInsuranceInputLookup : ServiceSoap12BindingOperation {
	ServiceSvc_GetInsuranceInputLookup * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInsuranceInputLookup * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInsuranceInputLookup *)aParameters
;
@end
@interface ServiceSoap12Binding_GetInsuranceInputs : ServiceSoap12BindingOperation {
	ServiceSvc_GetInsuranceInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInsuranceInputs * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInsuranceInputs *)aParameters
;
@end
@interface ServiceSoap12Binding_GetInsuranceTypes : ServiceSoap12BindingOperation {
	ServiceSvc_GetInsuranceTypes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetInsuranceTypes * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetInsuranceTypes *)aParameters
;
@end
@interface ServiceSoap12Binding_GetLocations : ServiceSoap12BindingOperation {
	ServiceSvc_GetLocations * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetLocations * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetLocations *)aParameters
;
@end
@interface ServiceSoap12Binding_GetMedications : ServiceSoap12BindingOperation {
	ServiceSvc_GetMedications * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMedications * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMedications *)aParameters
;
@end
@interface ServiceSoap12Binding_GetPages : ServiceSoap12BindingOperation {
	ServiceSvc_GetPages * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetPages * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetPages *)aParameters
;
@end
@interface ServiceSoap12Binding_GetProtocolFiles : ServiceSoap12BindingOperation {
	ServiceSvc_GetProtocolFiles * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetProtocolFiles * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetProtocolFiles *)aParameters
;
@end
@interface ServiceSoap12Binding_GetProtocolGroups : ServiceSoap12BindingOperation {
	ServiceSvc_GetProtocolGroups * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetProtocolGroups * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetProtocolGroups *)aParameters
;
@end
@interface ServiceSoap12Binding_GetQuickButtons : ServiceSoap12BindingOperation {
	ServiceSvc_GetQuickButtons * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetQuickButtons * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetQuickButtons *)aParameters
;
@end
@interface ServiceSoap12Binding_GetShifts : ServiceSoap12BindingOperation {
	ServiceSvc_GetShifts * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetShifts * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetShifts *)aParameters
;
@end
@interface ServiceSoap12Binding_GetSignatureTypes : ServiceSoap12BindingOperation {
	ServiceSvc_GetSignatureTypes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetSignatureTypes * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetSignatureTypes *)aParameters
;
@end
@interface ServiceSoap12Binding_GetStates : ServiceSoap12BindingOperation {
	ServiceSvc_GetStates * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetStates * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetStates *)aParameters
;
@end
@interface ServiceSoap12Binding_GetStations : ServiceSoap12BindingOperation {
	ServiceSvc_GetStations * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetStations * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetStations *)aParameters
;
@end
@interface ServiceSoap12Binding_GetStatus : ServiceSoap12BindingOperation {
	ServiceSvc_GetStatus * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetStatus * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetStatus *)aParameters
;
@end
@interface ServiceSoap12Binding_GetUsers : ServiceSoap12BindingOperation {
	ServiceSvc_GetUsers * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetUsers * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetUsers *)aParameters
;
@end
@interface ServiceSoap12Binding_GetZips : ServiceSoap12BindingOperation {
	ServiceSvc_GetZips * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetZips * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetZips *)aParameters
;
@end
@interface ServiceSoap12Binding_GetVitalsTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetVitalsTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetVitalsTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetVitalsTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetVitalInputLookupTable : ServiceSoap12BindingOperation {
	ServiceSvc_GetVitalInputLookupTable * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetVitalInputLookupTable * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetVitalInputLookupTable *)aParameters
;
@end
@interface ServiceSoap12Binding_GetUnits : ServiceSoap12BindingOperation {
	ServiceSvc_GetUnits * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetUnits * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetUnits *)aParameters
;
@end
@interface ServiceSoap12Binding_GetSettings : ServiceSoap12BindingOperation {
	ServiceSvc_GetSettings * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetSettings * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetSettings *)aParameters
;
@end
@interface ServiceSoap12Binding_GetxInputTables : ServiceSoap12BindingOperation {
	ServiceSvc_GetxInputTables * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetxInputTables * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetxInputTables *)aParameters
;
@end
@interface ServiceSoap12Binding_GetOutcomes : ServiceSoap12BindingOperation {
	ServiceSvc_GetOutcomes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetOutcomes * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetOutcomes *)aParameters
;
@end
@interface ServiceSoap12Binding_GetOutcomeTypes : ServiceSoap12BindingOperation {
	ServiceSvc_GetOutcomeTypes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetOutcomeTypes * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetOutcomeTypes *)aParameters
;
@end
@interface ServiceSoap12Binding_GetOutcomeRequiredItems : ServiceSoap12BindingOperation {
	ServiceSvc_GetOutcomeRequiredItems * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetOutcomeRequiredItems * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetOutcomeRequiredItems *)aParameters
;
@end
@interface ServiceSoap12Binding_GetOutcomeRequiredSignatures : ServiceSoap12BindingOperation {
	ServiceSvc_GetOutcomeRequiredSignatures * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetOutcomeRequiredSignatures * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetOutcomeRequiredSignatures *)aParameters
;
@end
@interface ServiceSoap12Binding_UpdateChange6 : ServiceSoap12BindingOperation {
	ServiceSvc_UpdateChange6 * parameters;
}
@property (nonatomic, strong) ServiceSvc_UpdateChange6 * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_UpdateChange6 *)aParameters
;
@end
@interface ServiceSoap12Binding_BackupTicket : ServiceSoap12BindingOperation {
	ServiceSvc_BackupTicket * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicket * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicket *)aParameters
;
@end
@interface ServiceSoap12Binding_BackupTicketInputs : ServiceSoap12BindingOperation {
	ServiceSvc_BackupTicketInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketInputs * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketInputs *)aParameters
;
@end
@interface ServiceSoap12Binding_BackupTicketNotes : ServiceSoap12BindingOperation {
	ServiceSvc_BackupTicketNotes * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketNotes * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketNotes *)aParameters
;
@end
@interface ServiceSoap12Binding_BackupTicketChanges : ServiceSoap12BindingOperation {
	ServiceSvc_BackupTicketChanges * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketChanges * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketChanges *)aParameters
;
@end
@interface ServiceSoap12Binding_BackupTicketAttachments : ServiceSoap12BindingOperation {
	ServiceSvc_BackupTicketAttachments * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketAttachments * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketAttachments *)aParameters
;
@end
@interface ServiceSoap12Binding_BackupTicketSignatures : ServiceSoap12BindingOperation {
	ServiceSvc_BackupTicketSignatures * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketSignatures * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketSignatures *)aParameters
;
@end
@interface ServiceSoap12Binding_GetReviewTransferTickets : ServiceSoap12BindingOperation {
	ServiceSvc_GetReviewTransferTickets * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTickets * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTickets *)aParameters
;
@end
@interface ServiceSoap12Binding_GetReviewTransferTicketInputs : ServiceSoap12BindingOperation {
	ServiceSvc_GetReviewTransferTicketInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketInputs * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketInputs *)aParameters
;
@end
@interface ServiceSoap12Binding_GetReviewTransferTicketForms : ServiceSoap12BindingOperation {
	ServiceSvc_GetReviewTransferTicketForms * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketForms * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketForms *)aParameters
;
@end
@interface ServiceSoap12Binding_GetReviewTransferTicketChanges : ServiceSoap12BindingOperation {
	ServiceSvc_GetReviewTransferTicketChanges * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketChanges * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketChanges *)aParameters
;
@end
@interface ServiceSoap12Binding_GetReviewTransferTicketAttachments : ServiceSoap12BindingOperation {
	ServiceSvc_GetReviewTransferTicketAttachments * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketAttachments * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketAttachments *)aParameters
;
@end
@interface ServiceSoap12Binding_GetReviewTransferTicketSignatures : ServiceSoap12BindingOperation {
	ServiceSvc_GetReviewTransferTicketSignatures * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketSignatures * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketSignatures *)aParameters
;
@end
@interface ServiceSoap12Binding_GetReviewTransferTicketNotes : ServiceSoap12BindingOperation {
	ServiceSvc_GetReviewTransferTicketNotes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetReviewTransferTicketNotes * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetReviewTransferTicketNotes *)aParameters
;
@end
@interface ServiceSoap12Binding_BackupTicketFormsInput : ServiceSoap12BindingOperation {
	ServiceSvc_BackupTicketFormsInput * parameters;
}
@property (nonatomic, strong) ServiceSvc_BackupTicketFormsInput * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_BackupTicketFormsInput *)aParameters
;
@end
@interface ServiceSoap12Binding_SearchForPatientByName : ServiceSoap12BindingOperation {
	ServiceSvc_SearchForPatientByName * parameters;
}
@property (nonatomic, strong) ServiceSvc_SearchForPatientByName * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_SearchForPatientByName *)aParameters
;
@end
@interface ServiceSoap12Binding_SearchForPatientBySSN : ServiceSoap12BindingOperation {
	ServiceSvc_SearchForPatientBySSN * parameters;
}
@property (nonatomic, strong) ServiceSvc_SearchForPatientBySSN * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_SearchForPatientBySSN *)aParameters
;
@end
@interface ServiceSoap12Binding_DoAdminUnitIpad : ServiceSoap12BindingOperation {
	ServiceSvc_DoAdminUnitIpad * parameters;
}
@property (nonatomic, strong) ServiceSvc_DoAdminUnitIpad * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_DoAdminUnitIpad *)aParameters
;
@end
@interface ServiceSoap12Binding_DoAdminMachineIpad : ServiceSoap12BindingOperation {
	ServiceSvc_DoAdminMachineIpad * parameters;
}
@property (nonatomic, strong) ServiceSvc_DoAdminMachineIpad * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_DoAdminMachineIpad *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompleteTickets : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompleteTickets * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompleteTickets * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompleteTickets *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompleteTicketInputs : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompleteTicketInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompleteTicketInputs * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompleteTicketInputs *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompleteTicketAttachments : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompleteTicketAttachments * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompleteTicketAttachments * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompleteTicketAttachments *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompleteTicketSignatures : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompleteTicketSignatures * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompleteTicketSignatures * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompleteTicketSignatures *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompleteTicketNotes : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompleteTicketNotes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompleteTicketNotes * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompleteTicketNotes *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompTickets : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompTickets * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTickets * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTickets *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompTicketInputs : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompTicketInputs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketInputs * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketInputs *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompTicketForms : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompTicketForms * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketForms * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketForms *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompTicketChanges : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompTicketChanges * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketChanges * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketChanges *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompTicketAttachments : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompTicketAttachments * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketAttachments * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketAttachments *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompTicketSignatures : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompTicketSignatures * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketSignatures * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketSignatures *)aParameters
;
@end
@interface ServiceSoap12Binding_GetIncompTicketNotes : ServiceSoap12BindingOperation {
	ServiceSvc_GetIncompTicketNotes * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetIncompTicketNotes * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetIncompTicketNotes *)aParameters
;
@end
@interface ServiceSoap12Binding_GetMonitors : ServiceSoap12BindingOperation {
	ServiceSvc_GetMonitors * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMonitors * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMonitors *)aParameters
;
@end
@interface ServiceSoap12Binding_GetMonitorVitals : ServiceSoap12BindingOperation {
	ServiceSvc_GetMonitorVitals * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMonitorVitals * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMonitorVitals *)aParameters
;
@end
@interface ServiceSoap12Binding_GetMonitorProcedure : ServiceSoap12BindingOperation {
	ServiceSvc_GetMonitorProcedure * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMonitorProcedure * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMonitorProcedure *)aParameters
;
@end
@interface ServiceSoap12Binding_GetMonitorMed : ServiceSoap12BindingOperation {
	ServiceSvc_GetMonitorMed * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMonitorMed * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMonitorMed *)aParameters
;
@end
@interface ServiceSoap12Binding_GetMonitorImage : ServiceSoap12BindingOperation {
	ServiceSvc_GetMonitorImage * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetMonitorImage * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetMonitorImage *)aParameters
;
@end
@interface ServiceSoap12Binding_GetZoll : ServiceSoap12BindingOperation {
	ServiceSvc_GetZoll * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetZoll * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetZoll *)aParameters
;
@end
@interface ServiceSoap12Binding_GetZollVitals : ServiceSoap12BindingOperation {
	ServiceSvc_GetZollVitals * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetZollVitals * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetZollVitals *)aParameters
;
@end
@interface ServiceSoap12Binding_GetZollProcs : ServiceSoap12BindingOperation {
	ServiceSvc_GetZollProcs * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetZollProcs * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetZollProcs *)aParameters
;
@end
@interface ServiceSoap12Binding_GetPCR : ServiceSoap12BindingOperation {
	ServiceSvc_GetPCR * parameters;
}
@property (nonatomic, strong) ServiceSvc_GetPCR * parameters;
- (id)initWithBinding:(ServiceSoap12Binding *)aBinding delegate:(id<ServiceSoap12BindingResponseDelegate>)aDelegate
	parameters:(ServiceSvc_GetPCR *)aParameters
;
@end
@interface ServiceSoap12Binding_envelope : NSObject {
}
+ (ServiceSoap12Binding_envelope *)sharedInstance;
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements bodyKeys:(NSArray *)bodyKeys;
@end
@interface ServiceSoap12BindingResponse : NSObject {
	NSArray *headers;
	NSArray *bodyParts;
	NSError *error;
}
@property (nonatomic) NSArray *headers;
@property (nonatomic) NSArray *bodyParts;
@property (nonatomic) NSError *error;
@end
