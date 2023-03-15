//Class for 'Add/Edit Staff' button on Job Team page,in which we can insert & remove staff from job team.

public with sharing class JobTeamAddEditStaffExtension{

             public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
    
    
     public boolean isMob{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }  
        
 
     
     // Global Variables 
     public List<Job_Team__c> lstJobTeam{get;set;}
     Public Set<String> StaffNameJobTeam =new Set<String>();
     Public Set<string> Srole;
     public String jobId,clientid;
     public list<Staff__c> staffs;
     public list<Client_Contact__c> CCs;
     public list<Vendor_Contact__c> VCs;
     public List<StaffWrappers> AllStaffWrappers{get;set;}
     public List<StaffWrappers> AllCreateStaffWrappers{get;set;}
     public List<Job_Team__c> AddJobTeam;
     Map<String,Job_Team__c> staffJobTeamMap = new Map<String,Job_Team__c>();
     public string LabelWarning{get;set;}
     // End of Global variables 
      
    // End of Global variables
     
      
     public string StatusString {get; set;} 
     public List<SelectOption> StatusList; 
     public List<SelectOption> getStatusList(){
      if (StatusList!= NULL) {            return StatusList;
        }
        StatusList= new List<SelectOption>();
            StatusList.add(new selectOption('All', 'All')); 
         
            StatusList.add(new selectOption('Staff','Staff'));  
            StatusList.add(new selectOption('Client Contact','Client Contact'));  
            StatusList.add(new selectOption('Vendor Contact','Vendor Contact'));  
       
        
        
        return StatusList;
      } 
      
      
      
      
     public List<SelectOption> UserRoleSelectOptions{get;set;}
     public String UserRoleString{get;set;}
     public String UserRoleString1{get;set;}
     public Map<String, Integer>  StaffActiveJobsCountMap{get;set;}
     public list<String> urstaffList{get;set;}
     public String dUserRole{get;set;}
     public String mUserRole{get;set;}
     
     Public void DisplayChart(){
        String urole = UserRoleString;
        String jobStatus = 'Active';
        List<Job_Team__c> uRolejobTeam = [select Staff__c, Role__c, Job__r.Status__c from Job_Team__c where Role__c = :urole and Job__r.Status__c = :jobStatus limit 1000];
        StaffActiveJobsCountMap = new Map<String, Integer>();
        for(Job_Team__c urjt:uRolejobTeam){
            if(StaffActiveJobsCountMap.keyset().contains(urjt.Staff__c)){
                Integer x = StaffActiveJobsCountMap.get(urjt.Staff__c)+1;
                StaffActiveJobsCountMap.put(urjt.Staff__c, x);
            }
            else{
                StaffActiveJobsCountMap.put(urjt.Staff__c, 1);
            }
        }
        urstaffList = new list<String>();
        for(String ss:StaffActiveJobsCountMap.keyset()){
            urstaffList.add(ss);
        }
        mUserRole = 'NotNone';
     }
     Public void DisplayChart1(){
        String urole = UserRoleString1;
        String jobStatus = 'Active';
        List<Job_Team__c> uRolejobTeam = [select Staff__c, Role__c, Job__r.Status__c from Job_Team__c where Role__c = :urole and Job__r.Status__c = :jobStatus limit 1000];
        StaffActiveJobsCountMap = new Map<String, Integer>();
        for(Job_Team__c urjt:uRolejobTeam){
            if(StaffActiveJobsCountMap.keyset().contains(urjt.Staff__c)){
                Integer x = StaffActiveJobsCountMap.get(urjt.Staff__c)+1;
                StaffActiveJobsCountMap.put(urjt.Staff__c, x);
            }
            else{
                StaffActiveJobsCountMap.put(urjt.Staff__c, 1);
            }
        }
        urstaffList = new list<String>();
        for(String ss:StaffActiveJobsCountMap.keyset()){
            urstaffList.add(ss);
        }
        dUserRole = 'NotNOne';
     }
     
      
     // Start Constructor
     public JobTeamAddEditStaffExtension(ApexPages.StandardController controller)
      {
        List<UserRole> userRoleList = [select Name from UserRole order by Name limit 500];
        UserRoleSelectOptions = new List<SelectOption>();
        for(UserRole ur:userRoleList){
            UserRoleSelectOptions.add(new selectOption(ur.name,ur.Name));
        }
        String urole = 'None';
        String jobStatus = 'Active';
        List<Job_Team__c> uRolejobTeam = [select Staff__c, Role__c, Job__r.Status__c from Job_Team__c where Role__c = :urole and Job__r.Status__c = :jobStatus limit 1000];
        StaffActiveJobsCountMap = new Map<String, Integer>();
        for(Job_Team__c urjt:uRolejobTeam){
            if(StaffActiveJobsCountMap.keyset().contains(urjt.Staff__c)){
                Integer x = StaffActiveJobsCountMap.get(urjt.Staff__c)+1;
                StaffActiveJobsCountMap.put(urjt.Staff__c, x);
            }
            else{
                StaffActiveJobsCountMap.put(urjt.Staff__c, 1);
            }
        }
        urstaffList = new list<String>();
        for(String ss:StaffActiveJobsCountMap.keyset()){
            urstaffList.add(ss);
        }
        dUserRole = 'none';
        mUserRole = 'none';
        
        
        StatusString ='Staff';
      
     //   StatusString ='All';
       
        staffs = new List<Staff__c>();
        AllStaffWrappers = new List<StaffWrappers>();
        AllCreateStaffWrappers = new List<StaffWrappers>();
        
         jobId=System.currentPagereference().getParameters().get('id');
         lstJobTeam=[Select Id, Role__c,Staff__c, Job__c,Email__c, Job__r.Name from Job_Team__c where job__c =:jobId order by CreatedDate];
         
         Set<string> Srole=new Set<String>();
        Set<Id> Staskid=new Set<Id>();
        
        
        Job__c  jobrecord=[select id,JS_Client__c, name,Schedule_Template__c from Job__c where id =:jobId ];
        clientid=jobrecord.JS_Client__c;
        system.debug('ClientId'+clientid);
        
        
            List<Schedule_Task__c> STaskslist=[select id,name,Schedule_Template__c,(select id,name  from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c=:jobrecord.Schedule_Template__c ];
            
            
         for(Schedule_Task__c st:STaskslist){
         
          Staskid.add(st.id);
         
         
         }
         
         List<ScheduleTaskRole__c> STRolelist =[select id,name  from ScheduleTaskRole__c where Schedule_Task__c in:Staskid ];
         
         for(ScheduleTaskRole__c str:STRolelist ){
         
          Srole.add(str.name);
         
         system.debug('SRoles'+Srole);
         }
            Set<string> staffNameSet = new Set<String>();
      //Client Contact Operation Details
          
            
    /*        String query1 ='SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Client_Contact_Role__c,Username__c from Client_Contact__c Where Client__c=:clientid AND Active__c=true   Order by Client_Contact_Role__c,name';
            
            
            CCs= Database.query(query1);
             Set<string> staffNameSet = new Set<String>();
            system.debug('cclist'+CCs);
            if(!CCs.isEmpty()){
            
            
            
            for(Job_Team__c jt : lstJobTeam){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Client_Contact__c c:CCs){
            
            if(! staffNameSet.contains(c.name))//(s.First_Name__c+' '+s.Last_Name__c))
            AllstaffWrappers.add(new staffWrappers(c,c.getSobjectType(),Srole.contains(c.Client_Contact_Role__c)));
            
            else{ staffWrappers w =new staffWrappers(c,c.getSobjectType(),Srole.contains(c.Client_Contact_Role__c));w.selection = TRUE; AllstaffWrappers.add(w);StaffNameJobTeam.add(c.name); 
             }
        }
  }
  //Client Contact  Operation Details    */
          
          
          
          
     //Staff Operation Details
          
            String query ='SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Role__c,Username__c from Staff__c where Active__c=true and IsDeleted__c=False order by Role__c,name';
            
            staffs = Database.query(query);
           
            if(!staffs.isEmpty()){
            
            
            
            for(Job_Team__c jt : lstJobTeam){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Staff__c s:staffs){
            
            if(! staffNameSet.contains(s.name))//(s.First_Name__c+' '+s.Last_Name__c))
            AllstaffWrappers.add(new staffWrappers(s,s.getSobjectType(),Srole.contains(s.role__C)));
            
            else{ staffWrappers w =new staffWrappers(s,s.getSobjectType(),Srole.contains(s.role__C));w.selection = TRUE; AllstaffWrappers.add(w);StaffNameJobTeam.add(s.name); 
             }
        }
  }
  //End Staff Operation Details
  
  
  
  
  
  
  //Vendor Contact Operation Details
          
    /*        String query2 ='SELECT id,name,Active__c,First_Name__c,Email__c,Last_Name__c,Role__c,User_Name__c from Vendor_Contact__c where Active__c=true  order by Role__c,name';
            
            VCs= Database.query(query2);
            
            if(!VCs.isEmpty()){
            
            
            
            for(Job_Team__c jt : lstJobTeam){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Vendor_Contact__c v:VCs){
            
            if(! staffNameSet.contains(v.name))//(s.First_Name__c+' '+s.Last_Name__c))
            AllstaffWrappers.add(new staffWrappers(v,v.getSobjectType(),Srole.contains(v.Role__c)));
            
            else{ staffWrappers w =new staffWrappers(v,v.getSobjectType(),Srole.contains(v.Role__c));w.selection = TRUE; AllstaffWrappers.add(w);StaffNameJobTeam.add(v.name); 
             }
        }
  } //Vendor Contact  Operation Details*/
         
      }
      // End of Constructor
      
    //Start method  Search for staffs 
    Public void SerachStaff(){
      
     if(StatusString == 'All'){
     
       AllstaffWrappers.clear();
        Set<string> Srole=new Set<String>();
        Set<Id> Staskid=new Set<Id>();
        
        
        Job__c  jobrecord=[select id,JS_Client__c, name,Schedule_Template__c from Job__c where id =:jobId ];
        clientid=jobrecord.JS_Client__c;
        system.debug('ClientId'+clientid);
        
        
            List<Schedule_Task__c> STaskslist=[select id,name,Schedule_Template__c,(select id,name  from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c=:jobrecord.Schedule_Template__c ];
            
            
         for(Schedule_Task__c st:STaskslist){
         
          Staskid.add(st.id);
         
         
         }
         
         List<ScheduleTaskRole__c> STRolelist =[select id,name  from ScheduleTaskRole__c where Schedule_Task__c in:Staskid ];
         
         for(ScheduleTaskRole__c str:STRolelist ){
         
          Srole.add(str.name);
         
         system.debug('SRoles'+Srole);
         }
          
      //Client Contact Operation Details
          
            
            String query1 ='SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Client_Contact_Role__c,Username__c from Client_Contact__c Where Client__c=:clientid AND Active__c=true   Order by Client_Contact_Role__c,name';
            
            
            CCs= Database.query(query1);
             Set<string> staffNameSet = new Set<String>();
            system.debug('cclist'+CCs);
            if(!CCs.isEmpty()){
            
            
            
            for(Job_Team__c jt : lstJobTeam){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Client_Contact__c c:CCs){
            
            if(! staffNameSet.contains(c.name))//(s.First_Name__c+' '+s.Last_Name__c))
            AllstaffWrappers.add(new staffWrappers(c,c.getSobjectType(),Srole.contains(c.Client_Contact_Role__c)));
            
            else{ staffWrappers w =new staffWrappers(c,c.getSobjectType(),Srole.contains(c.Client_Contact_Role__c));w.selection = TRUE; AllstaffWrappers.add(w);StaffNameJobTeam.add(c.name); 
             }
        }
  }
  //Client Contact  Operation Details    
          
          
          
          
     //Staff Operation Details
          
            String query ='SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Role__c,Username__c from Staff__c where Active__c=true and IsDeleted__c=False order by Role__c,name';
            
            staffs = Database.query(query);
           
            if(!staffs.isEmpty()){
            
            
            
            for(Job_Team__c jt : lstJobTeam){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Staff__c s:staffs){
            
            if(! staffNameSet.contains(s.name))//(s.First_Name__c+' '+s.Last_Name__c))
            AllstaffWrappers.add(new staffWrappers(s,s.getSobjectType(),Srole.contains(s.role__C)));
            
            else{ staffWrappers w =new staffWrappers(s,s.getSobjectType(),Srole.contains(s.role__C));w.selection = TRUE; AllstaffWrappers.add(w);StaffNameJobTeam.add(s.name); 
             }
        }
  }
  //End Staff Operation Details
  
  
  
  
  
  
  //Vendor Contact Operation Details
          
            String query2 ='SELECT id,name,Active__c,First_Name__c,Email__c,Last_Name__c,Role__c,User_Name__c from Vendor_Contact__c where Active__c=true  order by Role__c,name';
            
            VCs= Database.query(query2);
            
            if(!VCs.isEmpty()){
            
            
            
            for(Job_Team__c jt : lstJobTeam){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Vendor_Contact__c v:VCs){
            
            if(! staffNameSet.contains(v.name))//(s.First_Name__c+' '+s.Last_Name__c))
            AllstaffWrappers.add(new staffWrappers(v,v.getSobjectType(),Srole.contains(v.Role__c)));
            
            else{ staffWrappers w =new staffWrappers(v,v.getSobjectType(),Srole.contains(v.Role__c));w.selection = TRUE; AllstaffWrappers.add(w);StaffNameJobTeam.add(v.name); 
             }
        }
  } //Vendor Contact  Operation Details
 
  
  }  
  if(StatusString == 'Staff'){
      AllstaffWrappers.clear();
      Set<string> Srole=new Set<String>();
        Set<Id> Staskid=new Set<Id>();
        
        
        Job__c  jobrecord=[select id,JS_Client__c, name,Schedule_Template__c from Job__c where id =:jobId ];
        clientid=jobrecord.JS_Client__c;
        system.debug('ClientId'+clientid);
        
        
            List<Schedule_Task__c> STaskslist=[select id,name,Schedule_Template__c,(select id,name  from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c=:jobrecord.Schedule_Template__c ];
            
            
         for(Schedule_Task__c st:STaskslist){
         
          Staskid.add(st.id);
         
         
         }
         
         List<ScheduleTaskRole__c> STRolelist =[select id,name  from ScheduleTaskRole__c where Schedule_Task__c in:Staskid ];
         
         for(ScheduleTaskRole__c str:STRolelist ){
         
          Srole.add(str.name);
         
         system.debug('SRoles'+Srole);
         }
         
         //Staff Operation Details
          Set<string> staffNameSet = new Set<String>();
            String query ='SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Role__c,Username__c from Staff__c where Active__c=true and IsDeleted__c=False order by Role__c,name';
            
            staffs = Database.query(query);
           
            if(!staffs.isEmpty()){
            
            
            
            for(Job_Team__c jt : lstJobTeam){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Staff__c s:staffs){
            
            if(! staffNameSet.contains(s.name))//(s.First_Name__c+' '+s.Last_Name__c))
            AllstaffWrappers.add(new staffWrappers(s,s.getSobjectType(),Srole.contains(s.role__C)));
            
            else{ staffWrappers w =new staffWrappers(s,s.getSobjectType(),Srole.contains(s.role__C));w.selection = TRUE; AllstaffWrappers.add(w);StaffNameJobTeam.add(s.name); 
             }
        }
     }
     //End Staff Operation Details
  
  
  }
  if(StatusString == 'Client Contact'){
      AllstaffWrappers.clear();
      Set<string> Srole=new Set<String>();
        Set<Id> Staskid=new Set<Id>();
        
        
        Job__c  jobrecord=[select id,JS_Client__c, name,Schedule_Template__c from Job__c where id =:jobId ];
        clientid=jobrecord.JS_Client__c;
        system.debug('ClientId'+clientid);
        
        
            List<Schedule_Task__c> STaskslist=[select id,name,Schedule_Template__c,(select id,name  from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c=:jobrecord.Schedule_Template__c ];
            
            
         for(Schedule_Task__c st:STaskslist){
         
          Staskid.add(st.id);
         
         
         }
         
         List<ScheduleTaskRole__c> STRolelist =[select id,name  from ScheduleTaskRole__c where Schedule_Task__c in:Staskid ];
         
         for(ScheduleTaskRole__c str:STRolelist ){
         
          Srole.add(str.name);
         
         system.debug('SRoles'+Srole);
         }
          //Client Contact Operation Details
          
            
            String query1 ='SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Client_Contact_Role__c,Username__c from Client_Contact__c Where Client__c=:clientid AND Active__c=true   Order by Client_Contact_Role__c,name';
            
            
            CCs= Database.query(query1);
             Set<string> staffNameSet = new Set<String>();
            system.debug('cclist'+CCs);
            if(!CCs.isEmpty()){
            
            
            
            for(Job_Team__c jt : lstJobTeam){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Client_Contact__c c:CCs){
            
            if(! staffNameSet.contains(c.name))//(s.First_Name__c+' '+s.Last_Name__c))
            AllstaffWrappers.add(new staffWrappers(c,c.getSobjectType(),Srole.contains(c.Client_Contact_Role__c)));
            
            else{ staffWrappers w =new staffWrappers(c,c.getSobjectType(),Srole.contains(c.Client_Contact_Role__c));w.selection = TRUE; AllstaffWrappers.add(w);StaffNameJobTeam.add(c.name); 
             }
        }
  }
  //Client Contact  Operation Details   
     
  }if(StatusString == 'Vendor Contact'){
    AllstaffWrappers.clear();
      Set<string> Srole=new Set<String>();
        Set<Id> Staskid=new Set<Id>();
        
        
        Job__c  jobrecord=[select id,JS_Client__c, name,Schedule_Template__c from Job__c where id =:jobId ];
        clientid=jobrecord.JS_Client__c;
        system.debug('ClientId'+clientid);
        
        
            List<Schedule_Task__c> STaskslist=[select id,name,Schedule_Template__c,(select id,name  from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c=:jobrecord.Schedule_Template__c ];
            
            
         for(Schedule_Task__c st:STaskslist){
         
          Staskid.add(st.id);
         
         
         }
         
         List<ScheduleTaskRole__c> STRolelist =[select id,name  from ScheduleTaskRole__c where Schedule_Task__c in:Staskid ];
         
         for(ScheduleTaskRole__c str:STRolelist ){
         
          Srole.add(str.name);
         
         system.debug('SRoles'+Srole);
         }
         Set<string> staffNameSet = new Set<String>();
         //Vendor Contact Operation Details
          
            String query2 ='SELECT id,name,Active__c,First_Name__c,Email__c,Last_Name__c,Role__c,User_Name__c from Vendor_Contact__c where Active__c=true  order by Role__c,name';
            
            VCs= Database.query(query2);
            
            if(!VCs.isEmpty()){
            
            
            
            for(Job_Team__c jt : lstJobTeam){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Vendor_Contact__c v:VCs){
            
            if(! staffNameSet.contains(v.name))//(s.First_Name__c+' '+s.Last_Name__c))
            AllstaffWrappers.add(new staffWrappers(v,v.getSobjectType(),Srole.contains(v.Role__c)));
            
            else{ staffWrappers w =new staffWrappers(v,v.getSobjectType(),Srole.contains(v.Role__c));w.selection = TRUE; AllstaffWrappers.add(w);StaffNameJobTeam.add(v.name); 
             }
        }
  } //Vendor Contact  Operation Details
  
  }
  
  }  
  //End method Search for staffs 
  
  
    //Start wrapper class for selected staffs 
    
    public class StaffWrappers{
       // Public Staff__c Staff{get;set;}
        public Sobject sobjet{get;set;}
        public boolean selection{get;set;}
        Public boolean Sroles{get;set;}
        Public SObjectWrappers Sojw{get;set;}
        Public SobjectType SobjType{get;set;}
        
       /* public StaffWrappers(Sobject sb, Boolean STroles){
        this.staff = staff;
        selection = False;
        this.Sroles=STroles;
        }*/
        
       public StaffWrappers( Sobject sb, SobjectType st, Boolean STroles){
       
        this.sobjet=sb;
        this.SobjType=st;
        selection = False;
        this.Sroles=STroles;
        
        Sojw=new SObjectWrappers(sobjet,SobjType);
        
        }
    }
    //End wrapper class for selected staffs 
    
    //Start wrapper class for SobjectTypes 
    
    public class SObjectWrappers{
        public Staff__c staff{get;set;}
        public Client_Contact__c CContact{get;set;}
        public Vendor_Contact__c VContact{get;set;}
        Public String  Staffname{get;set;}
        Public String  Username{get;set;}
        Public String  Rolename{get;set;}
        Public Boolean Active{get;set;}
        Public String  Email{get;set;}
        
        public SObjectWrappers( Sobject sb, SobjectType st){
         
        
         
        if(Client_Contact__c.getSobjectType()==st){
          this.CContact=(Client_Contact__c)sb;
          this.Staffname=CContact.Name;
          this.Username=CContact.Username__c;
          this.Rolename=CContact.Client_Contact_Role__c;
          this.Active=CContact.Active__c;
          this.Email=CContact.Email__c;
         }
         
        if(Vendor_Contact__c.getSobjectType()==st){
          this.VContact= (Vendor_Contact__c)sb;
          this.Staffname=VContact.Name;
          this.Username=VContact.User_name__c;
          this.Rolename=VContact.Role__c;
          this.Active=VContact.Active__c;
          this.Email=VContact.Email__c;
         }
         
          if(Staff__c.getSobjectType()==st){
          this.staff=(Staff__c)sb;
          this.Staffname=staff.Name;
          this.Username=staff.Username__c;
          this.Rolename=staff.Role__c;
          this.Active=staff.Active__c;
          this.Email=staff.Email__c;
           
          
          
         }
         
        
        }
    }
    //End wrapper class for SobjectTypes 
    
    
    
    
    
    
    //Start Adding staffs to team
    public PageReference Addstaff(){
    
     if(!AllstaffWrappers.isEmpty()){
     
        Addjobteam = new List<Job_Team__c>();
        List<Job_Team__c> deleteJobteam = new List<Job_Team__c>();
        List<Job_Task_Role__c> lstJTRDelete=new List<Job_task_Role__c>();
        
        for(StaffWrappers apw:AllStaffWrappers){
        
        boolean existing = StaffNameJobTeam.contains(apw.Sojw.Staffname); //(apw.staff.First_Name__c+' '+apw.staff.Last_Name__c);
        
        if(apw.selection == True){ if(!existing) AddJobTeam.add(new Job_Team__c(job__c=Jobid,Role__c=apw.Sojw.RoleName, Staff__c=apw.Sojw.staffname,Email__c=apw.Sojw.Email));   
                
                 }else if(existing){
                 
        if(staffJobTeamMap.containsKey(apw.Sojw.Staffname)){Job_Team__c objJTR = staffJobTeamMap.get(apw.Sojw.Staffname);  
        
        system.debug('HERE1'+objJTR );
        
        lstJTRDelete= [Select Id,Job_Task__c,Job_Task__r.Job__c from Job_Task_Role__c where Name=: objJTR.Role__c and Job_Task__r.Job__c =: objJTR.job__c AND User__c = : objJTR.Staff__c];
       
        system.debug('HERE2'+lstJTRDelete);
          
       if(lstJTRDelete.size()>0) if (!Job_Task_Role__c.sObjectType.getDescribe().isDeletable()){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
         
          }else{ delete lstJTRDelete;}   deleteJobteam.add(objJTR);     
           
                }
            }
            
        }
        
     if(!AddJobTeam.isEmpty()){ if (!Job_Team__c.sObjectType.getDescribe().isCreateable()){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
         
          }else{ insert AddJobTeam;} 
        
         }
        
        
        
      if(!deleteJobteam.isEmpty()){ if (!Job_Team__c.sObjectType.getDescribe().isDeletable()){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
          
           }
     
      else{ delete deleteJobteam;} 
           
                  }
          
            }
        if(isMob)
         {
        
                PageReference p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobId+'&tab=RelatedList'+'&section=Team');
                 p.setRedirect(true);
                 return p; 
         }
         else if(isLtng)
         {
             // PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=jobteam');
                 PageReference p =  new Pagereference('/'+jobId);
                 p.setRedirect(true);
                 return p; 
         
         }
        else
        {
        
          PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
          p.setRedirect(true);
          return p;
        }
    }
 //End method Adding staffs to team   
    
    // This method is called on to handle Cancel method
    public pagereference cancel()
    {
         if(isMob)
         {
        
                PageReference p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobId+'&tab=RelatedList'+'&section=Team');
                 p.setRedirect(true);
                 return p; 
         }
         else if(isLtng)
         {
             // PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=jobteam');
                 PageReference p =  new Pagereference('/'+jobId);
                 p.setRedirect(true);
                 return p; 
         
         }
        else
        {
        
          PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
          p.setRedirect(true);
          return p;
        }
    }
    // End of method Cancel
    
    
}