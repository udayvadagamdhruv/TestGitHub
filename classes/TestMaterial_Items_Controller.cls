@IsTest
public class TestMaterial_Items_Controller {
    public static testMethod void TestMaterial_Items_Controller(){  
       
        Recordtype rt=[SELECT ID,name FROM RecordType WHERE Name ='Each'];
        system.debug('***************'+rt);
        Material_Item__c  testI=new Material_Item__c (name='test 123',Calc_Unit__c ='Size');
        insert testI;
        
        Material_Inventory_Item__c mi= new Material_Inventory_Item__c(Material_Item__c=testI.id,Qty_On_Shelf__c=100);    
        insert mi;
        
        Material_Inventory_Item__c miInve= new Material_Inventory_Item__c(Material_Item__c=testI.id,Qty_On_Shelf__c=200);    
        insert miInve;
        
        Material_Usage_line_item__c  Tmuli= new Material_Usage_line_item__c (Material_Item__c=testI.id,Qty_On_Hand__c=100);
        insert Tmuli;
        
        Material_Usage_line_item__c  muli= new Material_Usage_line_item__c (Material_Item__c=testI.id);
        insert muli;
        
        test.startTest();
            Material_Items_Controller.getFieldsforObject('Material_Item__c');
            Material_Items_Controller.getMaterialUsageItems(testI.Id);
            Material_Items_Controller.updateMaterailItemQtyOnHandField(testI.Id);
            Material_Items_Controller.getMaterialInventory(testI.Id);
            Material_Items_Controller.deleteMInventoryItem(miInve.Id);
            Material_Items_Controller.deleteMIUsageItem(Tmuli.Id,testI.Id);
            Material_Items_Controller.fetchLatestFiles(testI.Id);
            Material_Items_Controller.gettodaydate();
        test.stopTest();

    }
}