/* This class is used to insert Vendor Contact Record */
public with sharing class CreateNewVendorContactController 
{
  /*  public Id VendorId;
    private final Vendor_Contact__c vendor_contact;
    public String RoleId;
    public String getRoleId() { return RoleId; }
    public void setRoleId(String p) {  this.RoleId = p; }
    
    
    public CreateNewVendorContactController(ApexPages.StandardController controller)
    {
        this.vendor_contact=(Vendor_Contact__c)controller.getrecord();
        String theId=ApexPages.CurrentPage().getParameters().get('vid');
        if(theId != null && theId != '')
        vendor_contact.Vendor__c = theId;
    } 
    
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
    
    public PageReference saveme()
    {
    String strid;
    strid=vendor_contact.Vendor__c;
     try
      {
          
          
          System.debug('RoleId ---------> ' + RoleId );
          if(String.isNotBlank(RoleId))
          {
              UserRole u=[Select Id,Name from UserRole where Id=:RoleId];
              String uName=u.Name;
              if (Schema.sObjectType.Vendor_Contact__c.fields.Role__c.isCreateable()) {
                  vendor_contact.Role__c = uName;}
          }
          else
          { 
              if (Schema.sObjectType.Vendor_Contact__c.fields.Role__c.isCreateable()) {
              vendor_contact.Role__c = '';}
          }
          if (Schema.sObjectType.Vendor_Contact__c.fields.Name.isCreateable()) {
              vendor_contact.Name = vendor_contact.First_Name__c +' '+vendor_contact.Last_Name__c;}
         if(Schema.sObjectType.Vendor_Contact__c.isCreateable()){
             insert vendor_contact;}
      }
      catch(System.DMLException e)
      {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+e.getMessage()); 
             ApexPages.addMessage(myMsg);
          return null;
      }
      PageReference p=new PageReference('/apex/VendorListViewSwitchPage?id='+strid+'&section=VendorContact');
      p.setRedirect(true);
      return p;
    }
    
    public PageReference cancelme()
    {
        String strid;
        strid=vendor_contact.Vendor__c;
        
          PageReference p=new PageReference('/apex/VendorListViewSwitchPage?id='+strid+'&section=VendorContact');
          p.setRedirect(true);
          return p;
          
    }
    
    
   
    
/* Positive Test Case*/
/*
        static testMethod void Test_CreateNewVendorContactController()
         {
             Vendor__c testVendor=new Vendor__c(Name='Test Vendor9901',Email__c='abc@gmail.com',Zip__c='12345');
               try
               {
                   insert testVendor;
               }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Vendor with same name Exists'));
               }
               
              Vendor__c testVendorerror=new Vendor__c(Name='Test Vendor9901',Email__c='abc@gmail.com',Zip__c='12345');
               try
               {
                   insert testVendorerror;
               }
               catch(System.DMLException e)
               {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
             Vendor_Contact__c testVC=new Vendor_Contact__c(Vendor__c=testVendor.Id,First_Name__c='Tom',Last_Name__c='Cruise',Email__c='abcde9@gmail.com');
           
            ApexPages.StandardController con=new ApexPages.StandardController(testVC);
            ApexPages.currentPage().getParameters().put('Id',testVC.Id);
          
        
            /* Instantiate the extention instance with the standard controller */
            
//remove this            CreateNewVendorContactController   ext=new CreateNewVendorContactController(con);
        
            /* Invoke the primary method on the extension */
            
          
//remove this            ApexPages.PageReference result1=ext.saveme();
           
/*//remove this
            Vendor_Contact__c testVendor1=new Vendor_Contact__c();
               try
               {
                   ApexPages.StandardController con1=new ApexPages.StandardController(testVendor1);
                    CreateNewVendorContactController   ext1=new CreateNewVendorContactController(con1);
                   ApexPages.PageReference result2=ext1.saveme();
               }
               catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
         }    
        /* End of Positive Test Case*/    
    
}
// End of Class