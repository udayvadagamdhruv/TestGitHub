public with sharing class VendorListViewExt {

    Public boolean ShowBBS{get;set;}
    Public Vendor__c v{get;set;}
    public VendorListViewExt(ApexPages.StandardController controller) {
    
    this.v=(Vendor__c)controller.getrecord();
    
    List<Billboard__c> objBB = [SELECT id, name,BB_Vendor__c,Client_Name__c FROM Billboard__c limit 1];
      If(objBB.size()>0)ShowBBS=true;
 
    }

}