public with sharing class EditInvAllocTempLItemExt {

   /*   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
    
    
    private final Invoice_Allocation_Template_Line_Item__c  objIATLI;
    public Invoice_Allocation_Template_Line_Item__c  objIATLI1{get;set;}
    public String  ClientName,IATID;
    
    public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }

    public EditInvAllocTempLItemExt(ApexPages.StandardController con) {
    
    this.objIATLI=(Invoice_Allocation_Template_Line_Item__c)con.getRecord();
        
        
        objIATLI1= [select id,Name,Allocation_Qty__c,Client__c ,Client__r.name,Invoice_Allocation_Template__c  from Invoice_Allocation_Template_Line_Item__c where  id =:objIATLI.id];
        String st1=objIATLI1.Client__c;
        
        IATID=objIATLI1.Invoice_Allocation_Template__c;
        
        if(String.isNotBlank(st1))
        {
            Client__c c=[Select id,Name from Client__c where id=: st1];
            ClientName= c.id; 
        }
       

    }
    
    
    
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


     // Method called on to Update 
  Public PageReference saveme()
    {
        try
        {
            if(schema.SobjectType.Invoice_Allocation_Template_Line_Item__c.Fields.Client__c.isUpdateable()){
                objIATLI.Client__c=ClientName;
            }           
            if(Schema.sObjectType.Invoice_Allocation_Template_Line_Item__c.isUpdateable()) {
                update objIATLI;
            }
        }
        catch(System.DMLException e) { return null;}
         
            PageReference p;
            if(isLtng)
            {
                 p = new PageReference('/apex/InvAllocationTempDetailpageLightning?id='+IATID);
            }
            else
            {
                  p = new PageReference('/apex/InvAllocationTempDetailpage?id='+IATID);
            }
             
      //  PageReference p =  new Pagereference('/apex/InvAllocationTempDetailpage?id='+IATID);
        p.setRedirect(true);
        return p; 
    }  
    // End of Method Update 
  
    // Method called on to handle Cancel button 
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
             
      // PageReference p =  new Pagereference('/apex/InvAllocationTempDetailpage?id='+IATID);
       p.setRedirect(true);
       return p;
    } 
*/



}