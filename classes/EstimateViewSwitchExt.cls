public with sharing class EstimateViewSwitchExt 
{
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
    
    
    public string EstId{get;set;}
    public Estimate_Line_Items__c Et{get;set;}
    
    public EstimateViewSwitchExt (ApexPages.StandardController controller) 
    {
        EstId = controller.getRecord().id;
        
        Et=[select id,name,Job__c from Estimate_Line_Items__c where id=:EstId];
        
    }
    
    Public PageReference pagedir()
    {
         String jobid;
         jobid =  Et.Job__c;
         
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=Jobcost'+'&section=estimate');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=5');
                p.setRedirect(true);
                return p;
        }
         
    }
    

}