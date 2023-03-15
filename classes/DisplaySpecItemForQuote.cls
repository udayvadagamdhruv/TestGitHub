// This class is used Display Spec Items for Quote
public with sharing class DisplaySpecItemForQuote 
{
     
    // Global variables
     public boolean isLtng{
                         
                         private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                         }
     
    
    
    
    String theID;
    public String specId{get;set;}
    public List<Quote_Spec_Item__c> qsi{get;set;} 
    // End of Global variables
    
    // Start Constructor
    public DisplaySpecItemForQuote(ApexPages.StandardController controller) 
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        qsi=[select id,Name,Description__c,Quote__c from Quote_Spec_Item__c where Quote__c =: theID Order By CreatedDate];
        
    }
    // End of Constructor
     
    // This method is called on to handle Save button
    public PageReference save()
    {
    try
     {
      update qsi;
     }
     catch(System.DMLException e)
     {
       return null;
     }
      PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+theID+'&section=estspecitems');
      p.setRedirect(true);
      return p;     
    }
    // End of method Save
    
    // This method is called on to handle Cancel button
     Public PageReference cancelme()
     {
        PageReference p =  new Pagereference('/apex/QuoteDetailPageLightning?id='+theID+'&section=estspecitems');
        p.setRedirect(true);
        return p;     
     }
    // End Cancel method
    
    // This method is called on to edit Quote Spec
     public Pagereference editQuoteSpec()
     {
       If(isLtng){        
          Pagereference p=new Pagereference('/apex/EditQuoteSpecItemLightning?id='+specId);
         p.setRedirect(true);
         return p;
         }
         
         else{
         
          Pagereference p=new Pagereference('/apex/EditQuoteSpecItem?id='+specId);
         p.setRedirect(true);
         return p;
         
         } 
    
    
     }
    // End method editQuoteSpec
    
    // This method is called on to DeleteQuoteSpec
     public Pagereference deleteQuoteSpec()
    {    
    
      
    
         Pagereference p=new Pagereference('/apex/DeleteQuoteSpecItem?id='+specId+'&section=estspecitems');
         p.setRedirect(true);
         return p;
    }
    // End method DeleteQuoteSpec
    
    // This method is called on to add New Quote Spec
    public pagereference addNewQuoteSpec()
    {
         theID = ApexPages.currentPage().getParameters().get('id');
         
         If(isLtng){       
         Pagereference p=Page.createnewquotespecitemLightning;
         p.setRedirect(true);
         p.getParameters().put('Qid',theID);
         return p;
         }
         
         else{
         
         Pagereference p=Page.createnewquotespecitem;
         p.setRedirect(true);
         p.getParameters().put('Qid',theID);
         return p;
         
         }
    }
    // End of method addNewQuoteSpec
    
    // This method is called on to Import Template
    public pagereference ImportProductionSpec()
    {
         theID = ApexPages.currentPage().getParameters().get('id');       
        /* Pagereference p=Page.importproductionspecitemLightning;
         p.setRedirect(true);
         p.getParameters().put('Qid',theID);
         return p;  */
         
         
         If(isLtng){        
         Pagereference p=Page.importproductionspecitemLightning;
         p.setRedirect(true);
         p.getParameters().put('Qid',theID);
         return p;
         }
         
         else{
         
         Pagereference p=Page.importproductionspecitem;
         p.setRedirect(true);
         p.getParameters().put('Qid',theID);
         return p;
         
         } 
         
         
         
         
         
    }
    // End of method ImportProductionSpecs
    
    // Test Method 
  static testMethod void test_DisplaySpecItemForQuote()
    {
        Quote_Spec_Item__c QSI = new Quote_Spec_Item__c();
        Quote__c q = new Quote__c();
        ApexPages.StandardController con=new ApexPages.StandardController(QSI);
        DisplaySpecItemForQuote ext=new DisplaySpecItemForQuote(con);
        System.assertEquals(q.id,ext.theID);
        ApexPages.currentPage().getParameters().put('id',q.Id);
        ApexPages.Pagereference result=ext.editQuoteSpec();
        result=ext.save();
        result=ext.cancelme();
        result=ext.deleteQuoteSpec();
        result=ext.addNewQuoteSpec();
        result = ext.ImportProductionSpec();
    } 
 // End of test Method        
}
// End of Class