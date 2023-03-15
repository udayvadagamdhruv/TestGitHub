// This class is used to Assign User To Role

public with sharing class AssignUser
{
   /* public List<RoleWrapper> rolewraps{get;set;}
    public Job_Task_Role__c objJTR{get;set;}
    Id JobTaskId;
    String strRoleName;
    
    //Added variable by Rahul
    public list<CCWrapper> CCntwraps{get; set;}
    public list<VenWrapper> VenWraps{get; set;}
    //Added variables end here
    
    // Standard Controller Constructor
    public AssignUser(ApexPages.StandardController controller)
    {
        Id aid=ApexPages.currentPage().getParameters().get('id');
        
        this.objJTR=(Job_Task_Role__c)controller.getrecord();
        
        Job_Task_Role__c objJTR = [select Name,Job_Task__c,Email__c,User__c from Job_Task_Role__c where id =: aid];
        
        JobTaskId = objJTR.Job_Task__c;
        strRoleName=objJTR.Name;
        roleWraps=new List<RoleWrapper>();
        
      for(Staff__c u: [Select Name from Staff__c where Role__c =: objJTR.Name and IsDeleted__c=:False])
       {
                RoleWrapper rw=new RoleWrapper();
                {
                    rw.u=u;
                    rw.selected=False;
                }
                roleWraps.add(rw);        
        }
        
        //added this code by rahul for generating client contacts on 10 June 2014
        CCntwraps = new list<CCWrapper>();
        for(Client_Contact__c u: [Select Id, Name, Client_Contact_Role__c from Client_Contact__c where Client_Contact_Role__c =: objJTR.Name]){
            CCWrapper cw=new CCWrapper();
            cw.u=u;
            cw.selected = false;
            CCntwraps.add(cw);        
        }
        //Added code ends here
        
        //added this code by rahul for generating Vendor contacts on 13 June 2014
        VenWraps = new list<VenWrapper>();
        for(Vendor_Contact__c u: [Select Id, Name, Role__c from Vendor_Contact__c where Role__c =: objJTR.Name]){
            VenWrapper cw=new VenWrapper();
            cw.u=u;
            cw.selected = false;
            VenWraps.add(cw);        
        }
        //Added code ends here
    }
    // End of Constructor 
    
    // Start RoleWrapper Class 
    public class RoleWrapper
    {
     public Staff__c u{get;set;}
     public Boolean selected{get;set;}
    }   
   // End of RoleWrapper Class 

    // Start Wrapper Class : This class will bind checkbox and its associated Client on layout
    public class CCWrapper
     {
         public Client_Contact__c u{get;set;}
         public Boolean selected{get;set;}
     }   
     // End of Wrapper Class
      
    // Start Wrapper Class : This class will bind checkbox and its associated Vendor on layout
    public class VenWrapper
     {
         public Vendor_Contact__c u{get;set;}
         public Boolean selected{get;set;}
     }   
     // End of Wrapper Class
     
    // Method called on handle Assign User functionality for the selected Role 
     public pagereference Save()
     {
         Boolean blnNothingSelected = false;
         for(RoleWrapper rw:roleWraps)
         {
             if(rw.selected==true)
             {
                 if(Schema.sObjectType.Job_Task_Role__c.Fields.User__c.isUpdateable()){
                     objJTR.User__c=rw.u.Name;
                 }
                 if(Schema.sObjectType.Job_Task_Role__c.isUpdateable()){
                     update objJTR; 
                 }
                 blnNothingSelected = true; 
                 break;
             }
         }
         //Added by rahul on 10 June 2014.
         for(CCWrapper varCCw : CCntwraps)
         {
             if(varCCw.selected==true)
             {
                 if(Schema.sObjectType.Job_Task_Role__c.Fields.User__c.isUpdateable()){
                     objJTR.User__c=varCCw.u.Name;
                 }
                 if(Schema.sObjectType.Job_Task_Role__c.isUpdateable()){
                     update objJTR;
                 }
                  
                 blnNothingSelected = true; 
                 break;      
               }
           }
           //Added code ends here
           //Added by rahul on 12 June 2014.
           for(VenWrapper varCCw : VenWraps)
           {
               if(varCCw.selected==true)
              {
                  if(Schema.sObjectType.Job_Task_Role__c.Fields.User__c.isUpdateable()){
                      objJTR.User__c=varCCw.u.Name;
                  }
                  if(Schema.sObjectType.Job_Task_Role__c.isUpdateable()) {
                      update objJTR; 
                  }
               blnNothingSelected = true; 
               break;      
               }
           }
           //Addded code ends here
           if(!blnNothingSelected)
           {
                 if(Schema.sObjectType.Job_Task_Role__c.Fields.User__c.isUpdateable()){
                      objJTR.User__c='';
                  }
                  if(Schema.sObjectType.Job_Task_Role__c.isUpdateable()) {
                      update objJTR;
                  }
           }
       PageReference p =  new Pagereference('/apex/JobTaskDetailPage?id='+JobTaskId);
       p.setRedirect(true);
       return p;
   }
  // End Save method 
     
  // Method called on to handle Cancel Button operation 
   public pagereference cancel()
    {
      PageReference p =  new Pagereference('/apex/JobTaskDetailPage?id='+JobTaskId);
      p.setRedirect(true);
      return p;
    }
  // End Cancel Method 
/*  
  // Test Coverage 
   static testMethod void AssignUserTest()
    {
        Job_Number_Setting__c customSetting323 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting323;
            
      Media_Type__c testMedia=new Media_Type__c(Name='Test Media 323');
      try
       {
       insert testMedia;
       }
      catch(System.DMLException e)
       {
       System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
       }
      
      Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 323',Media_Types__c=testMedia.Id);
      insert testST;
       
      Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 323');
      insert testSpec;
 
      Job__c testJob1=new Job__c(Name='Test Job 323',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
      try
       {
       insert testJob1;
       }
      Catch(System.DMLException e)
       {
       System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
       }
      System.assertEquals('Test Job 323',testJob1.Name);       
               
      Job_Task__c testJT=new Job_Task__c(Name='Test Job Task 323',Job__c=testJob1.Id,Days__c=5,Start_Date__c=System.Today());
      try
       {
       insert testJT;
       }       
      catch(System.DMLException e)
       {
       System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
       }
       
      Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Name='Test First Name 1 Test Last Name 1',Role__c='Design Manager',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com');
      insert testStaff1;
      
            
      Staff__c testStaff2=new Staff__c(First_Name__c='Test First Name 2',Last_Name__c='Test Last Name 2',Role__c='Designer',Email__c='testEmailStaff2@gmail.com',UserName__c='testEmailStaff2@gmail.com');
      insert testStaff2;
      
      Job_Task__c testJT1=new Job_Task__c(Name='Test Job Task 423',Job__c=testJob1.Id,Days__c=5,Start_Date__c=System.Today());
      insert testJT1;
                 
      Job_Task_Role__c testJTR=new Job_Task_Role__c(Name='Design Manager',Job_Task__c=testJT.Id,User__c='Test User 007');
      insert testJTR;
               
      Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Design Manager',Job_Task__c=testJT.Id);
      insert testJTR1;
               
      Job_Task_Role__c testJTR2=new Job_Task_Role__c(Name='Art Director Manager',Job_Task__c=testJT1.Id);
      insert testJTR2;
               
     // Instantiate the standard controller with the Job Task Role Item 
     ApexPages.StandardController con = new ApexPages.StandardController(testJTR1);
     ApexPages.currentPage().getParameters().put('Id',testJTR1.Id);
           
     // Instantiate the extention instance with the standardcontroller
     AssignUser ext=new AssignUser(con);
     
     // Invoke the Save method on the extension 
    
     ApexPages.PageReference result1=ext.Save();
     
    ext.roleWraps[0].selected=True;
    
     // Invoke the Save method on the extension 
      result1=ext.Save();
               
     // Invoke the Cancel Method
      ApexPages.PageReference result2=ext.cancel();
   }
  // End Test Coverage 
  */
}
// End of Class