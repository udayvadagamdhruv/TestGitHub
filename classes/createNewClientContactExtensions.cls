// This class is used to create new Client Contact Record
public with sharing class createNewClientContactExtensions {

    // Global variables
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     }  
    private Client_Contact__c objCC;
    public String clientId{get;set;}
    public String RoleId;
    public String getRoleId() { return RoleId; }
    public void setRoleId(String p) {  this.RoleId = p; }
    
    // End of Global variables
    
    // Start constructor
    public createNewClientContactExtensions(ApexPages.StandardController controller) 
    {
        this.objCC=(Client_Contact__c)controller.getRecord();
        Id cid = apexpages.currentpage().getparameters().get('cid');
       // Id cidcls= apexpages.currentpage().getparameters().get('CF00N3600000JN4GW_lkid');
        if(isLtng){
        objCC.Client__c = cid;
        }
         clientId=objCC.Client__c;
        
      
      // Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+cidcls));
    }
    // End of Constructor
    
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
    
    // This method is called on to save client contact
    public pagereference saveme()
    {
        try
        {
            if(String.isNotBlank(RoleId))
            {
                UserRole u=[Select Id,Name from UserRole where Id=:RoleId];
                String uName=u.Name;
                objCC.Client_Contact_Role__c = uName;
            }
            else
            {
                objCC.Client_Contact_Role__c = '';
            }

            objCC.Name=objCC.First_Name__c+' '+objCC.Last_Name__c;
            insert objCC;
        }
        catch(Exception e)
        {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+e.getMessage()); 
             ApexPages.addMessage(myMsg);
        
             return NULL;
        }  
        
        if(isLtng)
                {     
                   Pagereference p=new Pagereference('/apex/ClientViewPageLightning?id='+clientId);
                   p.setRedirect(true);
                   return p;
                }
                else
                {
                   Pagereference p=new Pagereference('/apex/ClientViewPage?id='+clientId);
                   p.setRedirect(true);
                   return p;
                }
    }
    // End of method save
    
    // This method is called on to handle Cancel button    
    public pagereference cancelme()
    {
       if(isLtng)
                {     
                   Pagereference p=new Pagereference('/apex/ClientViewPageLightning?id='+clientId);
                   p.setRedirect(true);
                   return p;
                }
                else
                {
                   Pagereference p=new Pagereference('/apex/ClientViewPage?id='+clientId);
                   p.setRedirect(true);
                   return p;
                }
    }
    // End of method Cancel
/*    
    // Start Test Coverage
    static testMethod void Test_createNewClientContactExtensions()
    {
        Client__c testClient = new Client__c(Name='Test Client 9897');
            insert testClient;
            
        System.assertEquals('Test Client 9897',testClient.Name);
        
        Client_Contact__c testCC = new Client_Contact__c(First_Name__c='Test Client', Last_Name__c='Contact' ,Name = 'Test Client Contact', Client__c=testClient.id,Email__c='testClientContact9897@SFDC.com');     
           
          // Instantiate the extention instance with the standard controller 
          
        ApexPages.StandardController con = new ApexPages.StandardController(testCC); 
        
         // Create the instance of a class
        createNewClientContactExtensions ext = new createNewClientContactExtensions(con);

            // Invoke the primary methodson the extension 
        ApexPages.Pagereference result = ext.saveme();
        
        ext.cancelme();
        
        // To cover catch block inside Saveme method
        delete testCC;
        
        result = ext.saveme();
    }// End of Test Coverage
    */
}// End of Class