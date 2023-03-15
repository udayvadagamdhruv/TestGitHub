// This class is used to display Tags under Jobs Tab
public with sharing class displayTagsUnderJobTab
{
 /*   // Global variables
    public Id jobId{get;set;}  
    public List<Tag__c> lstTags{get;set;}
    public String strTagId{get;set;}
    // End of Global variables
    
    // This mthod is called on to handle Inline Edit save
    public Pagereference save()
    {
        try
        {
            update lstTags; 
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
    public displayTagsUnderJobTab()
    {
        displayTags();
    }
    // End of Constructor
    
    // This method is called on to displayTags
    public void displayTags()
    {
        jobId=ApexPages.CurrentPage().getParameters().get('id');
        //commented by yogini on 9/11/12 - added order by createddate 
        //lstTags=[Select Id,Job__c,Name,Tag_Program_Title__c, Tag_Start_Date__c, Tag_End_Date__c, Tag_Due_Date__c, Tag_Air_Date__c, Tag_Air_Time__c, Tag_Lengths__c from Tag__c where Job__c=:jobId ORDER BY Name];        
        lstTags=[Select Id,Job__c,Name,Tag_Program_Title__c, Tag_Start_Date__c, Tag_End_Date__c, Tag_Due_Date__c, Tag_Air_Date__c, Tag_Air_Time__c, Tag_Lengths__c from Tag__c where Job__c=:jobId ORDER BY CreatedDate ASC];        
    }
    // End of method displayTags
    
    // This method is called on to editTag
    public pagereference editTag()
    {
        Pagereference p=new Pagereference('/apex/editTag?id='+strTagId);
        p.setRedirect(true);
        return p;
    }
    // End of method editTag
    
    // This method is called on to handle deleteTag
    public pagereference deleteTag()
    {
      /*
        Tag__c delTag= new Tag__c(Id=strTagId);
        delete delTag;
        displayTags();
        return NULL;
       
         Pagereference p=new Pagereference('/apex/DeleteTag?id='+strTagId);
         p.setRedirect(true);
         return p;
    }
    // End of method deleteTag
    
    // This method is used to create New Tag
    public pagereference createNewTag()
    {
           PageReference p=Page.CreateNewTag;
           p.setRedirect(true);
           p.getParameters().put('jobId',jobId);
           return p;
    }
    // End of createNewTag method
    
    // Start Test Coverage
    static testMethod void Test_displayTagsUnderJobTab()
    {
         Job_Number_Setting__c customSetting1371 = new  Job_Number_Setting__c(Name='NO');

                insert customSetting1371;
                
         Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1371');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1371',Media_Types__c=testMedia.Id);
             
                 insert testST;
     
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 1371');
                insert testSpec;
    
          Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='J 1371',Name='Test Job 1371',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
           
                   insert testJob1;
               
          Tag__c testTag1=new Tag__c(Name='Test Tag 1371',Job__c=testJob1.Id);
           
               insert testTag1;
               

          System.assertEquals('Test Tag 1371',testTag1.Name);
       
            // Instantiate the extention instance with the Custom Controller
          displayTagsUnderJobTab ext=new displayTagsUnderJobTab();
           
           // Invoke the primary method on the extension
          ext.displayTags();
          ext.strTagId=testTag1.Id;
          ApexPages.Pagereference result=ext.editTag();
          result=ext.deleteTag();
          result=ext.createNewTag();
          result=ext.save();
          result=ext.cancel();
           
          testTag1.Tag_Start_Date__c=System.Today();
          testTag1.Tag_Due_Date__c=System.Today()-1;
          result=ext.save();
           
          delete testJob1;
           
          result=ext.save();
    }  // End Test Coverage*/
}// End of Class