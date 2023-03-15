public with sharing class CreateBillboardInvoiceLIExtension {

 /*   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
   
   
    private final Billboard_Invoice_Line_Item__c bbili;
    public String bbiid{get;set;}
    public String BillboardInvoicename{get;set;}
   
    String GLDName;
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }

    String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    
    
    
    // Start Constructor
    public CreateBillboardInvoiceLIExtension(ApexPages.StandardController controller) {
    
     this.bbili=(Billboard_Invoice_Line_Item__c )controller.getRecord();
        bbiid=ApexPages.CurrentPage().getParameters().get('bbiid');
        Billboard_Invoice__c objBBI=[Select id,name from Billboard_Invoice__c where id=:bbiid];
        BillboardInvoicename=objBBI.Name;
        bbili.Billboard_Invoice__c = bbiid;
        
    }
    
    // This method is used to retrieve all GLDepartments into dropdown list
    public List<selectOption> getGLDepartments() 
     {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (GL_Department__c gld : [SELECT Id, name FROM GL_Department__c order by Name]) 
          {  
               optionList.add(new selectOption(gld.Id, gld.Name));  
          }
          return optionList;  
     }   
     // End of method getGLDepartments
    
    // This method is used to retrieve all GLCodes into dropdown list
    public List<selectOption> getGLCodes() 
     {
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (GL_Code__c users : [SELECT Id,GL_Id__c,Name FROM GL_Code__c where GL_Department__c =: GLDName ORDER BY Name]) 
          {  
               optionList.add(new selectOption(users.Id, users.GL_Id__c +' '+users.Name));  
          }
          return optionList;  
     }
     // End of method getGLCodes
    
            
      // Save Method
        public PageReference saveme() 
        {      
                try
                {
                    if(schema.SobjectType.Billboard_Invoice_Line_Item__c .Fields.GL_Department__c .isCreateable()){ 
                        bbili.GL_Department__c = GLDName;
                    }
                    if(schema.SobjectType.Billboard_Invoice_Line_Item__c .Fields.GL_Code__c .isCreateable()){ 
                        bbili.GL_Code__c = GLCName;
                    }
                    if(Schema.sObjectType.Billboard_Invoice_Line_Item__c .isCreateable()){
                        insert bbili;
                    }
                    
                }
                catch(DMLException e)
                {
                    return null;
                }
                
            
                 PageReference p;   
                 if(isLtng)
                 {
                    p = new PageReference('/apex/BillboardInvoiceDetailpageLightning?id='+bbiid+'&section=BBLI');
                 }
                
                else
                 {
                   p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+bbiid);
                 }
                
            
            // PageReference pageRef = new PageReference('/apex/BillboardInvoiceDetailpage?id='+bbiid);
              p.setRedirect(true);
              return p;
                  
                  
        }
        // End of Save Method

        // Cancel Method
        Public PageReference cancelme()
        {       
           
           PageReference p;   
             if(isLtng)
             {
                p = new PageReference('/apex/BillboardInvoiceDetailpageLightning?id='+bbiid+'&section=BBLI');
             }
            
            else
             {
               p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+bbiid);
             }
           
           
          //  PageReference p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+bbiid);
            p.setRedirect(true);
            return p;   
            
       }
        // Cancel Method        
        
*/
}