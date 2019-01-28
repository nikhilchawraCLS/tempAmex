global class CL_PB_CreditOutcomes{  
    
    @InvocableMethod 
    global static void cl_pb_creditOutcome(List<genesis__Applications__c> app){
        CL_InvokeIntegrations.invokeJourneyOptimizer(app[0].Id);
        List<genesis__Applications__c> updateApp = new List<genesis__Applications__c>();
        /*testing
        *Rules for Denied
        */
        Map<Id, genesis__Rule__c> mapRulesCredit_Outcome_Denied = new Map<Id, genesis__Rule__c>([SELECT Id,
                                                                                   Name,        
                                                                                   genesis__Message_failure__c
                                                                              FROM genesis__Rule__C
                                                                             WHERE Name = :Label.Credit_Outcome_Denied
                                                                                AND genesis__Enabled__c = true
                                                                           ]);
                                                                           
        List<genesis__Checklist__c> checkList = genesis.RulesAPI.evaluateRules(app[0], mapRulesCredit_Outcome_Denied.values(), false, false);
        System.debug('Checklist = '+checkList);
            
        String resultCredit_Outcome_Denied = '';
        for(genesis__Checklist__c checklistObj: checkList){
            if(!checklistObj.genesis__Result__c){
                resultCredit_Outcome_Denied += mapRulesCredit_Outcome_Denied.get(checklistObj.genesis__Rule__c).genesis__Message_failure__c + '\r\n';
            }
        }          
            
        System.debug('resultCredit_Outcome_Denied = '+resultCredit_Outcome_Denied);
        /*
        *Rules for Non Instant
        */
        Map<Id, genesis__Rule__c> mapRulesCredit_Outcome_Non_Instant = new Map<Id, genesis__Rule__c>([SELECT Id,
                                                                                   Name,        
                                                                                   genesis__Message_failure__c
                                                                              FROM genesis__Rule__C
                                                                             WHERE Name = :Label.Credit_Outcome_Non_Instant
                                                                               AND genesis__Enabled__c = true
                                                                           ]);
                                                                           
        List<genesis__Checklist__c> checkList1 = genesis.RulesAPI.evaluateRules(app[0], mapRulesCredit_Outcome_Non_Instant.values(), false, false);
       // System.debug('Checklist = '+checkList1);
            
        String resultCredit_Outcome_Non_Instant = '';
        for(genesis__Checklist__c checklistObj: checkList1){
            if(!checklistObj.genesis__Result__c){
                resultCredit_Outcome_Non_Instant += mapRulesCredit_Outcome_Non_Instant.get(checklistObj.genesis__Rule__c).genesis__Message_failure__c + '\r\n';
            }
        }          
            
        System.debug('resultCredit_Outcome_Non_Instant = '+resultCredit_Outcome_Non_Instant); 
        /*
        *Rules for Offers
        */
        Map<Id, genesis__Rule__c> mapRulesCredit_Outcome_Offers = new Map<Id, genesis__Rule__c>([SELECT Id,
                                                                                   Name,        
                                                                                   genesis__Message_failure__c
                                                                              FROM genesis__Rule__C
                                                                             WHERE Name = :Label.Credit_Outcome_Offers
                                                                               AND genesis__Enabled__c = true
                                                                           ]);
                                                                           
        List<genesis__Checklist__c> checkList2 = genesis.RulesAPI.evaluateRules(app[0], mapRulesCredit_Outcome_Offers .values(), false, false);
       // System.debug('Checklist = '+checkList2);
            
        String resultCredit_Outcome_Offers = '';
        for(genesis__Checklist__c checklistObj: checkList2){
            if(!checklistObj.genesis__Result__c){
                resultCredit_Outcome_Offers += mapRulesCredit_Outcome_Offers.get(checklistObj.genesis__Rule__c).genesis__Message_failure__c + '\r\n';
            }
        }          
            
        System.debug('resultCredit_Outcome_Offers = '+resultCredit_Outcome_Offers);   
        
        //Updating the field values based on Rule evaluationtest
        if(String.isBlank(resultCredit_Outcome_Offers)){
            
            genesis__Applications__c application = new genesis__Applications__c(Id=app[0].Id);  
            System.debug('before rating = '+ application );
           // genesis.SkuidPricingCtrl.generatePricing(app[0].Id);
            application.genesis__Status__c = 'Approved - Offer Generated';
            application.portal_stage__c = 'Customer_Applies_Approved';
            System.debug('after rating = '+ application );
            updateApp.add(application);
        }
        if(String.isBlank(resultCredit_Outcome_Non_Instant)){
            Group docReview = [select Id from Group where  Type = 'Queue' AND NAME = 'Document Review' Limit 1];
            genesis__Applications__c application = new genesis__Applications__c(Id=app[0].Id);        
            application.genesis__Status__c = 'Pending - Document Review'; 
            application.portal_stage__c = 'DocumentUplaod';
            application.OwnerId = docReview.id;
            System.debug('resultCredit_Outcome_Non_Instant '+ application );

            updateApp.add(application);
        }
        if(String.isBlank(resultCredit_Outcome_Denied)){
            genesis__Applications__c application = new genesis__Applications__c(Id=app[0].Id);        
            application.genesis__Status__c = 'Denied';
            application.portal_stage__c = 'Customer_Applies_Denied';
            System.debug('resultCredit_Outcome_Denied '+ application );
 
            updateApp.add(application);
        }
        
        if(updateApp != null && updateApp.size() > 0){
            update updateApp;
        }
    }
}