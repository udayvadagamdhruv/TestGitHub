public with sharing class EstimateViewFromPoSwitchExt {


   public boolean isLtng {set;get{
   
   return (Userinfo.getUITheme()=='Theme4d')?true:false;
  
   }} 
    public string poid {set;get;}
    public Purchase_Order__c PO {get;set;}
   

    public EstimateViewFromPoSwitchExt(ApexPages.StandardController controller) {
    
    poid=controller.getRecord().id;
    PO=[select id,name,Job__c From Purchase_Order__c where id=:poid];

    }
    
    
    public pageReference EstviewFromPO(){
     String jobid;
         jobid =  PO.Job__c;
         
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