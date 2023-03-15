public with sharing class CreateInvoiceAllocationLI {

/*
public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  

//Global variables
    public String CIid{get;set;}
    Public list<Invoice_Allocation_Line_Item__c> IALI {get;set;}
    public ID selectedClient {get; set;}
    
    String GLDName;
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }

    String GLCName;
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    
    
    
    

public CreateInvoiceAllocationLI()
   {
       CIid = ApexPages.currentPage().getParameters().get('id');
       
       IALI=new list<Invoice_Allocation_Line_Item__c>();
       
       IALI.add(new Invoice_Allocation_Line_Item__c(Client_Invoice__c=CIid));
       List<selectOption> options = new List<selectOption>();
        options = getClient() ;
       }
       
     public List<selectOption> getClient() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c c : [SELECT Id, name,client_code__c  FROM Client__c order by Name]) 
        {  
            optionList.add(new selectOption(c.Id, c.Name + (c.client_code__c != null?' - ':'') + (c.client_code__c != null?c.client_code__c:''))); 
        }
        return optionList;  
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
                try{
                list<Invoice_Allocation_Line_Item__c> IALI1= new List<Invoice_Allocation_Line_Item__c>();
                 
                       for(Invoice_Allocation_Line_Item__c ia:IALI){
                        if(schema.SobjectType.Invoice_Allocation_Line_Item__c.Fields.Client_Name__c.isCreateable()){ 
                            ia.Client_Name__c=selectedClient;
                        }
                      //  ia.GL_Department__c = GLDName;
                      //  ia.GL_Code__c = GLCName;
                        IALI1.add(ia);
                       
                       }
                       if(Schema.sObjectType.Invoice_Allocation_Line_Item__c.isCreateable()){
                        insert IALI1;
                        }
                        
                    }
                    catch(DMLException e){ return null;} 
                 
                 PageReference pageRef;
                 if(isLtng)      
                  pageRef= new PageReference('/apex/ClientInvoiceDetailpageLightning?id='+CIid);
                  else
                  pageRef= new PageReference('/apex/ClientInvoiceDetailpage?id='+CIid);
                  pageRef.setRedirect(true);
                  return pageRef;
                  
                  
               }
            // End of Save Method
            
            
            public PageReference savenew() 
                { 
                list<Invoice_Allocation_Line_Item__c> IALI1= new List<Invoice_Allocation_Line_Item__c>();
                 try
                    {
                       for(Invoice_Allocation_Line_Item__c ia:IALI){
                        if(schema.SobjectType.Invoice_Allocation_Line_Item__c.Fields.Client_Name__c.isCreateable()){ 
                        ia.Client_Name__c=selectedClient;
                        }
                      //  ia.GL_Department__c = GLDName;
                       // ia.GL_Code__c = GLCName;
                        
                        IALI1.add(ia);
                       
                       }
                       if(Schema.sObjectType.Invoice_Allocation_Line_Item__c.isCreateable()){
                         insert IALI1;
                       }
                        
                    }
                    catch(DMLException e){return null;   }
                   
                  PageReference pageRef;
                if(isLtng) 
                   pageRef = new PageReference('/apex/CreateInvoiceAllocationLILightning?id='+CIid);
                 else
                   pageRef = new PageReference('/apex/CreateInvoiceAllocationLI?id='+CIid);
                   pageRef.setRedirect(true);
                   return pageRef;
                  
                  
               }




 // Method called on to handle Back Button
   public pagereference Back()
  {
              PageReference pageRef;
                 if(isLtng)      
                  pageRef= new PageReference('/apex/ClientInvoiceDetailpageLightning?id='+CIid);
                  else
                  pageRef= new PageReference('/apex/ClientInvoiceDetailpage?id='+CIid);
                  pageRef.setRedirect(true);
                return pageRef;
  }
  // End of Back
*/
}