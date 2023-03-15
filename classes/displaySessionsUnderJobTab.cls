// This class is used to display Tags under Jobs Tab
public with sharing class displaySessionsUnderJobTab
{
  /*  // Global variables
    public Id jobId{get;set;}  
    public List<Session__c> lstSessions{get;set;}
    public String strSessionId{get;set;}
    public String ssnIdChosen {get; set;}
    public Boolean ChildExists{get;set;}
  //  public String strSessionId1{get;set;}
    // End of Global variables
    
    //Start of Save method
    public Pagereference save()
    {
        try
        {
            update lstSessions; 
         }
         catch(Exception e)
         {   
          return NULL;   
         }        
      
      PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=10');
      p.setRedirect(true);
      return p;
     return NULL; 
    }
    //End of Save method
    
    public PageReference delCont()
    {
     Session__c toDel=new Session__c(id=ssnIdChosen);
      if(Session__c.sObjectType.getDescribe().isDeletable()){
          delete todel;}
     
     displaySessions();
     
     return NULL;
    }
    
    //Start of Cancel method
    public pagereference cancel()
    {
        PageReference p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=10');
        p.setRedirect(true);
        return p;
    
    }
    //End of Cancel Method
    
    // Start Constructor
    public displaySessionsUnderJobTab()
    {
        displaySessions();
    }
    // End of Constructor
    
    // This method is called on to displaySessions
    public void displaySessions()
    {
        jobId=ApexPages.CurrentPage().getParameters().get('id');
        lstSessions=[Select Id,Job__c,Session_Status__c,Name,GL_Department__c,GL_Code__c,Session_Type__c,Start_Time__c,End_Time__c,Producer__c,Quantity__c,Technician__c,Unit_Cost__c,Vendor__c from Session__c where Job__c=:jobId ORDER BY Name];
    }
    // End of method displaySessions
    
    // This method is called on to editSession
    public pagereference editSession()
    {
        List<Estimate_Line_Items__c> approvedELI = new List<Estimate_Line_Items__c>();
        approvedELI = [select id,Name,Approved__c,Session__c from Estimate_Line_Items__c where Session__c =: strSessionId and Approved__c =: True];
        
        ChildExists = false;
             
        if(approvedELI.isEmpty())
        {  
        Pagereference p=new Pagereference('/apex/EditSession?id='+strSessionId);
        p.setRedirect(true);
        return p;
        }
        else
        {
        ChildExists = true;
        return null;
        }
    }
    // End of method editSession
    
    // This method is called on to handle deleteSession
    public pagereference deleteSession()
    {
        Pagereference p=new Pagereference('/apex/DeleteSession?id='+ssnIdChosen);
        p.setRedirect(true);
        return p;
    }
    // End of method deleteSession
    
    // This method is used to create New Session
    public pagereference createNewSession()
    {
           PageReference p=Page.CreateNewSession;
           p.setRedirect(true);
           p.getParameters().put('jobid',jobId);
           return p;
    }
    // End of createNewTag method
    
    // Start Test Coverage
    static testMethod void Test_displaySessionsUnderJobTab()
    {
    
         Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name= 'yy');
         insert customSetting001; 
         
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1371');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1371',Media_Types__c=testMedia.Id);
             
                 insert testST;
     
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1371');
                insert testSpec;
    
            Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='Job12346',Name='Test Job 1371',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
               }
               
               Session__c testSession=new Session__c(Name='Test Session 1371',Job__c=testJob1.Id);
               insert testSession;
               
               System.assertEquals('Test Session 1371',testSession.Name);
               
               ApexPages.currentPage().getParameters().put('id',testJob1.Id);
               
              // Instantiate the extention instance with the Custom Controller
              DisplaySessionsUnderJobTab ext1=new DisplaySessionsUnderJobTab();
               
       
            // Instantiate the extention instance with the Custom Controller
           displaySessionsUnderJobTab ext=new displaySessionsUnderJobTab();
           
           // Invoke the primary method on the extension
           ext.displaySessions();
           ext.strSessionId=testSession.Id;
           ApexPages.Pagereference result=ext.editSession();
           result=ext.deleteSession();
           result=ext.createNewSession();
           result=ext.save();
           result=ext.cancel();
    }*/
    // End Test Coverage
}// End of Class