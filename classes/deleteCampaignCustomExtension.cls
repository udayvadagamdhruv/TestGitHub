/* Extension class to Delete Campaign */

public with sharing class deleteCampaignCustomExtension 
{
  
    /* Global Variables*/
    private final Campaign__c objCampaign;
    public String oId{get;set;}
    public Boolean isError{get;set;}
  //  String strCampId;
 //   public Campaign__c Camp;
    /* End of Global Variables*/
    
    /* Standard Controller Constructor*/
    public deleteCampaignCustomExtension(ApexPages.StandardController con) 
    {
        isError = False;
        this.objCampaign=(Campaign__c)con.getrecord();
        
        Schema.DescribeSObjectResult r1 = Campaign__c.sObjectType.getDescribe();
        oId = r1.getKeyPrefix();
   //     Camp= [select id,Name from Campaign__c where id =: objCampaign.id];
    //    strCampId = Camp.id;
       // System.Debug('Camp '+objCampaign);
    }
    /* End of Standard Controller Constructor */
    
    /* Method called on to Delete Extension */
     public PageReference checkDelete()
     {
    //   Campaign__c objCamp = [select id,Name from Campaign__c where id =: strCampId]; 
        try
        {
            Database.delete(objCampaign);  
          
        }
        catch(System.DMLException e)
        {
            isError = True;
            return null;
        }
        
        /* After deletion Navigate to Campaign Tab */
     /*   if(!isPageLoad)
        {
        PageReference p =  new Pagereference('/apex/AdminListView?intFocus=7');
        p.setRedirect(true);
        return p;
        } */
           //PageReference p =  new Pagereference('/apex/CampaignTabOverride');
            Schema.DescribeSObjectResult r = Campaign__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            PageReference p =  new Pagereference('/'+keyPrefix);
            p.setRedirect(true);
            return p;
     }
     // End of Delete Method
     
  /* Start Test Coverage Code */
   static testMethod void Test_deleteCampaignCustomExtension()
      {
          
          Job_Number_Setting__c customSetting2902 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting2902;
      
          Media_Type__c testMedia=new Media_Type__c(Name='MT2902');
              insert testMedia;
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST2902',Media_Types__c=testMedia.Id);
              insert testST;
          
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT2902');
              insert testSpec;
        
          Campaign__c testCampaign1=new Campaign__c(Name='C2902',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=0);
              insert testCampaign1;
         
          Account a=new Account(Name='Account2902');
              insert a;
         
          Contact c=new Contact(FirstName='Contact2902',LastName='LN2902',AccountId=a.id,Email='testC2902@SFDC.com');
              insert c;
                
          Job__c testJob1=new Job__c(Name='Job2902',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,Client__c=a.id,Client_Contact__c=c.id);
           try
            {
                insert testJob1;
            }
           catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
          System.assertEquals('Job2902',testJob1.Name);  
      
           
          Campaign__c testCamp=new Campaign__c(Name='TC009');
        
                 insert testCamp;
             
         System.assertEquals('TC009',testCamp.Name);
         
         
         Campaign__c testCamp2=new Campaign__c(Name='TC009');
           try
            {
                insert testCamp2;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
         
         ApexPages.CurrentPage().getParameters().put('id',testCamp.id);
             
          /* Instantiate the standard controller with the Campaign */
         ApexPages.StandardController con=new ApexPages.StandardController(testCamp);
        
         /* Instantiate the extention instance with the standardcontroller */
         deleteCampaignCustomExtension ext=new deleteCampaignCustomExtension(con);
        // ext.strCampId = testCamp.id;
         /* Invoke the primary method on the extension */
         ApexPages.PageReference result=ext.CheckDelete();
        
          /* Below code covers the Catch statement */
         result=ext.CheckDelete();
         
         
         
          ApexPages.CurrentPage().getParameters().put('id',testCampaign1.id);
             
          /* Instantiate the standard controller with the Campaign */
         ApexPages.StandardController con1=new ApexPages.StandardController(testCampaign1);
        
         /* Instantiate the extention instance with the standardcontroller */
         deleteCampaignCustomExtension ext1=new deleteCampaignCustomExtension(con1);
        // ext.strCampId = testCamp.id;
         /* Invoke the primary method on the extension */
         ApexPages.PageReference result1=ext1.CheckDelete();
        
          /* Below code covers the Catch statement */
         result1=ext1.CheckDelete();
         
      }
    /* End of Test Coverage */
}
/* ENd of Class */