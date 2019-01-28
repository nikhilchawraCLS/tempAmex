/**
* The CLS_LexisNexisBusinessInstaID class has a method with
* @Invocable annotation which is called from Process Builder
* for LexisNexis Business InstaID KYB Check
*
* @author  Sridhar M
* @version 1.0
* @since   2019-01-20 
*/

global class CL_PB_LexisNexisBusinessInstaID{

    /**
    * This method is used to call the future method from CL_InvokeIntegrations class 
    * for Business InstaID pull, evaluate the Rules configured and update fields accordingly.
    * @param app The genesis__Applications__c record passed from Process Builder.
    */
    @InvocableMethod
    global static void cl_pb_businessInstaIDCheck(List<genesis__Applications__c> app){
    
        List<genesis__Applications__c> updateApp = new List<genesis__Applications__c>();    
        List<genesis__Applications__c> appList = [SELECT Id, 
                                                         genesis__Loan_Amount__c,
                                                         genesis__Status__c,
                                                         genesis__Account__c,
                                                         genesis__Account__r.Corporate_Structure__c,
                                                         KYB_Performed__c,
                                                         KYB_Status__c,
                                                         KYC_Performed__c,
                                                         KYC_Status__c
                                                    FROM genesis__Applications__c
                                                   WHERE Id=:app[0].Id];
                                                   
        //Calling the invokeLexisNexisBusinessInstaIdPull future method for BusinessInstaID Pull
        CL_InvokeIntegrations.invokeLexisNexisBusinessInstaIdPull(app[0].Id);
                
        //If the Corporate Structure is Sole Prop, Run the POO Check Rules, 
        //else Run the KYB rules on LexisNexis BusinessInstaID's Response
        if(appList[0].genesis__Account__r.Corporate_Structure__c == 'Sole Prop'){
            
            //Querying the POO_Checks_on_BusinessInstaID rule and evaluating it        
            Map<Id, genesis__Rule__c> mapPOORules = new Map<Id, genesis__Rule__c>([SELECT Id,
                                                                                          Name,        
                                                                                          genesis__Message_failure__c
                                                                                     FROM genesis__Rule__C
                                                                                    WHERE Name = :Label.POO_Checks_on_BusinessInstaID
                                                                                      AND genesis__Enabled__c = true
                                                                                  ]);                
            List<genesis__Checklist__c> checkList_POO = genesis.RulesAPI.evaluateRules(appList[0], mapPOORules.values(), false, false);
            System.debug('checkList_POO = '+checkList_POO);
            
            String resultPOO = '';
            for(genesis__Checklist__c checklistObj: checkList_POO){
                if(!checklistObj.genesis__Result__c){
                    resultPOO += mapPOORules.get(checklistObj.genesis__Rule__c).genesis__Message_failure__c + '\r\n';
                }
            }          
            System.debug('CLS_LexisNexisBusinessInstaID POO Rule Result = '+resultPOO);
                  
            if(!String.isBlank(resultPOO)){ 
                genesis__Applications__c application = new genesis__Applications__c(Id=appList[0].Id);
                application.genesis__Status__c = 'Regulatory Checks Completed';
                application.KYB_Performed__c = TRUE;
                application.POO_Status__c = 'Failed';
                updateApp.add(application);
            }
            else{
                genesis__Applications__c application = new genesis__Applications__c(Id=appList[0].Id);
                application.genesis__Status__c = 'Regulatory Checks Completed';                
                application.KYB_Performed__c = TRUE;
                application.POO_Status__c = 'Passed';
                updateApp.add(application);
            }             
        }
        else{
            //Evaluate the KYB rules on LexisNexis BusinessInstaID's Response
            Map<Id, genesis__Rule__c> mapRules = new Map<Id, genesis__Rule__c>([SELECT Id,
                                                                                          Name,        
                                                                                          genesis__Message_failure__c
                                                                                     FROM genesis__Rule__C
                                                                                    WHERE Name = :Label.KYB_Rules_on_LexisNexis_Response
                                                                                      AND genesis__Enabled__c = true
                                                                                  ]);                
            List<genesis__Checklist__c> checkList_KYB = genesis.RulesAPI.evaluateRules(appList[0], mapRules.values(), false, false);
            System.debug('checkList_KYB = '+checkList_KYB);
            
            String result = '';
            for(genesis__Checklist__c checklistObj: checkList_KYB){
                if(!checklistObj.genesis__Result__c){
                    result += mapRules.get(checklistObj.genesis__Rule__c).genesis__Message_failure__c + '\r\n';
                }
            }          
            System.debug('CLS_LexisNexisBusinessInstaID KYB Rule Result = '+result);
              System.debug('ENterign after result..');          
            if(!String.isBlank(result)){ 
                          System.debug('ENterign Failed scenerio..');          
                genesis__Applications__c application = new genesis__Applications__c(Id=appList[0].Id);            
                application.genesis__Status__c = 'Lexis Nexis - Business InstaID - Failed';
                application.KYB_Performed__c = TRUE;
                application.KYB_Status__c = 'Failed';
    
                updateApp.add(application);
            }
            else{
            System.debug('ENterign Success scenerio..'); 
                genesis__Applications__c application = new genesis__Applications__c(Id=appList[0].Id);            
                application.genesis__Status__c = 'Regulatory Checks Completed';    //'Lexis Nexis - Business InstaID - Passed';
                application.KYB_Performed__c = TRUE;
                application.KYB_Status__c = 'Passed';

                updateApp.add(application);
            }                     
        }
        
        if(updateApp != null && updateApp.size() > 0){
            update updateApp;
        }
    }
}