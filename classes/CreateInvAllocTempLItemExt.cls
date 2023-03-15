public with sharing class CreateInvAllocTempLItemExt {

    // Global Variables
    
   /*     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
        
        private final Invoice_Allocation_Template_Line_Item__c sc; 
        public String IATID{get;set;}
        public String ClientName;
    
        public String getClientName() { return ClientName; }
        public void setClientName(String s) {  this.ClientName= s; }
        
      // End of Global variables

    // Standard Controller Constructor 
    public CreateInvAllocTempLItemExt (ApexPages.StandardController controller)
    {
        this.sc=(Invoice_Allocation_Template_Line_Item__c)controller.getrecord();
        IATID=ApexPages.CurrentPage().getParameters().get('IATID');
        sc.Invoice_Allocation_Template__c= IATID;
    }
    // End Constructor
 
    public List<selectOption> getClients() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c c : [SELECT Id, name,client_code__c  FROM Client__c order by Name]) 
        {  
            optionList.add(new selectOption(c.Id, c.Name + (c.client_code__c != null?' - ':'') + (c.client_code__c != null?c.client_code__c:''))); 
        }
        return optionList;  
    }
   
    // Method called to save 
    Public PageReference saveme()
    {
        try
        {
            if(schema.SobjectType.Invoice_Allocation_Template_Line_Item__c.Fields.Client__c.isCreateable()){
             sc.Client__c=ClientName;
             }
             if(Schema.sObjectType.Invoice_Allocation_Template_Line_Item__c.isCreateable()){
             insert sc;
             }
             
              PageReference p;
            if(isLtng)
            {
                 p = new PageReference('/apex/InvAllocationTempDetailpageLightning?id='+IATID);
            }
            else
            {
                  p = new PageReference('/apex/InvAllocationTempDetailpage?id='+IATID);
            }
             
                     
          //   PageReference p =  new Pagereference('/apex/InvAllocationTempDetailpage?id='+IATID);
             p.setRedirect(true);
             return p;
           
        }
        catch(System.DMLException e)
        {
            return null;
        }
    }
    // End save method
    
    public PageReference savenew() 
                { 
                
                 try
                    {
                        if(schema.SobjectType.Invoice_Allocation_Template_Line_Item__c.Fields.Client__c.isCreateable()){
                           sc.Client__c=ClientName;
                         }
                         if(Schema.sObjectType.Invoice_Allocation_Template_Line_Item__c.isCreateable()){
                             insert sc;
                         }
                         
                        PageReference p;
                        if(isLtng)
                        {
                             p = Page.CreateInvAllocTempLItemLightning;
                        }
                        else
                        {
                              p = Page.CreateInvAllocTempLItem;
                        }
                         
                        
                       //PageReference p =  Page.CreateInvAllocTempLItem;
                       p.setRedirect(true);
                       p.getParameters().put('IATID',IATID);
                       return p;
                    }
                    catch(DMLException e){return null;   }
                   
                  
                  
                  
               }
    
    
    
    
    
    
    // Cancel Method
        Public PageReference cancelme()
        {       
            PageReference p;
            if(isLtng)
            {
                 p = new PageReference('/apex/InvAllocationTempDetailpageLightning?id='+IATID);
            }
            else
            {
                  p = new PageReference('/apex/InvAllocationTempDetailpage?id='+IATID);
            }
           
           
           
           // PageReference p = new PageReference('/apex/InvAllocationTempDetailpage?id='+IATID);
            p.setRedirect(true);
            return p;   
            
        }
        // Cancel Method  
    
    
    */
    
    
    

}