// This class is used to edit Job Spec
public with sharing class EditJobSpecExtension
{
    // Global variables 
    
     public boolean isLtng{private set; get{
                                                                                string t;
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
    
    
     public boolean isMob{private set; get{
                                                                                string t;
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }  
        
    private final Job_Spec__c objJobSpec;
    String strId1,strId2;
    // End of Global variables
    
    // Start Constructor
    public EditJobSpecExtension(ApexPages.StandardController controller) 
    {
        string tt;
        this.objJobSpec=(Job_Spec__c)controller.getrecord();
    }
    // End Constructor
    
    // Method called on to edit Job Spec
    
    Public PageReference saveme()
    {
        strId1 = objJobSpec.Job__c;   
        try
        {
            update objJobSpec;
        }
        catch(System.DMLException e)
        {
        return null;
        }        
        
        if(isMob)
            {
                 PageReference p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+strId1+'&tab=RelatedList'+'&section=CreativeBrief');p.setRedirect(true);
                 return p; 
            }
            
            else if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+strId1+'&section=CreativeBrief');p.setRedirect(true);
                 return p; 
            }
            else
            {
                    // After inserting Job Spec, navigate to Creative Brief Tab        
                    PageReference p =  new Pagereference('/apex/jobListView?id='+strId1 +'&intFocus=3');
                    p.setRedirect(true);
                    return p;
            }
            
    }
    // End edit method
    
    // Method called on to handle Cancel button
    
    Public PageReference cancelme()
    {
       strId2 =  objJobSpec.Job__c;   
       
       if(isMob)
            {
                 PageReference p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+strId2 +'&tab=RelatedList'+'&section=CreativeBrief');p.setRedirect(true);
                 return p; 
            }
            
            else if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+strId2+'&section=CreativeBrief' );p.setRedirect(true);
                 return p; 
            }
            else
            {
                    // After inserting Job Spec, navigate to Creative Brief Tab        
                    PageReference p =  new Pagereference('/apex/jobListView?id='+strId2 +'&intFocus=3');
                    p.setRedirect(true);
                    return p;
            }
            
       
    } 
    
 /*   // Test Coverage 
     static testMethod void Test_EditJobSpec()
     {
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 625');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 625',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Specification Template 625');
                insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 625',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         
                 insert testJob1;
                 
          Job_Spec__c testJobSpec=new Job_Spec__c(Name='Job Spec 625',Job__c=testJob1.Id);
          
                  insert testJobSpec;
         
          System.assertEquals('Job Spec 625',testJobSpec.Name);
    
            // Instantiate the standard controller with the Job Spec
          ApexPages.StandardController con=new ApexPages.StandardController(testJobSpec);
        
            // Instantiate the extention instance with the standardcontroller
          EditJobSpecExtension ext1=new EditJobSpecExtension(con);
        
           // Invoke the primary method on the extension 
          ApexPages.PageReference result=ext1.saveme();    
          result=ext1.cancelme();   
        
            // To cover catch block in save method
          delete testJobSpec;
          result=ext1.saveme();  
       }*
    // End of Test Coverage*/
}
// End of Class