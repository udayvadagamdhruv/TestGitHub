global with sharing class BatchClassforRefreshAccessToken implements Database.Batchable<Sobject>,   Database.AllowsCallouts {
    
    global list<Workdocs_Connection__c> Upd_Wdc_AcessToken=new list<Workdocs_Connection__c>();
   public string query='select id, Access_Token__c,Refresh_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c  from Workdocs_Connection__c where State__c!=null';
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator(query);
        //return null;
    }
    
    global void execute(Database.BatchableContext BC ,list<Workdocs_Connection__c> wdclst){
       
      if(wdclst.size()>0){
         for(Workdocs_Connection__c wdc:wdclst){
             
           if(wdc.Refresh_Token__c!=null){ 
               try{
                httprequest reqRefToken=new httprequest();
                reqRefToken.setEndpoint('https://zocalo.'+wdc.State__c+'.amazonaws.com/api/v1/token/refresh');
                reqRefToken.setHeader('Content-Type', 'application/json');
                reqRefToken.setBody('{\"RefreshToken\":\"'+wdc.Refresh_Token__c+'\"}');
                reqRefToken.setMethod('POST');
                
                http ht=new http();
                httpresponse res=ht.send(reqRefToken);
                
                   if(res.getStatusCode()==201){  
                       Map<String,Object> refreshmap=(Map<String,Object>)JSON.deserializeUntyped(res.getBody());
                       system.debug('==refresh body='+res.getBody());
                       
                       string acessToken=String.valueof(refreshmap.get('AccessToken'));
                       string refreshToken=String.valueof(refreshmap.get('RefreshToken'));
                       
                       system.debug('==Access Token='+acessToken);
                       system.debug('==refreshToken='+refreshToken);
                       if(schema.SobjectType.Workdocs_Connection__c.Fields.Access_Token__c.isUpdateable()){
                           wdc.Access_Token__c=acessToken;
                       }
                       Upd_Wdc_AcessToken.add(wdc);
                   }  
               }   
               
               catch(Exception e){
                  System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );  
               }   
            }  
          }
        }
        
        if(Upd_Wdc_AcessToken.size()>0){
            if(Schema.sObjectType.Workdocs_Connection__c.isUpdateable()) {
                update Upd_Wdc_AcessToken;
            }
        }
       
    }
    
    global void finish(Database.BatchableContext BC){
        
    }

}