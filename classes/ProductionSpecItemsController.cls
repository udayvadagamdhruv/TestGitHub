public with sharing class ProductionSpecItemsController {

   /*

 
 public string pstempid {set;get;}
 public list<Production_Spec_Item__c> prospecitems {set;get;}
 public string prospeid  {set;get;}
 
  public ProductionSpecItemsController()
  {
        pstempid =ApexPages.CurrentPage().getParameters().get('id');
        prospecitems =[select id,name,Production_Spec_Template__c,Description__c From Production_Spec_Item__c where Production_Spec_Template__c=:pstempid];
  }


  public pageReference CreateNewSpecItem()
  {
  
   pageReference p=page.CreateProductionSpecItemLightning;
    p.setredirect(true);
    p.getParameters().put('pstempid',pstempid );
    return p;
  
  }
  
 public PageReference deletemethod() {
       PageReference p=new PageReference('/apex/DeleteProductionSpecItem?id='+prospeid);
        p.setredirect(true);
        return p;
   
    }


    public PageReference editmethod() {
        PageReference p=new PageReference('/apex/EditProductionSpecItem?id='+prospeid);
        p.setredirect(true);
        return p;
    }*/

}