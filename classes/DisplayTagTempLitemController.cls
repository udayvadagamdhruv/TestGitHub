public with sharing class DisplayTagTempLitemController{

// Global variables 
     /*   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  


        String theID;
        public List<Tag_Template_Item__c> TagLI{get;set;} 
        public id strTagLI{get;set;}
        // End Global variables 
        
        // Start Constructor 
        public DisplayTagTempLitemController() 
        {
             theID = ApexPages.CurrentPage().getParameters().get('id');
             TagLI=[select id,Name,TagTemplate__c,Air_Date__c,Air_Time__c,Lengths__c,Promo_Due_Date__c,Promo_End_Date__c,Show_Air_Date__c,Description__c from Tag_Template_Item__c where TagTemplate__c=: theID ORDER BY Name];
        }
        // End Constructor
       
        
        // THis methos is called on to Create 
        public PageReference createTagLI()
        {
           // PageReference p =  Page.CreateInvAllocTempLItem;
            
            PageReference p;
            if(isLtng)
            {
                p = new PageReference('/apex/CreateTagtempLineItemsLightning?TagID='+theID);
            }
            else
            {
              p = new PageReference('/apex/CreateTagtempLineItems?TagID='+theID);
            }
             p.setRedirect(true);
           return p;
          
          /*  p =  Page.CreateTagtempLineItems;
            p.setRedirect(true);
            p.getParameters().put('TagID',theID);
            return p
        }
        // End method 
        
         // This method is called on to handle Edit button
        /*   public Pagereference EditIATLI()
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
               
               Database.Delete(objIATLI);
          
           
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