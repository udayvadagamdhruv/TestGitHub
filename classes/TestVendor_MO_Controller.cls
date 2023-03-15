@IsTest
public class TestVendor_MO_Controller {
    
    @testSetup public static void SetupData(){
        Client__c c=new Client__c(name='Manikanta Kurella');
        insert c;
        
        Vendor__c v=new Vendor__c(name='test Vendor');
        insert v;  
        
        Material_Item__c mt = new Material_Item__c( name= 'Test item',Calc_Unit__c = 'Sheet',Mt_Status__c='Active');
        insert mt;
        
        
    }
    
    public static testMethod void Test1(){
        Vendor_MO_Controller.getObjectType(new list<string>{'Job__c'});
        Vendor_MO_Controller.getLabelforObject('Job__c');
        Vendor_MO_Controller.getMPLIPermiossions();
        Vendor_MO_Controller.getMOPermiossions();
        Vendor_MO_Controller.getFieldsforObject('Job__c');
        Vendor__c vendor=[select id,Name From Vendor__c where name='test Vendor'];
        Vendor_MO_Controller.getMORecords(vendor.id);
        Vendor_MO_Controller.getMatereialItems('sheet');
        Material_Item__c mit = [select id,name,Mt_Status__c from Material_Item__c where name = 'Test item'];        
        Vendor_MO_Controller.getMatereialItemsFieldvalues(mit.id);
        
        Material_Order__c mo = new Material_Order__c(Vendor_Name__c = vendor.id,Issue_Date__c=system.today(),MO_Due_Date__c=system.today());
        insert mo;
        
        Material_Purchase_Line_Item__c mpli = new Material_Purchase_Line_Item__c(Material_Order__c = mo.id,Material_Item__c = mit.id);
        insert mpli;
        
        Vendor_MO_Controller.getMPLIRecords(mo.id);
        Vendor_MO_Controller.getMPLIReceiptRecords(mpli.id);
        Vendor_MO_Controller.deleteMOrcd(mo.id);
    }
    
    public static testMethod void Test2(){
        Vendor__c vendor=[select id,Name From Vendor__c where name='test Vendor'];
        
        Material_Order__c mo = new Material_Order__c(Vendor_Name__c = vendor.id,Issue_Date__c=system.today(),MO_Due_Date__c=system.today());
        insert mo;  
        Vendor_MO_Controller.deleteMOrcd(mo.id);
    }
    
    public static testMethod void Test3(){
        Material_Item__c mit = [select id,name,Mt_Status__c from Material_Item__c where name = 'Test item'];        
        
        Vendor__c vendor=[select id,Name From Vendor__c where name='test Vendor'];
        
        Material_Order__c mo = new Material_Order__c(Vendor_Name__c = vendor.id,Issue_Date__c=system.today(),MO_Due_Date__c=system.today());
        insert mo;  
        Material_Purchase_Line_Item__c mpli = new Material_Purchase_Line_Item__c(Material_Order__c = mo.id,Material_Item__c = mit.id);
        insert mpli;
        Vendor_MO_Controller.deleteMPLIrcd(mpli.id);
        Material_Purchase_Line_Item__c mplircd = new Material_Purchase_Line_Item__c(Material_Order__c = mo.id,Material_Item__c = mit.id);
        insert mplircd;
        Vendor_MO_Controller.editmplircd(mplircd.id);
        
    }
    
    
    public static testMethod void Test4(){
        
        Material_Item__c mit = new Material_Item__c();
        mit.name = 'test mt';
        mit.Mt_Status__c = 'Active';
        insert mit;
        
        Material_Usage_line_item__c muli = new Material_Usage_line_item__c(Qty_On_Hand__c = 20,Credit__c = 5,Type__c = 'Purchase',Material_Item__c = mit.id);
        insert muli;
        
        Vendor__c vendor=[select id,Name From Vendor__c where name='test Vendor'];
        
        Material_Order__c mo = new Material_Order__c(Vendor_Name__c = vendor.id,Issue_Date__c=system.today(),MO_Due_Date__c=system.today());
        insert mo;  
        
        Material_Purchase_Line_Item__c mpli = new Material_Purchase_Line_Item__c(Material_Order__c = mo.id,Material_Item__c = mit.id,Qty__c = 50 ,Qty_Outstanding__c = 0,Calc_Unit__c = 'Size');
        insert mpli;
        
        Material_Order_Line_Item_Receipt__c mprrcd = new Material_Order_Line_Item_Receipt__c(Material_Purchase_Line_Item__c = mpli.id,MOLI_Receipt_Qty__c = 5,MPLI_Receipt_Status__c = 'Received',MOLI_Receipt_Date__c = system.today());
        insert mprrcd;
        
        Vendor_MO_Controller.createandupdatematerial(mprrcd.id);
        
    }
    
    public static testMethod void Test5(){
        
        Material_Item__c mit = new Material_Item__c();
        mit.name = 'test mt';
        mit.Mt_Status__c = 'Active';
        mit.Case_Pack__c = 1;
        insert mit;
        
        Material_Usage_line_item__c muli = new Material_Usage_line_item__c(Qty_On_Hand__c = 20,Credit__c = 5,Type__c = 'Purchase',Material_Item__c = mit.id);
        insert muli;
        
        Vendor__c vendor=[select id,Name From Vendor__c where name='test Vendor'];
        
        Material_Order__c mo = new Material_Order__c(Vendor_Name__c = vendor.id,Issue_Date__c=system.today(),MO_Due_Date__c=system.today());
        insert mo;  
        
        Material_Purchase_Line_Item__c mpli = new Material_Purchase_Line_Item__c(Material_Order__c = mo.id,Material_Item__c = mit.id,Qty__c = 50 ,Qty_Outstanding__c = 0,Calc_Unit__c = 'Sheet');
        insert mpli;
        
        Material_Order_Line_Item_Receipt__c mprrcd = new Material_Order_Line_Item_Receipt__c(Material_Purchase_Line_Item__c = mpli.id,MOLI_Receipt_Qty__c = 5,MPLI_Receipt_Status__c = 'Received',MOLI_Receipt_Date__c = system.today());
        insert mprrcd;
        
        Vendor_MO_Controller.createandupdatematerial(mprrcd.id);
        
    }
    
    public static testMethod void Test6(){
        Material_Item__c mit = new Material_Item__c();
        mit.name = 'test mt';
        mit.Mt_Status__c = 'Active';
        insert mit;
        
        Material_Usage_line_item__c muli = new Material_Usage_line_item__c(Qty_On_Hand__c = 20,Type__c = 'Purchase',Material_Item__c = mit.id,Credit__c = 10,Debit__c = 5);
        insert muli;
        
        Vendor__c vendor=[select id,Name From Vendor__c where name='test Vendor'];
        
        Material_Order__c mo = new Material_Order__c(Vendor_Name__c = vendor.id,Issue_Date__c=system.today(),MO_Due_Date__c=system.today());
        insert mo;  
        
        Material_Purchase_Line_Item__c mpli = new Material_Purchase_Line_Item__c(Material_Order__c = mo.id,Material_Item__c = mit.id,Qty__c = 50 ,Qty_Outstanding__c = 0,Calc_Unit__c = 'Each');
        insert mpli;
        
        Material_Order_Line_Item_Receipt__c mprrcd = new Material_Order_Line_Item_Receipt__c(Material_Purchase_Line_Item__c = mpli.id,MOLI_Receipt_Qty__c = 5,MPLI_Receipt_Status__c = 'Received',MOLI_Receipt_Date__c = system.today());
        insert mprrcd;
        
        Vendor_MO_Controller.createandupdatematerial(mprrcd.id);
        
    }
    
    public static testMethod void Test7(){
        Material_Item__c mit = new Material_Item__c();
        mit.name = 'test mt';
        mit.Mt_Status__c = 'Active';
        insert mit;
        
        Vendor__c vendor=[select id,Name From Vendor__c where name='test Vendor'];
        
        Material_Order__c mo = new Material_Order__c(Vendor_Name__c = vendor.id,Issue_Date__c=system.today(),MO_Due_Date__c=system.today());
        insert mo;  
        
        Material_Purchase_Line_Item__c mpli = new Material_Purchase_Line_Item__c(Material_Order__c = mo.id,Material_Item__c = mit.id,Qty__c = 50 ,Qty_Outstanding__c = 0,Calc_Unit__c = 'Size');
        insert mpli;
        
        Material_Order_Line_Item_Receipt__c mprrcd = new Material_Order_Line_Item_Receipt__c(Material_Purchase_Line_Item__c = mpli.id,MOLI_Receipt_Qty__c = 5,MPLI_Receipt_Status__c = 'Received',MOLI_Receipt_Date__c = system.today());
        insert mprrcd;
        
        Vendor_MO_Controller.createandupdatematerial(mprrcd.id);
        
    }
    
    public static testMethod void Test8(){
        Material_Item__c mit = new Material_Item__c();
        mit.name = 'test mt';
        mit.Mt_Status__c = 'Active';
        insert mit;
        
        Vendor__c vendor=[select id,Name From Vendor__c where name='test Vendor'];
        
        Material_Order__c mo = new Material_Order__c(Vendor_Name__c = vendor.id,Issue_Date__c=system.today(),MO_Due_Date__c=system.today());
        insert mo;  
        
        Material_Purchase_Line_Item__c mpli = new Material_Purchase_Line_Item__c(Material_Order__c = mo.id,Material_Item__c = mit.id,Qty__c = 50 ,Qty_Outstanding__c = 0,Calc_Unit__c = 'Sheet');
        insert mpli;
        
        Material_Order_Line_Item_Receipt__c mprrcd = new Material_Order_Line_Item_Receipt__c(Material_Purchase_Line_Item__c = mpli.id,MOLI_Receipt_Qty__c = 5,MPLI_Receipt_Status__c = 'Received',MOLI_Receipt_Date__c = system.today());
        insert mprrcd;
        
        Vendor_MO_Controller.createandupdatematerial(mprrcd.id);
        
    }
    
     public static testMethod void Test10(){
        Material_Item__c mit = new Material_Item__c();
        mit.name = 'test mt';
        mit.Mt_Status__c = 'Active';
        insert mit;
        
        Vendor__c vendor=[select id,Name From Vendor__c where name='test Vendor'];
        
        Material_Order__c mo = new Material_Order__c(Vendor_Name__c = vendor.id,Issue_Date__c=system.today(),MO_Due_Date__c=system.today());
        insert mo;  
        
        Material_Purchase_Line_Item__c mpli = new Material_Purchase_Line_Item__c(Material_Order__c = mo.id,Material_Item__c = mit.id,Qty__c = 50 ,Qty_Outstanding__c = 0,Calc_Unit__c = 'Each');
        insert mpli;
        
        Material_Order_Line_Item_Receipt__c mprrcd = new Material_Order_Line_Item_Receipt__c(Material_Purchase_Line_Item__c = mpli.id,MOLI_Receipt_Qty__c = 5,MPLI_Receipt_Status__c = 'Received',MOLI_Receipt_Date__c = system.today());
        insert mprrcd;
        
        Vendor_MO_Controller.createandupdatematerial(mprrcd.id);
        
    }

}