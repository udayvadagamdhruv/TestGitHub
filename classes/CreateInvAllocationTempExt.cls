public with sharing class CreateInvAllocationTempExt {


    // Global variables 
    /*
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string InvTempprefix {set;get;}
    public final Invoice_Allocation_Template__c objIAT; 
    public string IATID;
    
     // Start Constructor
    public CreateInvAllocationTempExt(ApexPages.StandardController controller) 
    {
       this.objIAT = (Invoice_Allocation_Template__c)controller.getRecord(); 
       
       InvTempprefix = Invoice_Allocation_Template__c.SobjectType.getDescribe().getKeyPrefix();
       
    }
    // End Constructor
    
    //Save Method
    Public PageReference saveme()
    {
           try 
           { 
                insert objIAT;
                IATID=objIAT.id;
           }
           Catch(System.DMLException e) { return null; }
           PageReference p;   
             if(isLtng)
             {
                 p =  new Pagereference('/apex/InvAllocationTempDetailpageLightning?id='+IATID);
             }
            
            else
             {
                 p =  new Pagereference('/apex/InvAllocationTempDetailpage?id='+IATID);
             }
       
     // PageReference p =  new Pagereference('/apex/InvAllocationTempDetailpage?id='+IATID);
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
                p =  new Pagereference('/'+InvTempprefix+'/o');
             }
            
            else
             {
               p =  new Pagereference('/apex/AdminListView?intFocus=12');
             }
               p.setRedirect(true);
               return p; 
             
      
             /* PageReference p =  new Pagereference('/apex/AdminListView?intFocus=12');
              p.setRedirect(true);
              return p; */
     // }
    //End of cancel Method

}