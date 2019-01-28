global without sharing class CL_Document_Portal implements clcommon.PortalCustomRemoteAPI1{
    
    global clcommon.Response invokeAction(String componentStrName, String[] disclosureNames, Map<String, Object> params) {
        clcommon.Response res;
        system.debug('CL_Document_Portal '); //Category attachment Association
        try{
           if(params != null){
               system.debug('--params--'+params );
              // String uniqueIdentifier = (String)params.get(CLS_PortalAPIConstants.UNIQUE_IDENTIFIER); 
               String AttachmentId =(String) params.get('attachmentId');
               String docId =(String) params.get('documentId');
               //List<clcommon__Applications__c> AppUpdateList = (List<clcommon__Applications__c>) JSON.deserialize(AppValues, List<clcommon__Applications__c>.class);
               //system.debug('appUpdateList'+appUpdateList);
               if(true){
                    List<clcommon__Document_Category__c> appDocList = [SELECT id,
                                                                    Name,
                                                                    clcommon__Active__c,
                                                                    clcommon__Priority__c,
                                                                    clcommon__Required__c,
                                                                    clcommon__Status__c,
                                                                    clcommon__Document_Definition__c
                                                               FROM clcommon__Document_Category__c
                                                               WHERE id = :docId
                                                            ORDER BY CreatedDate desc limit 1];
                    system.debug('--appDocList --'+appDocList );  
                    
                                                      
                    if(appDocList != null && appDocList .size() > 0){
                            res = setSuccessResponse(appDocList, AttachmentId );
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
    
    private clcommon.Response setSuccessResponse(List<clcommon__Document_Category__c> appDocList, String AttachmentId ){
        clcommon.Response res = new clcommon.Response();
        //system.debug('--params--'+params);
        clcommon__Document_Category__c appDoc = appDocList[0];
        appDoc.clcommon__Status__c='SUBMITTED';
        update appdoc;
        
        clcommon__Category_Attachment_Association__c caa = new clcommon__Category_Attachment_Association__c(clcommon__Attachment_Id__c = AttachmentId,
                                                                                                            clcommon__Document_Category__c = appDoc.Id);
                                                                                                            
        insert caa;                                                                                                   
        
        Map<String,Object> fields = createResponseMap(appDoc);
        
        List<clcommon.PortalCustomRemoteActionRecord> respList = new List<clcommon.PortalCustomRemoteActionRecord>();
        respList.add(new clcommon.PortalCustomRemoteActionRecord(CLS_PortalAPIConstants.KEY_RESPONSE, fields));
        res = clcommon.PortalActions.getCustomRemoteActionResponse(respList);
        res.status = clcommon.Constants.SUCCESS; 
        return res;
    }
   
   private Map<String,Object> createResponseMap(clcommon__Document_Category__c appDoc){
        Map<String,Object> fields = new Map<String,Object>();
        
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