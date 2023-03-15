public with sharing class ProductionEstTempEnhancedListExt {

/*
        // Global variables
       
        public List<Production_Estimate_Template__c> lstPET{get;set;}
      //  public String strPET{get;set;}
         public String Peid{get;set;}
    
       // End of Global variables
    
    
      public ProductionEstTempEnhancedListExt(ApexPages.StandardController controller) 
      {
            lstPET= [Select Id, Name from Production_Estimate_Template__c Order BY Name LIMIT 10000 ];
      }
      
      
    public Pagereference DelSpec()
    {
           Production_Estimate_Template__c delci = [Select id,Name from Production_Estimate_Template__c where id =: Peid];
            if(Production_Estimate_Template__c.sObjectType.getDescribe().isDeletable()){
            delete delci; }
          
          
           Pagereference p=new Pagereference('/apex/AdminListView?intFocus=13');
           p.setRedirect(true);
           return p;
    }
    
    public Pagereference EditPE()
    {
          
           Pagereference p=new Pagereference('/apex/EditProductionEstimateTemplate?id='+Peid);
           p.setRedirect(true);
           return p;
    }
    
    
    public Pagereference NewMethod()
    {
          
           Pagereference p=new Pagereference('/apex/CreateProductionEstimateTemplate');
           p.setRedirect(true);
           return p;
    }*/
    
    
}