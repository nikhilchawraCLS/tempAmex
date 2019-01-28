global without sharing class CLS_OfferAcceptportalAPI  implements clcommon.PortalCustomRemoteAPI1{
   
    global clcommon.Response invokeAction(String componentStrName, String[] disclosureNames, Map<String, Object> params) {
        clcommon.Response res;
        
        try{
            if(params != null){
                system.debug('--params--'+params );
                String AppId = (String) params.get('applicationId');
                String SelectedOfferId = (String) params.get('SelectedPaymentPlan');
                //String uniqueIdentifier = (String)params.get(CLS_PortalAPIConstants.UNIQUE_IDENTIFIER); 
                if(true){
                    List<genesis__Applications__c> appList = [SELECT id 
                                                              FROM genesis__Applications__c
                                                              WHERE id = : AppId  
                                                              ORDER BY CreatedDate asc limit 1];   
                    if(appList != null && appList.size() > 0){
                        res = setSuccessResponse(appList,SelectedOfferId);
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
    private clcommon.Response setSuccessResponse( List<genesis__Applications__c> AppUpdateList, String SelectedOfferId){
        clcommon.Response res = new clcommon.Response();
        system.debug('--AppUpdateList--'+AppUpdateList);
        List<genesis__Application_Pricing_Detail__c> SelectPricingList = [SELECT id, Name, genesis__Application__c, genesis__Selected__c 
                                                                    FROM genesis__Application_Pricing_Detail__c
                                                                   WHERE Id= :SelectedOfferId  limit 1];
          
        AppUpdateList[0].genesis__Status__c = 'Approved - Offer Accepted';
        AppUpdateList[0].Portal_Stage__c = 'close_deal';
        update appUpdateList[0];
                                                                 
        if(!SelectPricingList.IsEmpty()){
            SelectPricingList[0].genesis__Selected__c=true;
            update SelectPricingList[0];
        }
        
        List<genesis__Application_Pricing_Detail__c> uncheckExistingPricing = new List<genesis__Application_Pricing_Detail__c>();
        List<genesis__Application_Pricing_Detail__c> NonSelectedPricingList = [SELECT id, Name, genesis__Application__c, genesis__Selected__c 
                                                                    FROM genesis__Application_Pricing_Detail__c
                                                                   WHERE genesis__Application__c = :appUpdateList[0].Id
                                                                         AND Id != :SelectedOfferId];
        
        for(genesis__Application_Pricing_Detail__c pricing : NonSelectedPricingList ){
            pricing.genesis__selected__c =false;
            uncheckExistingPricing.add(pricing);
        }   
        
        if(!uncheckExistingPricing.isEmpty())
            update uncheckExistingPricing;                                                         
        
        Map<String,Object> fields = createResponseMap(appUpdateList[0]);
        
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