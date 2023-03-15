public with sharing class Job_Billing_Tab {
    
	@AuraEnabled
    public static List<Tool_Tip__c> getHelpTextrecords() {
        List <Tool_Tip__c> lsthelptxt = [Select Id,Client_Invoice__c from Tool_Tip__c WITH SECURITY_ENFORCED];
        return lsthelptxt;
    }
    
    @AuraEnabled
    public static string FetchObjectType(List<String> ObjNames) {
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);   
    }
    
   
    @AuraEnabled 
    public static List<boolean> getisAccessable()
    {
        List<boolean> isAccess=new List<boolean>();
        isAccess.add(schema.sObjectType.Client_Invoice__c.isAccessible());            
        isAccess.add(schema.sObjectType.Client_Invoice_Line_Item__c.isAccessible());
        isAccess.add(schema.sObjectType.Invoice_Allocation_Line_Item__c.isAccessible());
        isAccess.add(schema.sObjectType.Client_Invoice__c.isCreateable()); 
        system.debug('>>>>>>>>>> Client Inv object Setting  >>>>>>>>>>>>'+isAccess);
        return isAccess;
    }
    
    // ================================================= Display Records in CLI Section ==============================================================================//
    @AuraEnabled 
    public static List <Client_Invoice__c> getCLIrecords(Id recordId) {
        system.debug(recordId);
        List < Client_Invoice__c > lstCLI = [Select id,Invoice_Total_new__c,Name,Cost_Per__c,Client_Name__c,Client_Name__r.name,Date_Due__c,Invoice_Date__c,Invoice_Status__c,Invoice_Total__c,Job__c,Notes__c,Term__c,Total_Allocated_Qty__c,Total_Produced__c from Client_Invoice__c where Job__c =: [Select id from Job__c where id =: recordId] WITH SECURITY_ENFORCED Order BY CreatedDate desc,Name ];
        return lstCLI;
    }
    
    // ================================================= Edit CLI Records ==============================================================================//
    
    @AuraEnabled
    public static string updateCLI(List <Client_Invoice__c> editCLIList){
        try{
            if(Schema.sObjectType.Client_Invoice__c.isUpdateable()){
                update editCLIList;
                return 'true';
            }
            else{
                return 'Client Invoice has Insufficient access to update';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    // ================================================= Delete CLI Records ===================================================================//
    
    @AuraEnabled
    public static list<string> DeleteCLI(String CLId){
        list<string> aa=new list<string>();
       
        try{
            Client_Invoice__c DeleteCLI =[Select id,Name,Job__c from Client_Invoice__c where id =:CLId WITH SECURITY_ENFORCED];
            string Jobid=DeleteCLI.Job__c;
            if(!Schema.sObjectType.Client_Invoice__c.isDeletable()){
                aa.add('Error');
               aa.add('Error, Client Invoice has Insufficient access to delete this record');
               return aa;                            
            }
            else{
                delete DeleteCLI; 
                aa.add('OK');
                aa.add(''+Jobid);
                 return aa;
            }
        } catch(Exception e){
            aa.add('NO'); aa.add(''+e.getMessage());  return aa;
        }        
       
    }
    
    // ================================================= get Client Records ===================================================================//
    
    @AuraEnabled
    public Static Map < Id, String > getClients() 
    {
        Map < Id, String > optionMap = new Map < Id, String > ();        
        optionMap.put(null, '--None--');  
        for (Client__c c : [SELECT Id, name FROM Client__c WITH SECURITY_ENFORCED order by Name])  
        { 
            optionMap.put(c.Id, c.name);
        }
        return optionMap;  
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
    public static String geLabelforObject(String sObjName) {
        string objlabel = Schema.getGlobalDescribe().get(sObjName).getDescribe().getLabel();
        return objlabel;
    }
    
    
    /****************************************************************************************************************************************************
* ****************************************************** Invoice Line Items **************************************************************
* ***************************************************************************************************************************************************/
     @AuraEnabled 
    public static boolean showProductionEstimate() {
        Boolean ShowProductionEstimate=false;
        ProductionEstimate__c activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate= activeSettings.Active__c;
        return ShowProductionEstimate;
    }
    
    /********************************************** Fetch All Estimate/Production Estimate ************************************************************/
    
    @AuraEnabled 
    public static List<Sobject> getAddEstLIinCLInvLI(Id recordId) {
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        Boolean ShowProductionEstimate =activeSettings.Active__c;
        Map<String,Client_Invoice_Line_Item__c> CLIMap = new Map<String,Client_Invoice_Line_Item__c>();
        Client_Invoice__c  C=new Client_Invoice__c();
        List<Sobject> ShowList=new List<Sobject>();
        C= [Select id,Name,Job__c from Client_Invoice__c where id =: recordId WITH SECURITY_ENFORCED];
        if(ShowProductionEstimate)
        {  
             List <Client_Invoice_Line_Item__c> lstCLI = [Select Id, name, Production_Estimate__c, Equipment_Type__c, Production_Estimate__r.name from Client_Invoice_Line_Item__c where Client_Invoice__c = : recordId WITH SECURITY_ENFORCED order by CreatedDate];
            system.debug('============' + lstCLI.size());
            List <Production_Estimate__c> ELI = [Select id, PE_Template__c,Sort_Order__c, Name, Amount__c, Vendor__c, Job__c, Equipment_Type__c, Approved__c, Total_Cost__c, GL_Code__c,GL_Code__r.Name, Quantity__c From Production_Estimate__c where Job__c = : C.Job__c and Approved__c = true WITH SECURITY_ENFORCED Order By Sort_Order__c];

            if(!ELI.isEmpty()) 
            {
                Set < string > ELINameSet = new Set < String > ();
                for (Client_Invoice_Line_Item__c ClientLI: lstCLI)
                {
                    ELINameSet.add(ClientLI.Production_Estimate__c);
                    CLIMap.put(ClientLI.Production_Estimate__c, ClientLI);
                }

                for (Production_Estimate__c e: ELI) 
                {
                    if (!ELINameSet.contains(e.id))
                    {
                        ShowList.add(e);
                    }
                   
                 }
            }
        }
        else
        {
            List<Estimate_Line_Items__c> ELI=new List<Estimate_Line_Items__c>();
            List <Client_Invoice_Line_Item__c> lstCLI=[Select Id,name,Estimate_Line_Item__c,Estimate_Line_Item__r.name from Client_Invoice_Line_Item__c where Client_Invoice__c =:recordId WITH SECURITY_ENFORCED order by CreatedDate];
            system.debug('============'+lstCLI.size());
            ELI=[Select id,Name,Amount__c,Vendor__c,Job__c,Approved__c,Total_Amount__c,GL_Code__c,GL_Code__r.Name, Quantity__c, Unit_Type__c From Estimate_Line_Items__c where  Job__c =: C.Job__c and Approved__c = true WITH SECURITY_ENFORCED Order By Name];
            system.debug('===ELI========='+ELI.size());
            if(!ELI.isEmpty()){
                Set<string> ELINameSet = new Set<String>();
                for(Client_Invoice_Line_Item__c ClientLI : lstCLI){
                    ELINameSet.add(ClientLI.Estimate_Line_Item__c);
                    CLIMap.put(ClientLI.Estimate_Line_Item__c,ClientLI);
                }
                for(Estimate_Line_Items__c e: ELI)
                {
                    if(!ELINameSet.contains(e.id))
                    {
                        ShowList.add(e);
                    }
                }
            } 
            
        }
         return ShowList; 
    }
    
    /****************************** Save the Selected the records in Add Line items table **********************************************/
    
    @AuraEnabled 
    public static string insertEstLI_PELI(String CLInvRecId, List<SObject> selRecords) {
        System.debug('====CLInvRecId========='+CLInvRecId);
        
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        Boolean ShowProductionEstimate =activeSettings.Active__c;
        
        list<Client_Invoice_Line_Item__c> CLIinsert=new list<Client_Invoice_Line_Item__c>();
        List<Estimate_Line_Items__c> Estrec=new List<Estimate_Line_Items__c>();
        List<Production_Estimate__c> PErec=new  List<Production_Estimate__c>();
        
        if(!ShowProductionEstimate){
            Estrec=(List<Estimate_Line_Items__c>)selRecords;
            System.debug('====Esimate records========='+Estrec);
            if(Estrec.size()>0){
                for(Estimate_Line_Items__c e:Estrec){
                    Client_Invoice_Line_Item__c CLI=new Client_Invoice_Line_Item__c();
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.Estimate_Line_Item__c.isCreateable()){
                        CLI.Estimate_Line_Item__c=e.id;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.Billable_Amount__c.isCreateable()){     
                        CLI.Billable_Amount__c=e.Total_Amount__c;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.GL_Code__c.isCreateable()){
                        CLI.GL_Code__c=e.GL_Code__c;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.Quantity__c.isCreateable()){
                        CLI.Quantity__c=e.Quantity__c;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.Client_Invoice__c.isCreateable()){
                        CLI.Client_Invoice__c=CLInvRecId;
                    }
                    CLIinsert.add(CLI);
                }
            }
        }
        else{
            PErec=(List<Production_Estimate__c>)selRecords;
            System.debug('====Production Esimate records========='+PErec);
            System.debug('====Production  records size========='+PErec.size());
            if(PErec.size()>0){
                for(Production_Estimate__c pe:PErec){
                    Client_Invoice_Line_Item__c CLI1=new Client_Invoice_Line_Item__c();
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.Production_Estimate__c.isCreateable()){
                        CLI1.Production_Estimate__c=pe.id;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.Billable_Amount__c.isCreateable()){
                        CLI1.Billable_Amount__c=pe.Total_Cost__c;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.GL_Code__c.isCreateable()){
                        CLI1.GL_Code__c=pe.GL_Code__c;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.Quantity__c.isCreateable()){
                        CLI1.Quantity__c=pe.Quantity__c;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.Sort_Order__c.isCreateable()){
                        CLI1.Sort_Order__c=pe.Sort_Order__c;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.PE_Template__c.isCreateable()){
                        CLI1.PE_Template__c = pe.PE_Template__c;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.Equipment_Type__c.isCreateable()){
                        CLI1.Equipment_Type__c=pe.Equipment_Type__c;
                    }
                    if (Schema.sObjectType.Client_Invoice_Line_Item__c.fields.Client_Invoice__c.isCreateable()){
                        CLI1.Client_Invoice__c=CLInvRecId;
                    }
                    CLIinsert.add(CLI1);
                }
            }
        }
        
        System.debug('====CLIinsert records========='+CLIinsert);
        System.debug('====CLIinsert records size========='+CLIinsert);
        if(CLIinsert.size()>0){
            try {
                if(!Schema.sObjectType.Client_Invoice_Line_Item__c.isCreateable()){                     
                    return 'Invoice Line Items has Insufficient access to Create';
                }
                else{
                    insert  CLIinsert;
                }
            } catch (System.DMLException e) {
                return '' + e.getMessage();
            }
        }
        return 'OK';
    }
    
    /***************************** Fetch all Client Invoice Line Items record and display it on Invoice section ***********************************/
    
    @AuraEnabled
    public Static List <Client_Invoice_Line_Item__c> getClientInvLI(Id recordId) 
    {
        List <Client_Invoice_Line_Item__c> CILI=[select id,Name,Equipment_Type__c,PE_Template__c,Tax__c,Client_Invoice__c,GL_Code__r.Name,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,Production_Estimate__c,Production_Estimate__r.Name,Billable_Amount__c,Quantity__c,GL_Code__c,GL_Code_No__c,Unit_Type__c from Client_Invoice_Line_Item__c where Client_Invoice__c =: recordId WITH SECURITY_ENFORCED ORDER BY Sort_Order__c];
        List <Client_Invoice_Line_Item__c> DupCli=new List <Client_Invoice_Line_Item__c>();
        Map <string,list<Client_Invoice_Line_Item__c>> MapPE = new Map <string,list<Client_Invoice_Line_Item__c>> ();        
        for(Client_Invoice_Line_Item__c JS:CILI)
        {
            if(MapPE.containsKey(js.PE_Template__c))
            {
                List <Client_Invoice_Line_Item__c> CLIlist =  MapPE.get(js.PE_Template__c);
                CLIlist.add(js);
                DupCli.add(js);
                MapPE.put(js.PE_Template__c,CLIlist);  
            }
            else
            {
                MapPE.put(js.PE_Template__c, new List<Client_Invoice_Line_Item__c>{js}) ;
                DupCli.add(js);
            }   
        }
        return  DupCli;  
    }  
    
    /***************************** Update Client Invoice Line Items ********************************************/
    
    @AuraEnabled
    public static string updateCLInvLI(List <Client_Invoice_Line_Item__c> editCLInvLIList){
        try{
            if(!Schema.sObjectType.Client_Invoice_Line_Item__c.isUpdateable()){                     
                return 'Invoice Line Items has Insufficient access to Update';
            }
            else{
                update editCLInvLIList;
                return 'true';
            }
            
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    /***************************** Delete Client Invoice Line Items ********************************************/
    
    @AuraEnabled
    public static string deleteCLInvLI(String CLIid){
       
        try{
            Client_Invoice_Line_Item__c objCILI=[Select id,Client_Invoice__c,Estimate_Line_Item__c,Production_Estimate__c from Client_Invoice_Line_Item__c where id=:CLIid WITH SECURITY_ENFORCED];
            Id CIid=objCILI.Client_Invoice__c;
            if(!Schema.sObjectType.Client_Invoice_Line_Item__c.isDeletable()){                     
                return 'Invoice Line Items has Insufficient access to delete';
            }
            else{
                delete objCILI;
                return 'OK';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }   
    
    
    
    
    
    /****************************************************************************************************************************************************
* ****************************************************** Invoice Allocation Line Items **************************************************************
* ***************************************************************************************************************************************************/
    
    @AuraEnabled 
    public static List <Invoice_Allocation_Line_Item__c> getInvALIrecords(Id recordId) {
        system.debug(recordId);
        List < Invoice_Allocation_Line_Item__c > lstInvALI = [select id,Name,Client_Invoice__c,Client_Invoice__r.Total_Allocated_Qty__c,Client_Invoice__r.Total_Produced__c,Client_Invoice__r.Cost_Per__c,Client_Invoice__r.Reconciliation__c,Client_Name__r.Name,Allocation_Qty__c,Allocation_Amount__c,Client_Name__c,GL_Department__c,GL_Code__c,GL_Code_No__c from Invoice_Allocation_Line_Item__c where Client_Invoice__c =: [Select id from Client_Invoice__c where id =: recordId] WITH SECURITY_ENFORCED ORDER BY Name];
        return lstInvALI;
    }
    
    /***************************** Update Client Invoice Allocation Items ********************************************/
    
    @AuraEnabled
    public static string updateInvALI(List <Invoice_Allocation_Line_Item__c> editInvALIList){
        try{
            if(!Schema.sObjectType.Invoice_Allocation_Line_Item__c.isUpdateable()){                     
                return 'Invoice Allocation Line Item has Insufficient access to Update';
            }
            else{
                update editInvALIList;
                return 'true';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    /***************************** Delete Client Invoice Allocation Items ********************************************/
    
    @AuraEnabled
    public static string deleteIALI(String CLIid){
       
        try{
            Invoice_Allocation_Line_Item__c objIALI=[Select id,Client_Invoice__c from Invoice_Allocation_Line_Item__c where id=:CLIid WITH SECURITY_ENFORCED];
            Id CIid=objIALI.Client_Invoice__c;
            if(!Schema.sObjectType.Invoice_Allocation_Line_Item__c.isDeletable()){                     
                return ' Invoice Allocation Line Item has Insufficient access to delete';
            }
            else{
                delete objIALI;
                return 'OK';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }        
    
    // This method is called on to populate all InvAllocationTemplates into drop down list
    @AuraEnabled
    public Static Map < Id, String > getInvAllocationTemplates() 
    {
        Map < Id, String > optionMap = new Map < Id, String > ();        
        optionMap.put(null, '--None--');  
        for (Invoice_Allocation_Template__c a : [SELECT Id, name FROM Invoice_Allocation_Template__c WITH SECURITY_ENFORCED ORDER BY Name]) 
        { 
            optionMap.put(a.Id, a.name);
        }
        return optionMap;  
    }  
    
    
    // This method is called on to Import Allocation Template
    @AuraEnabled
    public Static String importIATLI(Id CLIid,String selectedInvAllocationTemp)
    {
        List<Invoice_Allocation_Line_Item__c> insertClientInvAllocation=new List<Invoice_Allocation_Line_Item__c>();
        List<Invoice_Allocation_Template_Line_Item__c> lstIATLI=new List<Invoice_Allocation_Template_Line_Item__c>();
        
        if(selectedInvAllocationTemp!=null && selectedInvAllocationTemp!='')
        {
          /*  list<Invoice_Allocation_Template_Line_Item__c> AllocationItems=[Select id,Name,Allocation_Qty__c,Client__c from Invoice_Allocation_Template_Line_Item__c where Client_Invoice__c=:CLIid and Invoice_Allocation_Template__c=:selectedInvAllocationTemp];
            if(AllocationItems.size()>0){
                return 'This Template already Imported for this Client Invoice';
            }
            else{*/
            try{
                lstIATLI=[Select id,Name,Allocation_Qty__c,Client__c from Invoice_Allocation_Template_Line_Item__c where Invoice_Allocation_Template__c=:selectedInvAllocationTemp WITH SECURITY_ENFORCED Order By CreatedDate ];
            }
            catch(Exception e){
                return ''+e.getMessage();
            }
                if(lstIATLI.size()==0){
                    return 'This Template doesn\'t have Line Items to import';
                }
                else{ 
                    try
                    {
                        // List<Invoice_Allocation_Template_Line_Item__c> lstIATLI=[Select id,Name,Allocation_Qty__c,Client__c from Invoice_Allocation_Template_Line_Item__c where Invoice_Allocation_Template__c=:selectedInvAllocationTemp Order By CreatedDate ];
                        for(Invoice_Allocation_Template_Line_Item__c sp:lstIATLI)
                        {
                            Invoice_Allocation_Line_Item__c js=new Invoice_Allocation_Line_Item__c();
                            if (Schema.sObjectType.Invoice_Allocation_Line_Item__c.fields.Allocation_Qty__c.isCreateable()){
                                js.Allocation_Qty__c=sp.Allocation_Qty__c;}
                            if (Schema.sObjectType.Invoice_Allocation_Line_Item__c.fields.Client_Name__c.isCreateable()){
                                js.Client_Name__c=sp.Client__c ;}
                            if (Schema.sObjectType.Invoice_Allocation_Line_Item__c.fields.Client_Invoice__c.isCreateable()){
                                js.Client_Invoice__c=CLIid;}
                            
                            insertClientInvAllocation.add(js);
                        }
                        if(Schema.sObjectType.Invoice_Allocation_Line_Item__c.isCreateable()){   
                            insert insertClientInvAllocation;}
                        else{
                            return 'Error, Invoice Allocation Line item has Insufficient access to create record';
                        }
                    }
                    catch(System.DMLException e)
                    {
                        return ''+e.getMessage();
                    }
                }
            }
        else{
            return 'Please select the  Invoice Allocation Template';
        }
        return 'Sucessfully Imported Client Invoice Allocation records';
    }
    
    
    // This method is called on to calculate Total Allocation Amount of  Invoice Allocation Line Items
     @AuraEnabled 
    public static double getSumCash(Id CLIid)
    { 
        Sobject sumCash; 
        sumCash = [SELECT SUM(Allocation_Amount__c) sum FROM Invoice_Allocation_Line_Item__c WHERE Client_Invoice__c =: CLIid WITH SECURITY_ENFORCED];   
        return double.valueOf(sumCash.get('sum')); 
    }  
    // End of method getSumCash
    
    // This method is called on to calculate Total Allocation Qty of  Invoice Allocation Line Items
    @AuraEnabled 
    public static Integer getSumQuant(Id CLIid)
    { 
        Sobject sumQuant;
        sumQuant = [SELECT SUM(Allocation_Qty__c) sum FROM Invoice_Allocation_Line_Item__c WHERE Client_Invoice__c =: CLIid WITH SECURITY_ENFORCED];   
        return Integer.valueOf(sumQuant.get('sum')); 
    }  
    // End of method getsumQuant
    
    
    
}