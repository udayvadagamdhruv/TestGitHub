public with sharing class DisplayBillboardContractController {

/*public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
       String theid;
        public List<Billboard_Contract__c> BBC{get;set;} 
        public String strBBC{get;set;}
        // End Global variables 
        
        // Start Constructor 
        public DisplayBillboardContractController () 
        {
             theid= ApexPages.CurrentPage().getParameters().get('id');
             BBC=[select id,Name,BB_Vendor_Name__c,Billboard__c,Billboard_Type__c,Contract_Number__c,Contract_Title__c,End_Date__c,Expiration_Date__c,No_of_Insertions__c,Rate__c,Start_Date__c,Status__c from Billboard_Contract__c where Billboard__c =: theid ORDER BY End_Date__c];
        }
        // End Const

        
         
        // THis methos is called on to Create Billboard Contract
        public PageReference createBBC()
        {
             PageReference p;   
             if(isLtng)
             {
                p = Page.CreateBillboardContractLightning;
             }
            
             else
             {
               p = Page.CreateBillboardContract;
             }
            
           // PageReference p =  Page.CreateBillboardContract;
            p.setRedirect(true);
            p.getParameters().put('bbid',theid);
            return p;
        }
        // End method 
        
        
         // This method is called on to handle delete Billboard Contract
         public pagereference deleteBBC()
         {
             Billboard_Contract__c objBBC=[Select id,Billboard__c from Billboard_Contract__c where id=:strBBC];
               Id BID=objBBC.Billboard__c ;
               
               if(Billboard_Contract__c.sObjectType.getDescribe().isDeletable()){
                   Database.Delete(objBBC);}
          
           
               // After deletion, navigate to BB Detail Page
               
               PageReference p;   
               if(isLtng)
               {
                  p = new Pagereference('/apex/BillboardDetailPageLightning?id='+BID+'&section=BBC');
               }
            
               else
               {
                   p = new Pagereference('/apex/BillboardDetailPage?id='+BID);
               }
             
             
              // Pagereference p=new Pagereference('/apex/BillboardDetailPage?id='+BID);
               p.setRedirect(true);
               return p;
         }
         // End of method deleteBBC        
         */
}