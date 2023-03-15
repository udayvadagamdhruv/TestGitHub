// This class is used to Assign User To selected Role 
public with sharing class JobTeamAssignUser 
{
    // Global variables
  /*  public List<RoleWrapper> rolewraps{get;set;}
    public Job_Team__c objJTR{get;set;}
    Id JobTeamId;
    
    public list<CCWrapper> CCntwraps{get; set;}
    public list<VenWrapper> VenWraps{get; set;}
    // End of GLobal variables
    

    // Start Constructor
    public JobTeamAssignUser(ApexPages.StandardController controller)
      {
        Id aid=ApexPages.currentPage().getParameters().get('id');
        system.debug('aid is@@@ :'+aid);
        this.objJTR=(Job_Team__c)controller.getrecord();
        
        Job_Team__c objJTR = [select Role__c,Job__c,Staff__c from Job_Team__c where id =: aid Limit 1];
        JobTeamId = objJTR.Job__c;
        roleWraps=new List<RoleWrapper>();
        
     /*   for(Job_Team__c j: [Select Id, Staff__c from Job_Team__c where Id =: aid])
        {
             selectedStaff.add(j.Staff__c);   
        }
        System.debug('Selected Staff : '+selectedStaff);
      
        
        for(Staff__c u: [Select Id, Name from Staff__c where Role__c =: objJTR.Role__c   and IsDeleted__c=:False])
         {
                RoleWrapper rw=new RoleWrapper();
                rw.u=u;
                rw.selected = false;
                roleWraps.add(rw);        
          }
        
        List<Staff__c> lstu = [select Name from Staff__c where User_Type__c =:'User'];
        set<string> uname = new set<string>();
        for(Staff__c obj : lstu)
        {
            uname.add(obj.Name);
        }  
          
        for(User ub : [select Name from user where Name in: uname])
        {
            system.debug('Name:::::'+ub.Name);
        }  
        
        //added this code by rahul for generating client contacts on 10 June 2014
        CCntwraps = new list<CCWrapper>();
        for(Client_Contact__c u: [Select Id, Name, Client_Contact_Role__c from Client_Contact__c where Client_Contact_Role__c =: objJTR.Role__c]){
            CCWrapper cw=new CCWrapper();
            cw.u=u;
            cw.selected = false;
            CCntwraps.add(cw);        
        }
        //Added code ends here
        
        //added this code by rahul for generating Vendor contacts on 12 June 2014
        VenWraps = new list<VenWrapper>();
        for(Vendor_Contact__c u: [Select Id, Name, Role__c from Vendor_Contact__c where Role__c =: objJTR.Role__c]){
            VenWrapper cw=new VenWrapper();
            cw.u=u;
            cw.selected = false;
            VenWraps.add(cw);        
        }
        //Added code ends here
    
       }
       // End of Constructor
         
    // Start Wrapper Class : This class will bind checkbox and its associated Staff on layout
    public class RoleWrapper
     {
         public Staff__c u{get;set;}
         public Boolean selected{get;set;}
     }   
     // End of Wrapper Class
     
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
   
   // Save Method 
    public pagereference Save()
     {
     Boolean blnNothingSelected = false;
      for(RoleWrapper rw:roleWraps)
       {
       //lst=new List<Job_Task_Role__c>();
         if(rw.selected==true)
          {
              if(schema.SobjectType.Job_Team__c.Fields.Staff__c.isUpdateable()){ objJTR.Staff__c=rw.u.Name;}
                if(Schema.sObjectType.Job_Team__c.isUpdateable()){update objJTR;}
           blnNothingSelected = true; 
           break;      
           }
       }
       
       //Added by rahul on 10 June 2014.
       for(CCWrapper varCCw : CCntwraps)
       {
           if(varCCw.selected==true)
          {
           objJTR.Staff__c=varCCw.u.Name;
           update objJTR; 
           blnNothingSelected = true; 
           break;      
           }
       }
       //Addded code ends here

       //Added by rahul on 12 June 2014.
       for(VenWrapper varCCw : VenWraps)
       {
           if(varCCw.selected==true)
          {
           objJTR.Staff__c=varCCw.u.Name;
           update objJTR; 
           blnNothingSelected = true; 
           break;      
           }
       }
       //Addded code ends here       
       if(!blnNothingSelected)
       {
          objJTR.Staff__c='';
           update objJTR;  
       }
       
     PageReference p =  new Pagereference('/apex/JobListView?id='+JobTeamId);
     p.setRedirect(true);
     return p;
     }
       // End of Save Method
 
      // Cancel method to deal with Cancel button 
    public pagereference cancel()
     {
          PageReference p =  new Pagereference('/apex/JobListView?id='+JobTeamId);
          p.setRedirect(true);
          return p;
     }
     // End of Cancel Method 
 
 /* Test Method for Test Coverage 
 Private static testMethod void JobTaskRoleTest()
  {
   Profile p1=[Select Id, Name From Profile where Name=: 'System Administrator' LIMIT 1]; 
   
   //Set up user 
   User u2 = [Select id,IsActive from User where IsActive =: True and ProfileId =:p1.id Limit 1];
   System.RunAs(u2)
    {
      UserRole ur12 = new UserRole(Name = 'Design Manager');
      insert ur12;
      
      Media_Type__c testMedia=new Media_Type__c(Name='Test Media 326');
       try
        {
            insert testMedia;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
        }
           
      Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 326',Media_Types__c=testMedia.Id);
          insert testST;
       
      Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 326');
          insert testSpec;
     
      Job__c testJob1=new Job__c(Name='Test Job 326',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
       try
        {
            insert testJob1;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
        }
       System.assertEquals('Test Job 326',testJob1.Name);       
               
      Job_Team__c testJT=new Job_Team__c(Job__c=testJob1.Id,Role__c='Design Manager');
       try
        {
            insert testJT;
        }       
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
        }
              
      // Instantiate the standard controller with the Job Team 
      
        Staff__c testStaff1=new Staff__c(First_Name__c='Test First Name 1',Last_Name__c='Test Last Name 1',Role__c='Design Manager',Email__c='testEmailStaff1@gmail.com',UserName__c='testEmailStaff1@gmail.com',IsDeleted__c = False);
        insert testStaff1;
                             
        ApexPages.StandardController con = new ApexPages.StandardController(testJT);
        ApexPages.currentPage().getParameters().put('Id',testJT.Id);
    
        // Instantiate the extention instance with the standardcontroller 
        JobTeamAssignUser ext=new JobTeamAssignUser(con);
                
        // Invoke the Save method on the extension
        ApexPages.PageReference result=ext.Save();
        ext.roleWraps[0].selected=true;
        result=ext.Save();
        ApexPages.PageReference result1=ext.cancel();
      
      }//End of RunAs
     
     } End of Test Method */
}// End of Class