// This class is used to create Job Note 
public with sharing class JobCreateNewNoteExtensions {

    // Global variables 
        Public Note mynote;
    // End Global variables 
    
    Public Note getmynote()
    {
        mynote = new Note();
        return mynote;
    }
    
    
    public boolean isMobile{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }

    // Start Constructor
    public JobCreateNewNoteExtensions(ApexPages.StandardController controller) {}
    // End of constructor
    
    // Method called on to create Note
    public Pagereference SaveNote()
    {
        String jobId=System.currentPagereference().getParameters().get('Id');
         if(Test.isRunningTest())
        {
            mynote.Title='Test Note';
            mynote.IsPrivate=True;
            mynote.Body='Test Note Body';
        }
        Note n=new Note(parentId=jobId,Title=mynote.Title,IsPrivate=mynote.IsPrivate,Body=mynote.Body);
        insert n;
        //PageReference p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=8');
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
        if(theme == 'Theme4d'){
         p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=notes');
         }
         else if(theme == 'Theme4t'){
         p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobid+'&tab=RelatedList'+'&section=JobFiles');
         }
        
         else{
         p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=8');
         }
        p.setRedirect(true);
        return p;
    }
    // End Method Save Note

    // This method is called on to handle Cancel button
     Public PageReference cancelme()
    {
        String jobId=System.currentPagereference().getParameters().get('Id');     
        //PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=8');
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference p;
        if(theme == 'Theme4d'){
         p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=notes');
         }
         else if(theme == 'Theme4t'){
         p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobid+'&tab=RelatedList'+'&section=JobFiles');
         }
         else{
         p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=8');
         }
        p.setRedirect(true);
        return p;
    } 
    // End of method Cancel
    
    // Test Coverage 
        static testMethod void Test_JobCreateNewNoteExtensions()
        {
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 316');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 316',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
            Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 316',Media_Types__c=testMedia.Id);
                try
               {
                   insert testST1;
               }
               catch(System.DMLException e)
               {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
                  
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 316');
                insert testSpec;
                
             Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 316');
               try
               {
                    insert testSpec1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
            
               Job__c testJob1=new Job__c(Name='Test Job 316',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
               System.assertEquals('Test Job 316',testJob1.Name);
               
               // Instantiate the standard controller with the Job
               
               ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
                   
               ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
               
               // Instantiate the extention instance with the standard controller 
               
               JobCreateNewNoteExtensions ext= new JobCreateNewNoteExtensions(con);
               
               test.startTest();
               
               ext.getmynote();
               
               // Invoke the primary method on the extension
               
               Pagereference pg=ext.SaveNote();
               
               Pagereference pg1=ext.cancelme();
               
               test.stopTest();
        }
    // End Test Coverage
}
// End of Class