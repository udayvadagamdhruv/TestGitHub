// This class is used to display Role-User pair under Job Task Detail 
public with sharing class DisplayRole_User 
{
    // Global variables 
  /*  public List<Job_Task_Role__c> lstJTR{get;set;} 
    public List<Job_Task_Role__c> lstJTR1{get;set;} 
    public string strJTRID{get;set;}
    public Job_Task_Role__c objJTR{get;set;}
    public List<Staff__c> lstStaff{get;set;}
    public String theId;
    // End of Global variables 
    
    // Start Constructor 
    public DisplayRole_User() 
    {
         strJTRID='';
         theID = ApexPages.CurrentPage().getParameters().get('id');
         lstJTR=[select User__c,id,Name,Job_Task__r.Name,Job_Task__r.Id from Job_Task_Role__c where Job_Task__c =: [Select id from Job_Task__c where id =: theID]];
    }
    // End Constructor
    
    // This method called on to add new Staff to Job Task 
    public Pagereference addNewStaff()
    {
       String theId=ApexPages.CurrentPage().getParameters().get('id');
       PageReference p = Page.AddStaffToJobTask;
       p.setredirect(true);
       p.getParameters().put('id',theID); 
       return p;
    }
    // End addNewStaff method 
    
    
    // This method called on to assign user to task 
    public Pagereference AssignTheUser()
    {
        Job_Task_Role__c objJTR=[Select User__c,Id,Name,Job_Task__c from Job_Task_Role__c where id=:strJTRID];
        List<Staff__c> lstStaff=[Select Name,Role__c from Staff__c where Role__c =: objJTR.Name and IsDeleted__c=:False];
        List<Client_Contact__c> lstCC = [Select Id, Name, Client_Contact_Role__c from Client_Contact__c where Client_Contact_Role__c =: objJTR.Name];
        List<Vendor_Contact__c> lstVend = [Select Id, Name, Role__c from Vendor_Contact__c where Role__c =: objJTR.Name];
        
        if(lstStaff.size()==1 && lstCC.size() == 0 && lstVend.size() == 0)
        {
            if(schema.SobjectType.Job_Task_Role__c.Fields.User__c.isUpdateable()){
                objJTR.User__c=lstStaff[0].Name;
            }
            if(Schema.sObjectType.Job_Task_Role__c.isUpdateable()) {
                update objJTR;
            }
            PageReference p = new PageReference('/' + theId);
            p.setRedirect(true);
            return p;
        }        
        Else
        {
            Pagereference p=new Pagereference('/apex/AssignUserToRoleOnJobTask?id='+objJTR.Id);
            p.setRedirect(true);
            return p;
        }
    }
    // End of AssignTheUser method 

    //This method called to delete the user assigned to task
    public Pagereference DeleteTheUser()
    {
        Job_Task_Role__c objJTR=[Select User__c,Id,Name,Job_Task__c from Job_Task_Role__c where id=:strJTRID];
        system.debug('selected user *********'+objJTR);
         if(Job_Task_Role__c.sObjectType.getDescribe().isDeletable()){
             Delete objJTR;}
        Pagereference p = new Pagereference('/apex/JobTaskDetailPage?id='+theID);
        p.setRedirect(true);
        return p;
    }    
    //End of DeleteTheUser method

    // This method called on to add new Role to Task
     public PageReference AddNewRole()
    {
       String qid;
       String theId=ApexPages.CurrentPage().getParameters().get('id');
       Job_Task_Role__c objJTR = new Job_Task_Role__c();
       Job_Task__c j = [Select Id from Job_Task__c where id =: theID];
       qid=j.Id;
       
       PageReference p = Page.AssignRoleToJobTask;
       p.setredirect(true);
       p.getParameters().put('qid',theID); 
       return p;
    }
    // End of AddNewRole method
/*    
    // Start Test Coverage
        static testMethod void Test_DisplayRole_User()
        {
            DisplayRole_User d=new DisplayRole_User();
            
             Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
             
                insert testMedia;
             
             Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 50',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 50');
                insert testSpec;
                
             Job__c testJob1=new Job__c(Name='Test Job 10',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         
                 insert testJob1;
                 
             System.assertEquals('Test Job 10',testJob1.Name);         
                 
             Job_Task__c testJobTask=new Job_Task__c(Name='Job Task 10',Job__c=testJob1.Id);
                insert testJobtask;
    
             // Instantiate the extention instance with the standardcontroller 
                DisplayRole_User d1=new DisplayRole_User();
      
       
                ApexPages.currentPage().getParameters().put('Id', testJobTask.Id);
                ApexPages.PageReference result1=d1.AddNewRole();
        
                DisplayRole_User d2=new DisplayRole_User();
        
                Job_Task_Role__c testJobTaskRole=new Job_Task_Role__c(Job_Task__c=testJobTask.Id,Name='Design Manager',User__c='');
                     insert testJobTaskRole;
         
        
                 DisplayRole_User ext=new DisplayRole_User();
                 ext.strJTRID = testJobTaskRole.Id;
                 ApexPages.PageReference result2=ext.AssignTheUser();
                 result2=ext.addNewStaff();
            
                Job_Task_Role__c testJobTaskRole1=new Job_Task_Role__c(Job_Task__c=testJobTask.Id,Name='Project Manager',User__c='');
                 insert testJobTaskRole1;
                 
                Staff__c st=new Staff__c();
                st.First_Name__c='mno';
                st.Last_Name__c='pqr';
                st.Email__c='mnopqr@gmail.com';
                st.UserName__c='mnopqr@gmail.com';
                st.Role__c='Project Manager';
                st.IsDeleted__c=False;
                insert st;       
             
                ext.strJTRID = testJobTaskRole1.Id;
                result2=ext.AssignTheUser();
     }
    // End of Test Coverage
*/
}
// End of Class */