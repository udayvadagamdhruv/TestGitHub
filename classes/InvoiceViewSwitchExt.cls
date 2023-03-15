public with sharing class InvoiceViewSwitchExt {

      public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
    
    
    public string InvId{get;set;}
    public Invoice__c Inv{get;set;}
    
    public InvoiceViewSwitchExt (ApexPages.StandardController controller) 
    {
        InvId= controller.getRecord().id;
        
        Inv=[select id,name,Job__c from Invoice__c where id=:InvId];
        
    }
    
    Public PageReference pagedir()
    {
         String jobid;
         jobid =  Inv.Job__c;
         
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=Jobcost'+'&section=vendorinvoices');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=7');
                p.setRedirect(true);
                return p;
        }
         
    }
  

}