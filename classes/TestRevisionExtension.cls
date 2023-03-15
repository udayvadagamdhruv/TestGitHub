public with sharing class TestRevisionExtension
{

    /* // Global variables
    public Job__c objJob;
    Public String strId1,strId2,jobid,clientid;
    public  boolean isError{get;set;}
    String MTName,ClientName,CCName,ScheduleTemp,CampaignName,SpecTempName,JobName,CreatedBy,strJob_Id,JobNum,RevInc;
    //Declared j here by Rahul on 3rd March 2014 for Dev item #639
    public Job__c j;
    public list<Staff__c> staffs;
    public list<Client_Contact__c> CCs;
    public list<Vendor_Contact__c> VCs;
    public Set<String> ClientNames=new set<String>();
    public Set<String> VendorNames=new set<String>();
    public Set<String> staffNames=new set<String>();
    public Date dtStartDate,dtDueDate;
    String UserName;
    public String oldJobId{get;set;}
    Public Boolean ShowProductionEstimate{get;set;}
    // End of Global variables
    
    // Start constructor
    public TestRevisionExtension(ApexPages.StandardController con) 
    {
       
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        
        isError=False;
        this.objJob=(Job__c)con.getrecord();
        jobid = ApexPages.currentpage().getParameters().get('id');
        userName=UserInfo.getName();
     
        // Retrieve Old Job Data  
        //Added all the job fields in query by Rahul on 3rd March 2014 for dev #639
        j = [select id, Name, Media_Types__c, Job_Auto_Number__c,Schedule_Template__c, Start_Date__c, Due_Date__c, JS_Client__c,JS_Client_Contact__c, Campaign__c, Client_Contact__c, Specification_Template__c, CreatedById, Client__c, Budgeted_Cost__c,  Completion_Date__c, Number_of_Days__c, Dummy_Date_1__c, Dummy_Date_2__c, Dummy_Date_3__c, Dummy_Date_4__c, Dummy_Date_5__c, Dummy_Date_6__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Picklist_4__c, Dummy_Picklist_5__c, Dummy_Picklist_6__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Text_4__c, Dummy_Text_5__c, Dummy_Text_6__c, Estimate_Total__c, Flag__c, Job_Description__c, marked_Done__c, Schedule_Calc__c, Status__c, Status_Notes__c, Traffic_Notes__c from Job__c  where id =: objJob.id Limit 1];
        //[select id,Name,Media_Types__c,Schedule_Template__c,Start_Date__c,Due_Date__c,JS_Client__c,Campaign__c,Client_Contact__c,Specification_Template__c,CreatedById from Job__c  where id =: objJob.id Limit 1];
        clientid=j.JS_Client__c;
        
          String query ='SELECT id,name,Active__c from Staff__c where Active__c=true and IsDeleted__c=False order by name';
            
          staffs = Database.query(query); 
        
          for(Staff__c s:staffs){
          staffNames.add(s.name);
          
          
          }
        
        
         String query1 ='SELECT id,name,Active__c from Client_Contact__c Where Client__c=:clientid AND Active__c=true   Order by name';
            
          CCs= Database.query(query1);   
            
            
         for(Client_Contact__c  s:CCs){
          ClientNames.add(s.name);
          
          
          }   
            
        String query2 ='SELECT id,name,Active__c from Vendor_Contact__c where Active__c=true  order by name';
            
         VCs= Database.query(query2);
                 
            
          for(Vendor_Contact__c  s:VCs){
          
          VendorNames.add(s.name);
          
          
          }    
        
        
        
        OldJobId=j.Id;
        
        MTName = j.Media_Types__c;
        ScheduleTemp = j.Schedule_Template__c;
        ClientName = j.JS_Client__c;
        system.debug('Client ======+++'+j.JS_Client__c);
        
        
        CCName = j.JS_Client_Contact__c;
        CampaignName = j.Campaign__c; 
        SpecTempName = j.Specification_Template__c;
        //JobName='Duplicate : '+' '+j.Name+' '+'Created By :'+userName;
        JobName='Dup : '+DateTime.Now()+' '+j.Name;
        
      // RevInc=Revision_Increment__c+i;
        
        
      //  JobNum=j.Job_Auto_Number__c+' R'+'RevInc';
        
        if(JobName.length() > 80)
        {
           JobName = JobName.substring(0,80);
        }
        CreatedBy=j.CreatedById;
        
        dtStartDate=j.Start_Date__c;
        dtDueDate=j.Due_Date__c;
        
    }
    // End constructor
    
    // Method called to insert duplicate of selected Job
    Public PageReference duplicateJob()
    {
      /*  if(jobName.length() > 80)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Job Name of Duplicate Job can not be greater than 80 characters'));
            return NULL;
        }
        
         List<Job__c> jobrr=[Select id,name,RRbackend__c from Job__c where Jobidbackend__c=:j.Job_Auto_Number__c order by RRbackend__c DESC limit 1 ];
        try
        {
            system.debug('Client ======'+ClientName);
            Job__c jj = [select id,Revision_Increment__c from Job__c where Job_Auto_Number__c = :j.Job_Auto_Number__c.split(' R')[0]];
if(schema.SobjectType.Job__c.Fields.Revision_Increment__c.isUpdateable()){ 
jj.Revision_Increment__c = jj.Revision_Increment__c +1;}
if(Schema.sObjectType.Job__c.isUpdateable()){
update jj;}
            Job__c dupJob = new Job__c(Name=JobName,Revision_Increment__c = jj.Revision_Increment__c ,Media_Types__c=MTName, Job_Auto_Number__c=JobNum, Revision__c=True,Jobidbackend__c=j.Job_Auto_Number__c,RRbackend__c =(jobrr.size()>0?jobrr[0].RRbackend__c+1:1),Schedule_Template__c=SCheduleTemp,Specification_Template__c= SpecTempName,Start_Date__c=dtStartDate,Due_Date__c=dtDueDate,JS_Client__c=ClientName,JS_Client_Contact__c=CCName,Campaign__c=CampaignName, Budgeted_Cost__c = j.Budgeted_Cost__c,  Completion_Date__c = j.Completion_Date__c, Number_of_Days__c = j.Number_of_Days__c , Dummy_Date_1__c = j.Dummy_Date_1__c , Dummy_Date_2__c = j.Dummy_Date_2__c , Dummy_Date_3__c = j.Dummy_Date_3__c , Dummy_Date_4__c = j.Dummy_Date_4__c , Dummy_Date_5__c = j.Dummy_Date_5__c , Dummy_Date_6__c = j.Dummy_Date_6__c , Dummy_Picklist_1__c = j.Dummy_Picklist_1__c , Dummy_Picklist_2__c = j.Dummy_Picklist_2__c , Dummy_Picklist_3__c = j.Dummy_Picklist_3__c , Dummy_Picklist_4__c = j.Dummy_Picklist_4__c , Dummy_Picklist_5__c = j.Dummy_Picklist_5__c , Dummy_Picklist_6__c = j.Dummy_Picklist_6__c , Dummy_Text_1__c = j.Dummy_Text_1__c , Dummy_Text_2__c = j.Dummy_Text_2__c , Dummy_Text_3__c = j.Dummy_Text_3__c , Dummy_Text_4__c = j.Dummy_Text_4__c , Dummy_Text_5__c = j.Dummy_Text_5__c , Dummy_Text_6__c = j.Dummy_Text_6__c , Estimate_Total__c = j.Estimate_Total__c , Flag__c = j.Flag__c , Job_Description__c = j.Job_Description__c , marked_Done__c = j.marked_Done__c , Schedule_Calc__c = j.Schedule_Calc__c , Status__c = j.Status__c , Status_Notes__c = j.Status_Notes__c , Traffic_Notes__c = j.Traffic_Notes__c);
            //new Job__c(Name=JobName,Media_Types__c=MTName,Schedule_Template__c=SCheduleTemp,Specification_Template__c= SpecTempName,Start_Date__c=dtStartDate,Due_Date__c=dtDueDate,JS_Client__c=ClientName,Client_Contact__c=CCName,Campaign__c=CampaignName);  
             insert dupJob;
             
                
             // Trigger invokes JobTeam record, but we are duplicating record here.So, We will delete this records and create from retrieving from Old Job
             List<Job_Team__c> lstJobTeam=new List<Job_Team__c>();
             lstJobTeam=[Select id from Job_Team__c where Job__c=: dupJob.id];
             if(Job_Team__c.sObjectType.getDescribe().isDeletable()){
              delete lstJobTeam;
              }
         
              // Trigger invokes JobSpec record, but we are duplicating record here.So, We will delete this records and re-create from retrieving from Old Job
              List<Job_Spec__c> deleteJobSpec=[Select id from Job_Spec__c where Job__c=:dupJob.id];
               if(Job_Spec__c.sObjectType.getDescribe().isDeletable()){
               delete deleteJobSpec;    }
                
             // Retrieve Team records
              lstJobTeam=[Select id,Job__c, Role__c,Staff__c,Email__c from Job_Team__c where Job__c=:OldJobId ORDER BY CreatedDate];
              List<Job_Team__c> insertJobTeam=new List<Job_Team__c>();
         
              for(Job_Team__c jt1:lstJobTeam)
              {
             
                 
                 if(staffNames.contains(jt1.Staff__c) || ClientNames.contains(jt1.Staff__c) || VendorNames.contains(jt1.Staff__c)){
                 
                  Job_Team__c jt=new Job_Team__c();
                  jt.Job__c=dupJob.id;
                  jt.Role__c=jt1.Role__c;
                  jt.Staff__c=jt1.Staff__c;
                  jt.Email__c=jt1.Email__c;
                  insertJobTeam.add(jt);
                 
                 
                 }
                 
                  
                  
                  
              }
             insert insertJobTeam;
         
             System.debug('Job Team records for duplicate Job are created');
                
             List<Job_Task__c> insertJobTask=new List<Job_Task__c>();
             List<Job_Task__c> lstJT=new List<Job_Task__c>();
             Set<Id> OldTaskId=new Set<Id>();
             Map<String,Id> mp1 = new Map<String,Id>();
             Map<Id,Id> mp2 = new Map<Id,Id>();
               
             lstJT=[Select id,Name,GL_Code__c,Report__c,Locked__c,Days__c,Due_Date__c,Revised_Due_Date__c, Task_Order__c,Start_Date__c from Job_Task__c where Job__c=:OldJobId ORDER BY Start_Date__c];
              
             for(Job_Task__c task:lstJT)
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
                  objJT.Job__c = dupJob.id;
                  
                  mp1.put(task.Name,task.id);
                  insertJobTask.add(objJT);
             }
               insert insertJobTask;
           
               System.debug('Schedule record are inserted');
                
               for(Job_Task__c jt:insertJobTask)
               {
                    mp2.put(mp1.get(jt.Name),jt.Id);
               }
                
              List<Job_Task_Role__c> lstJTR=[Select id,Name,User__c,Job_Task__c from Job_Task_Role__c where Job_Task__c IN:OldTaskId];
                
              List<Job_Task_Role__c> insertJTR=new List<Job_Task_Role__c>();
                
              for(Job_Task_Role__c taskRole:lstJTR)
              {
                     Job_Task_Role__c objJTR=new Job_Task_Role__c();
                     objJTR.Name=taskRole.Name;
                     objJTR.User__c=taskRole.User__c;
                     objJTR.Job_Task__c=mp2.get(taskRole.Job_Task__c);
                     insertJTR.add(objJTR);
              }
             insert insertJTR;
                
              System.debug('Job Task Role are inserted');
                 
              List<Job_Spec__c> insertJobSpec=new List<Job_Spec__c>();
              List<Job_Spec__c> lstJS=[Select id,Name,Description__c,Job__c from Job_Spec__c where Job__c=: OldJobId];
                
              for(Job_Spec__c spec:lstJS)
             {
                  Job_Spec__c objJS=new Job_Spec__c();
                  objJS.Name=spec.Name;
                  objJS.Description__c=spec.Description__c;
                  objJS.Job__c=dupJob.id;
                  insertJobSpec.add(objJS);
             }
             insert insertJobSpec;
                
            System.debug('Job Spec Records are re-created');
            
            //sushma added code for the duplciation of the tags.
            List<Tag__c> insertJobTag=new List<Tag__c>();
            List<Tag__c> lstJTag=[Select id,Name,Job__c,Tag_Air_Date__c,Tag_Air_Time__c,Dummy_Date_1__c,Dummy_Date_2__c,Dummy_Date_3__c,Dummy_Date_4__c,Dummy_Picklist_1__c,Dummy_Picklist_2__c,Dummy_Picklist_3__c,Dummy_Picklist_4__c,Dummy_Text_1__c,Dummy_Text_2__c,Dummy_Text_3__c,Dummy_Text_4__c,Tag_Lengths__c,Tag_Due_Date__c,Tag_End_Date__c,Tag_Start_Date__c,Tag_Program_Title__c  from Tag__c where Job__c=: OldJobId ORDER BY CreatedDate];
             for(Tag__c tag:lstJtag)
             {
                  Tag__c objJTag=new Tag__c();
                  objJTag.Name=tag.Name;
                  objJTag.Job__c=dupJob.id;
                  objJTag.Tag_Air_Date__c=tag.Tag_Air_Date__c;
                  objJTag.Tag_Air_Time__c=tag.Tag_Air_Time__c;
                  objJTag.Dummy_Date_1__c=tag.Dummy_Date_1__c;
                  objJTag.Dummy_Date_2__c=tag.Dummy_Date_2__c;
                  objJTag.Dummy_Date_3__c=tag.Dummy_Date_3__c;
                  objJTag.Dummy_Date_4__c=tag.Dummy_Date_4__c;
                  objJTag.Dummy_Picklist_1__c=tag.Dummy_Picklist_1__c;
                  objJTag.Dummy_Picklist_2__c=tag.Dummy_Picklist_2__c;
                  objJTag.Dummy_Picklist_3__c=tag.Dummy_Picklist_3__c;
                  objJTag.Dummy_Picklist_4__c=tag.Dummy_Picklist_4__c;
                  objJTag.Dummy_Text_1__c=tag.Dummy_Text_1__c;
                  objJTag.Dummy_Text_2__c=tag.Dummy_Text_2__c;
                  objJTag.Dummy_Text_3__c=tag.Dummy_Text_3__c;
                  objJTag.Dummy_Text_4__c=tag.Dummy_Text_4__c;
                  objJTag.Tag_Lengths__c=tag.Tag_Lengths__c;
                  objJTag.Tag_Due_Date__c=tag.Tag_Due_Date__c;
                  objJTag.Tag_End_Date__c=tag.Tag_End_Date__c;
                  objJTag.Tag_Start_Date__c=tag.Tag_Start_Date__c;
                  objJTag.Tag_Program_Title__c=tag.Tag_Program_Title__c;
                  
                  insertJobTag.add(objJTag);
             }
             insert insertJobTag;
             //all fields for job tags
             //Tag_Air_Date__c,Tag_Air_Time__c,Dummy_Date_1__c,Dummy_Date_2__c,Dummy_Date_3__c,Dummy_Date_4__c,Dummy_Picklist_1__c,Dummy_Picklist_2__c,Dummy_Picklist_3__c,Dummy_Picklist_4__c,Dummy_Text_1__c,Dummy_Text_2__c,Dummy_Text_3__c,Dummy_Text_4__c,Job__c,Tag_Lengths__c,Tag_Due_Date__c,Tag_End_Date__c,Tag_Start_Date__c,Tag_Program_Title__c   
            System.debug('Job Tag Records are re-created');
                
             if(ShowProductionEstimate){
             
            //Subhranshu added code for the duplciation of the Production Estimate.
            List<Production_Estimate__c> insertProdEstimate=new List<Production_Estimate__c>();
            List<Production_Estimate__c> lstProdEstimate=[Select id,Name,Job__c,Calc_Unit__c,Color__c,Commission__c,Equipment_Type__c,GL_Department__c,GL_Code__c,of_Pages__c,
            
            Length_in_Inches__c,Material_Item__c,EachQtyUpforUsed__c,Quantity__c,Qty_Up__c,SheetQtyUpforUsed__c,Sided__c,Vendor__c,Width_in_Inches__c  from Production_Estimate__c where Job__c=: OldJobId ORDER BY CreatedDate];
              
             for(Production_Estimate__c p:lstProdEstimate)
             {
                  Production_Estimate__c  objJPE=new Production_Estimate__c  ();
                  
                  objJPE.name=p.Name;
                  objJPE.Job__c=dupJob.id;
                  objJPE.Calc_Unit__c=p.Calc_Unit__c;
                  objJPE.Color__c=p.Color__c;
                  objJPE.Commission__c=p.Commission__c;
                  objJPE.GL_Department__c=p.GL_Department__c;
                  objJPE.GL_Code__c=p.GL_Code__c;
                  objJPE.of_Pages__c=p.of_Pages__c;
                  objJPE.Length_in_Inches__c=p.Length_in_Inches__c;
                  objJPE.Material_Item__c=p.Material_Item__c;
                  objJPE.Quantity__c=p.Quantity__c;
                  objJPE.Qty_Up__c=p.Qty_Up__c;
                  objJPE.SheetQtyUpforUsed__c=p.SheetQtyUpforUsed__c;
                  objJPE.EachQtyUpforUsed__c=p.EachQtyUpforUsed__c; 
                  objJPE.Sided__c=p.Sided__c;
                  objJPE.Vendor__c=p.Vendor__c;
                  objJPE.Width_in_Inches__c  =p.Width_in_Inches__c  ;
                  objJPE.Equipment_Type__c=p.Equipment_Type__c;
                  
                  
                 
                  insertProdEstimate.add(objJPE);
             }
             insert insertProdEstimate;
             //all fields for Production Estimate
             
             
             }else{
             
              List<Estimate_Line_Items__c > insertEstimate=new List<Estimate_Line_Items__c >();
             
              List<Estimate_Line_Items__c> abc = [select id,Job__c,Quantity__c,Amount__c,Name,GL_Code__c,GL_Department__c,Vendor__c from Estimate_Line_Items__c where Job__c=:OldJobId ORDER BY CreatedDate];
             
              for(Estimate_Line_Items__c es:abc) {
               Estimate_Line_Items__c  objJEst=new Estimate_Line_Items__c ();
                
                objJEst.name=es.Name;
                objJEst.Job__c=dupJob.id;
                objJEst.Quantity__c=es.Quantity__c;
                objJEst.Amount__c=es.Amount__c;
                objJEst.GL_Code__c=es.GL_Code__c;
                objJEst.GL_Department__c=es.GL_Department__c;
                objJEst.Vendor__c =es.Vendor__c ;
                
                insertEstimate.add(objJEst);
               
              
              }
             insert insertEstimate;
             
             
             }
                
                
                
                
            // After creating duplicate Job navigates to its detail page

              PageReference p =  new Pagereference('/apex/JobListView?id='+dupJob.id+'&intFocus=1');
              p.setRedirect(true);
              return p;    
             }
             catch(System.DMLException e)
             {
                 isError = True;
                 return NULL;
             }           
    }
    // End method Saveme
    
     // Method called to Handle Cancel button opeartion 
     public PageReference cancel()
     {
         jobid = ApexPages.currentpage().getParameters().get('id');
         PageReference p =  new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=1');
         p.setRedirect(true);
         return p;
     } 
     // End of Cancel method 
    
    //This method is called on to navigate to the Old Job
      public pagereference navigateToOldJob()
     {
         jobid = ApexPages.currentpage().getParameters().get('id');
         PageReference p =  new Pagereference('/apex/JobListView?id='+OldJobId+'&intFocus=1');
         p.setRedirect(true);
         return p;
     }
     // End method navigateToOldJob
*/
}