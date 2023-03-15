// This class is used to add New Job Spec
public with sharing class extension_JobSpec 
{
    /* public boolean isLtng{
                         
                         private set; get{
                                                        String t;
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                         }
     public boolean isMob{
                         
                         private set; get{
                                                        String t;
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
                         }


    // Global variables
    private final Job_Spec__c objJobSpec;
    public Id jobId{get;set;}
    public String strJob{get;set;}
    // End of Global variables
    
    // Start constructor
    public extension_JobSpec(ApexPages.StandardController con) 
    {
        String tt;
        string ttt;
        jobId=ApexPages.currentPage().getParameters().get('jobId');
       
        Job__c objJob=[Select id,Name from Job__c where id=:jobId];
        strJob=objJob.Name;
         this.objJobSpec=(Job_Spec__c)con.getRecord();
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,''+objJobSpec));
    }
    // End constructor
    
    // This method is called on to save new Job Spec
    Public PageReference saveme()
    {
       
           //Job_Spec__c obj=new Job_Spec__c(Job__c=jobId,Name=objJobSpec.Name,Description__c=objJobSpec.Description__c);
           try
           {
               //insert obj;
               if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) {   
                   objJobSpec.Job__c=jobId;}
               if(Schema.sObjectType.Job_Spec__c.isCreateable()){ insert objJobSpec;}
            }
            catch(System.DMLException e)
            {
                return NULL;
            }    
            
            if(isMob)
            {
                 PageReference p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobId+'&tab=RelatedList'+'&section=CreativeBrief');p.setRedirect(true);
                 return p; 
            }
            
            else if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=CreativeBrief');p.setRedirect(true);
                 return p; 
            }
            else
            {
                    // After inserting Job Spec, navigate to Creative Brief Tab        
                    PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=3');
                    p.setRedirect(true);
                    return p;
            }
    }
    // End method save
    
    // This method is called on to handle Cancel button
   Public PageReference cancelme()
    { 
      // String strid;
     //  strid = objJobSpec.Job__c;  
     
          if(isMob)
            {
                 PageReference p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobId+'&tab=RelatedList'+'&section=CreativeBrief');p.setRedirect(true);
                 return p; 
            }
            
            else if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=CreativeBrief');p.setRedirect(true);
                 return p; 
            }
            else
            {
                    // After inserting Job Spec, navigate to Creative Brief Tab        
                    PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=3');
                    p.setRedirect(true);
                    return p;
            }
    }
    // ENd Cancel method 
    
   /* // Test Coverage 
     
          static testMethod void insertJobSpec()
          {
              Job_Number_Setting__c customSetting305 = new  Job_Number_Setting__c(Name= 'yy');

                insert customSetting305;
            
              Media_Type__c testMedia=new Media_Type__c(Name='Test Media 305');
              insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 305',Media_Types__c=testMedia.Id);
              insert testST;
                 
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 305');
              insert testSpec;
                
              Job__c testJob1=new Job__c(Name='Test Job 305',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
              insert testJob1;
                 
              System.assertEquals('Test Job 305',testJob1.Name);   
                 
              Job_Spec__c testJobSpec=new Job_Spec__c(Name='Job Spec 306',Job__c=testJob1.Id);
         
               
              ApexPages.currentPage().getParameters().put('jobId',testJob1.Id); 
              
              // Instantiate the standard controller with the Job    
                   ApexPages.StandardController con=new ApexPages.StandardController(testJobSpec);
        
              // Instantiate the extention instance with the standard controller 
                   extension_JobSpec ext=new extension_JobSpec(con);
        
              // Invoke the primary method on the extension 
                   ApexPages.PageReference result=ext.saveme();    
                   result=ext.cancelme(); 
                    
                      
              Job_Spec__c testJobSpec1=new Job_Spec__c(Name='Job Spec 306',Job__c=testJob1.Id);
              
                // Instantiate the standard controller with the Job  Spec  
              ApexPages.StandardController con1=new ApexPages.StandardController(testJobSpec1);
              
              // Instantiate the extention instance with the standard controller 
              
              extension_JobSpec ext1=new extension_JobSpec(con1);
              
              // Invoke the primary method on the extension 
              
              try
               {      
                ApexPages.PageReference result3=ext1.saveme();    
               }
              catch(System.DMLException e)
               {
               System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
               }
          }
    // End of Test Coverage */
}
// End of Class