public with sharing class CreateProductionEstimateTemplateExt 
{
  
    // Global variables 
    
 /*   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string PETempprefix {set;get;}

    public  final Production_Estimate_Template__c objPET; 
    public string PETID;
    
     // Start Constructor
    public CreateProductionEstimateTemplateExt(ApexPages.StandardController controller) 
    {
       this.objPET = (Production_Estimate_Template__c)controller.getRecord(); 
       
       PETempprefix = Production_Estimate_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End Constructor
    
    //Save Method
    Public PageReference saveme()
    {
     try 
       { 
            insert objPET;
            PETID=objPET.id;
       }
       Catch(System.DMLException e) { return null; }
        
      PageReference p =  new Pagereference('/'+PETID);
      p.setRedirect(true);
      return p;
    }
    //End of Save Method
    
    //Cancel Method
      Public PageReference cancelme()
      {
             PageReference p;   
             if(isLtng)
             {
                p =  new Pagereference('/'+PETempprefix+'/o');
             }
            
            else
             {
               p = new Pagereference('/apex/AdminListView?intFocus=13');
             }
               p.setRedirect(true);
               return p; 
             
             
           /*   PageReference p =  new Pagereference('/apex/AdminListView?intFocus=13');
              p.setRedirect(true);
              return p; 
      }*/
    //End of cancel Method
    

}