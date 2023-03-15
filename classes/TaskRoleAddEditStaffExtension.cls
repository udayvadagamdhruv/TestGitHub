public with sharing class TaskRoleAddEditStaffExtension {

    // Global variables
    
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
    
    
    
    
    
        
        public Id jobTaskId{get;set;}
        public List<Job_Task_Role__c> lstJTR{get;set;}
        public list<Job_Team__c> staffs;
        public List<StaffWrappers> AllStaffWrappers{get;set;}
        public List<StaffWrappers> AllCreateStaffWrappers{get;set;}
        Public Set<String> StaffNameTaskRole =new Set<String>();
        Public Id jobId;
        public Job_Task__c objJT{get;set;}
        List<Job_Task_Role__c> AddTaskRole;
        Map<String,Job_Task_Role__c> staffTaskRoleMap = new Map<String,Job_Task_Role__c>();
        public string LabelWarning{get;set;}
        
    // End of Global variables
    
    // Standard controller Constructor
    public TaskRoleAddEditStaffExtension (ApexPages.StandardController controller)
    {
               
                
                jobTaskId=ApexPages.CurrentPage().getParameters().get('Id');
                objJT=[Select Id, Job__c from Job_Task__c where Id=:jobTaskId];
                Id jobId=objJT.Job__c;
                lstJTR= [Select Id,name,User__c,Job_Task__c,Job_Task__r.Job__c,Email__c  from Job_Task_Role__c where Job_Task__c =:jobTaskId ];
                
                staffs = new List<Job_Team__c>();
                AllStaffWrappers = new List<StaffWrappers>();
                AllCreateStaffWrappers = new List<StaffWrappers>();
                  
    }
    // End Constructor
    
    
    // This method is used to handle cancel method
    public pagereference cancel()
    {  
       jobId= objJT.Job__c;   
       
               if(isLtng) {
                       
                   PageReference p =  new Pagereference('/apex/JobTaskDetailPageLightning?id='+jobTaskId);
                   p.setRedirect(true);
                   return p;
                 }
             else if(isMob)
                  {
                       PageReference p = new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobId+'&tab=RelatedList'+'&section=Schedule');
                         p.setRedirect(true);
                         return p;
                  }
                 
               else {
                   PageReference p =  new Pagereference('/apex/JobTaskDetailPage?id='+jobTaskId);
                   p.setRedirect(true);
                   return p;
                  }
    }
    // End of method cancel
    
    
    //Start method  Search for staff members from Job Team
    Public void SerachStaff(){
          jobId= objJT.Job__c;   
          String query ='Select Staff__c,Role__c,Email__c  from Job_Team__c where Job__c=: jobId and Staff__c!=null ';
          staffs = Database.query(query);
          if(!staffs.isEmpty()){Set<string> staffNameSet = new Set<String>();
            for(Job_Task_Role__c jtr : lstJTR){
                staffNameSet.add(jtr.User__c);
                staffTaskRoleMap.put(jtr.User__c,jtr);
            }
            
            for(Job_Team__c s:staffs){
            
            if(! staffNameSet.contains(s.Staff__c))
               {
                   AllstaffWrappers.add(new staffWrappers(s));
               
              }
                  
            else{ 
                     staffWrappers w =new staffWrappers(s);
                     w.selection = TRUE;
                     AllstaffWrappers.add(w);
                     StaffNameTaskRole.add(s.Staff__c); 
               }
        }
    
    }
  }  
  //End method  Search for staff members from Job Team
  
    //Start wrapper class for selected staff members 
    
    public class StaffWrappers{
        public Job_Team__c staff{get;set;}
        public boolean selection{get;set;}
        
        public StaffWrappers(Job_Team__c staff){
        this.staff = staff;
        selection = False;
        }
    }
    //End wrapper class for staff members
    
    
    //Start Adding/Removing staff members to Job Task
    public PageReference Addstaff(){
     if(!AllstaffWrappers.isEmpty()){
        AddTaskRole = new List<Job_Task_Role__c>();
        List<Job_Task_Role__c> deleteTaskRole = new List<Job_Task_Role__c>();
        
        for(StaffWrappers apw:AllStaffWrappers){
        boolean existing = StaffNameTaskRole.contains(apw.staff.Staff__c); 
        
        
            if(apw.selection == True){
            if(!existing) AddTaskRole.add(new Job_Task_Role__c(Name=apw.staff.Role__c,User__c=apw.staff.Staff__c,Job_Task__c=jobTaskId,Email__c=apw.staff.Email__c));   
            }else if(existing){if(staffTaskRoleMap.containsKey(apw.staff.Staff__c)){Job_Task_Role__c objJTR = staffTaskRoleMap.get(apw.staff.Staff__c);
              system.debug('HERE1'+objJTR );
         
           deleteTaskRole.add(objJTR);
                }
            }
            
        }
        if(!AddTaskRole.isEmpty()){if (!Job_Task_Role__c.sObjectType.getDescribe().isCreateable()){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
        
           }else{ insert AddTaskRole;} }
          
                  
        if(!deleteTaskRole.isEmpty()){if (!Job_Task_Role__c.sObjectType.getDescribe().isDeletable()){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
         }else{ delete deleteTaskRole;} 
            }
        }
    
    jobId= objJT.Job__c; 
    
        if(isLtng){
                 PageReference p = new Pagereference('/apex/JobTaskDetailPagelightning?id='+jobTaskId);
                 p.setRedirect(true);
                 return p;  
          }
          else if(isMob)
          {
               PageReference p = new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobId+'&tab=RelatedList'+'&section=Schedule');
                 p.setRedirect(true);
                 return p;
          }
          
          else{
          
                 PageReference p = new Pagereference('/apex/JobTaskDetailPage?id='+jobTaskId);
                 p.setRedirect(true);
                 return p;  
          
          }
    }
 //End method Adding/Removing staff members to Job Task
}