public with sharing class CreateCT {


   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
      public string CTemprefix {set;get;}


    // Global variables 
    private final Campaign_Template__c objCampTemp; 


    public CreateCT(ApexPages.StandardController controller){
    
    objCampTemp=(Campaign_Template__c)controller.getRecord(); 
    CTemprefix=Campaign_Template__c.SObjectType.getDescribe().getKeyPrefix(); 
    }


  Public PageReference saveme()
  {
        try 
           { 
             insert objCampTemp;
           }
        Catch(System.DMLException e)
           {
               return null;
           }
         
       PageReference p;
        if(isLtng)
            p = new Pagereference('/'+CTemprefix+'/o');
        else
            p = new Pagereference('/apex/AdminListView?intFocus=15');
            p.setRedirect(true);
            return p;
  
    }
   
    
    //Cancel Method
   Public PageReference cancelme()
    {
      PageReference p;
      if(isLtng)
        p=new Pagereference('/'+CTemprefix+'/o');
       else
        p=new Pagereference('/apex/AdminListView?intFocus=15');
        p.setRedirect(true);
        return p;          
      }


}