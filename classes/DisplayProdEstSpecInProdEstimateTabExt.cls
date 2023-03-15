public with sharing class DisplayProdEstSpecInProdEstimateTabExt {
/*
   
    public Id ProdEstLIId{get;set;}
    public List<Production_Spec_Item__c> lstProdSpec{get;set;}
    public List<Production_Estimate_Spec_Item__c> lstProdEstli{get;set;}
    public Production_Estimate__c ProdEstLI{get;set;}
    public String ProductionSpecTempName{get;set;}
    public String SpecId{get;set;}
    public String Peid{get;set;}
    
    
    
    public List<selectOption> getProductionSpecTemplate() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new SelectOption('','-None-'));
        for (Production_Spec_Template__c a : [SELECT Id, name FROM Production_Spec_Template__c ORDER BY Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    
    public DisplayProdEstSpecInProdEstimateTabExt(ApexPages.StandardController SC) 
    {
        ProdEstLI= (Production_Estimate__c)SC.getRecord();
        ProdEstLIId= ApexPages.currentPage().getParameters().get('id');  
        LoadEstSpecItemss();
    }
    
    private void LoadEstSpecItemss()
    {
         ProdEstLIId= ApexPages.currentPage().getParameters().get('id');       
         lstProdEstli=[Select id,Name,Description__c from Production_Estimate_Spec_Item__c where Production_Estimate__c=: ProdEstLIId ORDER BY CreatedDate];   
    }
    
   /* public Pagereference editSpec()
    {
           Pagereference p=new Pagereference('/apex/EditestimatelineitemunderJob?id='+SpecId);
           p.setRedirect(true);
           return p;
    }
    */
    
 /*   public Pagereference DelSpec()
    {
           Production_Estimate_Spec_Item__c delci = [Select id,Name from Production_Estimate_Spec_Item__c where id =: Peid];
            if(Production_Estimate_Spec_Item__c.sObjectType.getDescribe().isDeletable()){
                delete delci; }
          
          
           Pagereference p=new Pagereference('/apex/ProductionEstimatedetailpage?id='+ProdEstLIId );
           p.setRedirect(true);
           return p;
    }
    
     // This method is called on to handle Save button
    public PageReference save()
    {
          try
          {   
              update lstProdEstli;
          }
          catch(System.DMLException e)
          {
              return null;
          }
          PageReference p =  new Pagereference('/apex/ProductionEstimatedetailpage?id='+ProdEstLIId );
          p.setRedirect(true);
          return p;     
    }
    // End of method Save
    
    // This method is called on to handle Cancel button
     Public PageReference cancelme()
     {
        PageReference p =  new Pagereference('/apex/ProductionEstimatedetailpage?id='+ProdEstLIId );
        p.setRedirect(true);
        return p;     
       }
    // End Cancel method
    
   // This method is called on to add New Spec
    public pagereference addNewSpecs()
    {
         ProdEstLIId = ApexPages.currentPage().getParameters().get('id');       
         Pagereference p=Page.createProductionEstimateSpec;
         p.setRedirect(true);
         p.getParameters().put('ProdEstLIId ',ProdEstLIId );
         return p;
    }
    // End of method addNewJobSpec
    
    
    
    // This method is called on to Import Specs
    public pagereference importSpecs()
    {
        List<Production_Estimate_Spec_Item__c> insertEstSpecItems=new List<Production_Estimate_Spec_Item__c >();    
        
        if(ProductionSpecTempName==NULL || ProductionSpecTempName=='-None-')
        {
           ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Production Spec Temp : You must select a Template.');
           ApexPages.addMessage(msg1);
        }
        else
        {
            try
            {
                List<Production_Spec_Item__c> lstSpecs=[Select id,Name,Description__c from Production_Spec_Item__c where Production_Spec_Template__c=:ProductionSpecTempName];
                for(Production_Spec_Item__c sp:lstSpecs)
                {
                  Production_Estimate_Spec_Item__c js=new Production_Estimate_Spec_Item__c();
                    if(schema.SobjectType.Production_Estimate_Spec_Item__c.Fields.Name.isCreateable()){ 
                        js.Name=sp.Name;
                    }
                    if(schema.SobjectType.Production_Estimate_Spec_Item__c.Fields.Description__c.isCreateable()){ 
                        js.Description__c=sp.Description__c;
                    }
                    if(schema.SobjectType.Production_Estimate_Spec_Item__c.Fields.Production_Estimate__c.isCreateable()){ 
                        js.Production_Estimate__c= ProdEstLIId ;
                    }
                  insertEstSpecItems.add(js);
                }
                if(Schema.sObjectType.Production_Estimate_Spec_Item__c.isCreateable()){
                    insert insertEstSpecItems;
                }
             }
             catch(System.DMLException e)
             {
               return NULL;
             }
        }   
        
          PageReference p =  new Pagereference('/apex/ProductionEstimatedetailpage?id='+ProdEstLIId );
          p.setRedirect(true);
          return p; 
      
    }
    // End of method Import Specs
    
    */
    

}