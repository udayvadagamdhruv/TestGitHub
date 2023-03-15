public with sharing class EditTimesheetEntryLightningExt {

public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  

public boolean showTaskSelectList {set;get;}
public Timesheet_Entries__c TSEntry {set;get;}
public Id jobId{get;set;}
public string jobname {set;get;}
public string selectedTask {set;get;}
//public list<String> Usernames {set;get;}

private Id GLCodeId;
private String GLCodeVal; 
private List<Job_Task__c> objTask;

Public String UserWhrCondi{Set;Get;}
Public Id UserID{set;get;}
Public list<string> UFields{set;get;}
Public string CompUser{set;get;}

 Public Map<id,string> taskmap {get;set;}  
 
 public string TSEdit{
        get;
        set;
    }

  public EditTimesheetEntryLightningExt(ApexPages.StandardController controller) {
  
  TSEdit= apexpages.currentpage().getparameters().get('TSEdit');
  
  showTaskSelectList=false;
    UserWhrCondi = 'Where IsActive=true and Name NOT  IN (\'Automated Process\',\'jobsuite Site Guest User\')';
    this.TSEntry=(Timesheet_Entries__c)controller.getRecord();
    TSEntry=[select id,name,Hours_Worked__c,Job__c,GL_Code__c,GL_Code__r.name,Date__c,User__c,Task_Name__c from Timesheet_Entries__c where id=:TSEntry.id];
    jobId=TSEntry.Job__c;
    
   //UserID=TSEntry.User__c;
    
    Job__c objJob=[Select id,name,JS_Client__r.name,Job_Auto_Number__c  from Job__c where id=:jobId ];
    jobname=objJob.Job_Auto_Number__c+' - '+objJob.name; 
  

    list<Job_Task__c> jTask=[select id,name from Job_Task__c where name=:TSEntry.Task_Name__c  and job__c=:jobid limit 1];
     if(jTask.size()>0){
     selectedTask=jTask[0].id;
     showTaskSelectList=true;
     }
     
   
    
      taskmap=new Map<id,string>();
      List<Job_Task__c> objJobTasklist=[Select Id, Name from Job_Task__c where Job__c =:jobId order by Task_Order__c,CreatedDate];
        for(Job_Task__c obj : objJobTasklist){
        taskmap.put(obj.id,obj.name);
        
        }
        UFields=new list<String>{'email'}; 
     
      
      list<user> u=[select id,name from User where id=:TSEntry.User__c limit 1];
      if(u.size()>0){
     CompUser=u[0].name;
      }
     
    
      
        
    }


  public list<SelectOption> getTaskName(){
  taskmap=new Map<id,string>();
  list<SelectOption> tasklist=new list<SelectOption>();
  tasklist.add(new SelectOption('','-None-'));
  for(Job_Task__c JTask:[Select Id, Name, CreatedDate,Task_Order__c from Job_Task__c where Job__c =:jobid order by Task_Order__c,CreatedDate]){
   tasklist.add(new SelectOption(JTask.id,JTask.name));
   taskmap.put(JTask.id,JTask.name);
  }
  return tasklist;
  
 }

 public String getGlCodeofTask(){
 
 if(showTaskSelectList){
 
 if(string.valueof(selectedTask) <> '' || string.valueof(selectedTask ) != NUll){
         objTask = [Select GL_Code__c, GL_Code__r.Name from Job_Task__c  where Id=:selectedTask and Job__c=:jobid limit 1];
           if(objTask.size()>0){
            for(Job_Task__c objTemp:objTask){
                    if(string.valueof(objTemp.GL_Code__c)<>'' || string.valueof(objTemp.GL_Code__c)<>null){
                        GLCodeId = objTemp.GL_Code__c;
                        GLCodeVal = string.valueof(objTemp.GL_Code__r.Name);
                       
                    }
                    else{
                        GLCodeVal= '';
                    }
                }
               }
               else{
                 GLCodeVal= '';
                 }           
            }
        else{
            GLCodeVal = '';
        }
       
        return GLCodeVal;
 
 }
 
 else{
 GLCodeId =TSEntry.GL_Code__c;
 GLCodeVal=TSEntry.GL_Code__r.Name;
 return GLCodeVal; 
 }
 
 }
 
 
 public pageReference Save(){
 
  pageReference  pg;
 try{
      if(jobname =='' || jobname == Null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must select the Job Name ');
            ApexPages.addMessage(myMsg);
            return null;        
        }
        
        if(selectedTask == '' || selectedTask == Null && showTaskSelectList){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' You must select Task Name');
            ApexPages.addMessage(myMsg);
            return null;                
        }
        
        if(TSEntry.Date__c== Null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' Please enter date ');
            ApexPages.addMessage(myMsg);
            return null;                
        }
        
       else{
         TSEntry.job__c=jobid;
         if(showTaskSelectList){
         TSEntry.Task_Name__c=taskmap.get(selectedTask);
         }
         else{
         TSEntry.Task_Name__c=TSEntry.Task_Name__c;
         }
         TSEntry.GL_Code__c=GLCodeId;
         
          if(isLtng && UserId!=null){  
          // if(!Usernames.Contains(CompUser)){  
           //  Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,+'Users Not Found With This Name'));
            //  return null;
             //}
            // else{
              user u1=[select id,name from User where id=:UserId];
              TSEntry.User__c=u1.id;
           //  }
            }
             
         update TSEntry;
       }
 
 }
  catch(System.DMLException e){
    Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,''+e.getMessage()));
    return null;
  }
 
 
   
 
    String th = userinfo.getUiTheme();
        if(th == 'Theme4t')
        {
            // pg =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobid+'&tab=RelatedList'+'&section=timesheet');
            
              if(TSEdit=='JobDetail')          
                 pg =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobid+'&tab=RelatedList'+'&section=timesheet');
              else
                //  pg =  new Pagereference('/'+TSEntry.id);
                pg =  new Pagereference('/apex/TimesheetTabOverrideMobile');
            
            
        }
        else if(th == 'Theme4d')
        {
           pg =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobid+'&section=jobtime');
        }
        else
        {
           pg =  new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=15');
        }
        pg.setRedirect(true);
        return pg;
  
 }


 public pagereference cancel(){
 
 // Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,'Useid'+userId));
  //Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,'cmuser'+CompUser));
 
 pageReference  pg;
 String th = userinfo.getUiTheme();
      if(th == 'Theme4t')
        {
              if(TSEdit=='JobDetail')          
                 pg =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobid+'&tab=RelatedList'+'&section=timesheet');
              else
               //   pg =  new Pagereference('/'+TSEntry.id);
                pg =  new Pagereference('/apex/TimesheetTabOverrideMobile');
                 // pg=new Pagereference(ApexPages.currentPage().getParameters().get('retURL'));
            
        }
        else if(th == 'Theme4d')
        {
           pg =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobid+'&section=jobtime');
        }
        else
        {
           pg =  new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=15');
        }
        pg.setRedirect(true);
        return pg;
        
   
    //return null; 
 }


 

 

}