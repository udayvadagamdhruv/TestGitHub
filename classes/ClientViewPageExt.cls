public with sharing class ClientViewPageExt {

  /* Public boolean ShowBBS{get;set;}
    Public Client__c v{get;set;}
    Public boolean showMap{get;set;}
    public ClientViewPageExt(ApexPages.StandardController controller) {
    
        this.v=(Client__c)controller.getrecord();
        
        List<Billboard__c> objBB = [SELECT id, name,BB_Vendor__c,Client_Name__c FROM Billboard__c limit 1];
        If(objBB.size()>0)ShowBBS=true;
        
        ClientControl__c  activeSettings = ClientControl__c.getOrgDefaults();
        showMap = activeSettings.Detail_Page_Map__c;
 
    }*/

}