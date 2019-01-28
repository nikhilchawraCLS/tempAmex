global without sharing class CLS_DocVerification implements clcommon.PortalCustomRemoteAPI1{
   
    global clcommon.Response invokeAction(String componentStrName, String[] disclosureNames, Map<String, Object> params) {
        clcommon.Response res;
        try{
            if(params != null){
                system.debug('--params--'+params );
                String AppId = (String) params.get('applicationId');
                //String SelectedOfferId = (String) params.get('SelectedPaymentPlan');
                //String uniqueIdentifier = (String)params.get(CLS_PortalAPIConstants.UNIQUE_IDENTIFIER); 
                if(true){
                    List<genesis__Applications__c> appList = [SELECT id 
                                                              FROM genesis__Applications__c
                                                              WHERE id = : AppId  
                                                              ORDER BY CreatedDate asc limit 1];   
                    if(appList != null && appList.size() > 0){
                        res = setSuccessResponse(appList);
                    } else {
                        res = CLS_PortalUtils.setResponse(clcommon.Constants.ERROR, clcommon.Constants.API_EXCEPTION, 'Contract not found');
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
    private clcommon.Response setSuccessResponse( List<genesis__Applications__c> AppUpdateList){
        clcommon.Response res = new clcommon.Response();
        system.debug('--AppUpdateList--'+AppUpdateList);
       
        //AppUpdateList[0].genesis__Status__c = 'Offer Accepted';
        AppUpdateList[0].Portal_Stage__c = 'docusign_signed';
        update appUpdateList[0];
                                                                 

        Map<String,Object> fields = createResponseMap(appUpdateList[0]);
        
        List<clcommon.PortalCustomRemoteActionRecord> respList = new List<clcommon.PortalCustomRemoteActionRecord>();
        respList.add(new clcommon.PortalCustomRemoteActionRecord(CLS_PortalAPIConstants.KEY_RESPONSE, fields));
        res = clcommon.PortalActions.getCustomRemoteActionResponse(respList);
        res.status = clcommon.Constants.SUCCESS;
        return res;
    }
    
    private Map<String,Object> createResponseMap(genesis__Applications__c app){
        Map<String,Object> fields = new Map<String,Object>();
        //List<ContentDocumentLink> contentDoc = [Select id, ContentDocumentId, ContentDocument.LatestPublishedVersionId from ContentDocumentLink where LinkedEntityId = :app.Id limit 1];
        Attachment attachTest = [select id from Attachment where name ='testingDoc.pdf' limit 1];
        if(app.Portal_Stage__c != null){
            fields.put(CLS_PortalAPIConstants.PORTALSTAGE, app.Portal_Stage__c);
            //if(!attachTest)
                fields.put('AttachedDoc',attachTest.Id);
        }
        system.debug('--fields--'+fields);
        return fields;
    }
}