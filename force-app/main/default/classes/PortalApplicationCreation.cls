global without sharing class PortalApplicationCreation implements clcommon.PortalCustomRemoteAPI1{
    global clcommon.Response invokeAction(String componentStrName, String[] disclosureNames, Map<String, Object> params){
        //*****The return Type will be in this class
        clcommon.Response res = new clcommon.Response();
        system.debug('inside portalApplicationCreation class');
        
        //****the map that will contain the response sent by the API
        map<String,Object> fields= new map<String,Object>();
        try{
            genesis__Applications__C app;
            system.debug('disclosure names '+disclosureNames);
            system.debug('params '+params);
            //"params" map will contain the request  that are sent from the portal during the API call
            Double Amount = Double.valueOf(params.get('requestedLoanAmount'));
            String TIN = String.valueOf(params.get('TIN_Number'));
            String Token = String.valueOf(params.get('Token'));
            system.debug('values amount '+amount+' TIN '+TIN+' Token '+Token);
            List<Account> accList = [select id from Account where Tin__c= :TIN limit 1];
            system.debug('accList'+accList);
           if(!accList.isEmpty()){
               List<genesis__Credit_Rating_Matrix__c> creditRating = [select id from genesis__Credit_Rating_Matrix__c limit 1];
               List<clcommon__CL_Product__c> clProduct = [select id from clcommon__CL_Product__c limit 1];
               app = new genesis__Applications__c(genesis__account__c = accList[0].Id,
                                                                           Requested_Loan_Amount__c = amount,
                                                                           token__c = Token,
                                                                           portal_Stage__C ='Customer_Applies_Personal_Info',
                                                                          // genesis__Status__c = 'NEW - ENTERED',
                                                                           genesis__Credit_Rating__c = creditRating[0].Id,
                                                                           genesis__Expected_Start_Date__c = system.today(),
                                                                           genesis__Loan_Amount__c = amount,
                                                                           genesis__CL_Product__c = clProduct[0].Id);
            }else{
                res = new clcommon.Response();
                res.status = clcommon.Constants.ERROR;
                res.errorCode = clcommon.Constants.API_EXCEPTION;
                res.errorMessage = 'Invalid TIN';
                return res;
            }
            try{
                insert app;
                system.debug('app'+app.Id);
            }catch(DmlException e){
                throw e;
            }
            
            //*****whatever data needs to be returned should be in this map format
            fields.put('Response','Success');
            fields.put('appId',app.Id);
                        
            List<clcommon.PortalCustomRemoteActionRecord> records = new List<clcommon.PortalCustomRemoteActionRecord>();
            records.add ( new clcommon.PortalCustomRemoteActionRecord( 'response', fields));//***response map is assigned to be returned
            res = clcommon.PortalActions.getCustomRemoteActionResponse(records);  
        }catch (Exception er) {
            res = new clcommon.Response();
            res.status = clcommon.Constants.ERROR;
            res.errorCode = clcommon.Constants.API_EXCEPTION;
            res.errorMessage = er.getMessage();
        }
        return res;
    }
}