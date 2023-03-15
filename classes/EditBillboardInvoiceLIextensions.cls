public with sharing class EditBillboardInvoiceLIextensions {

 /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
  
  
   private final Billboard_Invoice_Line_Item__c objBBILI;
   public String BBIID{get;set;}
   public String BillboardInvoicename{get;set;}  
   public Billboard_Invoice_Line_Item__c objBBILI1{get;set;}
   Public String GLDName;
   public String getGLDName() { return GLDName; }
   public void setGLDName(String s) {  this.GLDName = s; }

   Public String GLCName;
   public String getGLCName() { return GLCName; }
   public void setGLCName(String s) {  this.GLCname = s; } 
   
   
     // End of Global variables 

    // Standard Controller Constructor
    public EditBillboardInvoiceLIextensions(ApexPages.StandardController con) 
    {
        this.objBBILI=(Billboard_Invoice_Line_Item__c)con.getRecord();
        
        
        objBBILI1= [SELECT id, name,Amount__c,Billboard_Invoice__c,Billboard_Invoice__r.name,GL_Code_No__c,GL_Department__c,GL_Code__c,Unit_Type__c ,Quantity__c FROM Billboard_Invoice_Line_Item__c WHERE id =:objBBILI.id];
        BillboardInvoicename=objBBILI1.Billboard_Invoice__r.name;
        BBIID=objBBILI1.Billboard_Invoice__c;
        
        String st1 = objBBILI1.GL_Department__c;
        String st2=objBBILI1.GL_Code__c;
        system.debug('st1 -----> ' + st1);
        system.debug('st2 -----> ' + st2);
        
       
        if(String.isNotBlank(st1))
        {
            GL_Department__c GD=[Select id,Name from GL_Department__c where id=: st1];
            GLDName=GD.id; 
        }
         if(String.isNotBlank(st2))
        {
            GL_Code__c GC=[Select id,Name from GL_Code__c where id=: st2];
            GLCName=GC.id; 
        }
        
       
       
    }
    // End of Standard Controller Constructor 
    
    
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
                        if(schema.SobjectType.Billboard_Invoice_Line_Item__c.Fields.GL_Department__c.isUpdateable()){
                            objBBILI.GL_Department__c = GLDName;
                        }
                        if(schema.SobjectType.Billboard_Invoice_Line_Item__c.Fields.GL_Code__c.isUpdateable()){
                            objBBILI.GL_Code__c = GLCName;
                        }
                        if(Schema.sObjectType.Billboard_Invoice_Line_Item__c.isUpdateable()) {
                            update objBBILI;
                        }
                        
                    }
                    catch(DMLException e)
                    {
                        return null;
                    }
                    
                     PageReference p;   
                     if(isLtng)
                     {
                        p = new PageReference('/apex/BillboardInvoiceDetailpageLightning?id='+BBIID+'&section=BBLI');
                     }
                    
                     else
                     {
                       p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+BBIID);
                     }
                    
                    
                    
              //   PageReference pageRef = new PageReference('/apex/BillboardInvoiceDetailpage?id='+BBIID);
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
                p = new PageReference('/apex/BillboardInvoiceDetailpageLightning?id='+BBIID+'&section=BBLI');
             }
            
             else
             {
               p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+BBIID);
             }
                   
                   
                   
           // PageReference p = new PageReference('/apex/BillboardInvoiceDetailpage?id='+BBIID);
            p.setRedirect(true);
            return p;   
            
       }
// Cancel Method     
    
    */
    
}