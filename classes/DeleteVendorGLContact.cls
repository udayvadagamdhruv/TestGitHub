public with sharing class DeleteVendorGLContact {
     public boolean isError{get;set;}
    private Id vendorId;
    private final Vendor_GL_Code__c objVC;
    public DeleteVendorGLContact(ApexPages.StandardController con) {
        this.objVC=(Vendor_GL_Code__c)con.getrecord();
         vendorId = [Select Id, Vendor__c from Vendor_GL_Code__c where Id =:objVC.Id limit 1].Vendor__c;

    }
    public PageReference CheckDelete(){
        Database.delete(objVC);
        PageReference p =  new Pagereference('/apex/VendorListViewSwitchPage?id='+vendorId+'&section=GLCode'); 
        p.setRedirect(true);
        return p; 
    }
}