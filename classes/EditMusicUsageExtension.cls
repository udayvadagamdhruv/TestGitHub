//This Class is Used to override the Edit button of Music_Usage Object 
public with sharing class EditMusicUsageExtension 
{
    //Start of Global Variables
  /*  String JobId,muID;
    Private final Music_Usage__c musicusage;
    //End of Global Variables
    
    //Start of Constructor
    public EditMusicUsageExtension(ApexPages.StandardController controller)
    {
        this.musicusage = (Music_Usage__c)controller.getrecord();
        muID = ApexPages.currentPage().getParameters().get('id');
        
        Music_Usage__c mu = [select id,Name,Job__c from Music_Usage__c where id =: muID];
        JobId = mu.Job__c;
        
    }
    //End of Constructor
    
    //Update method
    public PageReference saveme()
    {
        try
         {
            update musicusage;
         }
         catch(DMLException e)
         {
            return null;
         }
         PageReference pageref = new PageReference('/apex/JobListView?id='+JobId+'&intFocus=12');
         pageref.setRedirect(true);
         return pageref;
    }
    //End of Update Method
    
    public PageReference cancelme()
    {
        PageReference p = new PageReference('/apex/JobListView?id='+JobId+'&intFocus=12');
        p.setRedirect(true);
        return p;
    }
    
    
    // Positive Test Case
    private static testMethod void Test_CreateNewSessionExtension()
     {
      
      Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name= 'yy');
      insert customSetting001; 
     
      Media_Type__c testMedia=new Media_Type__c(Name='TM32333');
      insert testMedia;
             
      Schedule_Template__c testST=new Schedule_Template__c(Name='TST32333',Media_Types__c=testMedia.Id);
      insert testST;
               
      Specification_Template__c testSpec=new Specification_Template__c(Name='TSPT32333');
      insert testSpec;
            
      Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='Job32333',Name='TestJobByDeveloper32333',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
       try
        {
            insert testJob1;
        }
       catch(System.DMLException e)
        {
         //   System.assert(e.getMessage().contains('Job with same name Exists'));
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
       
      System.assertEquals('TestJobByDeveloper32333',testJob1.Name);    
            
      Music_Usage__c testMU=new Music_Usage__c(Name='MU',Job__c=testjob1.Id);
      try
       {
           insert testMU;
       }
      catch(System.DMLException e)
       {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
       }
       
      ApexPages.currentPage().getParameters().put('id',testMU.id);
      ApexPages.StandardController con=new ApexPages.StandardController(testMU);    
      EditMusicUsageExtension ext=new EditMusicUsageExtension(con);  
 
      ApexPages.PageReference result1=ext.saveme(); 
      
      Delete testMU;         
    
      result1 = ext.saveme();
      result1 = ext.cancelme();
           
    }  */
  // End of Test Coverage Code

}
//End Of Class