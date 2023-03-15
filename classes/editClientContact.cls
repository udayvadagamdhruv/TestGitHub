// Extension Class for Edit Client Contact
public with sharing class editClientContact
{
  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     }  
            
        

    // Global Variables
    private final Client_Contact__c objContact;
    public string strUserName{get;set;}
    public string strEmail{get; set;}
    //added by Rahul for Role dropdown on 10th June 2014 
    public String RoleId;
    public String getRoleId() { return RoleId; }
    public void setRoleId(String p) {  this.RoleId = p; }
    public Client_Contact__c objClC{get;set;}
    //added var ends here
    // End of Global Variables 

    // Standard Controller Extension
    public editClientContact(ApexPages.StandardController con)
    {
      this.objContact=(Client_Contact__c)con.getrecord();
    //  if(this.objContact.UserName__c == '')
    //    this.objContact.UserName__c = this.objContact.Email__c; 
         strUserName = this.objContact.UserName__c;
        system.debug('111111'+strUserName);
        
      if( strUserName == null)
       {  
         this.objContact.UserName__c =   this.objContact.Email__c;
        system.debug('222222'+strUserName);
       }
       
        objClC = [SELECT id, name,UserName__c, Client_Contact_Role__c FROM Client_Contact__c WHERE id =: objContact.id];
        String st1 = objClC.Client_Contact_Role__c;
        if(String.isNotBlank(st1))
        {
            UserRole ur=[Select Name from UserRole where Name =: st1];
            RoleId = ur.id;
        }
        
       
        
       /* else
        {
            strUserName = this.objContact.UserName__c;
            system.debug('******'+strUserName);
            }*/
    }
    // End of Standard Controller Extension
    
    // This method is called on to populate Roles from Organization
    public List<selectOption> getRole()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
          for (UserRole roles :[SELECT Id,Name FROM UserRole ORDER BY Name])  
          {    
                options.add(new selectOption(roles.Id,roles.Name)); //for all records found - add them to the picklist options
          }
        return options; //return the picklist options
    }
    // End of method getRole
    
    // Method called on to update client contact
    
    
     Public PageReference saveme()
    {
        String strid;
        strid = objContact.Client__c;
        try 
        {
            //Added code by Rahul on 10th June 2014
            if(String.isNotBlank(RoleId))
            {
                UserRole u=[Select Id,Name from UserRole where Id=:RoleId];
                String uName=u.Name;
                objContact.Client_Contact_Role__c = uName;
            }
            else
            {
                objContact.Client_Contact_Role__c = '';
            }
            //Added code ends here
            
            objContact.Name=objContact.First_Name__c+' '+objContact.Last_Name__c;
            
           // if(strUserName != null)
           // {
             // objContact.UserName__c = strUserName;
           //   }
            //  else
             // {
              //  objContact.UserName__c = objContact.Email__c;
             // }
            update objContact;
           
           /* 
            if(objContact.Salesforce_User__c==True)
            {
                String email=objContact.Email__c;
                String fName=objContact.First_Name__c;
                String lName=objContact.Last_Name__c;
                String alias=(objContact.First_Name__c).subString(0,3)+' '+(objContact.Last_Name__c).subString(0,1);
            
                boolean active=objContact.Active__c;
                boolean salesforceUser=objContact.Salesforce_User__c;
                updateCurrentUser(email,fName,lName,alias,active);
            }
            */
       }
        catch(System.DMLException e)
         {
           Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,''+e.getMessage()));
            return null; 
         }
         
         // After editing Navigate to the Client record 
         if(isLtng)
         {
           PageReference p =  new Pagereference('/apex/ClientViewPageLightning?id='+strid);
            p.setRedirect(true);            return p;
         
         
         }
        else
            {
            PageReference p =  new Pagereference('/apex/ClientViewPage?id='+strid);
            p.setRedirect(true);            return p;
            }
    }
    
    /*
    // This method is used to update associated User
    
    @future
    public static void updateCurrentUser(String email,String fname,String lname,String alias,boolean active)
    {
        User u=[Select Id from User where Username=:email];
        u.Email=email;
        u.Username=email;
        u.FirstName=fname;
        u.LastName=lname;
        u.alias=alias;
        try
        {
            update u;
        }
        catch(System.DMLException e)
        {
             
        }
    }
    */
/*    
    // Test Coverage
    static testMethod void Test_editClientContact()
    {
        
        Client__c testAC=new Client__c(Name='Test Account 1050');
        try
        {
            insert testAC;
        }
        catch(System.DMLException e)
        {
            System.assertEquals('MIXED_DML_OPERATION',e.getDmlStatusCode(0));
        }    
        
        Client_Contact__c testC=new Client_Contact__c(Client__c=testAC.id,Name='Test AFR',First_Name__c='Test',Last_Name__c='AFR',Email__c='testContactAFR@SFDC.com',UserName__c='testContactAFR@SFDC.com',Salesforce_User__c=True);
        
            insert testC;
            
      /*
        User u1 = new User(FirstName = 'Test',
                           LastName = 'AFR',
                           Email = 'testContactAFR@SFDC.com',
                           Username='testContactAFR@SFDC.com',
                           ProfileId=p.Id,
                           Alias='test',
                           emailencodingkey='UTF-8',
                           languagelocalekey='en_US',
                           localesidkey='en_US',
                           timezonesidkey='America/Los_Angeles');
        insert u1;
        */    
       
        /*
        ApexPages.CurrentPage().getParameters().put('id',testC.id);
    
         // Instantiate the standard controller with the Client Contact
        ApexPages.StandardController con=new ApexPages.StandardController(testC);
        
        // Instantiate the extention instance with the standard controller
        editClientContact ext=new editClientContact(con);
        
        try
        {
            ApexPages.Pagereference result=ext.saveme();
        }
         catch(System.DMLException e)
        {
            System.assertEquals('MIXED_DML_OPERATION',e.getDmlStatusCode(0));
        }   
        
        delete testC;
        try
        {
          ApexPages.Pagereference result1=ext.saveme();
        }
         catch(System.DMLException e)
        {
            System.assertEquals('MIXED_DML_OPERATION',e.getDmlStatusCode(0));
        }       
   } 
    // End of Test Coverage
*/
}
// End of Class