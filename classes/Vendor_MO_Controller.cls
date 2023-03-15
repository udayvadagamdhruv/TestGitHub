public class Vendor_MO_Controller {
   
    //Below methods are Material Order and Material purchase Order line item related code added on 05 - 04 - 2022 and 06 - 04 - 2022
    @AuraEnabled
    public static String getObjectType(List<String> ObjNames) {
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);   
    }
    
    @AuraEnabled
    public static String getLabelforObject(String sObjName) {
        string objlabel = Schema.getGlobalDescribe().get(sObjName).getDescribe().getLabel();
        return objlabel;
    }
    
    @AuraEnabled 
    public static List <Material_Order__c> getMORecords(Id recordId) {
        system.debug(recordId);
        List <Material_Order__c> lstMO = [select id,Name,Vendor_Name__r.name, Issue_Date__c, MO_Due_Date__c, Status__c,Vendor_Name__c  from Material_Order__c where Vendor_Name__c =:recordId WITH SECURITY_ENFORCED Order By CreatedDate desc ];
        return lstMO;
    }
    
    // ================================================= FieldSets fields =====================================================================//
    
    @AuraEnabled
    public static List < String > getFieldsforObject(String sObjName) {
        
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.FieldSet > fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();
        
        string fieldsetname;
        for (string s: fieldMap.keyset())
            fieldsetname = s;
        List < Schema.FieldSetMember > fields = fieldMap.get(fieldsetname).getFields();
        List < string > fieldsname = new List < string > ();
        
        for (Schema.FieldSetMember fieldName: fields) {
            fieldsname.add(fieldName.getFieldPath());
        }
        return fieldsname;
    }
    
    
    @AuraEnabled 
    public static list<Boolean> getMOPermiossions()
    {
        list<boolean> isAccessList=new list<boolean>();
        isAccessList.add(Schema.sObjectType.Material_Order__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Material_Order__c.isCreateable()); 
        isAccessList.add(Schema.sObjectType.Material_Order__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Material_Order__c.isdeletable());
        return isAccessList;
    }
    
    //Below methods are Material purchase Order line item  related code added on 06 - 04 - 2022
    
    @AuraEnabled 
    public static list<Boolean> getMPLIPermiossions()
    {
        list<boolean> isAccessList=new list<boolean>();
        isAccessList.add(Schema.sObjectType.Material_Purchase_Line_Item__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Material_Purchase_Line_Item__c.isCreateable()); 
        isAccessList.add(Schema.sObjectType.Material_Purchase_Line_Item__c.isUpdateable());
        
        isAccessList.add(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.isCreateable()); 
        isAccessList.add(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.isUpdateable());
        return isAccessList;
    }
    
    @AuraEnabled
    public Static list<Material_Item__c> getMatereialItems(String CalUnit) {   
        system.debug('===CalUnit========'+CalUnit);
        list<Material_Item__c> miList=new list<Material_Item__c>();
        // miList=[SELECT Id, name FROM Material_Item__c where recordtype.name =:CalUnit order by Name];
        //Added Mt_Status__c in below soql query on 30 - 03 - 2022
        miList=[SELECT Id, Name,Calc_Unit__c,Mt_Status__c	 FROM Material_Item__c where Calc_Unit__c=:CalUnit and Mt_Status__c = 'Active' WITH SECURITY_ENFORCED order by Name];
        return miList;
    }
    
    @AuraEnabled
    public Static Material_Item__c getMatereialItemsFieldvalues(String rcdids) {   
        system.debug('===rcdids========'+rcdids);
        // miList=[SELECT Id, name FROM Material_Item__c where recordtype.name =:CalUnit order by Name];
        //Added Mt_Status__c in below soql query on 30 - 03 - 2022
        Material_Item__c miList=[SELECT Id, Name,Calc_Unit__c,Mt_Status__c,Case_Pack__c,Roll_LF__c,Qty_On_Hand__c FROM Material_Item__c where id=:rcdids and Mt_Status__c = 'Active' WITH SECURITY_ENFORCED order by Name limit 1];
        return miList;
    }
    
    @AuraEnabled 
    public static List <Material_Purchase_Line_Item__c> getMPLIRecords(Id recordId) {
        system.debug(recordId);
        List <Material_Purchase_Line_Item__c> lstMPLI =  [select id,name,Material_Item__c, Material_Item__r.name,Material_Order__c, Material_Order__r.name,MPLI_Status__c, Calc_Unit__c,Qty__c,Qty_Outstanding__c from Material_Purchase_Line_Item__c  where Material_Order__c =:recordId WITH SECURITY_ENFORCED Order By CreatedDate desc ];
        return lstMPLI;
    }
    
    @AuraEnabled 
    public static List <Material_Order_Line_Item_Receipt__c> getMPLIReceiptRecords(Id recordId) {
        system.debug(recordId);
        set<string>MPLIIDS = new set<string>();
        list<Material_Order_Line_Item_Receipt__c> MOLIReceiptrcd = new list<Material_Order_Line_Item_Receipt__c>();
        
        List <Material_Purchase_Line_Item__c> lstMPLI =  [select id,name,Material_Item__c, Material_Item__r.name,Material_Order__c, Material_Order__r.name,MPLI_Status__c, Calc_Unit__c,Qty__c from Material_Purchase_Line_Item__c  where Material_Order__c =: recordId WITH SECURITY_ENFORCED Order By CreatedDate desc ];
        for(Material_Purchase_Line_Item__c JMPLI : lstMPLI){
            MPLIIDS.add(JMPLI.Id);  
        }
        
        list<Material_Order_Line_Item_Receipt__c> MOLIReceipt = [select id,name,Material_Purchase_Line_Item__c,Material_Purchase_Line_Item__r.Name,MOLI_Receipt_Date__c,MOLI_Receipt_Qty__c,MPLI_Receipt_Status__c from Material_Order_Line_Item_Receipt__c where Material_Purchase_Line_Item__c =: MPLIIDS WITH SECURITY_ENFORCED Order By CreatedDate desc];
        return MOLIReceipt;
    }
    
    //Below method is used to create MULI record and updating its material items fields Qty on hand on 07 - 04 - 2022
    @AuraEnabled 
    public static string createandupdatematerial(string rcdids){
        system.debug('rcd id === '+rcdids);
        string molireceiptstatus = '';
         decimal qty = 0;
        decimal Outstandingdebitqty = 0;
        Material_Order_Line_Item_Receipt__c MPLIReceipt = [select id,name,Material_Purchase_Line_Item__c,MOLI_Receipt_Qty__c,MPLI_Receipt_Status__c from Material_Order_Line_Item_Receipt__c where id =: rcdids WITH SECURITY_ENFORCED limit 1];
        molireceiptstatus = MPLIReceipt.MPLI_Receipt_Status__c;
        system.debug(molireceiptstatus);
        if(molireceiptstatus == 'Received'){
             Outstandingdebitqty = 0;
           qty = MPLIReceipt.MOLI_Receipt_Qty__c;
        }
        else{
           qty = 0; 
         Outstandingdebitqty = MPLIReceipt.MOLI_Receipt_Qty__c;   
        }
        
        list<Material_Purchase_Line_Item__c> mplircds = [select id,name,Material_Item__c, Material_Item__r.name,Material_Order__c, Material_Order__r.name,MPLI_Status__c, Calc_Unit__c,Qty__c,Qty_Outstanding__c from Material_Purchase_Line_Item__c where id =: MPLIReceipt.Material_Purchase_Line_Item__c  WITH SECURITY_ENFORCED limit 1];
        string materialitemid = mplircds[0].Material_Item__c;
        system.debug('materialitemid === '+materialitemid);
        
        // Below llogic is for  Qty outstading update 
        if(Schema.sObjectType.Material_Purchase_Line_Item__c.fields.Qty_Outstanding__c.isupdateable()){
            if(mplircds[0].Qty_Outstanding__c == null || mplircds[0].Qty_Outstanding__c <= 0 ||mplircds[0].Qty_Outstanding__c == null){
                mplircds[0].Qty_Outstanding__c =    mplircds[0].Qty__c - qty ; 
            }
            else{
                mplircds[0].Qty_Outstanding__c =  mplircds[0].Qty_Outstanding__c - qty; 
            }
        }
        
        if(Schema.sObjectType.Material_Purchase_Line_Item__c.isupdateable()){
            update mplircds;
        }
        //ends here
        
        Material_Item__c MIrec=[Select Id,Name ,Qty_On_Hand__c,Calc_Unit__c,Case_Pack__c,Roll_LF__c,(Select Id,Name,Qty_On_Hand__c,Date__c,Debit__c,Credit__c,Type__c,Material_Item__c  from Material_Usage_line_items__r Order by Createddate DESC) from Material_Item__c  where Id=:materialitemid WITH SECURITY_ENFORCED limit 1];
        
        Material_Usage_line_item__c MIUIfields = new Material_Usage_line_item__c();
        
        if(MIrec.Material_Usage_line_items__r.size()>0){
            
            decimal latestmuln = MIrec.Material_Usage_line_items__r[0].Qty_On_Hand__c;
            
            if(mplircds[0].Calc_Unit__c == 'Size'){
                
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Material_Item__c.isCreateable()){
                    MIUIfields.Material_Item__c = materialitemid;
                }
                
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                    MIUIfields.Qty_On_Hand__c = ((MIrec.Material_Usage_line_items__r[0].Qty_On_Hand__c) + ((qty != null ? qty *  MIrec.Roll_LF__c : 0) - (Outstandingdebitqty != null ? Outstandingdebitqty *  MIrec.Roll_LF__c : 0)));
                    system.debug('MIUIfields.Qty_On_Hand__c === '+MIUIfields.Qty_On_Hand__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                    MIUIfields.Credit__c = (qty != null ? qty * MIrec.Roll_LF__c : 0);
                    system.debug(' MIUIfields.Credit__c === '+ MIUIfields.Credit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                    MIUIfields.Debit__c = (Outstandingdebitqty != null ? Outstandingdebitqty * MIrec.Roll_LF__c : 0);
                    system.debug(' MIUIfields.Debit__c === '+ MIUIfields.Debit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Date__c.isCreateable()){
                    MIUIfields.Date__c = system.today();
                    system.debug(' MIUIfields.Date__c === '+ MIUIfields.Date__c);
                } 
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Type__c.isCreateable()){
                    MIUIfields.Type__c = 'Purchase';
                }
            }
            else if(mplircds[0].Calc_Unit__c == 'Sheet'){
                
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Material_Item__c.isCreateable()){
                    MIUIfields.Material_Item__c = materialitemid;
                }
                
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                    MIUIfields.Qty_On_Hand__c = ((MIrec.Material_Usage_line_items__r[0].Qty_On_Hand__c) + ((qty != null ? qty *  MIrec.Case_Pack__c : 0) - (Outstandingdebitqty != null ? Outstandingdebitqty *  MIrec.Case_Pack__c : 0)));
                    system.debug('MIUIfields.Qty_On_Hand__c === '+MIUIfields.Qty_On_Hand__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                    MIUIfields.Credit__c = (qty != null ? qty * MIrec.Case_Pack__c : 0);
                    system.debug(' MIUIfields.Credit__c === '+ MIUIfields.Credit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                    MIUIfields.Debit__c = (Outstandingdebitqty != null ? Outstandingdebitqty * MIrec.Case_Pack__c : 0);
                    system.debug(' MIUIfields.Debit__c === '+ MIUIfields.Debit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Date__c.isCreateable()){
                    MIUIfields.Date__c = system.today();
                    system.debug(' MIUIfields.Date__c === '+ MIUIfields.Date__c);
                } 
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Type__c.isCreateable()){
                    MIUIfields.Type__c = 'Purchase';
                }   
            }
            else{
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Material_Item__c.isCreateable()){
                    MIUIfields.Material_Item__c = materialitemid;
                }
                
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                    MIUIfields.Qty_On_Hand__c = ((MIrec.Material_Usage_line_items__r[0].Qty_On_Hand__c) + ((qty != null ? qty : 0) - (Outstandingdebitqty != null ? Outstandingdebitqty : 0)));
                    system.debug('MIUIfields.Qty_On_Hand__c === '+MIUIfields.Qty_On_Hand__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                    MIUIfields.Credit__c = (qty != null ? qty  : 0);
                    system.debug(' MIUIfields.Credit__c === '+ MIUIfields.Credit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                    MIUIfields.Debit__c = (Outstandingdebitqty != null ? Outstandingdebitqty : 0);
                    system.debug(' MIUIfields.Debit__c === '+ MIUIfields.Debit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Date__c.isCreateable()){
                    MIUIfields.Date__c = system.today();
                    system.debug(' MIUIfields.Date__c === '+ MIUIfields.Date__c);
                } 
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Type__c.isCreateable()){
                    MIUIfields.Type__c = 'Purchase';
                }   
                
            }
            
            if(Schema.sObjectType.Material_Usage_line_item__c.isCreateable()){
                insert MIUIfields;
                system.debug('inserted rcd is === '+MIUIfields + '\n');
                
                if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()){
                    MIrec.Qty_On_Hand__c =  MIUIfields.Qty_On_Hand__c;
                    update MIrec;
                    system.debug('Updated rcd is === '+MIrec + '\n');
                    
                }
            }
        }
        else
        {
            if(mplircds[0].Calc_Unit__c == 'Size'){
                
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Material_Item__c.isCreateable()){
                    MIUIfields.Material_Item__c = materialitemid;
                }
                
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                    MIUIfields.Qty_On_Hand__c = qty != null ? qty : 0;
                    system.debug('MIUIfields.Qty_On_Hand__c === '+MIUIfields.Qty_On_Hand__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                    MIUIfields.Credit__c = qty != null ? qty  : 0;
                    system.debug(' MIUIfields.Credit__c === '+ MIUIfields.Credit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                    MIUIfields.Debit__c = 0;
                    system.debug(' MIUIfields.Debit__c === '+ MIUIfields.Debit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Date__c.isCreateable()){
                    MIUIfields.Date__c = system.today();
                    system.debug(' MIUIfields.Date__c === '+ MIUIfields.Date__c);
                } 
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Type__c.isCreateable()){
                    MIUIfields.Type__c = 'Purchase';
                }
            }
            else if(mplircds[0].Calc_Unit__c == 'Sheet'){
                
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Material_Item__c.isCreateable()){
                    MIUIfields.Material_Item__c = materialitemid;
                }
                
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                    MIUIfields.Qty_On_Hand__c = qty != null ? qty : 0;
                    system.debug('MIUIfields.Qty_On_Hand__c === '+MIUIfields.Qty_On_Hand__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                    MIUIfields.Credit__c = qty != null ? qty  : 0;
                    system.debug(' MIUIfields.Credit__c === '+ MIUIfields.Credit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                    MIUIfields.Debit__c = 0;
                    system.debug(' MIUIfields.Debit__c === '+ MIUIfields.Debit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Date__c.isCreateable()){
                    MIUIfields.Date__c = system.today();
                    system.debug(' MIUIfields.Date__c === '+ MIUIfields.Date__c);
                } 
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Type__c.isCreateable()){
                    MIUIfields.Type__c = 'Purchase';
                }   
            }
            else{
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Material_Item__c.isCreateable()){
                    MIUIfields.Material_Item__c = materialitemid;
                }
                
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                    MIUIfields.Qty_On_Hand__c = qty != null ? qty : 0;
                    system.debug('MIUIfields.Qty_On_Hand__c === '+MIUIfields.Qty_On_Hand__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                    MIUIfields.Credit__c = qty != null ? qty  : 0;
                    system.debug(' MIUIfields.Credit__c === '+ MIUIfields.Credit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                    MIUIfields.Debit__c = 0;
                    system.debug(' MIUIfields.Debit__c === '+ MIUIfields.Debit__c);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Date__c.isCreateable()){
                    MIUIfields.Date__c = system.today();
                    system.debug(' MIUIfields.Date__c === '+ MIUIfields.Date__c);
                } 
                if(Schema.sObjectType.Material_Usage_line_item__c.fields.Type__c.isCreateable()){
                    MIUIfields.Type__c = 'Purchase';
                }   
                
            }
            if(Schema.sObjectType.Material_Usage_line_item__c.isCreateable()){
                insert MIUIfields;
                system.debug('inserted rcd is === '+MIUIfields + '\n');
                
                if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()){
                    MIrec.Qty_On_Hand__c =  MIUIfields.Qty_On_Hand__c;
                    update MIrec;
                    system.debug('Updated rcd is === '+MIrec + '\n');
                }
            }   
        }
        
        return MIrec.id;
        // list<Material_Usage_line_item__c>muitmrcds = [select id,Name,Material_Item__c,Credit__c,Debit__c,Qty_On_Hand__c,Type__c from Material_Usage_line_item__c where Material_Item__c =: materialitemid  WITH SECURITY_ENFORCED  Order By CreatedDate desc limit 1];
    }
    
    @AuraEnabled 
    public static string deleteMOrcd(string rcdids){
        Material_Order__c morcds = [select id,name,Vendor_Name__r.name, Issue_Date__c, MO_Due_Date__c, Status__c,Vendor_Name__c,(select id from Material_Purchase_Line_Items__r)  from Material_Order__c where id =:rcdids  WITH SECURITY_ENFORCED limit 1];
        string returnval = '';
        if(morcds.Material_Purchase_Line_Items__r.size() > 0){
            returnval = 'undelete';
        }
        else{
            if(Schema.sObjectType.Material_Order__c.isdeletable()){
                delete morcds;
                returnval = 'deleted';
            }
        }
        return returnval;
    }
    
    @AuraEnabled 
    public static string deleteMPLIrcd(string rcdids){
        system.debug('rcdids == '+rcdids);
        list<Material_Purchase_Line_Item__c> MPLIrcd = [select id,name,Material_Item__c, Material_Item__r.name,Material_Order__c, Material_Order__r.name,MPLI_Status__c, Calc_Unit__c,Qty__c,(select id,name from Material_Order_Line_Item_Receipts__r) from Material_Purchase_Line_Item__c where id =: rcdids WITH SECURITY_ENFORCED limit 1];    
        string returnval = '';
        if(Schema.sObjectType.Material_Purchase_Line_Item__c.isdeletable()){
            if(MPLIrcd[0].Material_Order_Line_Item_Receipts__r.size() == 0 ){
            delete MPLIrcd;
            returnval = 'deleted';
            system.debug('returnval === '+returnval);
            }
        }
        return returnval;
    }
    
    @AuraEnabled 
    public static string editmplircd(string rcdids){
        system.debug('rcdids == '+rcdids);
        Material_Purchase_Line_Item__c MPLIrcd = [select id,name,Material_Item__c, Material_Item__r.name,Material_Order__c, Material_Order__r.name,MPLI_Status__c, Calc_Unit__c,Qty__c,Qty_Outstanding__c from Material_Purchase_Line_Item__c where id =: rcdids WITH SECURITY_ENFORCED limit 1];    
        string returnval = '';
        if(Schema.sObjectType.Material_Purchase_Line_Item__c.isupdateable()){
            MPLIrcd.MPLI_Status__c = 'Received';
            update MPLIrcd;
            returnval = 'updated';
            system.debug('returnval === '+returnval);
        }
        return returnval;
    }   
}