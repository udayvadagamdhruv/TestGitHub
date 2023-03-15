public with sharing class BillboardDetailPageMapExt {


   /* Public Billboard__c BBId {get;set;}
    Public Billboard__c BB {get;set;}
    Public String centerLat{get; set;}
    Public String centerLang{get; set;}

    public BillboardDetailPageMapExt(ApexPages.StandardController controller) {
    
    this.BBid=(Billboard__c)controller.getrecord();
     
      BB=[select id, name,Longitude__c, Latitude__c,Client_Name__c,Client_Name__r.Name ,Client_Name__r.Longitude__c,Client_Name__r.Latitude__c from Billboard__c where id=:ESAPI.encoder().SFDC_HTMLENCODE(ApexPages.CurrentPage().getParameters().get('id'))];
      centerLat = BB.Latitude__c ;
      centerLang = BB.Longitude__c ;
    

    }
*/
}