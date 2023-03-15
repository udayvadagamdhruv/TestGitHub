// Extension class to Create New Tag under Job Tab 
public with sharing class CreateNewTagExtensions
{
  /*  // Global Variables 
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     } 
  
    public Id jobId{get;set;}
    private final Tag__c objTag;
    // End of Global variables
    
    // Standard Controller Constructor 
    public CreateNewTagExtensions(ApexPages.StandardController controller) 
    {   
        this.objTag = (Tag__c)controller.getRecord();    
        jobId=ApexPages.CurrentPage().getParameters().get('jobId');
        objTag.Job__c = jobId;
    }
    // End Of Standard Controller Constructor 

    // Method called on to Create New Tag 
    Public PageReference saveme()
    {
       try
       {
           insert objTag;
       }
       catch(DMLException e)
       {
           return null;
       } 
               
        PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=Tag');
        }
        else
        {
             p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=9');
        }
       
       
      //  PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
        p.setRedirect(true);
        return p;
    }
    // End of Save method 
    
    // Cancel method 
    Public PageReference cancelme()
    {
       
        PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=Tag');
        }
        else
        {
             p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=9');
        }
       
     //  PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
       p.setRedirect(true);
       return p;
    } 
     // End of Cancel method
    
    
 // Test Method 
 
 /*   static testMethod void Test_CreateNewTagExtensions()
    {
        Job_Number_Setting__c customSetting351 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting351;
            
          Media_Type__c testMedia1 = new Media_Type__c(Name='Test Media 351');
             
                insert testMedia1;
             
          Schedule_Template__c testST1 = new Schedule_Template__c(Name='Test Schedule Template 351',Media_Types__c=testMedia1.Id);
             
                 insert testST1;
                 
         Specification_Template__c testSpec1 = new Specification_Template__c(Name='Testing Spcification Template 351');
                insert testSpec1;
                
         Job__c testJob1 = new Job__c(Name='Test Job 351',Start_Date__c=System.Today(),Media_Types__c=testMedia1.Id,Schedule_Template__c=testST1.Id,Specification_Template__c=testSpec1.Id);
         
                 insert testJob1;
                 
         System.assertEquals('Test Job 351',testJob1.Name);        
         
         Tag__c testTag1=new Tag__c(Name = 'Test Tag 351',Job__c = testJob1.Id);   
         
         
         ApexPages.CurrentPage().getParameters().put('jobId',testJob1.id);     
       
       // Instantiate the standard controller with the Job
        ApexPages.StandardController con = new ApexPages.StandardController(testTag1);
            
        // Instantiate the extention instance with the standardcontroller
        CreateNewTagExtensions ext=new CreateNewTagExtensions(con);
 
        // Invoke the primary method on the extension
        ApexPages.PageReference result = ext.saveme();  
        
        result = ext.cancelme();     
        
        delete testTag1;
        
        result = ext.saveme();
    } // End of Test Method */
}
// End of Class