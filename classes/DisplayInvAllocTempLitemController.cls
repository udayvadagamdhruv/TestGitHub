public with sharing class DisplayInvAllocTempLitemController {

/*// Global variables 
        public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  


        String theID;
        public List<Invoice_Allocation_Template_Line_Item__c> IATLI{get;set;} 
        public id strIATLI{get;set;}
        // End Global variables 
        
        // Start Constructor 
        public DisplayInvAllocTempLitemController () 
        {
             theID = ApexPages.CurrentPage().getParameters().get('id');
             IATLI=[select id,Name,Allocation_Qty__c,Client__c ,Invoice_Allocation_Template__c  from Invoice_Allocation_Template_Line_Item__c where Invoice_Allocation_Template__c=: theID ORDER BY Name];
        }
        // End Constructor
       
        
        // THis methos is called on to Create 
        public PageReference createIATLI()
        {
           // PageReference p =  Page.CreateInvAllocTempLItem;
            
            PageReference p;
            if(isLtng)
            {
                p =  Page.CreateInvAllocTempLItemLightning;
            }
            else
            {
              p =  Page.CreateInvAllocTempLItem;
            }
            
            
            p.setRedirect(true);
            p.getParameters().put('IATID',theID);
            return p;
        }
        // End method 
        
         // This method is called on to handle Edit button
           public Pagereference EditIATLI()
           {
                  system.debug('IATLI EDIT' + strIATLI);
                  
                    PageReference p;
                    if(isLtng)
                    {
                         p=new Pagereference('/apex/EditInvAllocTempLItemLightning?id='+strIATLI);
                    }
                    else
                    {
                          p=new Pagereference('/apex/EditInvAllocTempLItem?id='+strIATLI);
                    }
                  
               //   Pagereference p=new Pagereference('/apex/EditInvAllocTempLItem?id='+strIATLI);
                  p.setRedirect(true);
                  return p;
           }
   // End of Method Edit
        
        
        
        
        // This method is called on to handle delete Billboard Invoice Line Item
         public pagereference deleteIATLI()
         
         {
            system.debug('IATLI DELETE ' + strIATLI);
         
             Invoice_Allocation_Template_Line_Item__c  objIATLI=[Select id,Name,Allocation_Qty__c,Client__c ,Invoice_Allocation_Template__c  from Invoice_Allocation_Template_Line_Item__c where id=:strIATLI];
               Id IAT=objIATLI.Invoice_Allocation_Template__c  ;
               
               if(Invoice_Allocation_Template_Line_Item__c.sObjectType.getDescribe().isDeletable()){
                   Database.Delete(objIATLI);}
          
           
               // After deletion, navigate to CI Detail Page
               
               
                PageReference p;
                if(isLtng)
                {
                     p = new PageReference('/apex/InvAllocationTempDetailpageLightning?id='+IAT);
                }
                else
                {
                      p = new PageReference('/apex/InvAllocationTempDetailpage?id='+IAT);
                }
               
              // Pagereference p=new Pagereference('/apex/InvAllocationTempDetailpage?id='+IAT);
               p.setRedirect(true);
               return p;
         }
         // End of method deleteBBILI
        
        
*/        
      

}