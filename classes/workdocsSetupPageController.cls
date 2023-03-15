public with sharing class workdocsSetupPageController {

   public boolean accTokenExpire {set;get;}
    
    public Workdocs_Connection__c wdc{get;set;}
    public string baseUrl{get;set;}
    public string jobKeyPrefix {set;get;}
    Public string CampKeyPrefix {set;get;}
    
    public List<Workdocs_Connection__c> wdcList{get;set;}
    public List<Workdocs_Connection__c> wdcList1{get;set;}
    
    public workdocsSetupPageController(){
        
       // accessToken = apexpages.currentpage().getparameters().get('accessToken');
         
        jobKeyPrefix=Job__c.SObjectType.getDescribe().getKeyPrefix();
        CampKeyPrefix=Campaign__c.SObjectType.getDescribe().getKeyPrefix();
        
        wdcList = new List<Workdocs_Connection__c>();
        
        wdcList = [select id, Access_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c from Workdocs_Connection__c where State__c != null order by createddate asc limit 1];
        
        wdcList1 = new List<Workdocs_Connection__c>();
        
        wdcList1 = [select id, Access_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c  from Workdocs_Connection__c where User__c = :userinfo.getuserid() order by createddate asc limit 1];
        
        if(wdcList1.size() > 0){
          wdc = wdcList1[0];
          accTokenExpire=true;
          
       if(wdc.State__c!=null && wdc.Access_Token__c!=null){   
        String token = 'Bearer '+wdc.Access_Token__c;
        HttpRequest httpRequest1 = new HttpRequest();
        httpRequest1.setEndpoint('https://workdocs.'+wdc.State__c+'.amazonaws.com/api/v1/me');
        httpRequest1.setHeader('Authentication', token);
        httpRequest1.setMethod('GET');
           
        Http http1 = new Http();
        HttpResponse response1 = http1.send(httpRequest1); 
        
         
        if(response1.getStatus()!='Unauthorized' || response1.getStatusCode()!=401){
              accTokenExpire=false;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'You are successfully Connected to the WorkDocs. Please go to Job List View or Campaign List View'));
           }
         else{
            accTokenExpire=true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Access token Expired, Please connect once again.'));
         }  
        }    
            
      }
        else{
        
           accTokenExpire=true;
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Please connect to WorkDocs'));
           
            if(wdcList.size()==0){
                baseUrl = System.Url.getSalesforceBaseURL().toExternalForm();
                wdc = new Workdocs_Connection__c();
                if(schema.SobjectType.Workdocs_Connection__c.Fields.Redirect_Url__c.isUpdateable() && schema.SobjectType.Workdocs_Connection__c.Fields.Redirect_Url__c.isCreateable()){
                    wdc.Redirect_Url__c = baseUrl+'/apex/workdocs';
                }
            }
            else{
                baseUrl = System.Url.getSalesforceBaseURL().toExternalForm();
                wdc = new Workdocs_Connection__c();
                if(schema.SobjectType.Workdocs_Connection__c.Fields.Application_Id__c.isUpdateable() && schema.SobjectType.Workdocs_Connection__c.Fields.Application_Id__c.isCreateable()){
                    wdc.Application_Id__c = wdcList[0].Application_Id__c;
                }
                if(schema.SobjectType.Workdocs_Connection__c.Fields.Site_Name__c.isUpdateable() && schema.SobjectType.Workdocs_Connection__c.Fields.Site_Name__c.isCreateable()){
                    wdc.Site_Name__c = wdcList[0].Site_Name__c;
                }
                if(schema.SobjectType.Workdocs_Connection__c.Fields.Redirect_Url__c.isUpdateable() && schema.SobjectType.Workdocs_Connection__c.Fields.Redirect_Url__c.isCreateable()){
                    wdc.Redirect_Url__c = baseUrl+'/apex/workdocs';
                }
            }
        }
        
    }
    
    public pagereference SaveSettings(){
        if(schema.SobjectType.Workdocs_Connection__c.Fields.user__c.isUpdateable() && schema.SobjectType.Workdocs_Connection__c.Fields.user__c.isCreateable()){
            wdc.user__c = userinfo.getuserid();
        }
        if(Schema.sObjectType.Workdocs_Connection__c.isCreateable() && Schema.sObjectType.Workdocs_Connection__c.isUpdateable() ){
            upsert wdc;
        }
        pagereference p=new pagereference('https://auth.amazonworkdocs.com/oauth?app_id='+wdc.Application_Id__c+'&auth_type=AuthorizationCode&redirect_uri='+wdc.Redirect_Url__c+'&site_alias='+wdc.Site_Name__c+'&scopes=workdocs.content.read,workdocs.content.write,workdocs.profile.read,workdocs.admin.write,workdocs.activity.read');
        return p;    
    }
    
}