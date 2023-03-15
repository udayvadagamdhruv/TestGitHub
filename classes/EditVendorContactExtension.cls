// Extension class for Edit Vendor Contact
public with sharing class EditVendorContactExtension 
{
    // Global Variables
  /*  private final Vendor_Contact__c objVC;
    //added by Rahul for Role dropdown on 12th June 2014 
    public String RoleId;
    public String getRoleId() { return RoleId; }
    public void setRoleId(String p) {  this.RoleId = p; }
    public Vendor_Contact__c objClC{get;set;}
    //added var ends here
    // End of Global variables 
 
    // Standard Controller Extension
    public EditVendorContactExtension(ApexPages.StandardController con) 
    {
        this.objVC=(Vendor_Contact__c)con.getrecord();

        objClC = [SELECT id, name, Role__c FROM Vendor_Contact__c WHERE id =: objVC.id];
        String st1 = objClC.Role__c;
        system.debug('st1 -----> ' + st1);
        if(String.isNotBlank(st1))
        {
            UserRole ur=[Select Name from UserRole where Name =: st1];
            RoleId = ur.id; 
        }
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
    
    // Method called on to update Vendor Contact*
     Public PageReference saveme()
    {
        String strid;
        strid = objVC.Vendor__c;
        try 
        {    
            //Added code by Rahul on 12th June 2014
            System.debug('RoleId ---------> ' + RoleId );
            if(String.isNotBlank(RoleId))
            {
                UserRole u=[Select Id,Name from UserRole where Id=:RoleId];
                String uName=u.Name;
                 if(schema.SobjectType.Vendor_Contact__c.Fields.Role__c.isUpdateable()){   objVC.Role__c = uName;}
            }
            else
            {
                   if(schema.SobjectType.Vendor_Contact__c.Fields.Role__c.isUpdateable()){ objVC.Role__c = '';}
            }
            //Added code ends here

           if(schema.SobjectType.Vendor_Contact__c.Fields.Name.isUpdateable()){ objVC.Name = objVC.First_Name__c +' '+objVC.Last_Name__c;}
           if(Schema.sObjectType.Vendor_Contact__c.isUpdateable()){update objVC;}
        }
         catch(System.DMLException e)
         {
             return null; 
         }
         // After updating Vendor Contact navigate to Vendor Detail page
        PageReference p =  new Pagereference('/apex/VendorListViewSwitchPage?id='+strid+'&section=VendorContact');
        p.setRedirect(true);
        return p;
    }
    // End of Update Method
/*
    // Test Coverage Code
        static testMethod void CreateNewVendorContactPositiveTest()
        {
           Vendor__c testVendor=new Vendor__c(Name='TestV100',Email__c='abc@gmail.com',Zip__c='12345');
               try
               {
                   insert testVendor;
               }
               catch(System.DMLException e)
               {
                  // System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
             Vendor_Contact__c testVC=new Vendor_Contact__c(First_Name__c='abc11',Last_Name__c='def11',Email__c='af@gmail.com',Vendor__c=testVendor.Id,Active__c=true,Phone_1__c='123456');
              try
              {
             insert testVC;
             System.debug('Vendor Contact record inserted successfully@@@ '+testVC);
              }
             catch(System.DMLException e)
             {
           //  System.assert(e.getMessage().contains('Vendor Contact with same name Exists'));
             }   
             Vendor_Contact__c objVC1 = [select Id,Name,First_Name__c,Vendor__c from Vendor_Contact__c where Id =: testVC.Id Limit 1];
             
             objVC1.First_Name__c='Steve'; 
             
             // Instantiate the standard controller with the  Vendor Contact
                   
             ApexPages.StandardController con=new ApexPages.StandardController(objVC1);
             
             ApexPages.currentPage().getParameters().put('Id',objVC1.Id);
          
            // Instantiate the extention instance with the standard controller
            
            EditVendorContactExtension   ext=new EditVendorContactExtension(con);
        
            // Invoke the primary method on the extension
           
            ApexPages.PageReference result1=ext.saveme();
            
            delete objVC1;
            result1=ext.saveme();
            
            Vendor__c testVendor1=new Vendor__c(Name='TestV100',Email__c='abc@gmail.com',Zip__c='12345');
               try
               {
                   insert testVendor1;
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
         }    
        // End of Test Coverage
*/
}// End of Class