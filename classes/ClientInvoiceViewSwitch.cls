public with sharing class ClientInvoiceViewSwitch 
{
     /* public boolean isLtng{get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          } set;
            }  
   
   
    public string ClientinvoiceId{get;set;}
    public Client_Invoice__c CLI{get;set;}
    
    public ClientInvoiceViewSwitch (ApexPages.StandardController controller) 
    {
        ClientinvoiceId = controller.getRecord().id;
        
        CLI=[select id,name,Job__c from Client_Invoice__c  where id=:ClientinvoiceId];
        
    }
    
    Public PageReference pagedir()
    {
         String jobid;
         jobid =  CLI.Job__c;
        PageReference p;
         if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=Jobbilling');
            
        }
        else
        {
            p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=13');
               
        } 
         p.setRedirect(true);
             return p; 
    }*/
}