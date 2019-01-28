/**
* The CL_InvokeIntegrations class has future methods
* which are called from Invocable methods by Process Builder
* for KYC and KYB Regulatory Checks
*
* @author  Sridhar M
* @version 1.0
* @since   2019-01-20 
*/

public class CL_InvokeIntegrations {

    /**
    * This method is used for LexisNexisInstaID pull for KYC Check
    * @param applicationId Application record Id passed from Invocable method
    */
    @Future(callout=true)
    public static void invokeLexisNexisInstaIdPull(Id applicationId) {
        system.debug(' Entered into invokeLexisNexisInstaIdPull.. ' );
        
        
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
        borrowerValues1.put('applicationId',appList.get(0).Id);
        //borrowerValues1.addContextParameters('applicationId',app.Id);
        
        ints__Integration_Configuration__c integConfig = [ SELECT id , name ,ints__Integration_Service__c,ints__Type__c
                                                          FROM ints__Integration_Configuration__c
                                                          WHERE ints__Integration_Service__c='ID Verification' 
                                                         ] ;
        system.debug('name ='+integConfig.name);  
        system.debug('borrowerValues1 ='+borrowerValues1);       
        
        ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
        ints.IntegrationResponseObject responseObject =  mc.runPassthroughService(borrowerValues1,integConfig.ints__Integration_Service__c,'');
        system.debug('responseObject.responseStore Map ='+responseObject.responseStore);
        
    }
        
    /**
    * This method is used for TruVue01 pull for KYC Check
    * @param applicationId Application record Id passed from Invocable method
    */    
    @Future(callout=true)
    public static void invokeTruVue01Pull(Id applicationId) {
        system.debug(' Entered into invokeTruVue01Pull.. ' );
        
        
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
        borrowerValues1.put('applicationId',appList.get(0).Id);
        //borrowerValues1.addContextParameters('applicationId',app.Id);
        
        ints__Integration_Configuration__c integConfig = [ SELECT id , name ,ints__Integration_Service__c,ints__Type__c
                                                          FROM ints__Integration_Configuration__c
                                                          WHERE ints__Integration_Service__c='ID Verification Individual' 
                                                         ] ;
        system.debug('name ='+integConfig.name);  
        system.debug('borrowerValues1 ='+borrowerValues1);       
        
        ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
        ints.IntegrationResponseObject responseObject =  mc.runPassthroughService(borrowerValues1,integConfig.ints__Integration_Service__c,'');
        system.debug('responseObject.responseStore Map ='+responseObject.responseStore);
        
    }
    
    
        /**
    * This method is used for LexisNexisBusinessInstaID pull for KYB Check 
    * @param applicationId Application record Id passed from Invocable method
    */
    @Future(callout=true)
    public static void invokeLexisNexisBusinessInstaIdPull(Id applicationId) {
        system.debug(' Entered into invokeLexisNexisBusinessInstaIdPull.. ' );
        
        
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
        borrowerValues1.put('applicationId',appList.get(0).Id);
        //borrowerValues1.addContextParameters('applicationId',app.Id);
        
        ints__Integration_Configuration__c integConfig = [ SELECT id , name ,ints__Integration_Service__c,ints__Type__c
                                                          FROM ints__Integration_Configuration__c
                                                          WHERE ints__Integration_Service__c='Bank Verification' 
                                                         ] ;
        system.debug('name ='+integConfig.name);  
        system.debug('borrowerValues1 ='+borrowerValues1);       
        
        ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
        ints.IntegrationResponseObject responseObject =  mc.runPassthroughService(borrowerValues1,integConfig.ints__Integration_Service__c,'');
        system.debug('responseObject.responseStore Map ='+responseObject.responseStore);
        
    }    

    
    /**
    * This method is used for invokeJourneyOptimizer 
    * @param applicationId Application record Id passed from Invocable method
    */
    @Future(callout=true)
    public static void invokeJourneyOptimizer(Id applicationId) {
        system.debug(' Entered into invokeJourneyOptimizer.. ' );
         List<Id> appId = new List<Id>();
         List<genesis__Applications__c> appList = [SELECT Id, 
                                                  genesis__Loan_Amount__c,
                                                  genesis__Account__c,
                                                  genesis__Status__c,
                                                  KYB_Performed__c,
                                                  KYB_Status__c,
                                                  KYC_Performed__c,
                                                  KYC_Status__c
                                                  FROM genesis__Applications__c
                                                  WHERE Id =:applicationId AND genesis__Valid_Pricing_Flag__c=false];
                                                  
        if(!appList.isEmpty() ){                                        
            appId.add(appList[0].Id);
        
             
             OriginateWorkFlowJrnyOptm invokeJLOPT= new OriginateWorkFlowJrnyOptm(appId);
             ID jobID = System.enqueueJob(invokeJLOPT);
        
        }
    /*    
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
         borrowerValues.put('appId',appList.get(0).Id);
         borrowerValues1.put('InputMap',borrowerValues);
        //borrowerValues1.put('ApplicationId',appList.get(0).Id);
        //borrowerValues1.addContextParameters('applicationId',app.Id);
        
        ints__Integration_Configuration__c integConfig = [ SELECT id , name ,ints__Integration_Service__c,ints__Type__c
                                                          FROM ints__Integration_Configuration__c
                                                          WHERE ints__Integration_Service__c='Journey Optimizer' 
                                                         ] ;
        system.debug('name ='+integConfig.name);  
        system.debug('borrowerValues1 ='+borrowerValues1);       
        
        ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
        ints.IntegrationResponseObject responseObject =  mc.runPassthroughService(borrowerValues1,integConfig.ints__Integration_Service__c,'');
 
        system.debug('responseObject.responseStore Map ='+responseObject.responseStore);
        //system.debug('responseObject.offerDetails Map ='+responseObject.responseStore.get('offer_details'));
        Map<String,object> abc = (Map<String,object>) responseObject.responseStore.get('journeyoptimizerresponsesummary');
        //system.debug('response abc '+abc.get('application_no')); 
        Map<String,object> decisionMap = (Map<String,object>) abc.get('decision');
        Map<String,object> CustomerDataMap = (Map<String,object>) abc.get('customer_data');//customer_data
        Map<String,object> ficoScoreDetailsMap = (Map<String,object>) CustomerDataMap.get('fico_score_details');
        Integer ficoScore = Integer.valueOf(ficoScoreDetailsMap.get('score'));
        String decision_code = (String) decisionMap.get('decision_code');
        //Decision_reasons decision_reasons;
        List<Map<String,object>> offerList = new List<Map<String,object>>();
        String journey_stage= (String) decisionMap.get('journey_stage');
        Map<String,object> offer_detailsMap;
        if(decision_code=='approved' ){
            offer_detailsMap = (Map<String,object>) abc.get('offer_details');
            if(offer_detailsMap<>null && !offer_detailsMap.isEmpty()){ 
                    String Currency_code=(String)offer_detailsMap.get('Currency_code');
                    Map<String,object> offer_validity = (Map<String,object>) offer_detailsMap.get('offer_validity');
                    String dateFormat = (String)offer_validity.get('dateFormat'); 
                    String offerValidTill = (String) offer_validity.get('offerValidTill');
                    List<Object> myMapObjects = (List<Object>) offer_detailsMap.get('offers');
                    for (Object obj : myMapObjects) {
                         offerList.add((Map<String, Object>)obj);
                    }
             }       
         }  
       
        genesis__Application_Pricing_Detail__c pd;
        List<genesis__Application_Pricing_Detail__c> pdList = new List<genesis__Application_Pricing_Detail__c>();
        
        if(offerList<>null && !offerList.isEmpty()){
            for(Map<String,object> obj : offerList){
                pd = new genesis__Application_Pricing_Detail__c();
                Decimal maxAmount = Double.valueOf(obj.get('max_amount'));
                Decimal rate = Double.valueOf(obj.get('rate'));
                Decimal fixedFee =(maxAmount*rate)/100;
                Integer term = Integer.valueOf(obj.get('term'));
                pd.genesis__Term__c = term;
                pd.genesis__Residual_Term__c = term;
                //liability = (String)obj.get('liability');
                pd.genesis__Maximum_Financed_Amount__c = maxAmount;
                pd.Fixed_Fee__c = fixedFee;
                pd.Total_Repayment__c= fixedFee + maxAmount;
                //max_hbr= (String)obj.get('max_hbr');
                pd.genesis__Payment_Frequency__c='Monthly';
                pd.genesis__Payment_Amount_Per_Period__c =  (maxAmount/(term*30)).setScale(2);
                //pd.Offer_Validity__c = 
                //repayment_frequency=(String)obj.get('repayment_frequency');
                pd.Repayment_Method__c=(String)obj.get('repayment_type');
                pd.genesis__Interest_Rate__c = rate;
                pd.genesis__Application__c=applicationId;
                pdList.add(pd);
            }   
        }
        try{
            if(!pdList.isEmpty())
                insert pdList;
            
            genesis__applications__c app = new genesis__applications__c(Id = applicationId);
            app.Decision_Code__c=decision_code;
            app.Fico_Score__c=ficoScore;
            app.Journey_Stage__c=journey_stage;
            update app;     
           }
       catch(Exception e){
           System.debug(e.getMessage() + e.getStackTraceString());
       }*/
       
    }    
}