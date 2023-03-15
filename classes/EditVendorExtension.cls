// Extension Class for EditVendor 
public with sharing  class EditVendorExtension 
{/*
    // Global Variables
    private final Vendor__c objV;
     String strid,strid1;
    // End of Global variables 

    // Standard Controller Constructor
    public EditVendorExtension(ApexPages.StandardController con) 
    {
       if (!Test.isRunningTest()) {
        list<string> FSetFields = new list<string>();
        for(Schema.FieldSetMember f:sObjectType.Vendor__c.FieldSets.Vendor_Field_Sets.getFields()){
            FSetFields.add(f.getFieldPath());
        }
        con.addFields(FSetFields);
       } 
       this.objV=(Vendor__c)con.getrecord();
       
        
       
       
    }
    // End of Standard Controller Constructor 
   
    // Method called on to Update Vendor  
  Public PageReference saveme()
    {
        try
        {
            update objV;
            strid = objV.id;
        }
        catch(System.DMLException e)
        {
            return null;
        }
         // After updating the Vendor navigate to the Vendor Detail Page 
        PageReference p =  new Pagereference('/apex/VendorListViewSwitchPage?id='+strid);
        p.setRedirect(true);
        return p; 
    }  
    // End of Method Update Vendor 
  
    // Method called on to handle Cancel button 
    Public PageReference cancelme()
    {
       PageReference p =  new Pagereference('/apex/VendorTabOverride');
       p.setRedirect(true);
       return p;
    } 
    // End of Cancel Method */

   
}// End of Class