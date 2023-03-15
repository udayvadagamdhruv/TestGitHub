public with sharing class SpecViewSwitchExt {

    
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
    
    
    public string SpecId{get;set;}
    public Job_Spec__c Spec{get;set;}
    
    public SpecViewSwitchExt (ApexPages.StandardController controller) 
    {
        SpecId = controller.getRecord().id;
        
        Spec=[select id,name,Job__c from Job_Spec__c where id=:SpecId];
        
    }
    
    Public PageReference pagedir()
    {
         String jobid;
         jobid =  Spec.Job__c;
         
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=CreativeBrief');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=3');
                p.setRedirect(true);
                return p;
        }
         
    }
    

}