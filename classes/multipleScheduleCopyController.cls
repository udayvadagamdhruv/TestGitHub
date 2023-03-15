public with sharing class multipleScheduleCopyController {

    //Global variables
    
    public boolean isLtng{
                         
                         private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                         }
    
    
    public Id Cpyid{get; set;}
    private Job__c RecJb{get; set;}
    public list<JobWrapper> jbWrap{get; set;}
      //Added By Navaneeth START
    public list<Staff__c> staffs;
    public list<Client_Contact__c> CCs;
    public list<Vendor_Contact__c> VCs;

    public Set<String> ClientNames=new set<String>();
    public Set<String> VendorNames=new set<String>();
    public Set<String> staffNames=new set<String>();
    //Added By Navaneeth  END
    //End of global variables
        
    public multipleScheduleCopyController() {
        jbWrap = new list<JobWrapper>();
        Cpyid = ApexPages.currentPage().getParameters().get('CpyId');
        system.debug('Cpyid is@@@ : ' + Cpyid );
        
         String query ='SELECT id,name,Active__c from Staff__c where Active__c=true and IsDeleted__c=False order by name';
        staffs = Database.query(query); 
        for(Staff__c s:staffs)
        {
          staffNames.add(s.name);
        }
        //Client__c=:clientid AND
        //Job__c =: Cpyid
       // String clientid = RecJb.Client__c;
        String query1 ='SELECT id,name,Active__c from Client_Contact__c Where Active__c=true   Order by name';
        CCs= Database.query(query1);   
        for(Client_Contact__c  s:CCs)
        {
          ClientNames.add(s.name);
        }   
            
        String query2 ='SELECT id,name,Active__c from Vendor_Contact__c where Active__c=true  order by name';
        VCs= Database.query(query2);
        for(Vendor_Contact__c  s:VCs)
        {
          VendorNames.add(s.name);
        } 
       
        
        jobCamp();
    }

    // Start Wrapper Class : This class will bind checkbox and its associated Job on layout
    public class JobWrapper{
         public Job__c varJb{get;set;}
         public Boolean varJbSelect{get;set;}
         public JobWrapper(){
             varJb = new Job__c();
             varJbSelect = false;
         }
     }   
     // End of Wrapper Class
     
     //Method to populate job list for Rescheduling tasks.
     public pageReference jobCamp(){
         RecJb = [SELECT id, Name, Status__c,Job_Auto_Number__c,Client__c, Campaign__c, Schedule_Calc__c, Start_Date__c, Due_Date__c,Schedule_Template__c FROM Job__c WHERE id =: Cpyid];
         for(Job__c loopJb : [SELECT id, Name, Job_Auto_Number__c,Status__c, Campaign__c, Schedule_Calc__c, Start_Date__c, Due_Date__c,Schedule_Template__c FROM Job__c WHERE Campaign__c =: RecJb.Campaign__c AND Status__c =:'Active' AND id <>: Cpyid]){
             JobWrapper varJobWrap = new JobWrapper();
             varJobWrap.varJb = loopJb;
             varJobWrap.varJbSelect = false;
             jbWrap.add(varJobWrap);
         }
         return null;
     }
     //Method ends here.
     
     public PageReference cancel() {
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+RecJb.Id);
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/JobListView?id='+RecJb.Id);
                p.setRedirect(true);
                return p;
        }
    }
    
    public PageReference saveRsc() {
        set<id> setJbId = new set<id>();
        list<Job_Task__c> lstJbTskDel = new list<Job_Task__c>();
        list<Job_Task__c> lstJbTask = new list<Job_Task__c>();
        list<Job_Task__c> lstJbTskInsrt;
        Job_Task__c tmpJbTsk = new Job_Task__c();
        
        //get all selected jobs
        for(JobWrapper tmpJbw : jbWrap){
            if(tmpJbw.varJbSelect == true){
                setJbId.add(tmpJbw.varJb.id);
            }
        }
        //code ends here
        
        //get all tasks of selected jobs
        lstJbTskDel = [SELECT Id, Name,Schedule_Roles__c, Hours__c,Job__c,Completion_Date__c, Days__c, GL_Code__c, Locked__c, Marked_Done__c, Due_Date__c, Report__c, Revised_Due_Date__c, Assigned_Users__c, Start_Date__c, Status__c, Task_Order__c FROM Job_Task__c WHERE Job__c IN : setJbId];
         //Delete existing job tasks for selected jobs
        if(lstJbTskDel.size() > 0){
            DELETE lstJbTskDel;
        }
        //code ends here
        
        //Get tasks and task roles of current job
        Set<Id> OldTaskId=new Set<Id>();
        lstJbTask = [SELECT Id, Name, Next_Task_Due__c,Job__c,Schedule_Roles__c,Hours__c,Completion_Date__c, Days__c, GL_Code__c, Locked__c, Marked_Done__c, Due_Date__c, Report__c, Revised_Due_Date__c, Assigned_Users__c, Start_Date__c, Status__c, Task_Order__c FROM Job_Task__c WHERE Job__c =: Cpyid];
        System.debug('List of Job tasks for current job -----> ' + lstJbTask);
        for(Job_Task__c varJbTsk : lstJbTask)
        {
                OldTaskId.add(varJbTsk.id);
        }
        List<Job_Task_Role__c> lstJTR=[Select id,Name,User__c,Job_Task__c from Job_Task_Role__c where Job_Task__c IN:OldTaskId];
        //code ends here
        
         Map<String,Id> mp1 = new Map<String,Id>();
         Map<Id,Id> mp2 = new Map<Id,Id>();
         
        
        //Copy current job tasks to selected jobs
        for(id varid : setJbId){
             lstJbTskInsrt = new list<Job_Task__c>();
            for(Job_Task__c varJbTsk : lstJbTask){
               // OldTaskId.add(varJbTsk.id);
               
                tmpJbTsk = new Job_Task__c();
                System.debug('Temporary task on instance creation ---> ' + tmpJbTsk);
                //Create new instace for copy task 
                tmpJbTsk.Job__c = varid;
                tmpJbTsk.Name = varJbTsk.Name;
                tmpJbTsk.Completion_Date__c = varJbTsk.Completion_Date__c;
                tmpJbTsk.Days__c = varJbTsk.Days__c;
                tmpJbTsk.GL_Code__c = varJbTsk.GL_Code__c;
                tmpJbTsk.Locked__c = varJbTsk.Locked__c;
                tmpJbTsk.Marked_Done__c = varJbTsk.Marked_Done__c;
                tmpJbTsk.Due_Date__c = varJbTsk.Due_Date__c;
                tmpJbTsk.Report__c = varJbTsk.Report__c;
                tmpJbTsk.Revised_Due_Date__c = varJbTsk.Revised_Due_Date__c;
               // tmpJbTsk.Assigned_Users__c= varJbTsk.Assigned_Users__c;
                tmpJbTsk.Start_Date__c= varJbTsk.Start_Date__c;
                tmpJbTsk.Status__c= varJbTsk.Status__c;
                tmpJbTsk.Schedule_Roles__c=varJbTsk.Schedule_Roles__c;
                tmpJbTsk.Hours__c=varJbTsk.Hours__c;
                tmpJbTsk.Task_Order__c= varJbTsk.Task_Order__c;
                tmpJbTsk.Next_Task_Due__c=varJbTsk.Next_Task_Due__c;
                System.debug('Temporary task ---> ' + tmpJbTsk);
                
                mp1.put(varJbTsk.Name,varJbTsk.id); //Navaneeth
                
                //insert new copied instance in list of tasks
                lstJbTskInsrt.add(tmpJbTsk);
                
            }
       
        
       
        //Insert new copied job tasks for selected jobs.
        if(lstJbTskInsrt.size() > 0)
        {
            INSERT lstJbTskInsrt;
            
            for(Job_Task__c jt : lstJbTskInsrt)
               {
                    mp2.put(mp1.get(jt.Name),jt.Id);
               }
               
       
        //code ends here
        
        //To Insert TaskRoles
        
          
        
        List<Job_Task_Role__c> insertJTR=new List<Job_Task_Role__c>();
                
              for(Job_Task_Role__c taskRole:lstJTR)
              {
                     if(staffNames.contains(taskRole.User__c) || ClientNames.contains(taskRole.User__c) || VendorNames.contains(taskRole.User__c)){
                     Job_Task_Role__c objJTR=new Job_Task_Role__c();
                     objJTR.Name=taskRole.Name;
                     
                     objJTR.User__c=taskRole.User__c;
                    
                     objJTR.Job_Task__c=mp2.get(taskRole.Job_Task__c);
                     insertJTR.add(objJTR);
                      }
              }
              if(insertJTR.size() > 0)
             insert insertJTR;
              
        
        }
        }
        //code ends here
        
         if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+RecJb.Id);
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/JobListView?id='+RecJb.Id);
                p.setRedirect(true);
                return p;
        }
    }
}