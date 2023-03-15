public with sharing class PELIListViewSwitchExt
{
   /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  

  
       public string PELIId{get;set;}
       public Production_Estimate_Temp_Line_Items__c PELI{get;set;}
    
        public PELIListViewSwitchExt(ApexPages.StandardController controller) {
        
            PELIId = controller.getRecord().id;
        
            PELI=[select id,name,Production_Estimate_Template__c from Production_Estimate_Temp_Line_Items__c where id=:PELIId];
    
      
        }
    
    
    public pageReference pagedir(){
    
      String PEid;
      PEid  =  PELI.Production_Estimate_Template__c ;
      
         PageReference p ;
         if(isLtng)
         {
              p =  new Pagereference('/apex/PETempDetailpageLightning?id='+PEid);
         
         }
         else
         {
               p =  new Pagereference('/apex/ProductionEstimateTempDetailpage?id='+PEid);
         
         }
             p.setRedirect(true);
              return p;
      
    }*/


}