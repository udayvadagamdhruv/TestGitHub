// This class is used to create New Media Type
public with sharing class createnewMT 
{

     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
      public string MTprefix {set;get;}


    // Global variables 
    private final Media_Type__c objMT; 
    
     // Start Constructor
    public createnewMT(ApexPages.StandardController controller) 
    {
       this.objMT = (Media_Type__c)controller.getRecord(); 
       
       Schema.DescribeSObjectResult r=Media_Type__c.SObjectType.getDescribe();
        MTprefix=r.getKeyPrefix();
        
       // ApexPages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+MTprefix));
    }
    // End Constructor
    
    //Save Method
    Public PageReference saveme()
    {
     try 
       { 
            insert objMT;
       }
       Catch(System.DMLException e)
       {
           return null;
       }
     
      
      PageReference p;
       if(isLtng)
          {
          p =  new Pagereference('/'+MTprefix +'/o');
             
          }
       else
           {
            p =  new Pagereference('/apex/AdminListView?intFocus=8');
           }   
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
            p =  new Pagereference('/'+MTprefix +'/o');
          }
       else
           {
            p =  new Pagereference('/apex/AdminListView?intFocus=8');
           }   
           p.setRedirect(true);
           return p;          
      }
    //End of cancel Method
   
   //test method 
   static testMethod void insertMT()
     {
         Media_Type__c testMedia=new Media_Type__c(Name='MT002');
         ApexPages.StandardController con=new ApexPages.StandardController(testMedia);
         createnewMT ext=new createnewMT(con);        
         ApexPages.PageReference result=ext.saveme();
         System.assertEquals('MT002',testMedia.Name);
        
        Media_Type__c testMedia1=new Media_Type__c(Name='MT003');
           try
            {
                insert testMedia1;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
         Media_Type__c mt=[select id,Name from Media_Type__c where id =: testMedia1.id];
         mt.Name = 'MT002';
            try
            {
                update mt;
            }
            catch(System.DMLException e)
            {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
            
            Delete testMedia;
            result=ext.saveme();   
            result=ext.cancelme();
     }  
    //End of test Method 
}
// End of class