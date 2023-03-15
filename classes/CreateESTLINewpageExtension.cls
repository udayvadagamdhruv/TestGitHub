public with sharing class CreateESTLINewpageExtension 
{
     // Start Global variables
  /*
    private final Estimate_Template_Line_Items__c pest;
    public  Estimate_Template__c abc;
    public String qid{get;set;}
    public String orgId{get; set;}
    // End of Global variables
   
   // Start of Constructor
     public CreateESTLINewpageExtension(ApexPages.StandardController controller) 
     {
         
          this.pest=(Estimate_Template_Line_Items__c)controller.getRecord();
          qid=pest.Estimate_Template__c;
          //abc=new Estimate_Template__c();
          abc = [select id,name from Estimate_Template__c where id =: qid];

          pest.Estimate_Template__c=qid;
   
          orgId = UserInfo.getOrganizationId();
          system.debug('org id --------->'+orgId);
     }
   //End of Constructor 
   
 
   
   
    
   // Save method
    public PageReference saveme() 
    { 
       string strEstimateId;
     
         try
         { 
         //    pest.Material_Item__c=MIName;
             
             insert pest;
             strEstimateId = pest.Estimate_Template__c;
             
         }
       
        catch(System.DMLException e)
        {
               return null;
        }
        
      PageReference pageref =  new Pagereference('/'+strEstimateId);
      pageRef.setRedirect(true);
      return pageRef;
   } */
  // End of Save Method 

}