public with sharing class TagsListViewSwitchExt{
  /*  
    public boolean isLtng{get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          } set;
            }  
   
   
    public string TagId{get;set;}
    public Tag__c Tag{get;set;}
    
    public TagsListViewSwitchExt(ApexPages.StandardController controller) 
    {
        TagId= controller.getRecord().id;
        
        Tag=[select id,name,Job__c from Tag__c where id=:TagId];
        
    }
    
    Public PageReference pagedir()
    {
         String jobid;
         jobid =  Tag.Job__c;
         if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=Tag');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=9');
                p.setRedirect(true);
                return p;
        } 
    }*/
    

}