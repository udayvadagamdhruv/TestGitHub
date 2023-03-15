// This Class is used to Delete ScheduleTemplate */
public with sharing class DeleteScheduleTemplateExtension 
{
   public boolean isLtng{private set;get{
     string theme=UserInfo.getUITheme();
     return (theme=='Theme4d')?true:false;
 }}
 public string sctPrefix {set;get;}

    // Global Variables
    public Id JobId;
    public Boolean isError{get;set;}
    private final Schedule_Template__c objST; 
    // End of Global Variables 
    
    // Standard Controller Constructor 
    public DeleteScheduleTemplateExtension(ApexPages.StandardController con) 
    {
       isError = False;
       this.objST=(Schedule_Template__c)con.getrecord();
       
       sctPrefix=Schedule_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
     // End of Standard Controller Constructor 

    // Method called on to Delete 
    public PageReference checkDelete()
    {
        try
        {
            Database.delete(objST);        
        }
        catch(System.DMLException e)
        {
            isError = True;
            return null;
        }
        // After deletion Navigate to Schedule Template Tab 
        
      if(isLtng)
      {  
        PageReference p =  new Pagereference('/'+sctPrefix+'/o');
        p.setRedirect(true);
        return p;
       }
       else
       {
        PageReference p =  new Pagereference('/apex/AdminListView?intFocus=2');
        p.setRedirect(true);
        return p;
       
       }
     }
     
      public PageReference schtageback()
     {
    
     if(isLtng)
      {  
        PageReference p =  new Pagereference('/'+sctPrefix+'/o');
        p.setRedirect(true);
        return p;
       }
       else
       {
        PageReference p =  new Pagereference('/apex/AdminListView?intFocus=2');
        p.setRedirect(true);
        return p;
       
       }
     
     
     }
     
     
     // End of Delete Method
     
      // Start Test Coverage Code

        
        // End of Positive Test Case
}// End of Class