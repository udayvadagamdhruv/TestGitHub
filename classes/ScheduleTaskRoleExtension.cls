// Extension class to Select Role for Schedule Task 
public with sharing class ScheduleTaskRoleExtension {

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
   // public Id strId{get;set;}
    // End of Global Variables 
    

    
    set<String> sctaro=new set<String>();
               
    // Standard Controller Constructor 
    public ScheduleTaskRoleExtension(ApexPages.StandardController controller) 
    {
        isError=false;
        theId = ApexPages.CurrentPage().getParameters().get('scheduleTaskId');
        this.stc=(ScheduleTaskRole__c)controller.getrecord();
        stc.Schedule_Task__c=theId;
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
                 PageReference p =  new Pagereference('/apex/ScheduleTaskDetailPageLightning?id='+theId);
                 p.setRedirect(true);
                 return p;
            }
            else
            {
                    PageReference p =  new Pagereference('/apex/ScheduleTaskDetailPage?id='+theId);
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
                 PageReference p =  new Pagereference('/apex/ScheduleTaskDetailPageLightning?id='+theId);
                 p.setRedirect(true);
                 return p;
            }
            else
            {
                    PageReference p =  new Pagereference('/apex/ScheduleTaskDetailPage?id='+theId);
                     p.setRedirect(true);
                     return p;
            }
     
     
         
     }
     // End of method Save
     
     // Test Coverage
      static testMethod void Test_ScheduleTaskRoleExtension()
           {
             Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
                insert testMedia;
                
             Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 10',Media_Types__c=testMedia.Id);
                 
                  insert testST;
                  
              GL_Code__c testGL=new GL_Code__c(Name='Test GL Code',GL_ID__c='Test GL001');
                  insert testGL;
         
              Schedule_Task__c testSCT=new Schedule_Task__c(Name='Test Schedule Task 10',Schedule_Template__c=testST.Id,Days__c=5,GL_Code__c=testGL.Id);
                 insert testSCT;
                 
              System.assertEquals('Test Schedule Task 10',testSCT.Name);   
                 
               User u1 = [SELECT UserRole.Name from User where Profile.Name='System Administrator' limit 1];
               RoleWrapper w = New RoleWrapper();
                
               List<RoleWrapper> wlist = new List<RoleWrapper>(); 
      
               w.u = u1.UserRole;
               w.Checked= True;
               wlist.add(w); 
               
                // Instantiate the standard controller with the Spec Item
       
               ScheduleTaskRole__c st=new ScheduleTaskRole__c();
               ApexPages.StandardController con = new ApexPages.StandardController(st);
        
                // Instantiate the extention instance with the standardcontroller 
                ScheduleTaskRoleExtension ext=new ScheduleTaskRoleExtension(con);
                 ApexPages.PageReference result=ext.Save();    
                 
                 ext.roleWraps[0].checked=True;
                
        
                // Invoke the primary method on the extension 
                
                 result=ext.Save();     
               
               User u2 = [SELECT UserRole.Name from User where Profile.Name='System Administrator' limit 1];
               RoleWrapper w1 = New RoleWrapper();
                
               List<RoleWrapper> wlist1 = new List<RoleWrapper>(); 
      
               w1.u = u2.UserRole;
               w1.Checked= True;
               wlist1.add(w); 
               
                // Instantiate the standard controller with the Spec Item 
       
               ScheduleTaskRole__c st1=new ScheduleTaskRole__c();
               ApexPages.StandardController con1 = new ApexPages.StandardController(st1);
        
                // Instantiate the extention instance with the standardcontroller 
                ScheduleTaskRoleExtension ext1=new ScheduleTaskRoleExtension(con1);
        
                //  Invoke the primary method on the extension 
                 ApexPages.PageReference result1=ext1.Save();   
                 result1=ext1.cancel();
      }
     // End Test Coverage 
 }
 // End of Class