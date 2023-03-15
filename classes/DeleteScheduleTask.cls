// This Class is used to Delete Schedule Task

public with sharing class DeleteScheduleTask 
{
  // Global Variables 
                public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    public Id STId;
    private final Schedule_Task__c objST;
    public Double Task_Order_No{get;set;}
    // End of Global Variables
    
    // Standard Controller Constructor 
    public DeleteScheduleTask(ApexPages.StandardController con) 
    {
         this.objST=(Schedule_Task__c)con.getrecord();
         STId = [Select Id, Schedule_Template__c from Schedule_Task__c where Id =:objST.Id limit 1].Schedule_Template__c;
         Task_Order_No= [Select Id, Task_Order__c from Schedule_Task__c where Id =:objST.Id limit 1].Task_Order__c;
    }
    // ENd of Standard Controller Constructor 
    
    
    // Method called on to Delete Schedule Task
     public PageReference checkDelete()
     {
        try
        {
            Database.delete(objST);  
            List<Schedule_Task__c> updateTask=new List<Schedule_Task__c>();
            List<Schedule_Task__c> lstST=[Select id,Task_Order__c from Schedule_Task__c where Schedule_Template__c=: STId AND Task_Order__c >: Task_Order_No Order BY Task_Order__c];
            System.debug('Below Task records after deletion : '+lstST);
            if(!lstST.isEmpty())
            {
                for(Integer i=0;i<lstST.size();i++)
                {
                    if(i==0)
                    {
                        lstST[i].Task_Order__c = Task_Order_No;
                    }
                    else
                    {    
                        lstST[i].Task_Order__c= lstST[i-1].Task_Order__c + 1;
                    }
                    updateTask.add(lstST[i]);
                }
//            update lstST;
             update updateTask;
            }
            
                
        }
        catch(System.DMLException e)
        {
            return null;
        }
        
        
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverrideLightning?id='+STId);
             p.setRedirect(true);
             return p; 
        }
        else
        {
                 PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverride?id='+STId);
                p.setRedirect(true);
                return p;
        }
        
        
        // After deletion navigate to Schedule Template parent record 
           
     }
     // End of Check Delete
    
    
     // Test Coverage Code
         static testMethod void deleteScheduleTaskPositiveTest()
         {
                Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
                     insert testMedia;
                
                Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 10',Media_Types__c=testMedia.Id);
                     insert testST;
                 
                GL_Code__c testGL=new GL_Code__c(Name='Test GL Code',GL_ID__c='Test GL001');
                     insert testGL; 
                  
                Schedule_Task__c testSCT=new Schedule_Task__c(Name='Test Schedule Task 10',Schedule_Template__c=testST.Id,Days__c=5,GL_Code__c=testGL.Id);
                     insert testSCT; 
                
                // Test For Dupliacte Schedule Task 
                
                Schedule_Task__c testSCT1=new Schedule_Task__c(Name='Test Schedule Task 10',Schedule_Template__c=testST.Id,Days__c=5,GL_Code__c=testGL.Id);
                try
                {
                    insert testSCT1;   
                }
                catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
               }
               
                Schedule_Task__c testSCT2=new Schedule_Task__c(Name='Test Schedule Task 98',Schedule_Template__c=testST.Id,Days__c=5,GL_Code__c=testGL.Id);
                insert testSCT2;
                testSCT2.Name='Test Schedule Task 10';
                try
                {
                    update testSCT2;
                }
                catch(System.DMLException e)
               {
                   System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,  e.getDmlStatusCode(0));
               }
               // End of Duplicate Test 
               
               
                // Instantiate the standard controller with the Spec Item
       
            ApexPages.StandardController con=new ApexPages.StandardController(testSCT);
        
            // Instantiate the extention instance with the standardcontroller
            DeleteScheduleTask ext=new DeleteScheduleTask(con);
        
            // Invoke the primary method on the extension 
            ApexPages.PageReference result=ext.checkDelete();
            ApexPages.PageReference result1=ext.checkDelete();
         }
    // End of Test Coverage
}
// End of Class