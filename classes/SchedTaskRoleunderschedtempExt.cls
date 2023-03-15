// Extension class to Select Role for Schedule Task under Schedule Template 
public with sharing class SchedTaskRoleunderschedtempExt{

    // Global Variables 
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    public  boolean isError{get;set;}
    public List<RoleWrapper> rolewraps{get;set;}
    public ScheduleTaskRole__c stRole{get;set;}
    public List<ScheduleTaskRole__c> lst{get;set;}
    public ScheduleTaskRole__c stc;
    String strSTId,strid,theId;
    public String str1{get;set;}
    public Schedule_Task__c st{get;set;}
    
    // End of Global Variables 
    

    
    set<String> sctaro=new set<String>();
               
    // Standard Controller Constructor 
    public SchedTaskRoleunderschedtempExt(ApexPages.StandardController controller) 
    {
        isError=false;

      
        
        theId = ApexPages.CurrentPage().getParameters().get('scheduleTaskId'); 
        this.stc=(ScheduleTaskRole__c)controller.getrecord();
        stc.Schedule_Task__c=theId;
        st = [select id,Schedule_Template__c from Schedule_Task__c where id=:theId limit 1 ];
        roleWraps=new List<RoleWrapper>();
        
        
         
                
       //  List<ScheduleTaskRole__c> lstSTR = [Select id,Name,Schedule_Task__c from ScheduleTaskRole__c where Schedule_Task__c =: theID];
  
        List<UserRole> uRole=[Select Name from UserRole order by Name LIMIT 10000];
        
        for(ScheduleTaskRole__c str: [Select id,name,Schedule_Task__c from ScheduleTaskRole__c where Schedule_Task__c =: theID])
                {
                    sctaro.add(str.Name );
                }
          
        
       //  This will check all the roles which are already assigned to Schedule Task
        for(UserRole u: uRole)
        {
            RoleWrapper rw=new RoleWrapper();
            if(sctaro.contains(u.Name))
            {
                rw.u=u;
                rw.checked=True;
            }
            else
            {
                rw.u=u;
                rw.checked=False;
            }
            roleWraps.add(rw);        
        }
   }
   // End of Standard Controller Constructor

     // Start RoleWrapper Class Implementation
     public class RoleWrapper
     {
         public UserRole u{get;set;}
         public Boolean checked{get;set;}
     }       
     // End of Rolewrapper Class
     
   
     
     // Method called on to Save selected Roles 
        public pagereference Save()
        {
            // First it will delete already assigned Roles and then assign new Role based on user selection
            
            List<ScheduleTaskRole__c> lstSTR = [Select id,Name,Schedule_Task__c from ScheduleTaskRole__c where Schedule_Task__c =: theID];
            delete lstSTR;
            try
           {
             for(RoleWrapper rw:roleWraps)
             {
                lst=new List<ScheduleTaskRole__c>();
                 if(rw.checked==true)
                 {
                     stRole=new ScheduleTaskRole__c();
                     strid = stc.Schedule_Task__c;
                     stRole.Name=rw.u.Name;
                     stRole.Schedule_Task__c=strid;
                     lst.add(stRole);
                 }
                 insert lst;
             }
             // After save opeartion navigate to the Schedule Task Detail Page
             if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+st.Schedule_Template__c);
                 p.setRedirect(true);
                 return p; 
            }
            else
            {
                 PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverride?id='+st.Schedule_Template__c);
                 p.setRedirect(true);
                 return p;
            }
             
             
             
             
             
           }
        catch(DMLException e)
        {
         //isError = true;ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e))); 
          return null;
        }    
     }
     // End of method Save
     
     // This method is called on handle Cancel button
     public pagereference cancel()
     {
         if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+st.Schedule_Template__c);
             p.setRedirect(true);
             return p; 
        }
        else
        {
             PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverride?id='+st.Schedule_Template__c);
             p.setRedirect(true);
             return p;
        }
         
     }
     // End of method Save
     
    
 }
 // End of Class