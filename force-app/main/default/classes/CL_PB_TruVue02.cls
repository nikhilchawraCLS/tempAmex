/**
* The CL_PB_TruVue02 class has a method with
* @Invocable annotation which is called from Process Builder
* for TruVue02 KYB Check
*
* @author  Sridhar M
* @version 1.0
* @since   2019-01-20
*/

global class CL_PB_TruVue02{
   
    /**
    * This method is used to call the future method from CL_InvokeIntegrations class 
    * for TruVue02 KYB pull, evaluate the Rules configured and update fields accordingly.
    * @param app The genesis__Applications__c record passed from Process Builder.
    */
    @InvocableMethod
    global static void cl_pb_truVue02Check(List<genesis__Applications__c> app){
        
        List<genesis__Applications__c> updateApp = new List<genesis__Applications__c>();

        //Calling the invokeTruVue02Pull future method for TruVue01 KYC Pull
        //CL_InvokeIntegrations.invokeTruVue01Pull(app[0].Id);
        
        //Querying the KYB_Rules_on_TruVue02_Response rule and evaluating it
        Map<Id, genesis__Rule__c> mapRules = new Map<Id, genesis__Rule__c>([SELECT Id,
                                                                                   Name,        
                                                                                   genesis__Message_failure__c
                                                                              FROM genesis__Rule__C
                                                                             WHERE Name = :Label.KYB_Rules_on_TruVue02_Response
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
            
        System.debug('CLS_TruVue02 Rule Result = '+result);
            
        //Updating the field values based on Rule evaluation
        if(!String.isBlank(result)){
            genesis__Applications__c application = new genesis__Applications__c(Id=app[0].Id);        
            application.genesis__Status__c = 'Regulatory Checks Completed';
            application.KYB_Performed__c = TRUE;
            application.KYB_Status__c = 'Failed';

            updateApp.add(application);
        }
        else{
            genesis__Applications__c application = new genesis__Applications__c(Id=app[0].Id);        
            application.genesis__Status__c = 'Regulatory Checks Completed';
            application.KYB_Performed__c = TRUE;
            application.KYB_Status__c = 'Passed';

            updateApp.add(application);
        }          
        
        if(updateApp != null && updateApp.size() > 0){
            update updateApp;
        }
    }
}