global without sharing class CLS_PersonalInfoPagePortalAPI implements clcommon.PortalCustomRemoteAPI1{
    
    global clcommon.Response invokeAction(String componentStrName, String[] disclosureNames, Map<String, Object> params) {
        clcommon.Response res;
        try{
           if(params != null){
           
               system.debug('--params--'+params );
               
               String AppValues =(String) params.get('application');
               system.debug('appValues'+appValues);
               String AppId =(String) params.get('applicationId');
               system.debug('appId'+appId);
               List<genesis__Applications__c> AppUpdateList = (List<genesis__Applications__c>) JSON.deserialize(AppValues, List<genesis__Applications__c>.class);
               //String property =(String) params.get('property');
               //List<genesis__Monthly_Income_Expense_Info__c> MonthlyIncomeExpenseList = (List<genesis__Monthly_Income_Expense_Info__c>) JSON.deserialize(property, List<genesis__Monthly_Income_Expense_Info__c>.class);
              // system.debug('--MonthlyIncomeExpenseList--'+MonthlyIncomeExpenseList);
               system.debug('--AppUpdateList --'+AppUpdateList );
               
               //String uniqueIdentifier = (String)params.get(CLS_PortalAPIConstants.UNIQUE_IDENTIFIER); 
               if(true){
                    List<genesis__Applications__c> appList = [SELECT id, 
                                                                     Token__c,
                                                                     genesis__Status__c,
                                                                     genesis__CL_Purpose__c,
                                                                     genesis__Gross_Annual_Income__c,
                                                                     genesis__Loan_Amount__c,
                                                                     Portal_Stage__c
                                                                    // genesis__CL_Product__r.Min_Loan_Amount__c,
                                                                     //genesis__CL_Product__r.Max_Loan_Amount__c,
                                                                    // Request_Hard_Credit_Pull__c
                                                                FROM genesis__Applications__c
                                                               WHERE id = : AppId   
                                                            ORDER BY CreatedDate asc limit 1];
                    
                    if(appList != null && appList.size() > 0){
                        genesis__applications__c app = appList[0];
                        
                        // Always true for testing. 
                        Boolean isSessionValid = True;
                        if(isSessionValid){
                            //res = setSuccessResponse(appList.get(0),params);
                            res = setSuccessResponse(null,AppUpdateList,app);
                        }
                    } else {
                        res = CLS_PortalUtils.setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, 'Something went wrong.');
                    }                                   
                } else {
                    String errorMessage = CLS_PortalAPIConstants.ERROR_MESSAGE_PARAM_NOT_FOUND;
                    res = CLS_PortalUtils.setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, errorMessage);
                }
            } else {
                String errorMessage = CLS_PortalAPIConstants.ERROR_MESSAGE_PARAM_NOT_FOUND;
                res = CLS_PortalUtils.setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, errorMessage);
            }
        } catch(Exception e) {                                                                  
            res = CLS_PortalUtils.setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, CLS_PortalAPIConstants.ERROR_MESSAGE_SOMETHING_WENT_WRONG);
        }
        return res;
    }
    
    private clcommon.Response setSuccessResponse(List<genesis__Monthly_Income_Expense_Info__c> MonthlyIncomeExpenseList, 
                                                 List<genesis__Applications__c> AppUpdateList,
                                                 genesis__Applications__c app){
        clcommon.Response res = new clcommon.Response();
        
        app.genesis__CL_Purpose__c = AppUpdateList[0].genesis__CL_Purpose__c ;
        //app.genesis__Gross_Annual_Income__c= AppUpdateList[0].genesis__Gross_Annual_Income__c;
        app.genesis__Status__c = 'NEW - ENTERED';
        
        /*if(app.genesis__Gross_Annual_Income__c<>9999.00){
            app.portal_stage__c = 'Failure_Wrap';
        }*/
      
       // app.portal_stage__c = 'Customer_Applies_Approved';
        
        update app;
      
        Map<String,Object> fields = createResponseMap(app);
        
        List<clcommon.PortalCustomRemoteActionRecord> respList = new List<clcommon.PortalCustomRemoteActionRecord>();
        respList.add(new clcommon.PortalCustomRemoteActionRecord(CLS_PortalAPIConstants.KEY_RESPONSE, fields));
        res = clcommon.PortalActions.getCustomRemoteActionResponse(respList);
        res.status = clcommon.Constants.SUCCESS;
        return res;
    }
    
    
    private Map<String,Object> createResponseMap(genesis__Applications__c app){
        Map<String,Object> fields = new Map<String,Object>();
        
        if(app.Portal_Stage__c <> null){
             fields.put(CLS_PortalAPIConstants.PORTALSTAGE, app.Portal_Stage__c);
        }
        return fields;
    }
}