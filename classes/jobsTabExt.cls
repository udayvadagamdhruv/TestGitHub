public with sharing class jobsTabExt 
{
  
    public jobsTabExt(ApexPages.StandardController controller) 
    {
        
    }


    public jobsTabExt(ApexPages.StandardSetController controller) 
    {
       
    }
    
    public PageReference NewMethod()
    {
        PageReference p = new PageReference('/apex/JobRequestFormMobile');
                p.setRedirect(true); 
                return p;
    }
    
    
  
   
}