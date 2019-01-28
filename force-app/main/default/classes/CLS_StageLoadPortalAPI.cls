global without sharing class CLS_StageLoadPortalAPI implements clcommon.PortalCustomRemoteAPI1{
    
    global clcommon.Response invokeAction(String componentStrName, String[] disclosureNames, Map<String, Object> params) {
        clcommon.Response res;
        system.debug('CLS_StageLoadPortalAPI ');
        try{
           if(params != null){
               system.debug('--params--'+params );
               
              // String uniqueIdentifier = (String)params.get(CLS_PortalAPIConstants.UNIQUE_IDENTIFIER); 
               
               String AppValues =(String) params.get('application');
               String AppId =(String) params.get('applicationId');
               List<genesis__Applications__c> AppUpdateList = (List<genesis__Applications__c>) JSON.deserialize(AppValues, List<genesis__Applications__c>.class);
               system.debug('appUpdateList'+appUpdateList);
               if(true){
                    List<genesis__Applications__c> appList = [SELECT id, 
                                                                     Token__c,
                                                                    // Need_Income_Verification__c,
                                                                     Portal_Stage__c,
                                                                     genesis__Status__c,
                                                                     genesis__Gross_Annual_Income__c,
                                                                  //   FICO_Score__c,
                                                                     genesis__Total_Score__c
                                                                FROM genesis__Applications__c
                                                               WHERE id = :AppId   
                                                            ORDER BY CreatedDate asc limit 1];
                    system.debug('--appList--'+appList);  
                    
                                                      
                    if(appList != null && appList.size() > 0){
                            res = setSuccessResponse(appList);
                            
                    } else {
                        //res = setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, 'Contract not found');
                        res = CLS_PortalUtils.setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, 'Application not found');
                    }                                   
                } else {
                    String errorMessage = CLS_PortalAPIConstants.ERROR_MESSAGE_PARAM_NOT_FOUND;
                    //res = setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, errorMessage);
                    res = CLS_PortalUtils.setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, errorMessage);
                }
            } else {
                String errorMessage = CLS_PortalAPIConstants.ERROR_MESSAGE_PARAM_NOT_FOUND;
                //res = setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, errorMessage);
                res = CLS_PortalUtils.setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, errorMessage);
            }
        } catch(Exception e) {                                                                  
                //res = setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, e.getMessage()+' '+e.getStackTraceString());
                res = CLS_PortalUtils.setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, CLS_PortalAPIConstants.ERROR_MESSAGE_SOMETHING_WENT_WRONG);
        }
        return res;
    }
    
    private clcommon.Response setSuccessResponse(List<genesis__Applications__c> AppUpdateList){
        clcommon.Response res = new clcommon.Response();
        //system.debug('--params--'+params);
        genesis__Applications__c app = AppUpdateList[0];
        
        //AppUpdateList[0].Portal_Stage__c = 'Customer_Applies_Approved';
        //appUpdateList[0].genesis__Status__c = 'NEW - ENTERED';
        update AppUpdateList[0];
        system.debug('--app--'+app); 
        Map<String,Object> fields = createResponseMap(app);
        
        List<clcommon.PortalCustomRemoteActionRecord> respList = new List<clcommon.PortalCustomRemoteActionRecord>();
        respList.add(new clcommon.PortalCustomRemoteActionRecord(CLS_PortalAPIConstants.KEY_RESPONSE, fields));
        res = clcommon.PortalActions.getCustomRemoteActionResponse(respList);
        
        if(app.Portal_Stage__c != null &&  app.Portal_Stage__c=='Customer_Applies_Personal_Info'){
            res.status = 'PENDING';
        }
        else{
            res.status = clcommon.Constants.SUCCESS;
        }
        return res;
    }
   
    
    private Map<String,Object> createResponseMap(genesis__Applications__c app){
        Map<String,Object> fields = new Map<String,Object>();
        
        if(app.Portal_Stage__c != null){  /* &&  app.Portal_Stage__c<>'Customer_Applies_Approved'){ */
            fields.put(CLS_PortalAPIConstants.PORTALSTAGE,  app.Portal_Stage__c);
        }
       /* else{
            fields.put(CLS_PortalAPIConstants.PORTALSTAGE,);
        }*/
        system.debug('--fields--'+fields);
        return fields;
    }
    
    private clcommon.Response setResponse(String status, String errorCode, String errorMessage){
        clcommon.Response res = new clcommon.Response();
        res.status = status;
        res.errorCode = errorCode;
        res.errorMessage = errorMessage;
        return res;  
    } 
}