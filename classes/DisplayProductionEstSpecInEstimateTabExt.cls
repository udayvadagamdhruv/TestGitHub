public with sharing class DisplayProductionEstSpecInEstimateTabExt {

  /*   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    public Id EstLIId{get;set;}
    public List<Production_Spec_Item__c> lstProdSpec{get;set;}
    public List<Estimate_Spec_Item__c> lstEstli{get;set;}
    public Estimate_Line_Items__c EstLI{get;set;}
    public String ProductionSpecTempName{get;set;}
    public String SpecId{get;set;}
    public boolean errorMsg {set;get;}
    
    
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
    
    public DisplayProductionEstSpecInEstimateTabExt(ApexPages.StandardController SC) 
    {
       errorMsg=false;
        EstLI = (Estimate_Line_Items__c)SC.getRecord();
        EstLIId = ApexPages.currentPage().getParameters().get('id');  
        LoadEstSpecItemss();
    }
    
    private void LoadEstSpecItemss()
    {
         EstLIId = ApexPages.currentPage().getParameters().get('id');       
         lstEstli=[Select id,Name,Description__c from Estimate_Spec_Item__c where Estimates__c=: EstLIId  ORDER BY CreatedDate];   
    }
    
    public Pagereference editSpec()
    {
           Pagereference p=new Pagereference('/apex/EditestimatelineitemunderJob?id='+SpecId);
           p.setRedirect(true);
           return p;
    }
    
    
    public Pagereference DelSpec()
    {
           Pagereference p=new Pagereference('/apex/DeleteSpecItemUndertheEstLI?id='+SpecId);
           p.setRedirect(true);
           return p;
    }
    
     // This method is called on to handle Save button
    public PageReference save()
    {
          try
          {   
              update lstEstli;
          }
          catch(System.DMLException e)
          {
              return null;
          }
          
          if(isLtng)
          {
                 PageReference p = new Pagereference('/apex/EstimatedetailpageLightning?id='+EstLIId);
                 p.setRedirect(true);
                 return p; 
          }
          else
          {
                PageReference p =  new Pagereference('/apex/Estimatedetailpage?id='+EstLIId);
                p.setRedirect(true);
                return p;
          }
          
         
    }
    // End of method Save
    
    // This method is called on to handle Cancel button
     Public PageReference cancelme()
     {
         if(isLtng)
          {
                 PageReference p = new Pagereference('/apex/EstimatedetailpageLightning?id='+EstLIId);
                 p.setRedirect(true);
                 return p; 
          }
          else
          {
                PageReference p =  new Pagereference('/apex/Estimatedetailpage?id='+EstLIId);
                p.setRedirect(true);
                return p;
          }    
     }
    // End Cancel method
    
   
    // This method is called on to add New Spec
    public pagereference addNewSpecs()
    {
         EstLIId = ApexPages.currentPage().getParameters().get('id');       
         
         
          if(isLtng)
          {
                 Pagereference p=Page.createnewestimatelineitemLightning;
                 p.setRedirect(true);
                 p.getParameters().put('EstLIId',EstLIId);
                 return p; 
          }
          else
          {
                 Pagereference p=Page.createnewestimatelineitem;
                 p.setRedirect(true);
                 p.getParameters().put('EstLIId',EstLIId);
                 return p;
          }
         
         
         
         
    }
    // End of method addNewJobSpec
    
    
    
    // This method is called on to Import Specs
    public void importSpecs()
    {
        List<Estimate_Spec_Item__c > insertEstSpecItems=new List<Estimate_Spec_Item__c >();    
        
        if(ProductionSpecTempName==NULL || ProductionSpecTempName=='-None-')
        {
           errorMsg=true;
           ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Production Spec Temp : You must select a Template.');
           ApexPages.addMessage(msg1);
          // return null;
          
        }
        else
        {
          errorMsg=false;
            try
            {
                List<Production_Spec_Item__c> lstSpecs=[Select id,Name,Description__c from Production_Spec_Item__c where Production_Spec_Template__c=:ProductionSpecTempName];
                for(Production_Spec_Item__c sp:lstSpecs)
                {
                  Estimate_Spec_Item__c js=new Estimate_Spec_Item__c ();
                    if(schema.SobjectType.Estimate_Spec_Item__c.Fields.Name.isCreateable()){ 
                        js.Name=sp.Name;
                    }
                    if(schema.SobjectType.Estimate_Spec_Item__c.Fields.Description__c.isCreateable()){ 
                        js.Description__c=sp.Description__c;
                    }
                    if(schema.SobjectType.Estimate_Spec_Item__c.Fields.Estimates__c.isCreateable()){ 
                        js.Estimates__c= EstLIId ;
                    }
                  insertEstSpecItems.add(js);
                }
                if(Schema.sObjectType.Estimate_Spec_Item__c.isCreateable()){
                    insert insertEstSpecItems;
                }
             }
             catch(System.DMLException e)
             {
               //return NULL;
             }
             
          // lstEstli=[Select id,Name,Description__c from Estimate_Spec_Item__c where Estimates__c=: EstLIId  ORDER BY CreatedDate]; 
          
          
        }   
        
          
          
    }*/
    // End of method Import Specs
    
}