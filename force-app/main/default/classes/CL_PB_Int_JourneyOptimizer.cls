global class CL_PB_Int_JourneyOptimizer {
    
    /**
    * This method is used to call the future method from CL_InvokeIntegrations class 
    * for InstaID pull, evaluate the Rules configured and update fields accordingly.
    * @param app The genesis__Applications__c record passed from Process Builder.
    */
    @InvocableMethod
    global static void CL_PB_Int_JourneyOptimizer(List<genesis__Applications__c> app){
        
        List<genesis__Applications__c> updateApp = new List<genesis__Applications__c>();

        //Calling the invokeLexisNexisInstaIdPull future method for InstaID Pull
        CL_InvokeIntegrations.invokeJourneyOptimizer(app[0].Id);
        
        //Querying the KYC_Rules_on_LexisNexis_Response rule and evaluating it
      /*  Map<Id, genesis__Rule__c> mapRules = new Map<Id, genesis__Rule__c>([SELECT Id,
                                                                                   Name,        
                                                                                   genesis__Message_failure__c
                                                                              FROM genesis__Rule__C
                                                                             WHERE Name = :Label.KYC_Rules_on_LexisNexis_Response
                                                                               AND genesis__Enabled__c = true
                                                                           ]);
                                                                           
        List<genesis__Checklist__c> checkList = genesis.RulesAPI.evaluateRules(app[0], mapRules.values(), false, false);
        System.debug('Checklist = '+checkList);
            
        String result = '';
        for(genesis__Checklist__c checklistObj: checkList){
            if(!checklistObj.genesis__Result__c){
                result += mapRules.get(checklistObj.genesis__Rule__c).genesis__Message_failure__c + '\r\n';
            }
        }          
            
        System.debug('CLS_LexisNexisInstaID Rule Result = '+result);
            
        //Updating the field values based on Rule evaluation
        if(!String.isBlank(result)){
            genesis__Applications__c application = new genesis__Applications__c(Id=app[0].Id);
            application.genesis__Status__c = 'Lexis Nexis - InstaID - Failed';
            //app.KYC_Performed__c = TRUE;
            //app.KYC_Status__c = 'Failed';

            updateApp.add(application);
        }
        else{
            genesis__Applications__c application = new genesis__Applications__c(Id=app[0].Id);        
            application.genesis__Status__c = 'Lexis Nexis - InstaID - Passed';
            application.KYC_Performed__c = TRUE;
            application.KYC_Status__c = 'Passed';

            updateApp.add(application);
        }          
        
        if(updateApp != null && updateApp.size() > 0){
            update updateApp;
        }
        */
    }
    
   
}