public with sharing class DuplicateCamaignExtension {

 public Campaign__c campObj {set;get;}
 public Campaign__c camp {set;get;}
 public string  OldcampId {set;get;}
 public string  DupcampId {set;get;}
 public string campName;
 public list<Job__c> jobsUnderCamp=new list<Job__c>();
 public list<Job__c> DupJobsInsert=new list<Job__c>();
 public list<Staff__c> staffs;
 public list<Client_Contact__c> CCs;
 public list<Vendor_Contact__c> VCs;
 public Set<String> ClientNames=new set<String>();
 public Set<String> VendorNames=new set<String>();
 public Set<String> staffNames=new set<String>();
 public Map<String,Set<String>> Client_ContactMap=new Map<String,Set<String>>();
 public list<ID> Clientlist=new list<ID>();
 Public Boolean ShowProductionEstimate{get;set;}
 public  boolean isError{get;set;}

    public DuplicateCamaignExtension(ApexPages.StandardController controller) {
    
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        system.debug('The activeSettings is '+activeSettings+'The activeSettings.Active__c is '+activeSettings.Active__c);
        ShowProductionEstimate =activeSettings.Active__c;
        isError=False;
        this.campObj=(Campaign__c)controller.getrecord();
        system.debug('The camp object is '+ this.campObj);
        OldcampId=ApexPages.currentpage().getParameters().get('id');
        camp=[SELECT Id, Name,CreatedById, Active__c, Status__c, Budgeted_Cost__c, Start_Date__c, End_Date__c, Actual_Cost__c, Description__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Text_4__c, Dummy_Text_5__c, Dummy_Date_1__c, Dummy_Text_6__c, Dummy_Date_2__c, Dummy_Date_3__c, Dummy_Date_4__c, Dummy_Date_5__c, Dummy_Date_6__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Picklist_4__c, Dummy_Picklist_5__c, Dummy_Picklist_6__c, Dummy_Currency_1__c, Dummy_Currency_2__c, Job_Estimates__c FROM Campaign__c where Id=:campObj.id];
        system.debug('The camp id is '+ camp.id);
        String Dt1=''+DateTime.Now();
        campName=Dt1.substring(11,19)+' '+Dt1.substring(0,10)+': '+camp.Name;
        if(campName.length()>45)
        campName=campName.substring(0,45);
        
        jobsUnderCamp=[select id, Name, Media_Types__c, Schedule_Template__c, Start_Date__c, Due_Date__c, JS_Client__c,JS_Client_Contact__c,UpdateSchedDateFieldCheck__c, Creative_Overview__c,Campaign__c, Client_Contact__c, Specification_Template__c, CreatedById, Client__c, Budgeted_Cost__c,  Completion_Date__c, Number_of_Days__c, Dummy_Date_1__c, Dummy_Date_2__c, Dummy_Date_3__c, Dummy_Date_4__c, Dummy_Date_5__c, Dummy_Date_6__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Picklist_4__c, Dummy_Picklist_5__c, Dummy_Picklist_6__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Text_4__c, Dummy_Text_5__c, Dummy_Text_6__c, Estimate_Total__c, Flag__c, Job_Description__c, marked_Done__c, Schedule_Calc__c, Status__c, Status_Notes__c, Traffic_Notes__c from Job__c where Campaign__c=:camp.id];
        
        for(Job__c jb:jobsUnderCamp){
            if(jb.JS_Client__c!=null){
              Clientlist.add(jb.JS_Client__c);
              }
         }
       
        String query1 ='SELECT id,name,Active__c from Staff__c where Active__c=true and IsDeleted__c=False order by name';
        staffs =Database.query(query1);
         for(Staff__c s:staffs){
          staffNames.add(s.name);
          }
        
         String query3 ='SELECT id,name,Active__c from Vendor_Contact__c where Active__c=true  order by name';
        VCs= Database.query(query3);
        for(Vendor_Contact__c  s:VCs){
         VendorNames.add(s.name);
        }    
        
        String query2 ='SELECT id,name,Active__c,Client__c  from Client_Contact__c Where Client__c IN:Clientlist AND Active__c=true   Order by name';
          CCs= Database.query(query2);   
          for(Client_Contact__c  s:CCs){
          ClientNames.add(s.name);
          
             if(!Client_ContactMap.ContainsKey(s.Client__c)){
              Client_ContactMap.put(s.Client__c,new set<String>{s.name});
              }
              else{
              set<String> Ccons=new set<String>();
              Ccons=Client_ContactMap.get(s.Client__c);
              Ccons.add(s.Name);
              Client_ContactMap.put(s.Client__c,Ccons);
              }
         }   
        
         System.debug('=======camp======'+camp);
         System.debug('=======OldcampId======'+OldcampId);
         System.debug('=======jobsUnderCamp======'+jobsUnderCamp);
         System.debug('=======Clientlist Id ======'+Clientlist);
         System.debug('=======Client Contact Names ======'+ClientNames);
         System.debug('=======Active and Not Delted staffNames list======'+staffNames);
         System.debug('=======Active Vendor Contact Namelist======'+VendorNames);
         System.debug('=============Client_ContactMap with Client Id and Client Contact Names================'+Client_ContactMap);
        
       }

   
    public pagereference DuplicateCampagin(){
    
    
     try{
       
       Campaign__c DupCamp=new Campaign__c(
       Name=campName,
       //CreatedById=camp.CreatedById,
       Active__c=camp.Active__c, 
       Status__c=camp.Status__c, 
       Budgeted_Cost__c=camp.Budgeted_Cost__c, 
       Start_Date__c=camp.Start_Date__c,
       End_Date__c=camp.End_Date__c, 
       Actual_Cost__c=camp.Actual_Cost__c,
       Description__c=camp.Description__c,
       Dummy_Text_1__c=camp.Dummy_Text_1__c,
       Dummy_Text_2__c=camp.Dummy_Text_2__c,
       Dummy_Text_3__c=camp.Dummy_Text_3__c, 
       Dummy_Text_4__c=camp.Dummy_Text_4__c,
       Dummy_Text_5__c=camp.Dummy_Text_5__c,
       Dummy_Date_1__c=camp.Dummy_Date_1__c,
       Dummy_Text_6__c=camp.Dummy_Text_6__c,
       Dummy_Date_2__c=camp.Dummy_Date_2__c,
       Dummy_Date_3__c=camp.Dummy_Date_3__c,
       Dummy_Date_4__c=camp.Dummy_Date_4__c,
       Dummy_Date_5__c=camp.Dummy_Date_5__c,
       Dummy_Date_6__c=camp.Dummy_Date_6__c, 
       Dummy_Picklist_1__c=camp.Dummy_Picklist_1__c,
       Dummy_Picklist_2__c=camp.Dummy_Picklist_2__c,
       Dummy_Picklist_3__c=camp.Dummy_Picklist_3__c,
       Dummy_Picklist_4__c=camp.Dummy_Picklist_4__c,
       Dummy_Picklist_5__c=camp.Dummy_Picklist_5__c, 
       Dummy_Picklist_6__c=camp.Dummy_Picklist_6__c,
       Dummy_Currency_1__c=camp.Dummy_Currency_1__c,
       Dummy_Currency_2__c=camp.Dummy_Currency_2__c, 
       Job_Estimates__c=camp.Job_Estimates__c);
       
       insert DupCamp;
       
       for(Job__c j:jobsUnderCamp){
       
        String JobName=''+DateTime.Now();
        JobName=JobName.substring(11,19)+' '+JobName.substring(0,10)+': '+j.Name;
        if(JobName.length() > 80)
        {
           JobName = JobName.substring(0,80);
        }
       
        Job__c cj= new Job__c(
        Name=JobName,
        Media_Types__c=j.Media_Types__c,
        Schedule_Template__c=j.Schedule_Template__c,
        UpdateSchedDateFieldCheck__c=j.UpdateSchedDateFieldCheck__c,
        Specification_Template__c=j.Specification_Template__c,
        Start_Date__c=j.Start_Date__c,
        Due_Date__c=j.Due_Date__c,
        JS_Client__c=j.JS_Client__c,
        JS_Client_Contact__c=j.JS_Client_Contact__c,
        Campaign__c=DupCamp.id, 
        Budgeted_Cost__c = j.Budgeted_Cost__c,
        Completion_Date__c = j.Completion_Date__c,
        Number_of_Days__c = j.Number_of_Days__c , 
        Dummy_Date_1__c = j.Dummy_Date_1__c , 
        Dummy_Date_2__c = j.Dummy_Date_2__c , 
        Dummy_Date_3__c = j.Dummy_Date_3__c , 
        Dummy_Date_4__c = j.Dummy_Date_4__c , 
        Dummy_Date_5__c = j.Dummy_Date_5__c , 
        Dummy_Date_6__c = j.Dummy_Date_6__c , 
        Dummy_Picklist_1__c = j.Dummy_Picklist_1__c ,
        Dummy_Picklist_2__c = j.Dummy_Picklist_2__c , 
        Dummy_Picklist_3__c = j.Dummy_Picklist_3__c , 
        Dummy_Picklist_4__c = j.Dummy_Picklist_4__c , 
        Dummy_Picklist_5__c = j.Dummy_Picklist_5__c , 
        Dummy_Picklist_6__c = j.Dummy_Picklist_6__c , 
        Dummy_Text_1__c = j.Dummy_Text_1__c , 
        Dummy_Text_2__c = j.Dummy_Text_2__c ,
        Dummy_Text_3__c = j.Dummy_Text_3__c , 
        Dummy_Text_4__c = j.Dummy_Text_4__c , 
        Dummy_Text_5__c = j.Dummy_Text_5__c ,
        Dummy_Text_6__c = j.Dummy_Text_6__c , 
        Estimate_Total__c = j.Estimate_Total__c , 
        Flag__c = j.Flag__c , 
        Job_Description__c = j.Job_Description__c ,
        /* marked_Done__c = j.marked_Done__c ,*/ 
        Schedule_Calc__c = j.Schedule_Calc__c , 
        Status__c = j.Status__c , 
        Status_Notes__c = j.Status_Notes__c , 
        Traffic_Notes__c = j.Traffic_Notes__c,
        Creative_Overview__c = j.Creative_Overview__c);
         
         DupJobsInsert.add(cj);
       }
       
       if(DupJobsInsert.size()>0){
            insert DupJobsInsert;
           system.debug('The duplicate inserted jobs is '+DupJobsInsert);
         
             List<Job_Team__c> lstJobTeam=new List<Job_Team__c>();
             lstJobTeam=[Select id from Job_Team__c where Job__c IN:DupJobsInsert];
             System.debug('======lstJobTeam new jobs======'+lstJobTeam);
             delete lstJobTeam;
         
              // Trigger invokes JobSpec record, but we are duplicating record here.So, We will delete this records and re-create from retrieving from Old Job
              List<Job_Spec__c> deleteJobSpec=new  List<Job_Spec__c>();
              deleteJobSpec=[Select id from Job_Spec__c where Job__c IN:DupJobsInsert];
               System.debug('======deleteJobSpec new jobs======'+deleteJobSpec);
              delete deleteJobSpec;    
                
             // Retrieve Team records
              lstJobTeam=[Select id,Job__c, Role__c,Staff__c,Email__c,Job__r.Client__c from Job_Team__c where Job__c IN:jobsUnderCamp ORDER BY CreatedDate];
              System.debug('======lstJobTeam for older job jobs======'+lstJobTeam);
              List<Job_Team__c> insertJobTeam=new List<Job_Team__c>();
              
              Map<String,list<Job_Team__c>> jobTeamMap=new Map<String,list<Job_Team__c>>();
             for(Job_Team__c jt1:lstJobTeam)
             {
                if(!jobTeamMap.ContainsKey(jt1.Job__c)){
                    jobTeamMap.put(jt1.Job__c,new list<Job_Team__c>{jt1});
                  }
                else{
                    List<Job_Team__c> DlstJobTeam=new List<Job_Team__c>();
                    DlstJobTeam=jobTeamMap.get(jt1.Job__c);
                    DlstJobTeam.add(jt1);
                    jobTeamMap.put(jt1.Job__c,DlstJobTeam);
                   }
               }
              
              
              
              for(integer i=0;i<DupJobsInsert.size();i++)
              {
                if(jobTeamMap.get(jobsUnderCamp[i].id)!=null)
                 {
                 
                 for(Job_Team__c jt1:jobTeamMap.get(jobsUnderCamp[i].id))
                    {
                     
                     if(staffNames.contains(jt1.Staff__c) || VendorNames.contains(jt1.Staff__c)){
                         Job_Team__c jt=new Job_Team__c();
                          jt.Job__c=DupJobsInsert[i].id;
                          jt.Role__c=jt1.Role__c;
                          jt.Staff__c=jt1.Staff__c;
                          jt.Email__c=jt1.Email__c;
                          insertJobTeam.add(jt);
                     
                        }
                     
                     else if(Client_ContactMap.ContainsKey(jt1.Job__r.Client__c))
                      {
                          if(Client_ContactMap.get(jt1.Job__r.Client__c).contains(jt1.Staff__c))
                          {
                          Job_Team__c jt11=new Job_Team__c();
                          jt11.Job__c=DupJobsInsert[i].id;
                          jt11.Role__c=jt1.Role__c;
                          jt11.Staff__c=jt1.Staff__c;
                          jt11.Email__c=jt1.Email__c;
                          insertJobTeam.add(jt11);
                          }
                         
                        }
                     }  
                 }
                
              }
              
            insert insertJobTeam;
            
            
            
             List<Job_Task__c> insertJobTask=new List<Job_Task__c>();
             List<Job_Task__c> lstJT=new List<Job_Task__c>();
             Set<Id> OldTaskId=new Set<Id>();
            
            
             Map<Id,Id> mp2 = new Map<Id,Id>();
             Map<Id,Map<String,id>> jttmp1 = new Map<Id,Map<String,id>>();
             Map<Id,Map<Id,id>> jttmp2 = new Map<Id,Map<Id,id>>();
               
           lstJT=[Select id,Name,GL_Code__c,Report__c,Locked__c,Days__c,Due_Date__c,Revised_Due_Date__c, Task_Order__c,Start_Date__c,job__c,Job__r.Client__c from Job_Task__c where Job__c IN:jobsUnderCamp ORDER BY Start_Date__c];
           
            Map<String,list<Job_Task__c>> jobTasksMap=new Map<String,list<Job_Task__c>>();
           for(Job_Task__c jtsk:lstJT){
           
              if(!jobTasksMap.ContainsKey(jtsk.Job__c)){
                    jobTasksMap.put(jtsk.Job__c,new list<Job_Task__c>{jtsk});
                  }
                else{
                    List<Job_Task__c> DlstJT=new List<Job_Task__c>();
                    DlstJT=jobTasksMap.get(jtsk.Job__c);
                    DlstJT.add(jtsk);
                    jobTasksMap.put(jtsk.Job__c,DlstJT);
                   }
           
           }
           
            
           for(integer i=0;i<DupJobsInsert.size();i++)
          {  
              if(jobTasksMap.get(jobsUnderCamp[i].id)!=null)
              {
                 Map<String,Id> mp1 = new Map<String,Id>();
                 
                 for(Job_Task__c task:jobTasksMap.get(jobsUnderCamp[i].id))
                 {
                      OldTaskId.add(task.id);
                      Job_Task__c objJT = new Job_Task__c();
                      objJT.Name = task.Name;
                      objJT.GL_Code__c = task.GL_Code__c;
                      objJT.Report__c = task.Report__c;
                      objJT.Locked__c = task.Locked__c;
                      objJT.Days__c = task.Days__c;
                      //code added to duplicate the start date for all the tasks
                      objJT.Start_Date__c = task.Start_Date__c;
                      objJT.Due_Date__c = task.Due_Date__c;
                      objJT.Revised_Due_Date__c = task.Revised_Due_Date__c;
                      objJT.Task_Order__c = task.Task_Order__c;
                      objJT.Job__c = DupJobsInsert[i].id;
                      
                      mp1.put(task.Name,task.id);
                      
                      insertJobTask.add(objJT);
                 }
                
               jttmp1.put(DupJobsInsert[i].id,mp1); 
               }   
                
             }
             
             insert insertJobTask;
             
              System.debug('Schedule record are inserted');
                
               for(Job_Task__c jt:insertJobTask)
               {
                  // mp2.put(mp1.get(jt.Name),jt.Id);
                  if(!jttmp2.ContainsKey(jt.Job__c)){
                  jttmp2.put(jt.Job__c,new map<Id,Id>{jttmp1.get(jt.Job__c).get(jt.name) => jt.id});
                  }
                  else{
                   Map<Id,id> dtaskmap= new Map<Id,id>();
                   dtaskmap=jttmp2.get(jt.Job__c);
                   dtaskmap.put(jttmp1.get(jt.Job__c).get(jt.name),jt.id);
                   jttmp2.put(jt.Job__c,dtaskmap);
                  }
                    
               }
               
            
             System.debug('============lst of Job Tasks============='+lstJT);
             System.debug('============jttmp1============='+jttmp1); 
             System.debug('============jttmp2============='+jttmp2);
            
               
            
              List<Job_Task_Role__c> lstJTR=new List<Job_Task_Role__c>();
              lstJTR=[Select id,Name,User__c,Email__c,Job_Task__c,Job_Task__r.Job__c from Job_Task_Role__c where Job_Task__c IN:OldTaskId];
              Map<String,list<Job_Task_Role__c>> taskRoleMap=new Map<String,list<Job_Task_Role__c>>();
              List<Job_Task_Role__c> insertJTR=new List<Job_Task_Role__c>();
              
              for(Job_Task_Role__c jtr:lstJTR){
               if(!taskRoleMap.ContainsKey(jtr.Job_Task__c)){
                taskRoleMap.put(jtr.Job_Task__c,new list<Job_Task_Role__c>{jtr});
               }
               else{
                List<Job_Task_Role__c> DlstJTR=new List<Job_Task_Role__c>();
                DlstJTR=taskRoleMap.get(jtr.Job_Task__c);
                DlstJTR.add(jtr);
                taskRoleMap.put(jtr.Job_Task__c,DlstJTR);
               }
              }
              
             System.debug('============lstJTR============='+lstJTR); 
             System.debug('============taskRoleMap============='+taskRoleMap);
             
             
            for(integer i=0;i<DupJobsInsert.size();i++)
             {  
               if(jobTasksMap.get(jobsUnderCamp[i].id)!=null)
               {
                 for(Job_Task__c task:jobTasksMap.get(jobsUnderCamp[i].id))
                 {
                 
                   if(taskRoleMap.get(task.id)!=null){
                    System.debug('========taskRoleMap with task ids======='+taskRoleMap.get(task.id));
                    for(Job_Task_Role__c taskRole:taskRoleMap.get(task.id))
                    {
                     if(staffNames.contains(taskRole.User__c) || VendorNames.contains(taskRole.User__c)){
                     Job_Task_Role__c objJTR=new Job_Task_Role__c();
                     objJTR.Name=taskRole.Name;
                     objJTR.Email__c=taskRole.Email__c;
                     objJTR.User__c=taskRole.User__c;
                     objJTR.Job_Task__c=jttmp2.get(DupJobsInsert[i].id).get(taskRole.Job_Task__c);
                     insertJTR.add(objJTR);
                     }
                     
                   else if(Client_ContactMap.ContainsKey(task.Job__r.Client__c))
                      {
                          if(Client_ContactMap.get(task.Job__r.Client__c).contains(taskRole.User__c))
                          {
                             Job_Task_Role__c objJTR11=new Job_Task_Role__c();
                             objJTR11.Name=taskRole.Name;
                             objJTR11.Email__c=taskRole.Email__c;
                             objJTR11.User__c=taskRole.User__c;
                             objJTR11.Job_Task__c=jttmp2.get(DupJobsInsert[i].id).get(taskRole.Job_Task__c);
                             insertJTR.add(objJTR11);
                          
                          }
               
                      }
                   }
                 
                 }
               }
             } 
           }
           
           System.debug('========insertion of jobtaksroles list======='+insertJTR);
           insert insertJTR;
           
           
             System.debug('Job Task Role are inserted');
             
             
                 
              List<Job_Spec__c> insertJobSpec=new List<Job_Spec__c>();
              List<Job_Spec__c> lstJS=new List<Job_Spec__c>();
              Map<Id, List<Job_Spec__c>> jspecMap=new Map<Id, List<Job_Spec__c>> ();
              
              lstJS=[Select id,Name,Description__c,Job__c,Creative_Brief_Template__c from Job_Spec__c where Job__c IN:jobsUnderCamp];
              
               
              for(Job_Spec__c spec:lstJS)
               {
                if(!jspecMap.ContainsKey(spec.Job__c)){
                  jspecMap.put(spec.Job__c,new list<Job_Spec__c >{spec});
                 }
                 else{
                  List<Job_Spec__c> DlstJS=new List<Job_Spec__c>();
                  DlstJS=jspecMap.get(spec.Job__c);
                  DlstJS.add(spec);
                  jspecMap.put(spec.Job__c,DlstJS);
                 }
               }
               
               
            for(integer i=0;i<DupJobsInsert.size();i++)
            {  
              if(jspecMap.get(jobsUnderCamp[i].id)!=null)
              {
                 for(Job_Spec__c jspec:jspecMap.get(jobsUnderCamp[i].id))
                 { 
                  Job_Spec__c objJS=new Job_Spec__c();
                  objJS.Name=jspec.Name;
                  objJS.Description__c=jspec.Description__c;
                  objJS.Job__c=DupJobsInsert[i].id;
                  objJS.Creative_Brief_Template__c=jspec.Creative_Brief_Template__c;
                  insertJobSpec.add(objJS);
                 }
                 
               }
                 
             }
               
              
             insert insertJobSpec;
             
             System.debug('Job Spec Records are re-created');
           
           
           List<Graphics_Deliverables__c> InsertGDlist=new List<Graphics_Deliverables__c>();
           List<Graphics_Deliverables__c> GDlist=new List<Graphics_Deliverables__c>();
           Map<Id,List<Graphics_Deliverables__c>> JGraphicMap=new Map<Id,List<Graphics_Deliverables__c >>();

           GDlist=[SELECT Id, Name, Job__c, Graphics_Type__c, Graphics_Description__c, Graphics_Note__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Date_2__c, Dummy_Date_1__c, Dummy_Date_3__c, Dummy_Text_1__c, Dummy_Text_3__c, Dummy_Text_2__c, Dummy_Text_4__c, Dummy_Text_5__c, Dummy_Text_6__c, Dummy_Text_7__c, Dummy_Text_8__c, Dummy_Text_9__c, Dummy_Text_10__c, Dummy_Text_11__c, Dummy_Text_12__c, Dummy_Text_13__c, Dummy_Text_14__c, Dummy_Text_15__c, Dummy_Date_4__c, Dummy_Date_5__c, Dummy_Picklist_4__c, Dummy_Picklist_5__c, Deliverable_Date__c FROM Graphics_Deliverables__c where Job__c IN:jobsUnderCamp];
           
          for(Graphics_Deliverables__c jgd:GDlist){
              if(!JGraphicMap.ContainsKey(jgd.Job__c)){
                 JGraphicMap.put(jgd.Job__c,new List<Graphics_Deliverables__c>{jgd});
                }
              else{
                List<Graphics_Deliverables__c> DGDlist=new List<Graphics_Deliverables__c>();
                DGDlist=JGraphicMap.get(jgd.Job__c);
                DGDlist.add(jgd);
                JGraphicMap.put(jgd.Job__c,DGDlist);
               }
           }
           
           
               
            for(integer i=0;i<DupJobsInsert.size();i++)
            {  
              if(JGraphicMap.get(jobsUnderCamp[i].id)!=null)
              {
                 for(Graphics_Deliverables__c gde:JGraphicMap.get(jobsUnderCamp[i].id))
                 {
                  Graphics_Deliverables__c ObjGd=new Graphics_Deliverables__c();
                  
                    ObjGd.Name=gde.Name;
                    ObjGd.Job__c=DupJobsInsert[i].id;
                    ObjGd.Graphics_Type__c=gde.Graphics_Type__c;
                    ObjGd.Graphics_Description__c=gde.Graphics_Description__c;
                    ObjGd.Graphics_Note__c=gde.Graphics_Note__c;
                    ObjGd.Deliverable_Date__c=gde.Deliverable_Date__c;
                    ObjGd.Dummy_Date_1__c=gde.Dummy_Date_1__c;
                    ObjGd.Dummy_Date_2__c=gde.Dummy_Date_2__c;
                    ObjGd.Dummy_Date_3__c=gde.Dummy_Date_3__c;
                    ObjGd.Dummy_Date_4__c=gde.Dummy_Date_4__c;
                    ObjGd.Dummy_Date_5__c=gde.Dummy_Date_5__c; 
                    ObjGd.Dummy_Text_1__c=gde.Dummy_Text_1__c; 
                    ObjGd.Dummy_Text_2__c=gde.Dummy_Text_2__c;
                    ObjGd.Dummy_Text_3__c=gde.Dummy_Text_3__c;  
                    ObjGd.Dummy_Text_4__c=gde.Dummy_Text_4__c; 
                    ObjGd.Dummy_Text_5__c=gde.Dummy_Text_5__c; 
                    ObjGd.Dummy_Text_6__c=gde.Dummy_Text_6__c; 
                    ObjGd.Dummy_Text_7__c=gde.Dummy_Text_7__c; 
                    ObjGd.Dummy_Text_8__c=gde.Dummy_Text_8__c; 
                    ObjGd.Dummy_Text_9__c=gde.Dummy_Text_9__c; 
                    ObjGd.Dummy_Text_10__c=gde.Dummy_Text_10__c; 
                    ObjGd.Dummy_Text_11__c=gde.Dummy_Text_11__c; 
                    ObjGd.Dummy_Text_12__c=gde.Dummy_Text_12__c; 
                    ObjGd.Dummy_Text_13__c=gde.Dummy_Text_13__c; 
                    ObjGd.Dummy_Text_14__c=gde.Dummy_Text_14__c; 
                    ObjGd.Dummy_Text_15__c=gde.Dummy_Text_15__c; 
                    ObjGd.Dummy_Picklist_1__c=gde.Dummy_Picklist_1__c; 
                    ObjGd.Dummy_Picklist_2__c=gde.Dummy_Picklist_2__c;
                    ObjGd.Dummy_Picklist_3__c=gde.Dummy_Picklist_3__c;  
                    ObjGd.Dummy_Picklist_4__c=gde.Dummy_Picklist_4__c; 
                    ObjGd.Dummy_Picklist_5__c=gde.Dummy_Picklist_5__c; 
                    
                    InsertGDlist.add(ObjGd);
                 }
                 
               }
             }
           
              insert InsertGDlist;
           
        }
       
      PageReference p=new PageReference('/'+DupCamp.id);
      p.setRedirect(true);
      return p;
       
     }
       
     catch(System.DMLException e)
      {
        isError=true;
        return null;
      }
    
     
   }

}