global without sharing class CLS_ApplicationProcessingInitPortalAPI implements clcommon.PortalCustomRemoteAPI1{
    global clcommon.Response invokeAction(String componentStrName, String[] disclosureNames, Map<String, Object> params) {
        clcommon.Response res;
        try{
            if(params != null){
                system.debug('--params--'+params );
                String uniqueIdentifier = (String)params.get(CLS_PortalAPIConstants.UNIQUE_IDENTIFIER); 
                String DocusignEventStatus = '';
                String ApplicationId = (String)params.get('applicationId'); 
                
                if(params.containsKey('docuSignEvent')){
                    DocusignEventStatus = (String)params.get('docuSignEvent');
                }
                    
                if(!String.isBlank(uniqueIdentifier) && !String.isBlank(ApplicationId)){
                    List<genesis__Applications__c> appList = [SELECT id, 
                                                              Token__c,
                                                              genesis__Status__c,
                                                              
                                                              Portal_Stage__c 
                                                              FROM genesis__Applications__c
                                                              WHERE Token__c = :uniqueIdentifier  
                                                              AND Token__c != null
                                                              AND Id =: ApplicationId
                                                             // AND Is_URL_Used__c = False
                                                              ORDER BY CreatedDate asc limit 1];   
                    if(appList != null 
                        && appList.size() > 0 
                        && DocusignEventStatus != null
                        && DocusignEventStatus != ''){
                        
                        res = setSuccessResponse(appList[0],DocusignEventStatus); 
                    } else {
                        res = setLoadSuccessResponse(appList[0]);
                    }
                    
                    /*else if(appList != null 
                        && appList.size() > 0 
                        && String.IsBlank(DocusignEventStatus)){
                        res = setLoadSuccessResponse(appList[0]);
                        
                    } else {
                        res = setErrorResponse(appList[0]);
                    }  */                             
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
    private clcommon.Response setSuccessResponse(genesis__Applications__c app, String DocusignEventStatus){
        clcommon.Response res = new clcommon.Response();
        system.debug('--app--'+app);
        if(DocusignEventStatus.equalsIgnorecase('signing_complete')){
           /* if(app.genesis__Status__c.equalsignoreCase(CLS_Webster_Constants.INCOME_VERIFICATION_4506T_NEEDED))
              app.Portal_Stage__c = 'webster_docusign_signed'; */
       }else if(!DocusignEventStatus.equalsIgnorecase('signing_complete') && !DocusignEventStatus.equalsIgnorecase('') ){
          app.Portal_Stage__c = 'Customer_Applies_Denied';  
        }
        //app.Is_URL_Used__c = True;
        update app;
        Map<String,Object> fields;
        
        fields = createResponseMap(app);    
        List<clcommon.PortalCustomRemoteActionRecord> respList = new List<clcommon.PortalCustomRemoteActionRecord>();
        respList.add(new clcommon.PortalCustomRemoteActionRecord(CLS_PortalAPIConstants.KEY_RESPONSE, fields));
        res = clcommon.PortalActions.getCustomRemoteActionResponse(respList);
        res.status = clcommon.Constants.SUCCESS;
        return res;
    }
    private clcommon.Response setErrorResponse(genesis__Applications__c app){
        clcommon.Response res = new clcommon.Response();
        system.debug('--app--'+app);
        app.Portal_Stage__c = 'webster_session_timedOut';
        update app;
        
        Map<String,Object> fields;
        
        fields = createResponseMap(app);
         
        List<clcommon.PortalCustomRemoteActionRecord> respList = new List<clcommon.PortalCustomRemoteActionRecord>();
        respList.add(new clcommon.PortalCustomRemoteActionRecord(CLS_PortalAPIConstants.KEY_RESPONSE, fields));
        res = clcommon.PortalActions.getCustomRemoteActionResponse(respList);
        res.status = clcommon.Constants.SUCCESS;
        return res;
    }
    private clcommon.Response setLoadSuccessResponse(genesis__Applications__c app){
        clcommon.Response res = new clcommon.Response();
        system.debug('--app--'+app);
      //  app.Is_URL_Used__c = True;
        update app;
        
        Map<String,Object> fields;
        fields = createResponseMap(app);
         
        List<clcommon.PortalCustomRemoteActionRecord> respList = new List<clcommon.PortalCustomRemoteActionRecord>();
        respList.add(new clcommon.PortalCustomRemoteActionRecord(CLS_PortalAPIConstants.KEY_RESPONSE, fields));
        res = clcommon.PortalActions.getCustomRemoteActionResponse(respList);
        res.status = clcommon.Constants.SUCCESS;
        return res;
    }
    private Map<String,Object> createResponseMap(genesis__Applications__c app){
       Map<String,Object> fields = new Map<String,Object>();
        
       if(app.Portal_Stage__c != null){
        fields.put(CLS_PortalAPIConstants.PORTALSTAGE, app.Portal_Stage__c);
        }
        system.debug('--fields--'+fields);
        return fields;
    }
}