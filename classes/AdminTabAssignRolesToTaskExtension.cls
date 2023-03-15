// This class is used to assign Roles to Task on Admin Tab
public with sharing class AdminTabAssignRolesToTaskExtension
{
    // Global variables
    
                public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
     public String theId;
     public String strSTRID{get;set;}
     public List<ScheduleTaskRole__c> lstSTR{get;set;}
     // End of Global variables
     
    // Start Constructor
     public AdminTabAssignRolesToTaskExtension()
     {
       theId=ApexPages.CurrentPage().getParameters().get('Id');
       lstSTR=[Select Id,Name from ScheduleTaskRole__c where Schedule_Task__c=:theId];
     }
     // End Constructor
    
   // Start assignTheRole method
    public pagereference assignTheRole()
    {
           String theId=ApexPages.CurrentPage().getParameters().get('id');
           
           
             if(isLtng)
            {
                   PageReference p=Page.AssignRoleToSchduleTaskLightning;
                   p.setRedirect(true);
                   p.getParameters().put('scheduleTaskId',theId); return p;
            }
            else
            {
                    PageReference p=Page.AssignRoleToSchduleTask;
                   p.setRedirect(true);
                   p.getParameters().put('scheduleTaskId',theId);
                   return p;
            }
           
           
           
    }
    // end assignTheRole

    // Start Test Coverage
    static testMethod void Test_AdminTabAssignRolesToTaskExtension()
    {
        AdminTabAssignRolesToTaskExtension ext=new AdminTabAssignRolesToTaskExtension();
        ApexPages.Pagereference result=ext.assignTheRole();
        System.assertEquals(null,ext.theId);
    }
   // End Test Coverage 
}
// End of Class