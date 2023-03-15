// This class is used to display Music Usage under Jobs Tab
public with sharing class displayMusicUsageUnderJobsTab
{/*
    // Global variables
    public Id jobId{get;set;}  
    public List<Music_Usage__c> lstMU{get;set;}
    public String strMusicId{get;set;}
    // End of Global variables
    
    // This mthod is called on to handle Inline Edit save
    public Pagereference save()
    {
        try
        {
            update lstMU; 
         }
         catch(Exception e)
         {   
            return NULL; 
         }
         return NULL;
    }
    // End of method save
    
    // This method is called on to handle Cancel button
    public pagereference cancel()
    {
        return NULL;
    }
    // End of method Cancel
    
    // Start Constructor
    public displayMusicUsageUnderJobsTab()
    {
        displayMusicUsage();
    }
    // End of Constructor
    
    // This method is called on to display Music Usage records
    public void displayMusicUsage()
    {
        jobId=ApexPages.CurrentPage().getParameters().get('id');
        lstMU=[Select Id,Job__c,Name,Music_Usage_Library__c, Music_Usage_Start_Date__c, Music_Usage_End_Date__c, Music_Usage_Track__c, Music_Usage_Track_Info__c, Music_Usage_Promo_Length__c, Music_Usage_Drop__c, Music_Usage_Note__c from Music_Usage__c where Job__c=:jobId ORDER BY Name];
    }
    // End of method displayMusicUsage
    
    // This method is called on to edit Music Usage record
    public pagereference editMusicUsage()
    {
         Pagereference p=new Pagereference('/apex/EditMusicUsage?id='+strMusicId);
         p.setRedirect(true);
         return p;
    }
    // End of method editMusicUsage
    
    // This method is called on to handle delete music usage record
    public pagereference deleteMusicUsage()
    {
        /*
        Music_Usage__c delMU= new Music_Usage__c(Id=strMusicId);
        delete delMU;
        displayMusicUsage();
        return NULL;
       /
         Pagereference p=new Pagereference('/apex/DeleteMusicUsage?id='+strMusicID);
         p.setRedirect(true);
         return p;
    }
    // End of method deleteMusicUsage
    
    // This method is used to create New Music Usage record
    public pagereference createNewMusicUsage()
    {
           PageReference p=Page.CreateNewMusicUsage;
           p.setRedirect(true);
           p.getParameters().put('jobId',jobId);
           return p;
    }
    // End of createNewMusicUsage method
    
    // Start Test Coverage
    static testMethod void Test_displayMusicUsageUnderJobTab()
    {
         Job_Number_Setting__c customSetting7321 = new  Job_Number_Setting__c(Name='NO');

                insert customSetting7321;
                
         Media_Type__c testMedia1=new Media_Type__c(Name='Test Media 7321');
             
                insert testMedia1;
             
          Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 7321',Media_Types__c=testMedia1.Id);
             
                 insert testST1;
     
          Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 7321');
                insert testSpec1;
    
          Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='J 7321',Name='Test Job 7321',Start_Date__c=System.Today(),Media_Types__c=testMedia1.Id,Schedule_Template__c=testST1.Id,Specification_Template__c=testSpec1.Id);
           
                   insert testJob1;
               
          Music_Usage__c testMU1=new Music_Usage__c(Name='Test MU 7321',Job__c=testJob1.Id);
           
               insert testMU1;
               
          System.assertEquals('Test MU 7321',testMU1.Name);
       
            // Instantiate the extension instance with the Custom Controller
          displayMusicUsageUnderJobsTab ext=new displayMusicUsageUnderJobsTab();
           
           // Invoke the primary method on the extension
          ext.displayMusicUsage();
          ext.strMusicId=testMU1.Id;
          ApexPages.Pagereference result=ext.editMusicUsage();
          result=ext.deleteMusicUsage();
          result=ext.createNewMusicUsage();
          result=ext.save();
          result=ext.cancel();
           
          result=ext.save();
           
          delete testJob1;
           
          result=ext.save();
    }  // End Test Coverage*/
}// End of Class