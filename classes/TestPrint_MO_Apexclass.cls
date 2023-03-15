@isTest
public class TestPrint_MO_Apexclass {
    private static testMethod void TestPrint_MO_Apexclass(){
        Vendor__c testVendor=new Vendor__c(Name='TestV32444',Email__c='abcd@gmail.com',Zip__c='12345');
       try
        {
            insert testVendor;
        }
       catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Vendor with same name Exists'));
        }
        
        Material_Item__c MI= new Material_Item__c(Name='Pinsssss',Calc_Unit__c='Each',Qty_On_Hand__c=10,Mt_Status__c='Active');
         insert MI;
        
        Material_Order__c testMO =new Material_Order__c(MO_Due_Date__c=system.today(),Issue_Date__c=system.today(),Vendor_Name__c=testVendor.id);
        insert testMO;
        
        Material_Purchase_Line_Item__c MPLI = new Material_Purchase_Line_Item__c(Material_Order__c=testMO.id,Calc_Unit__c='Each',Material_Item__c=MI.id,Qty__c=50,MPLI_Status__c='Outstanding');
        insert MPLI; 
        /*try{
            insert MPLI;
        }
        catch(exception e){
            system.debug('message===='+e.getMessage()+' line no 21=== '+e.getLineNumber()+'causeeeee'+e.getCause());
        }*/
        
        Material_Order_Line_Item_Receipt__c MOLIRecp =new Material_Order_Line_Item_Receipt__c(Material_Purchase_Line_Item__c=MPLI.id,MOLI_Receipt_Date__c=system.today(),MOLI_Receipt_Qty__c=10,MPLI_Receipt_Status__c='Outstanding');
		insert MOLIRecp;
        
        ApexPages.CurrentPage().getParameters().put('id',testMO.id);
      ApexPages.StandardController con=new ApexPages.StandardController(testMO);    
      Print_MO_Apexclass ext=new Print_MO_Apexclass(con); 
    }
    
}