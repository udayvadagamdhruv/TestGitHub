public with sharing class POViewSwitchExt {

    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
    
    
    public string POId{get;set;}
    public Purchase_Order__c PO{get;set;}
    
    public POViewSwitchExt (ApexPages.StandardController controller) 
    {
        POId = controller.getRecord().id;
        
        PO=[select id,name,Job__c from Purchase_Order__c where id=:POId];
        
    }
    
    Public PageReference pagedir()
    {
         String jobid;
         jobid =  PO.Job__c;
         
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=Jobcost'+'&section=purchaseorders');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=6');
                p.setRedirect(true);
                return p;
        }
         
    }
  
}