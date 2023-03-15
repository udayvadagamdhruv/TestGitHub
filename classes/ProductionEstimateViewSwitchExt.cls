public with sharing class ProductionEstimateViewSwitchExt {
/*
    public boolean isLtng{get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          } set;
            }  
   
   
    public string PEid{get;set;}
    public Production_Estimate__c PE{get;set;}
  
    public ProductionEstimateViewSwitchExt(ApexPages.StandardController controller) {
          PEid = controller.getRecord().id;
        
        PE=[select id,name,Job__c from Production_Estimate__c where id=:PEid];
    }
    
    Public PageReference pagedir()
    {
         String jobid;
         jobid =  PE.Job__c;
         if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=Jobcost'+'&section=PE');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=14');
                p.setRedirect(true);
                return p;
        } 
    }
*/
}