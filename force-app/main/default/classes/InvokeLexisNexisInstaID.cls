public class InvokeLexisNexisInstaID {
@Future(callout=true)
    public static void invokeLexisNexisCreditPull(Id applicationId) {
        system.debug(' Entered into invokeLexisNexisCreditPull with param size = ' );
        
        
        List<genesis__Applications__c> appList = [SELECT Id, 
                                                  genesis__Loan_Amount__c,
                                                  genesis__Account__c,
                                                  genesis__Status__c,
                                                  KYB_Performed__c,
                                                  KYB_Status__c,
                                                  KYC_Performed__c,
                                                  KYC_Status__c
                                                  FROM genesis__Applications__c
                                                  WHERE Id =:applicationId];
        
        //CreditCheckRequest request = new CreditCheckRequest();
        //request.retrieveFromDatabase = false;            
        Map<String,Object> borrowerValues = new Map<String,Object>();
        Map<String,Object> borrowerValues1 = new Map<String,Object>();
        borrowerValues.put('borrowerId',appList.get(0).genesis__Account__c);
        borrowerValues1.put('InputMap',borrowerValues);
        //borrowerValues1.addContextParameters('applicationId',app.Id);
        
        ints__Integration_Configuration__c integConfig = [ SELECT id , name ,ints__Integration_Service__c,ints__Type__c
                                                          FROM ints__Integration_Configuration__c
                                                          WHERE ints__Integration_Service__c='Credit Check' ] ;
        system.debug('name ='+integConfig.name);  
        system.debug('borrowerValues1 ='+borrowerValues1);       
        
        ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
        ints.IntegrationResponseObject responseObject =  mc.runPassthroughService(borrowerValues1,integConfig.ints__Integration_Service__c,'');
        system.debug('responseObject.responseStore Map ='+responseObject.responseStore);
        
        }

}