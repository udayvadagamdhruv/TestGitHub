public class VendorController {
    
    @AuraEnabled
    public static list<SObject> vendorMI(Id recordid){
        List<Material_Item__c> VendorMI = [select id,Name,Vendor__r.Name,Vendor__c,Calc_Unit__c,Qty_On_Hand__c,Category__c,GL_Department__c,GL_Code__c from Material_Item__c where Vendor__c=:recordid];
        system.debug('VendorMI ===='+VendorMI);
        return VendorMI;
    }

}