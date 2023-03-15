public with sharing class Jobs_Workdocs_Under_Campaign_Controller {

/*
 public Workdocs_Connection__c wdc {set;get;}
 public list<Job__c> JobsUnderCmp {set;get;}
 public string Cmpid;
 

 public  Jobs_Workdocs_Under_Campaign_Controller(){
     String [] workdocsFileds = new String [] {'Access_Token__c','Application_Id__c','Redirect_Url__c','Workdocs_UserId__c','State__c','User__c','WD_Org_Id__c','Site_Name__c'};
     Map<String,Schema.SObjectField> m = Schema.SObjectType.Workdocs_Connection__c.fields.getMap();
     for (String fieldToCheck : workdocsFileds) {
       // Check if the user has  access on the each field
       if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                                                   'Insufficient access'));         
        }
     }

   list<Workdocs_Connection__c > Wdclist=[select id, Access_Token__c, Application_Id__c, Redirect_Url__c, Workdocs_UserId__c, State__c, User__c,WD_Org_Id__c, Site_Name__c from Workdocs_Connection__c where State__c != null and User__c = :userinfo.getuserid()  limit 1];
   Cmpid=Apexpages.currentpage().getparameters().get('Id');
   //wdc=Workdocs_Connection__c();
   //JobsUnderCmp=new list<Job__c>();
   JobsUnderCmp=[select id,Name,Workdocs_Folder_Id__c,Campaign__c from Job__c where Campaign__c=:Cmpid and Workdocs_Folder_Id__c!=null];
   
   if(Wdclist.size()==1){
      wdc=Wdclist[0];
  
     String token='Bearer '+wdc.Access_Token__c;
     for(Job__c jb:JobsUnderCmp){
         HttpRequest hreq1=new HttpRequest();
         hreq1.setEndpoint('https://workdocs.'+wdc.State__c+'.amazonaws.com/api/v1/folders/'+jb.Workdocs_Folder_Id__c+'/contents');
         hreq1.setHeader('Authentication',token);
         hreq1.setMethod('GET');
         
         http ht1=new http();
         httpResponse hres1=ht1.send(hreq1);
         if(hres1.getStatusCode()==200){
             System.debug('==Response==='+hres1);
             System.debug('==Response Body==='+hres1.getBody());
          }
         
      }
   }
       
 }*/

}