public with sharing class ShipmentListViewSwitchExt {

  /*  public boolean isLtng{get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          } set;
            }  
   
   
    public string shpid{get;set;}
    public Shipment__c Shipment{get;set;}
  
    public ShipmentListViewSwitchExt(ApexPages.StandardController controller) {
          shpid = controller.getRecord().id;
        
        Shipment=[select id,name,Job__c from Shipment__c where id=:shpid];
    }
    
    Public PageReference pagedir()
    {
         String jobid;
         jobid =  Shipment.Job__c;
        PageReference p;
         if(isLtng)
        {
             p=  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&tab=Jobcost'+'&section=shipment');
             
        }
        else
        {
           p = new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=16');

        } 
        p.setRedirect(true);
        return p; 
    }*/


}