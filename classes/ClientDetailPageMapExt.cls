global with sharing class ClientDetailPageMapExt{

    Public Client__c ClientId {get;set;}
    Public Client__c CC {get;set;}
    Public String centerLat{get; set;}
    Public String centerLang{get; set;}
    
    
    
    
    public Map<Id,Billboard__c> bbMap {get; set;}
    
    public ClientDetailPageMapExt(ApexPages.StandardController controller) {
    
     this.Clientid=(Client__c )controller.getrecord();
     
      CC=[select id, name,Longitude__c, Latitude__c from Client__c  where id=:ESAPI.encoder().SFDC_HTMLENCODE(ApexPages.CurrentPage().getParameters().get('id'))];
      
      centerLat = cc.Latitude__c ;
      centerLang = cc.Longitude__c ;
     // Clientid12=cc.id;  
       
    }
    
    
    @RemoteAction
    global static List<Billboard__c> findAll(String Clientid12) {
    
       
          
   return [SELECT Id, Name, Longitude__c, Latitude__c FROM Billboard__c where Client_Name__c =:Clientid12];
                    
                    
    }
    
    
    }