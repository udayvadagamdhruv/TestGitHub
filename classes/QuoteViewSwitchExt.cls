public with sharing class QuoteViewSwitchExt {
    
    public boolean isLtng{get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          } set;
            }  
   
   
    public string QuoteId{get;set;}
    public Quote__c Qu{get;set;}
    
    public QuoteViewSwitchExt(ApexPages.StandardController controller) 
    {
        QuoteId = controller.getRecord().id;
        
        Qu=[select id,name,Job__c from Quote__c where id=:QuoteId];
        
    }
    
    Public PageReference pagedir()
    {
         String jobid;
         jobid =  Qu.Job__c;
         if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=Jobcost'+'&section=jobquote');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=4');
                p.setRedirect(true);
                return p;
        } 
    }
    

}