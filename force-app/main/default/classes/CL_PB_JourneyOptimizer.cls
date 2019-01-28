global class CL_PB_JourneyOptimizer{

    @InvocableMethod
    global static void cl_pb_journeyOptimizerCheck(List<Id> appId){
    
        List<genesis__Applications__c> updateApp = new List<genesis__Applications__c>();
        List<genesis__Applications__c> appList = [SELECT Id, 
                                                         genesis__Loan_Amount__c,
                                                         genesis__Status__c,
                                                         KYB_Performed__c,
                                                         KYB_Status__c,
                                                         KYC_Performed__c,
                                                         KYC_Status__c
                                                    FROM genesis__Applications__c
                                                   WHERE Id IN :appId];
                                                       
        Map<Id, genesis__Rule__c> mapRules = new Map<Id, genesis__Rule__c>([SELECT Id,
                                                                                   Name,        
                                                                                   genesis__Message_failure__c
                                                                              FROM genesis__Rule__C
                                                                             WHERE Name = :Label.CL_Journey_Optimizer_Checks
                                                                               AND genesis__Enabled__c = true
                                                                           ]);
                                                                           
        for(genesis__Applications__c app : appList){
          List<genesis__Checklist__c> checkList = genesis.RulesAPI.evaluateRules(app, mapRules.values(), false, false);

            String result = '';
            for(genesis__Checklist__c checklistObj: checkList){
                if(!checklistObj.genesis__Result__c){
                    result += mapRules.get(checklistObj.genesis__Rule__c).genesis__Message_failure__c + '\r\n';
                }
            }          
            
            System.debug('CL Journey Optimizer Rule Result = '+result);
            if(!String.isBlank(result)){    //if(app.genesis__Loan_Amount__c < 2000){
                app.genesis__Status__c = 'Document Submission Required';
                
                updateApp.add(app);
             }
             else{


             }          
        }
        update updateApp;
    }
}