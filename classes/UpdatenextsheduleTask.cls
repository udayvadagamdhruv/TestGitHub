public with sharing class UpdatenextsheduleTask {
    
  /*  @future
    public static void UpdatenextsheduleTaskmethod(String jobid){   
        List<Job_Task__c> Tasksupdate1=new List<Job_Task__c> ();
        string taskid;  
        
        List<Job_Task__c>  CompletedTasks1=[select id, Next_Task_Due__c,Task_Order__c,name,Marked_Done__c from Job_Task__c where  Job__c =:jobid AND Marked_Done__c!=True WITH SECURITY_ENFORCED order by Task_Order__c  limit  1];
        if(CompletedTasks1.size() > 0 )for(Job_Task__c  jt:CompletedTasks1){
            taskid=jt.id;
            if(jt.Next_Task_Due__c!=true)
                if(Schema.sObjectType.Job_Task__c.fields.Next_Task_Due__c.isUpdateable()) {
                    jt.Next_Task_Due__c= True;}
            Tasksupdate1.add(jt);
        } 
        if(Schema.sObjectType.Job_Task__c.isUpdateable()){
            update Tasksupdate1;}*/
        
        /*  task1= CompletedTasks1.get(0);taskid=task1.id; // This two lines logic already in comments any way this method we are not using any where
if(task1.Next_Task_Due__c!=true)    task1.Next_Task_Due__c= True; update task1;*/
        
      /*  List<Job_Task__c> Tasks=[select id, Next_Task_Due__c,Task_Order__c,name,Marked_Done__c from Job_Task__c where  Job__c =:jobid WITH SECURITY_ENFORCED];
        List<Job_Task__c> Tasksupdate=new List<Job_Task__c> ();
        
        for(Job_Task__c ta:Tasks){
            
            if(ta.id!=taskid && ta.Next_Task_Due__c==True){
                if(Schema.sObjectType.Job_Task__c.fields.Next_Task_Due__c.isUpdateable()) {
                    ta.Next_Task_Due__c=False;}
                
                Tasksupdate.add(ta);
            }
        }
        if(Schema.sObjectType.Job_Task__c.isUpdateable()){
            Update Tasksupdate;}
    }   */
    
   @future
    public static void UpdatenextsheduleTaskmethod2(set<String> jobids,boolean MarkedDone){  
        try{
        system.debug('called');
        List<Job_Task__c> Tasksupdate1=new List<Job_Task__c> ();
        List<Job_Task__c> Tasksupdate=new List<Job_Task__c> ();
        List<Job_Task__c> CompletedTasks1=[select id,name,Next_Task_Due__c,Email__c,Task_Order__c,Marked_Done__c,Revised_Due_Date__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.name from Job_Task__c where  Job__c IN :jobids AND Marked_Done__c!=True WITH SECURITY_ENFORCED order by Task_Order__c limit  1];
        // new below line adding code for test exception
        //string ct = CompletedTasks1[0].Job__c;
        
        List<Job_Task__c> Tasks=[select id,name,Next_Task_Due__c,Task_Order__c,Email__c,Marked_Done__c from Job_Task__c where  Job__c IN :jobids WITH SECURITY_ENFORCED];
        system.debug('>>>>>>>>>>>>CompletedTasks1>>>>>>>>>>>>>'+CompletedTasks1);
        
        string taskid;
        
        if(CompletedTasks1.size() > 0 ){
            for(Job_Task__c  jt:CompletedTasks1){
                taskid=jt.id;
                if(jt.Next_Task_Due__c!=true)
                    if(schema.SobjectType.Job_Task__c.Fields.Next_Task_Due__c.isUpdateable()){ 
                        jt.Next_Task_Due__c= True;}
                Tasksupdate1.add(jt);
            } 
            if(Tasksupdate1.size() > 0){
                //Logic below two lines added for job timing status update 
                
                date finalduedate = CompletedTasks1[0].Revised_Due_Date__c;
                
                Job__c objJob=[Select id,name,Next_Tasks_Due__c,Job_Timing_Status__c,Due_Date__c from Job__c where Id=:CompletedTasks1[0].Job__c WITH SECURITY_ENFORCED limit 1];
                if(finalduedate >= system.today() &&  objJob.Due_Date__c >= system.today())
                {
                    objJob.Job_Timing_Status__c =  'On Track' ;
                }
                if(finalduedate < system.today() && objJob.Due_Date__c >= system.today()){
                    objJob.Job_Timing_Status__c =  'At Risk' ;  
                }
                if(objJob.Due_Date__c <= system.today() ){
                    objJob.Job_Timing_Status__c =  'Delayed' ;  
                }
                if(Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isCreateable() || Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isUpdateable()) {
                    objJob.Next_Tasks_Due__c = CompletedTasks1[0].name;
                }
                if(Schema.sObjectType.Job__c.isUpdateable())
                {
                   // update objJob;
                    system.debug('updated job === '+objJob.Next_Tasks_Due__c);
                }
            }    
        }
        
        /*  task1= CompletedTasks1.get(0);taskid=task1.id;
if(task1.Next_Task_Due__c!=true)    task1.Next_Task_Due__c= True; update task1;*/
        
        for(Job_Task__c ta:Tasks){
            if(ta.id!=taskid && ta.Next_Task_Due__c==True)
            {
                if(schema.SobjectType.Job_Task__c.Fields.Next_Task_Due__c.isUpdateable()){ 
                    ta.Next_Task_Due__c=False;}
                Tasksupdate.add(ta);
            }
        }
        if(Schema.sObjectType.Job_Task__c.isUpdateable()){
            update Tasksupdate1;
            Update Tasksupdate;
        }
        system.debug('>>>>>>>>>>>>Tasksupdate1>>>>>>>>>>>>>'+Tasksupdate1);  
        system.debug('>>>>>>>>>>>>Tasksupdate>>>>>>>>>>>>>'+Tasksupdate); 
               if(CompletedTasks1.size()>0 && MarkedDone){
            
            list<Job_Task_Role__c> tremlist=new  list<Job_Task_Role__c>();
            tremlist=[SELECT Id,Name,Job_Task__c,Email__c, User__c,Task_Final_Due__c FROM Job_Task_Role__c where Job_Task__c=:CompletedTasks1[0].id WITH SECURITY_ENFORCED]; 
            //string sender = CompletedTasks1[0].Email__c;
            //system.debug('==========sender emails======'+sender);  
            datetime finaldue = CompletedTasks1[0].Revised_Due_Date__c;
            system.debug('=======finaldue Date time instance========'+finaldue);  
            Date due = date.newinstance(finaldue.year(),finaldue.month(),finaldue.day());
            system.debug('=======due>= Date instance=='+due);  
            string due1= due.month()+'/'+due.day()+'/'+due.year();
            system.debug('>>>>>>>>>>>>formated date due1>>>>>>>>>>>>>'+due1);  
            
            //string[] split = sender.Split(',');
            list<string> emailList=new list<string>();
            for(Job_Task_Role__c a: tremlist)
            {
                emailList.add(a.Email__c);
            }
            system.debug('========emailList========'+emailList);
            
            if(emailList.size()>0){
                string pageUrl;
                String CSimageBody;
                Site_Request_Form_Settings__c siteSettings = Site_Request_Form_Settings__c.getOrgDefaults();
                CSimageBody= siteSettings.Org_URL__c;
                pageUrl=''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+CompletedTasks1[0].Job__c;
                system.debug('========pageUrl========'+pageUrl);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
                mail.setToAddresses(emailList);
                mail.setSubject('Task reminder for Job: '+CompletedTasks1[0].Job__r.name+' - #'+CompletedTasks1[0].Job__r.Job_Auto_Number__c);      
                mail.setUseSignature(false); 
                
                string body='<html><body><table border="0" style="padding:20px 250px 20px 250px" cellspacing="0"  height="100%" width="100%" bgcolor="#f5f8fa"><tr><td><div style="border:1px solid #831225;width:100%;min-width:100%;background-color:white;"><center><img src="'+CSimageBody+'" alt="JobSuite" width="120" height="50"></center></div><div style="width:100%;min-width:100%;border:1px solid #831225;border-top:0px solid #831225;background-color:white "><br/><br/><h1 style="font-size:24px;font-weight:600;margin:0;text-align:center"></h1><br/> <h2 style="font-size:18px;font-weight:500;margin:8px;text-align:center"> The task <b> "'+CompletedTasks1[0].name+'" </b>  on job #'+CompletedTasks1[0].Job__r.Job_Auto_Number__c+' ('+CompletedTasks1[0].Job__r.name+') is due on '+due1+'.'+'</h2><br/><br/> <hr style="height:2px;color:#eaf0f6;background-color:#eaf0f6;border:none;margin:0px 50px 0px 50px ;padding:0px"><br/><br/><center><a href="'+pageUrl+'" style="border-radius:5px;background-color:#425b76;color:#ffffff;display:inline-block;font-size:14px;font-weight:500;line-height:1;padding:10px 20px;text-decoration:none;width:auto;min-width:170px;white-space:nowrap" target="_blank">View Task</a></center><br/> <br/> </div> </td></tr></table></body></html>';
                //<html><body><table border="0" style="padding:20px 250px 20px 250px" cellspacing="0"  height="100%" width="100%" bgcolor="#f5f8fa"><tr><td><div style="border:1px solid #831225;width:100%;min-width:100%;background-color:white;"><center><img src="https://jsbaseorg-dev-ed--c.na7.content.force.com/servlet/servlet.ImageServer?id=015A0000002r67l&oid=00DA0000000Cir8&lastMod=1537962018000" alt="JobSuite" width="120" height="50"></center></div><div style="width:100%;min-width:100%;border:1px solid #831225;border-top:0px solid #831225;background-color:white "><br/><br/><br/> <h2 style="font-size:18px;font-weight:500;margin:4px;text-align:center">The task <b>"Concepts Due"</b> on job # 2314 (Green Day) is due on 08/14/2018.</h2><br/><br/> <hr style="height:2px;color:#eaf0f6;background-color:#eaf0f6;border:none;margin:0px 50px 0px 50px ;padding:0px"><br/><br/><center><a href="https://jsbaseorg-dev-ed--jobsuite.na7.visual.force.com/apex/JobdetailpageLightening07?id=a04A0000014jnFK&section=schedules" style="border-radius:5px;background-color:#425b76;color:#ffffff;display:inline-block;font-size:14px;font-weight:500;line-height:1;padding:10px 20px;text-decoration:none;width:auto;min-width:170px;white-space:nowrap" target="_blank">View Task</a></center><br/> <br/> </div> </td></tr></table></body></html>
                mail.setHtmlBody(body);
                
                ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
                boolean isEmailtoSend=activeSettings.Task_Remainder_Emails__c;
                System.debug('=====activeSettings===='+activeSettings.Task_Remainder_Emails__c);
                System.debug('=====activeSettings===='+isEmailtoSend);
                if(isEmailtoSend){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
                }
            }
        }  
    }
        catch(exception ex) {}  
    
    
   /* public static void UpdatenextsheduleTaskmethod3(set<String> jobids,boolean MarkedDone){
        if(MarkedDone == true){
            List<Job_Task__c> CompletedTasks1=[select id,name,Next_Task_Due__c,Email__c,Task_Order__c,Marked_Done__c,Revised_Due_Date__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.name from Job_Task__c where  Job__c IN :jobids and Marked_Done__c != true WITH SECURITY_ENFORCED order by Task_Order__c limit 1];
            if(CompletedTasks1.size() > 0 ){
                date finalduedate = CompletedTasks1[0].Revised_Due_Date__c;
                Job__c objJob=[Select id,name,Next_Tasks_Due__c,Job_Timing_Status__c,Due_Date__c from Job__c where Id=:jobids WITH SECURITY_ENFORCED limit 1];
                if(finalduedate >= system.today() &&  objJob.Due_Date__c >= system.today())
                {
                    objJob.Job_Timing_Status__c =  'On Track' ;
                }
                if(finalduedate < system.today() && objJob.Due_Date__c >= system.today()){
                    objJob.Job_Timing_Status__c =  'At Risk' ;  
                }
                if(objJob.Due_Date__c <= system.today() ){
                    objJob.Job_Timing_Status__c =  'Delayed' ;  
                }
                if(Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isCreateable() || Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isUpdateable()) {
                    objJob.Next_Tasks_Due__c = CompletedTasks1[0].name;
                }
                if(Schema.sObjectType.Job__c.isUpdateable())
                {
                    update objJob;
                    system.debug('updated job === '+objJob.Next_Tasks_Due__c);
                }
            }
        }
    }*/
    
    /*  public static void TaskRemainderNotiftication(Map<Id,Job_Task__c> OldTaskMap,Map<Id,Job_Task__c>NewTaskMap,set<string> jbIds){

List<Job_Task__c> RemaingTasks=[select id, Next_Task_Due__c,Email__c,Task_Order__c,name,Marked_Done__c,Revised_Due_Date__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.name from Job_Task__c where  Job__c IN :jbIds AND Marked_Done__c!=True order by Task_Order__c limit  1];
List<Job_Task__c> Tasks=[select id, Next_Task_Due__c,Task_Order__c,Email__c,name,Marked_Done__c from Job_Task__c where  Job__c IN :jbIds ];

System.debug('=================Old Taks============'+OldTaskMap.values());
System.debug('=================New  Taks============'+NewTaskMap.values());

}
*/
    

    }
    
    }