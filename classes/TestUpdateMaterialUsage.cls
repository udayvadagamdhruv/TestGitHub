@isTest
Public class TestUpdateMaterialUsage{
static testMethod void TestUpdateMaterialUsage(){

    Material_Item__c  testI=new Material_Item__c (name='test 123',Case_Pack__c=10,Calc_Unit__c='Size' );
    insert testI;
   
    Material_Inventory_Item__c mi= new Material_Inventory_Item__c(Material_Item__c=testI.id,Qty_On_Shelf__c=10);
    insert mi;
    
     Material_Usage_line_item__c mu= new Material_Usage_line_item__c(Material_Item__c=testI.id);
     insert mu;
     
      Material_Item__c  testI1=new Material_Item__c (name='test 123',Case_Pack__c=10,Calc_Unit__c='Sheet' );
    insert testI1;
   
    Material_Inventory_Item__c mi1= new Material_Inventory_Item__c(Material_Item__c=testI1.id,Qty_On_Shelf__c=10);
    insert mi1;
    
     Material_Usage_line_item__c mu1= new Material_Usage_line_item__c(Material_Item__c=testI1.id);
     insert mu1;
     
      Material_Item__c  testI2=new Material_Item__c (name='test 123',Case_Pack__c=10,Calc_Unit__c='Each' );
    insert testI2;
   
    Material_Inventory_Item__c mi2= new Material_Inventory_Item__c(Material_Item__c=testI2.id,Qty_On_Shelf__c=10);
    insert mi2;
    
     Material_Usage_line_item__c mu2= new Material_Usage_line_item__c(Material_Item__c=testI2.id);
     insert mu2;
    
    
   ApexPages.currentPage().getParameters().put('materialid',testI.Id);
    ApexPages.StandardController con=new ApexPages.StandardController(mi);

}


static testMethod void TestUpdateMaterialUsage2(){

    Material_Item__c  testI=new Material_Item__c (name='test 123',Case_Pack__c=10,Calc_Unit__c='Size' );
    insert testI;
   
    Material_Inventory_Item__c mi= new Material_Inventory_Item__c(Material_Item__c=testI.id,Qty_On_Shelf__c=-2);
    insert mi;
    
     Material_Usage_line_item__c mu= new Material_Usage_line_item__c(Material_Item__c=testI.id);
     insert mu;
     
      Material_Item__c  testI1=new Material_Item__c (name='test 123',Case_Pack__c=10,Calc_Unit__c='Sheet' );
    insert testI1;
   
    Material_Inventory_Item__c mi1= new Material_Inventory_Item__c(Material_Item__c=testI1.id,Qty_On_Shelf__c=-2);
    insert mi1;
    
     Material_Usage_line_item__c mu1= new Material_Usage_line_item__c(Material_Item__c=testI1.id);
     insert mu1;
     
      Material_Item__c  testI2=new Material_Item__c (name='test 123',Case_Pack__c=10,Calc_Unit__c='Each' );
    insert testI2;
   
    Material_Inventory_Item__c mi2= new Material_Inventory_Item__c(Material_Item__c=testI2.id,Qty_On_Shelf__c=-2);
    insert mi2;
    
     Material_Usage_line_item__c mu2= new Material_Usage_line_item__c(Material_Item__c=testI2.id);
     insert mu2;
    
    
   ApexPages.currentPage().getParameters().put('materialid',testI.Id);
    ApexPages.StandardController con=new ApexPages.StandardController(mi);

}

}