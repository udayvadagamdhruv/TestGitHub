public with sharing class DisplayCreativeBriefSpecItemsController {


public boolean isLtng { private set;get{
    
    string theme=UserInfo.getUITheme();
    return (theme=='Theme4d')?true:false;
}
}


        // Global variables 
        
            Public String theID;
            public List<Spec_Item__c> CSpecItem{get;set;} 
           // public id strCSpecItem{get;set;}
            
        // End of Global variables
       
       // Start Constructor 
        public DisplayCreativeBriefSpecItemsController ()
        {
         theID = ApexPages.CurrentPage().getParameters().get('id');
         CSpecItem=[select id,Name,Specification_Template__c,Description__c,Lock__c,Sort_Order__c,Value__c from Spec_Item__c where Specification_Template__c=: theID ORDER BY Sort_Order__c];
        }
        
        // End constructor
    
        // THis methos is called on to Create 
        public PageReference createSpecitems()
        {
         PageReference p;    
         if(isLtng)
                        p=new PageReference('/apex/CreateNewSpecItemLightning?Parentid='+theID);
         else
                p=new PageReference('/apex/CreateNewSpecItem?Parentid='+theID);
                p.setRedirect(true);
                return p;
        }
        // End method 
        
       // This is save method
    public PageReference save(){
        
      update CSpecItem;
      // After updating specs, navigate to creative template Tab
      PageReference p;
        
      if(isLtng)
          p=new Pagereference('/apex/SpecificationTemplateTabOverrideLti?id='+theID);
      else
          p=new Pagereference('/apex/SpecificationTemplateTabOverride?id='+theID);
          p.setRedirect(true);
          return p; 
    }
    
    
  //Method For Cancel button    
   public PageReference cancelme()
     {
     PageReference p;      
      if(isLtng)
          p =new Pagereference('/apex/SpecificationTemplateTabOverrideLti?id='+theID);
      else
          p=new Pagereference('/apex/SpecificationTemplateTabOverride?id='+theID);
          p.setRedirect(true);
          return p; 
    }
       
   

}