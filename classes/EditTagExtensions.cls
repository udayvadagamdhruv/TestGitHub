// This method is used in Edit_Tag vf page 
public with sharing class EditTagExtensions
{
   // Global variables
  /* 
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     } 
  
   
   
    private final Tag__c objTag;
    String strId1,strId2;
    public String jobId{get;set;}
    // End of Global variables
    
    // Constructor 
    public EditTagExtensions(ApexPages.StandardController con) 
    {
        this.objTag=(Tag__c)con.getrecord();
        
        Tag__c gdid = [select id,job__c from Tag__c where id =:objTag.id]; 
      
       jobId=gdid.Job__c; 
    }
    // End of Constructor 
    
    // method to Update
    Public PageReference saveme()
     {
      //  strId1 =  objTag.Job__c;
        try
        {
            update objTag;
        }
        catch(System.DMLException e)
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
       
        
                
        //PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
        p.setRedirect(true);
        return p; 
     }
   // End of Update Method
   
   // Cancel method
    Public PageReference cancelme()
    {
     //  strId2 =  objTag.Job__c;        
     //  PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=9');
    
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
    
    // Test Coverage
     
  /*   static testMethod void Test_EditTagExtensions()
     {
               Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

               insert customSetting001;
               
              Media_Type__c testMedia = new Media_Type__c(Name='Test Media 622');
              insert testMedia;
             
              Schedule_Template__c testST = new Schedule_Template__c(Name='Test Schedule Template 622',Media_Types__c=testMedia.Id);
              insert testST;
                 
              Specification_Template__c testSpec = new Specification_Template__c(Name='Testing Spcification Template 622');
              insert testSpec;
                
              Job__c testJob1 = new Job__c(Name='Test Job 622',Flag__c = True, Job_Auto_Number__c='Job 622', Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
                {
                   insert testJob1;
                }
               catch(System.DMLException e)
                {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' ,e.getDmlStatusCode(0));
                }
              System.assertEquals('Test Job 622',testJob1.Name); 
               
              Tag__c testTag = new Tag__c(Name='Test Tag 622',Job__c=testJob1.Id);
                  insert testTag;
              
        // Instantiate the standard controller with the Job 
           ApexPages.StandardController con=new ApexPages.StandardController(testTag);
        
        // Instantiate the extention instance with the standardcontroller
           EditTagExtensions ext=new EditTagExtensions(con);
        
        // Invoke the primary method on the extension 
           ApexPages.PageReference result=ext.saveme();
           ApexPages.PageReference result1=ext.cancelme();
         
           // To cover catch block  
           delete testTag;
           result=ext.saveme();
    }// End Test Coverage */
}
// End of class