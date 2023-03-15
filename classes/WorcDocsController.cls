public with sharing class WorcDocsController {

    public String accessToken {get;set;}
    public String state {get;set;}
    public String AuthorizationCode{get;set;}
    public String refreshToken{get;set;}
    public String WorkdocsUserId{get;set;}
    public String WorkdocsOrganizationId{get;set;}
    public Workdocs_Connection__c a{get;set;}
   

    public WorcDocsController(){
       
        
        list<Workdocs_Connection__c> a1=new list<Workdocs_Connection__c>();
        a1=[select id, Access_Token__c, Application_Id__c, Redirect_Url__c, State__c,User__c,Workdocs_UserId__c from Workdocs_Connection__c where User__c= :userinfo.getuserid() limit 1];
        
        if(a1.size()!=0){
        a=a1[0];
        }
        else{
        a=new Workdocs_Connection__c();
        }
        
        AuthorizationCode = apexpages.currentpage().getparameters().get('auth_code');
        state = apexpages.currentpage().getparameters().get('region');
        
        if(AuthorizationCode != null && AuthorizationCode != ''){
        
            HttpRequest httpRequest3 = new HttpRequest();
            httpRequest3.setEndpoint('https://workdocs.'+state+'.amazonaws.com/api/v1/token');
            httpRequest3.setHeader('Content-Type', 'application/json');
            httpRequest3.setBody('{\"Code\": \"'+AuthorizationCode+'\"}');
            //httpRequest3.setHeader('X-HTTP-Method-Override','PATCH');
            httpRequest3.setMethod('POST');
               
            Http http3 = new Http();
            HttpResponse response3 = http3.send(httpRequest3);
            System.debug('FileStatus 3:'+response3.getStatusCode());
            System.debug('FileBody 3:'+response3.getBody());
            Map <String, Object> root = (Map <String, Object>) JSON.deserializeUntyped(response3.getBody());
            
            accessToken = string.valueof(root.get('AccessToken'));
            refreshToken = string.valueof(root.get('RefreshToken'));
            
            Map <String, Object> userData = (Map <String, Object>)root.get('User');
            if(userData != null){
                WorkdocsUserId = string.valueof(userData.get('Id'));
                WorkdocsOrganizationId = string.valueof(userData.get('OrganizationId'));
            }
        
        }
        
        
        if(accessToken != null && accessToken != ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Access token generated successfully..! Please save access token in your salesforce org.'));
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Access token not generated, Please connect once again.'));
        }
        
    }
    
    public pagereference connect(){
        pagereference p = new pagereference('/apex/workdocsSetupPage');
        return p;
    }
    
    public pagereference save(){
    
       list<Workdocs_Connection__c> scheduleWDClst=new list<Workdocs_Connection__c>();
        scheduleWDClst=[select id, Access_Token__c, Application_Id__c, Redirect_Url__c, State__c,User__c,Workdocs_UserId__c from Workdocs_Connection__c Where Scheduled__c=true limit 1];
        if(scheduleWDClst.size()==0){
        
        
         ScheduleforRefreshAccessToken sched = new ScheduleforRefreshAccessToken();
         String cronExp = '0 0 * * * ?';
        String cronExp2 = '0 30 * * * ?';  // for run every 30 minutes
        String jobID = System.schedule('Schedule Job', cronExp, sched);
        String jobID2 = System.schedule('Schedule Job2', cronExp2, sched);
            if(schema.SobjectType.Workdocs_Connection__c.Fields.Scheduled__c.isUpdateable()){ 
                a.Scheduled__c=true;
            }
       }
        if(schema.SobjectType.Workdocs_Connection__c.Fields.Access_Token__c.isUpdateable()){
            a.Access_Token__c = accessToken;
        }
        if(schema.SobjectType.Workdocs_Connection__c.Fields.state__c.isUpdateable()){ 
            a.state__c = state;}
         if(schema.SobjectType.Workdocs_Connection__c.Fields.Authorization_Code__c.isUpdateable()){
             a.Authorization_Code__c = AuthorizationCode;}
         if(schema.SobjectType.Workdocs_Connection__c.Fields.Refresh_Token__c.isUpdateable()){
             a.Refresh_Token__c = refreshToken;}
         if(schema.SobjectType.Workdocs_Connection__c.Fields.Workdocs_UserId__c.isUpdateable()){
             a.Workdocs_UserId__c=WorkdocsUserId;}
        if(schema.SobjectType.Workdocs_Connection__c.Fields.WD_Org_Id__c.isUpdateable()){ 
            a.WD_Org_Id__c=WorkdocsOrganizationId;}
        //a.User__c = userinfo.getuserid();
        if(Schema.sObjectType.Workdocs_Connection__c.isUpdateable()){
            update a;}
        
        //togetWorkDocsUserId(accessToken,state);
        
        
        
        pagereference p = new pagereference('/apex/workdocsSetupPage');
        return p;
    }
/*    
    @future(callout=true)
    public static void togetWorkDocsUserId(String accessToken,String state){
     
        String token = 'Bearer '+ accessToken ;
        HttpRequest httpRequest1 = new HttpRequest();
        httpRequest1.setEndpoint('https://workdocs.'+state+'.amazonaws.com/api/v1/me');
        httpRequest1.setHeader('Authentication', token);
        httpRequest1.setMethod('GET');
           
        Http http1 = new Http();
        HttpResponse response1 = http1.send(httpRequest1);
        Map <String, Object> UsersMap = (Map <String, Object>) JSON.deserializeUntyped(response1.getBody());
        Map<String,Object> UsersMap1 = (Map<String,Object>) UsersMap.get('User');
        
        string WorkDocUserId='';
        string WorkDocsOrgId='';
        WorkDocUserId=string.valueof(UsersMap1.get('Id'));
        WorkDocsOrgId=string.valueof(UsersMap1.get('OrganizationId'));
        System.debug('======WorkDocsOrgId=='+WorkDocsOrgId);
        
        Workdocs_Connection__c aa=[select id, Access_Token__c, Application_Id__c, Redirect_Url__c, State__c,User__c,Workdocs_UserId__c from Workdocs_Connection__c where User__c= :userinfo.getuserid() limit 1]; 
        aa.Workdocs_UserId__c=WorkDocUserId;
        aa.WD_Org_Id__c=WorkDocsOrgId;
        update aa;
       
    
    }
 */
}