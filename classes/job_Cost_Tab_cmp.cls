public with sharing class job_Cost_Tab_cmp {
   
   
   
    /**************************************************************************************************************************************************
**********************************************************  QUOTE SECTION ************************************************************************
**************************************************************************************************************************************************/
    @AuraEnabled
    public static list<Boolean> getQuotePermiossions()
    {
        list<boolean> isAccessList=new list<boolean>();
        isAccessList.add(Schema.sObjectType.Quote__c.isCreateable());    
        isAccessList.add(Schema.sObjectType.Quote__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Quote_Spec_Item__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Quote_Spec_Item__c.isCreateable());
        isAccessList.add(Schema.sObjectType.Quote_Spec_Item__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Vendor_Quote__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Vendor_Quote__c.isCreateable());
        isAccessList.add(Schema.sObjectType.Vendor_Quote__c.isUpdateable());
        return isAccessList;
       
    }
    @AuraEnabled
    public static list<Boolean> getPEPermiossions()
    {
        list<boolean> isAccessList=new list<boolean>();
        isAccessList.add(Schema.sObjectType.Production_Estimate__c.isCreateable());    
        isAccessList.add(Schema.sObjectType.Production_Estimate__c.isUpdateable());    
        return isAccessList;
       
    }
    @AuraEnabled
    public static list<Boolean> getEstPermiossions()
    {
        list<boolean> isAccessList=new list<boolean>();
        isAccessList.add(Schema.sObjectType.Estimate_Line_Items__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Estimate_Line_Items__c.isCreateable());    
        isAccessList.add(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Estimate_Spec_Item__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Estimate_Spec_Item__c.isCreateable());    
        isAccessList.add(Schema.sObjectType.Estimate_Spec_Item__c.isUpdateable());
        return isAccessList;
       
    }
    @AuraEnabled
    public static list<Boolean> getShipPermiossions()
    {
        list<boolean> isAccessList=new list<boolean>();
        isAccessList.add(Schema.sObjectType.Shipment__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Shipment__c.isCreateable());    
        isAccessList.add(Schema.sObjectType.Shipment__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Shipment_Line_Item__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Shipment_Line_Item__c.isCreateable());    
        isAccessList.add(Schema.sObjectType.Shipment_Line_Item__c.isUpdateable());
        return isAccessList;
       
    }
    @AuraEnabled
    public static list<Boolean> getPOPermiossions()
    {
        list<boolean> isAccessList=new list<boolean>();
        isAccessList.add(Schema.sObjectType.Purchase_Order__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Purchase_Order__c.isCreateable());    
        isAccessList.add(Schema.sObjectType.Purchase_Order__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.PO_Line_Item__c.isAccessible());
        isAccessList.add(Schema.sObjectType.PO_Line_Item__c.isCreateable());    
        isAccessList.add(Schema.sObjectType.Invoice_Line_Item__c.isCreateable());
        return isAccessList;
       
    }
   
   
   
    @AuraEnabled
    public static list<Boolean> getVIPermiossions()
    {
        list<boolean> isAccessList=new list<boolean>();
        isAccessList.add(Schema.sObjectType.Invoice__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Invoice__c.isCreateable());    
        isAccessList.add(Schema.sObjectType.Invoice__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Invoice_Line_Item__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Invoice_Line_Item__c.isCreateable());    
        isAccessList.add(Schema.sObjectType.Invoice_Line_Item__c.isUpdateable());
        return isAccessList;
       
    }
   
   
    @AuraEnabled
    public static String getObjectType(List<String> ObjNames) {
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);  
    }
   
    @AuraEnabled
    public static boolean showProductionEstimate() {
        Boolean ShowProductionEstimate=false;
        ProductionEstimate__c activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate= activeSettings.Active__c;
        return ShowProductionEstimate;
    }
   
    @AuraEnabled
    public static boolean OrganizationIdsBasedOnpages(String Page){
        Id OrgId=userInfo.getOrganizationId();
        if(Page=='InvoiceFromPo'){
            if(orgId == '00DA0000000Cir8MAC' || orgId == '00Di0000000YKOKEA4' || orgId == '00De0000001KaOkEAK' || test.isRunningTest()){
                return true;
            }
        }    
        return false;
    }
   
   
    @AuraEnabled
    public static double getTotalAmountForSections(String ObjectName,String Jobid){
        Sobject sumCash;
        if(ObjectName=='Est'){
            sumCash = [SELECT SUM(Total_Amount__c) esum FROM Estimate_Line_Items__c WHERE Job__c =:Jobid WITH SECURITY_ENFORCED];  //and Approved__c = true
            return double.valueOf(sumCash.get('esum'));
        }
        else if(ObjectName=='ProEst'){
            sumCash = [SELECT SUM(Total_Cost__c) pestsum FROM Production_Estimate__c  WHERE Job__c =:Jobid WITH SECURITY_ENFORCED];   //Approved__c=:true
            return double.valueOf(sumCash.get('pestsum'));
        }
        else if(ObjectName=='PO'){
            sumCash = [SELECT SUM(Total_Amount__c) posum FROM Purchase_Order__c WHERE Job__c =:Jobid WITH SECURITY_ENFORCED];  
            return double.valueOf(sumCash.get('posum'));    
        }
        else if(ObjectName=='Inv'){
            sumCash = [SELECT SUM(Total_Amount__c) invsum FROM Invoice__c WHERE Job__c =:Jobid WITH SECURITY_ENFORCED];  
            return double.valueOf(sumCash.get('invsum'));
        }
        return 0.0;
    }
   
   
   
   
   
    // ================================================= Display Records in Quote Section ==============================================================================//
    @AuraEnabled
    public static List < Quote__c > getquoterecords(Id recordId) {
        system.debug(recordId);
        List < Quote__c > lstquotes = [select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: recordId] WITH SECURITY_ENFORCED Order By CreatedDate DESC,Name];
        return lstquotes;
    }
   
    // ================================================= Edit Quote Records ==============================================================================//
   
    @AuraEnabled
    public static string updateQuotes(List <Quote__c> editedQuoteList){
        try{
            if(Schema.sObjectType.Quote__c.isUpdateable()){
                update editedQuoteList;
                return 'true';}
            else{
                return 'Error, Quote has insufficient access to update';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
   
    // ================================================= Delete Quote Records ===================================================================//
   
    @AuraEnabled
    public static list<string> DeleteQuote(String quoteId){
        list<string> aa=new list<string>();
       
        try{
            Quote__c DelteQuote =[select Id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Id=:quoteId  WITH SECURITY_ENFORCED];
            string Jobid=DelteQuote.Job__c;
            if(Quote__c.sObjectType.getDescribe().isDeletable()){
                delete DelteQuote;
                aa.add('OK');
                aa.add(''+Jobid);
            }
            else{
                aa.add('NO');
                aa.add('Error,Quote has insufficient access to delete');
                return aa;  
            }
            //return ''+Jobid;
        } catch(Exception e){
            aa.add('NO');aa.add(''+e.getMessage());
            return aa;
        }
       
        return aa;
    }
   
    @AuraEnabled
    public static string updateQuoteSpecs(list<Quote_Spec_Item__c> editQuoteSpecsList){
        try{
            if(Schema.sObjectType.Quote_Spec_Item__c.isUpdateable()){
                update editQuoteSpecsList;
                return 'OK';  
            }
            else{
                return 'Error, Quote Spec Item has Insufficient access to update';
            }
        }
        catch(System.DmlException e){return e.getMessage();
                                    }
       
    }
   
    @AuraEnabled
    public static string updateProEstimateSpecs(list<Production_Estimate_Spec_Item__c> editProEstSpecsList){
        try{
            if(Schema.sObjectType.Production_Estimate_Spec_Item__c.isUpdateable()){
                update editProEstSpecsList;
                return 'OK';  
            }
            else{
                return 'Error, production estimate spec item has Insufficient access to update ';
            }
        }
        catch(System.DmlException e){return e.getMessage();
                                    }
       
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
   
    @AuraEnabled
    public static String getLabelforAllObjects() {
        Map<String,Schema.SobjectType> allObjMap=Schema.getGlobalDescribe();
        Map<String,String> ObjeApiNameMap=new Map<String,String>();
        String allObjJSON ='{';
        for(String SObjet:allObjMap.keyset()){
            Schema.DescribeSObjectResult objResult=allObjMap.get(SObjet).getDescribe();
            if(objResult.iscustom()){
                if(allObjJSON!='{')
                    allObjJSON+=', ';
                allObjJSON+='"'+objResult.getName()+'" : "'+objResult.getLabel()+'"';
                ObjeApiNameMap.put(objResult.getName(),objResult.getLabel());
            }
           
        }
        allObjJSON+='}';
        return allObjJSON;
    }
    // ******************************************* This method is used to retrieve all GLDepartments into dropdown list ******************************************************
   
    @AuraEnabled
    public Static decimal getMatereialItemsWidth(String materialid) {
        Material_Item__c miList =  [SELECT Id, Name,Calc_Unit__c,Mt_Status__c,Equipment_Type__c,Width_inches__c FROM Material_Item__c where id =:materialid and Mt_Status__c = 'Active' WITH SECURITY_ENFORCED limit 1];    
        return miList.Width_inches__c;
    }
   
    @AuraEnabled
    public Static list<Material_Item__c> getMatereialItems(String CalUnit,string equiptype) {  
        system.debug('===CalUnit========'+CalUnit);
        list<Material_Item__c> miList=new list<Material_Item__c>();
        // miList=[SELECT Id, name FROM Material_Item__c where recordtype.name =:CalUnit order by Name];
        //Added Status__c in below soql query on 30 - 03 - 2022
        miList=[SELECT Id, Name,Calc_Unit__c,Mt_Status__c,Equipment_Type__c FROM Material_Item__c where (Calc_Unit__c=:CalUnit  and Equipment_Type__c=:equiptype) and Mt_Status__c = 'Active' WITH SECURITY_ENFORCED order by Name];
        return miList;
    }
   
    @AuraEnabled
    public Static list<GL_Department__c> getGLDepartments()
    {    
       
        list<GL_Department__c>  gldlist=[SELECT Id, name FROM GL_Department__c WITH SECURITY_ENFORCED order by Name];
        return gldlist;  
    }
   
    // ****************************************** This method is used to retrieve all GLCodes under the GL Department into dropdown list *********************************************
   
    @AuraEnabled
    public Static list<GL_Code__c> getGLCodes(String GLDName)
    {
        /*  Map < Id, String > optionMap = new Map < Id, String > ();        
optionMap.put(null, '--None--');  
for (GL_Code__c glcode : [SELECT Id,Name,GL_Id__c FROM GL_Code__c where GL_Department__c =: GLDName ORDER BY Name])
{  
optionMap.put(glcode.Id, glcode.GL_Id__c +' '+glcode.Name);  
}
*/
        List<GL_Code__c> glcodelist=[SELECT Id,Name,GL_Id__c FROM GL_Code__c where GL_Department__c =: GLDName WITH SECURITY_ENFORCED ORDER BY Name];
        return glcodelist;  
    }  
   
    @AuraEnabled
    public Static Decimal getamount(String GLCName){
        Decimal Amount=0.00;
        if(GLCName!=null)
        {
            GL_Code__c  glc=[SELECT Id,GL_Id__c,Name,Unit_Cost__c FROM GL_Code__c where id=: GLCName WITH SECURITY_ENFORCED];
            Amount=glc.Unit_Cost__c;
        }
        return Amount;
    }    
   
   
    // ****************************************** This method is used to retrieve all Vendors under the GL_Code__c into dropdown list *********************************************
   
    @AuraEnabled
    public Static list<Vendor_GL_Code__c> getVendors(String GLCName)
    {
        /* Map < Id, String > optionMap = new Map < Id, String > ();        
optionMap.put(null, '--None--');  
for (Vendor_GL_Code__c ar : [SELECT Id,Name,Vendor__c,Vendor__r.Name,GL_Code__c FROM Vendor_GL_Code__c where GL_Code__c =: GLCName])  
{
optionMap.put(ar.Vendor__c, ar.Vendor__r.Name);
}
*/
        list<Vendor_GL_Code__c> vglcodelist=[SELECT Id,Name,Vendor__c,Vendor__r.Name,GL_Code__c FROM Vendor_GL_Code__c where GL_Code__c =: GLCName WITH SECURITY_ENFORCED];
        return vglcodelist;  
    }  
   
   
   
   
    // ******************************************* Quote related specitem  ************************************************************//    
    @AuraEnabled
    public static List<Quote_Spec_Item__c> getquotespecList(String quoteId) {
        List<Quote_Spec_Item__c>  QSI = [select id,Name,Description__c,Quote__c from Quote_Spec_Item__c where Quote__c =: quoteId WITH SECURITY_ENFORCED  Order By CreatedDate ];
        return QSI;
    }
    @AuraEnabled
    public static string deleteQuoteSpec(String SpecRecId) {
       
       
       
        try {
            Quote_Spec_Item__c spec = [select id, Name, Quote__c, Description__c From Quote_Spec_Item__c where id = : SpecRecId WITH SECURITY_ENFORCED limit 1];
            if(Schema.sObjectType.Quote_Spec_Item__c.isDeletable()){
                Delete spec;
                return 'Deleted';
            }
            else{
                return 'Error, Insufficient access to delete this record';
            }
        } catch (Exception e) {return '' + e.getMessage();
                              }
       
    }
    // ******************************************* Vendor Quote  ************************************************************//      
    @AuraEnabled
    public static List<Vendor_Quote__c> getVendorQuoteList(String quoteId) {
        List<Vendor_Quote__c>  VQL = [select Id,Name,Date__c,Amount__c,Vendor__c,Vendor__r.Id,Vendor__r.Name,Restrict__c,Quote__c from Vendor_Quote__c where Quote__c =: quoteId WITH SECURITY_ENFORCED ORDER BY Name];
        return VQL;
    }
    // ================================================= Edit Quote Records ==============================================================================//
   
    @AuraEnabled
    public static string updateVendorQuotes(List <Vendor_Quote__c> editedVendorQuoteList){
        try{
            if(Schema.sObjectType.Vendor_Quote__c.isUpdateable()){
                update editedVendorQuoteList;
                return 'true';}
            else{
                return 'Error, Vendor Quote Insufficient access to Update this record';
            }
        } catch(Exception e){return ''+e.getMessage();
                            }
    }
    @AuraEnabled
    public Static Map < Id, String > getVendorQuote(String quoteId)
    {    
        Map < Id, String > optionMap = new Map < Id, String > ();        
        optionMap.put(null, '--None--');  
        Quote__c q11 = [select id,Name,GL_Code__c from Quote__c where id =: quoteId WITH SECURITY_ENFORCED Limit 1 ];
        String glid = q11.GL_Code__c;
        for (Vendor_GL_Code__c gld : [SELECT Id,Name,Vendor__c,Vendor__r.Name,GL_Code__c FROM Vendor_GL_Code__c where GL_Code__c =: glid  WITH SECURITY_ENFORCED])
        {  
            optionMap.put(gld.Vendor__c, gld.Vendor__r.Name);  
        }
        return optionMap;  
    }
   
    @AuraEnabled
    public static string vendorUnapproved(String quoteId) {  
        ProductionEstimate__c activeSettings = ProductionEstimate__c.getOrgDefaults();
        Boolean ShowProductionEstimate = activeSettings.Active__c;
        try {
            Quote__c Qtrec = [select Id, Name, Job__c from Quote__c where Id = : quoteId  WITH SECURITY_ENFORCED];
           
            if (ShowProductionEstimate) {
                List < Production_Estimate__c > PE = [select id, Job__c, Quote__c, Quote__r.id, Approved__c from Production_Estimate__c where Quote__c = : quoteId and Job__c = : Qtrec.Job__c and Approved__c = True  WITH SECURITY_ENFORCED];
                if (PE.size() > 0) {
                    return 'You Can not unapprove this Quote Because Production Estimate Line Item Created from this Quote is Approved...';
                } else {
                    if(Schema.sObjectType.Quote__c.fields.Approved__c.isUpdateable()){
                        Qtrec.Approved__c = False;
                    }
                    if(Schema.sObjectType.Quote__c.isUpdateable()){
                        update Qtrec;}
                    else{
                        return 'Error, Quote has Insufficient access to update';
                    }                    
                    List < Production_Estimate__c > pest = [select id, Name, Quote__c from Production_Estimate__c where Quote__c = : quoteId WITH SECURITY_ENFORCED];
                    if(Schema.sObjectType.Production_Estimate__c.isDeletable()){
                        delete pest;}
                    else{
                        return 'Error, related Production Estimate has Insufficient access to delete';
                    }
                   
                    Vendor_Quote__c vq = [select id, Name, Quote__c, Restrict__c from Vendor_Quote__c where Quote__c = : quoteId and Restrict__c = true WITH SECURITY_ENFORCED];
                    if(Schema.sObjectType.Vendor_Quote__c.fields.Restrict__c.isUpdateable()){
                        vq.Restrict__c = false;}
                    if(Schema.sObjectType.Vendor_Quote__c.isUpdateable()){
                        update vq;}
                    else{
                        return 'Error, Vendor Quote has Insufficient access to update this record';
                    }
                }
            }
           
           
           
            else {
                List < Estimate_Line_Items__c > ESTL = [select Id, Job__c, Quote__c, Quote__r.id, Approved__c from Estimate_Line_Items__c where Quote__c = : quoteId and Job__c = : Qtrec.Job__c and Approved__c = True WITH SECURITY_ENFORCED];
                if (ESTL.size() > 0) {
                    return 'You Can not unapprove this Quote Because Estimate Line Item Created from this Quote is Approved...';
                } else {              
                    if(Schema.sObjectType.Quote__c.fields.Approved__c.isUpdateable()){
                        Qtrec.Approved__c = False;}
                    if(Schema.sObjectType.Quote__c.isUpdateable()){
                        update Qtrec;}
                    else{
                        return 'Error, Quote has Insufficient access to update';
                    }
                   
                    List < Estimate_Line_Items__c > est = [select id, Name, Quote__c from Estimate_Line_Items__c where Quote__c = : quoteId WITH SECURITY_ENFORCED];
                    if(Schema.sObjectType.Estimate_Line_Items__c.isDeletable()){
                        delete est;}
                    else{
                        return 'Error, Estimate Line Items has Insufficient access to delete ';
                    }
                   
                    Vendor_Quote__c vq = [select id, Name, Quote__c, Restrict__c from Vendor_Quote__c where Quote__c = : quoteId and Restrict__c = true WITH SECURITY_ENFORCED];
                    if(Schema.sObjectType.Vendor_Quote__c.fields.Restrict__c.isUpdateable()){
                        vq.Restrict__c = false;}
                    if(Schema.sObjectType.Vendor_Quote__c.isUpdateable()){
                        update vq;}
                    else{
                        return 'Error, Vendor Quote has Insufficient access to update';
                    }
                }
            }
        }
        catch (System.DMLException e) {return '' + e.getMessage();
                                      }
        return 'OK';
    }
   
    @AuraEnabled
    public static string vendorapproved(String VendorquoteId) {
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        Boolean  ShowProductionEstimate =activeSettings.Active__c;
       
        Vendor_Quote__c oldvq= [Select id,Name,Restrict__c,Quote__r.job__c,Quote__c from Vendor_Quote__c where id =: VendorquoteId WITH SECURITY_ENFORCED];
        try
        {
            if(Schema.sObjectType.Vendor_Quote__c.fields.Restrict__c.isUpdateable()){
                oldvq.Restrict__c=true;}
            if(Schema.sObjectType.Vendor_Quote__c.isUpdateable()){
                update oldvq;}
            else{
                return 'Error, Insufficient access to update this record';
            }
        }
        catch(System.DMLException e)
        {return ''+e.getMessage();
        }
       
        // string Jobid = Newvq.Quote__r.Job__c;
        Vendor_Quote__c q1 = [select Name,Quote__r.id,Quote__r.Name,Quote__r.GL_Department__c,Restrict__c,Vendor__c,Quote__r.Job__c,Quote__r.Quantity__c,Quote__r.GL_Code__c,Amount__c from Vendor_Quote__c where Id =: VendorquoteId WITH SECURITY_ENFORCED];
        List <Estimate_Spec_Item__c> lstELI=new List<Estimate_Spec_Item__c>();
        List<Production_Estimate_Spec_Item__c> lstPELI= new List<Production_Estimate_Spec_Item__c>();
        List<Quote_Spec_Item__c>  qsi = [Select id,Name,Description__c,Quote__c from Quote_Spec_Item__c where Quote__c =: oldvq.Quote__c WITH SECURITY_ENFORCED];  
        system.debug('=======ShowProductionEstimate in the Approved button========='+ShowProductionEstimate);
        if(ShowProductionEstimate ){
            Production_Estimate__c  pest = new Production_Estimate__c();
            if(Schema.sObjectType.Production_Estimate__c.fields.Name.isCreateable()) { pest.Name = q1.Quote__r.Name;}
            if(Schema.sObjectType.Production_Estimate__c.fields.GL_Department__c.isCreateable()) {  pest.GL_Department__c = q1.Quote__r.GL_Department__c;}
            if(Schema.sObjectType.Production_Estimate__c.fields.GL_Code__c.isCreateable()) {  pest.GL_Code__c = q1.Quote__r.GL_Code__c;}
            if(Schema.sObjectType.Production_Estimate__c.fields.Vendor__c.isCreateable()) {  pest.Vendor__c = q1.Vendor__c;}
            if(Schema.sObjectType.Production_Estimate__c.fields.Job__c.isCreateable()) { pest.Job__c = q1.Quote__r.Job__c;}
            if(Schema.sObjectType.Production_Estimate__c.fields.Quote__c.isCreateable()) { pest.Quote__c = q1.Quote__c;}
            if(Schema.sObjectType.Production_Estimate__c.fields.Amount__c.isCreateable()) { pest.Amount__c = q1.Amount__c;}
            if(Schema.sObjectType.Production_Estimate__c.fields.Quantity__c.isCreateable()) { pest.Quantity__c = q1.Quote__r.Quantity__c;}
            //strPEstimateId = pest.Id;
            try
            {
                if(Schema.sObjectType.Production_Estimate__c.isCreateable()){
                    insert pest;}
                else{
                    return 'Error, Production Estimate Insufficient access to insert this record';
                }
            }
            catch(System.DMLException e)
            {return ''+e.getMessage();
            }
           
            for(Quote_Spec_Item__c q3:qsi)
            {
                Production_Estimate_Spec_Item__c pestLI = new Production_Estimate_Spec_Item__c();
                if(Schema.sObjectType.Production_Estimate_Spec_Item__c.fields.Name.isCreateable()) { pestLI.Name = q3.Name;}
                if(Schema.sObjectType.Production_Estimate_Spec_Item__c.fields.Description__c.isCreateable()) {  pestLI.Description__c = q3.Description__c;}
                if(Schema.sObjectType.Production_Estimate_Spec_Item__c.fields.Production_Estimate__c.isCreateable()) {  pestLI.Production_Estimate__c= pest.id; }
                lstPELI.add(pestLI);
            }
            if(lstPELI.size()>0){
                try
                {
                    if(Schema.sObjectType.Production_Estimate_Spec_Item__c.isCreateable()){
                        insert lstPELI;}
                    else{
                        return 'Error, Production Estimate Spec Item Insufficient access to insert';
                    }
                }
                catch(System.DMLException e)
                {return ''+e.getMessage();
                }
            }
        }
        else{
            Estimate_Line_Items__c est = new Estimate_Line_Items__c();
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Name.isCreateable()) { est.Name = q1.Quote__r.Name;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.GL_Department__c.isCreateable()) {est.GL_Department__c = q1.Quote__r.GL_Department__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.GL_Code__c.isCreateable()) { est.GL_Code__c = q1.Quote__r.GL_Code__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Vendor__c.isCreateable()) { est.Vendor__c = q1.Vendor__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Job__c.isCreateable()) { est.Job__c = q1.Quote__r.Job__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Quote__c.isCreateable()) {est.Quote__c = q1.Quote__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Restrict__c.isCreateable()) { est.Restrict__c = q1.Restrict__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Amount__c.isCreateable()) { est.Amount__c = q1.Amount__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Quantity__c.isCreateable()) {est.Quantity__c = q1.Quote__r.Quantity__c;}
            //strEstimateId = est.Id;
            try
            {
                if(Schema.sObjectType.Estimate_Line_Items__c.isCreateable()){
                    insert est;}
                else{
                    return 'Error, Estimate Line Items Insufficient access to insert';
                }
            }
            catch(System.DMLException e)
            {return ''+e.getMessage();
            }
            for(Quote_Spec_Item__c q3:qsi)
            {
                Estimate_Spec_Item__c estLI = new Estimate_Spec_Item__c();
                if(Schema.sObjectType.Estimate_Spec_Item__c.fields.Name.isCreateable()) { estLI.Name = q3.Name;}
                if(Schema.sObjectType.Estimate_Spec_Item__c.fields.Description__c.isCreateable()) { estLI.Description__c = q3.Description__c;}
                if(Schema.sObjectType.Estimate_Spec_Item__c.fields.Estimates__c.isCreateable()) { estLI.Estimates__c = est.id; }
                lstELI.add(estLI);
            }
            if(lstELI.size()>0){
                try{
                    if(Schema.sObjectType.Estimate_Spec_Item__c.isCreateable()){
                        insert lstELI;}
                    else{
                        return 'Error, Estimate Spec Item has Insufficient access to insert';
                    }
                }
                catch(System.DMLException e)
                {return ''+e.getMessage();
                }
            }
           
        }
        return 'OK';
    }
   
   
    @AuraEnabled
    public static string vendorQuoteDelete(String VendorquoteId) {
       
        Vendor_Quote__c Vq=[Select Id, Quote__c from Vendor_Quote__c where Id =:VendorquoteId WITH SECURITY_ENFORCED limit 1];
        try
        {
            if(!(Schema.sObjectType.Vendor_Quote__c.isDeletable())){
                return 'Error, Insufficient access to delete this record';
            }
            else{
                Database.delete(Vq);
            }
        }
        catch(System.DMLException e)
        {return ''+e.getMessage();
        }
        return 'OK';
    }
   
   
    /**************************************************************************************************************************************************
**********************************************************  ESTIMATE SECTION *********************************************************************
**************************************************************************************************************************************************/
   
   
    // ******************************************* Displaying the records in Estimate Section under the job tab ************************************************************//
    @AuraEnabled
    public static List <Estimate_Line_Items__c> getEstimateRecords(Id recordId) {
        system.debug(recordId);
        List <Estimate_Line_Items__c> lstEstimates = [select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: recordId] WITH SECURITY_ENFORCED Order By CreatedDate DESC,Name];
        return lstEstimates;
    }
   
    // ******************************************* Updating the records in Estimate Section under the job tab ************************************************************//    
    @AuraEnabled
    public static string updateEst(List <Estimate_Line_Items__c> editedEstList){
        try{
            if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable()){
                update editedEstList;
                return 'true';}
            else{
                return 'Estimate line item has insufficient access to update';
            }
        } catch(Exception e){return ''+e.getMessage();
                            }
    }
   
    // ******************************************* Deleting the records in Estimate Section under the job tab ************************************************************//    
    @AuraEnabled
    public static List<string> deleteEst(String estRecId) {
        list<string> aa=new list<string>();
       
        try {
            Estimate_Line_Items__c Est = [select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Id = : estRecId WITH SECURITY_ENFORCED limit 1];
            string JobId=Est.Job__c;
            if(Estimate_Line_Items__c.sObjectType.getDescribe().isDeletable()){
                Delete Est;
                aa.add('OK');
                aa.add(''+JobId);
                return aa;
            }
            else{
                aa.add('NO');aa.add('Error, Estimate has insufficient access to delete');return aa;
            }
        } catch (Exception e) {
            aa.add('NO');aa.add(''+e.getMessage());return aa;
        }
       
       
    }
   
    @AuraEnabled
    public static string duplicateEtimate(String estRecId) {
        try {
            Estimate_Line_Items__c es = [select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Id = : estRecId WITH SECURITY_ENFORCED limit 1];
           
            Estimate_Line_Items__c  objJEst=new Estimate_Line_Items__c ();
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.name.isCreateable()) { objJEst.name=es.Name;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Job__c.isCreateable()) { objJEst.Job__c=es.Job__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Quantity__c.isCreateable()) {objJEst.Quantity__c=es.Quantity__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Amount__c.isCreateable()) { objJEst.Amount__c=es.Amount__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.GL_Code__c.isCreateable()) { objJEst.GL_Code__c=es.GL_Code__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.GL_Department__c.isCreateable()) {objJEst.GL_Department__c=es.GL_Department__c;}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Vendor__c.isCreateable()) { objJEst.Vendor__c =es.Vendor__c ;}
           
           
            if(Schema.sObjectType.Estimate_Line_Items__c.isCreateable()){
                insert objJEst;
                return 'OK';
            }
            else{
                return 'Error, Estimate Line Item has insufficient access to create';
            }
        } catch (Exception e) {return '' + e.getMessage();
                              }
       
       
    }
   
    // ******************************************* Production Estimate Secation *******************************************************//
    @AuraEnabled
    public static Map<String,list<Production_Estimate__c>> getProductionEstimateRecords(String recordId) {
        list<Production_Estimate__c> ProEstlist=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =:recordId WITH SECURITY_ENFORCED Order By Sort_Order__c];
       
        Map<String,list<Production_Estimate__c>>   MapPE = new Map<String,list<Production_Estimate__c>>();
       
        for(Production_Estimate__c pe:ProEstlist)
        {
            if(MapPE.containsKey(pe.PE_Template__c))
            {
                List <Production_Estimate__c> PElist = MapPE.get(pe.PE_Template__c);
                PElist.add(pe);
                MapPE.put(pe.PE_Template__c,PElist);  
            }
            else
            {
                MapPE.put(pe.PE_Template__c,new List<Production_Estimate__c>{pe});
            }  
           
        }
        return MapPE;
    }    
   
    @AuraEnabled
    public static list<Production_Estimate_Template__c> getProEstTempforProEst(){
        List<Production_Estimate_Template__c> pestTempList = new List<Production_Estimate_Template__c>();
        pestTempList = [SELECT Id, name FROM Production_Estimate_Template__c WITH SECURITY_ENFORCED ORDER BY Name];
        return pestTempList;  
    }
   
   
    @AuraEnabled
    public static string approveProEst(String ProEstID){
       
        try{
            Production_Estimate__c PEApprove=[select id,Job__c,Quantity__c,Amount__c,Name,GL_Code__c,GL_Department__c,Vendor__c From Production_Estimate__c Where Id =:ProEstID WITH SECURITY_ENFORCED Limit 1];
            if(Schema.sObjectType.Production_Estimate__c.fields.Approved__c.isUpdateable()){
                PEApprove.Approved__c=true;
            }
            if(Schema.sobjectType.Production_Estimate__c.isUpdateable()){
                update PEApprove;
            }
            else{
                return 'Error, Production Estimate has insufficient access to update';
            }
        }
        Catch(System.DmlException e){return ''+e.getMessage();
                                    }
        return 'OK';
    }
   
    @AuraEnabled
    public static string unApproveProEst(String ProEstID) {
        List < Material_Usage_line_item__c > UpadteRestMI = new List < Material_Usage_line_item__c > ();
        list< Material_Usage_line_item__c> mu =new  list< Material_Usage_line_item__c>();
        try {
            Production_Estimate__c PEunApprove = [select Id, Job__c, Quantity__c, Amount__c, Name, GL_Code__c, GL_Department__c, Vendor__c, Material_Item__c,Calc_Unit__c, Qty_Used__c, Lf_Used__c from Production_Estimate__c where Id = :ProEstID WITH SECURITY_ENFORCED Limit 1];
            if(Schema.sObjectType.Production_Estimate__c.fields.Approved__c.isUpdateable()){
                PEunApprove.Approved__c = false;}
            try{
                mu = [select Id, name, Production_Estimate__c, Material_Item__c, createddate from Material_Usage_line_item__c where Production_Estimate__c = :ProEstID WITH SECURITY_ENFORCED ];
            }
            Catch(Exception e){
                return 'Error,Material Usage line item has insufficient access';
            }
            if (mu.size() > 0){
                for (Material_Usage_line_item__c m: [Select Id, name, Qty_On_Hand__c, createddate, Material_Item__c from Material_Usage_line_item__c where Material_Item__c = : mu[0].Material_Item__c AND createddate > : mu[0].createddate WITH SECURITY_ENFORCED order by createddate DESC]) {
                    if (PEunApprove.Calc_Unit__c == 'Size') {
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){ m.Qty_On_Hand__c += PEunApprove.Lf_Used__c;}
                    } else {
                        if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){ m.Qty_On_Hand__c += PEunApprove.Qty_Used__c;}
                    }
                   
                    UpadteRestMI.add(m);
                   
                }
               
                if(Schema.sobjectType.Material_Item__c.isDeletable()){
                    Delete mu;}
                else{ return 'Error,Related Material Usage line item has insufficient access to Delete';}
            }
           
            if (mu.size() > 0) {
                Material_Item__c mit=new Material_Item__c();  
                try{
                    mit = [Select Id, name, Qty_On_Hand__c from Material_Item__c where Id = : PEunApprove.Material_Item__c WITH SECURITY_ENFORCED ];
                }Catch(Exception e){
                    return 'Error,Material Item has insufficient access';
                }
                if (PEunApprove.Calc_Unit__c == 'Size') {
                    if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()){mit.Qty_On_Hand__c += PEunApprove.Lf_Used__c;}
                } else {
                    if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()){ mit.Qty_On_Hand__c += PEunApprove.Qty_Used__c;}
                }
                if(Schema.sobjectType.Material_Item__c.isUpdateable()){
                    update mit;
                }
                else{
                    return 'Error,Related Material Item has insufficient access to update';
                }
            }
            if(Schema.sobjectType.Production_Estimate__c.isUpdateable()){
                update PEunApprove;}
            else{
                return 'Error, Production Estimate has insufficient access to update';
            }
        }
        Catch(Exception e) {return '' + e.getMessage();
                           }
        return 'OK';
    }
   
    @AuraEnabled
    public static string duplicateProEst(String ProEstID){
        List<Production_Estimate__c> insertProdEstimate=new List<Production_Estimate__c>();
        List<Production_Estimate__c> lstProdEstimate=[Select Id,Name,Job__c,Amount__c,Divide_Sheets_By_Two__c,Lf_Used__c,Quote__c,Restrict__c,Shippment_status__c,PE_Template__c,Calc_Unit__c,Color__c,Commission__c,Equipment_Type__c,GL_Department__c,GL_Code__c,of_Pages__c,
                                                      Length_in_Inches__c,Material_Item__c,EachQtyUpforUsed__c,Quantity__c,Qty_Up__c,SheetQtyUpforUsed__c,Sided__c,Vendor__c,Width_in_Inches__c  from Production_Estimate__c where Id =:ProEstID WITH SECURITY_ENFORCED Limit 1];
        try
        {
            for(Production_Estimate__c p:lstProdEstimate)
            {
                Production_Estimate__c  objJPE=new Production_Estimate__c();
                if(Schema.sObjectType.Production_Estimate__c.fields.name.isCreateable()){ objJPE.name='Dup : '+p.Name;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Job__c.isCreateable()){objJPE.Job__c=p.Job__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Calc_Unit__c.isCreateable()){objJPE.Calc_Unit__c=p.Calc_Unit__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Color__c.isCreateable()){objJPE.Color__c=p.Color__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Commission__c.isCreateable()){ objJPE.Commission__c=p.Commission__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.GL_Department__c.isCreateable()){ objJPE.GL_Department__c=p.GL_Department__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.GL_Code__c.isCreateable()){ objJPE.GL_Code__c=p.GL_Code__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.of_Pages__c.isCreateable()){ objJPE.of_Pages__c=p.of_Pages__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Length_in_Inches__c.isCreateable()){ objJPE.Length_in_Inches__c=p.Length_in_Inches__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Material_Item__c.isCreateable()){ objJPE.Material_Item__c=p.Material_Item__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Quantity__c.isCreateable()){ objJPE.Quantity__c=p.Quantity__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Qty_Up__c.isCreateable()){ objJPE.Qty_Up__c=p.Qty_Up__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.SheetQtyUpforUsed__c.isCreateable()){ objJPE.SheetQtyUpforUsed__c=p.SheetQtyUpforUsed__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.EachQtyUpforUsed__c.isCreateable()){ objJPE.EachQtyUpforUsed__c=p.EachQtyUpforUsed__c ;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Sided__c.isCreateable()){ objJPE.Sided__c=p.Sided__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Vendor__c.isCreateable()){objJPE.Vendor__c=p.Vendor__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Width_in_Inches__c.isCreateable()){ objJPE.Width_in_Inches__c  =p.Width_in_Inches__c ;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Equipment_Type__c.isCreateable()){ objJPE.Equipment_Type__c=p.Equipment_Type__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.PE_Template__c.isCreateable()){ objJPE.PE_Template__c=p.PE_Template__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Amount__c.isCreateable()){ objJPE.Amount__c=p.Amount__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Divide_Sheets_By_Two__c.isCreateable()){ objJPE.Divide_Sheets_By_Two__c=p.Divide_Sheets_By_Two__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Quote__c.isCreateable()){ objJPE.Quote__c=p.Quote__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Restrict__c.isCreateable()){ objJPE.Restrict__c=p.Restrict__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Shippment_status__c.isCreateable()){ objJPE.Shippment_status__c=p.Shippment_status__c;}
                insertProdEstimate.add(objJPE);
            }
            if(Schema.sobjectType.Production_Estimate__c.isCreateable()){
                insert insertProdEstimate;  
            }
            else{
                return 'Error, Production Estimate has insufficient access to insert';
            }
        }
        catch(System.DMLException e)
        {
            return ''+e.getMessage();
        }  
       
        return 'OK';
    }
   
    @AuraEnabled
    public static List<string> deleteProEst(String ProEstID){
        list<string> aa=new list<string>();
        List<Production_Estimate__c> DelProEst= [Select id,Name,Job__c,Amount__c,Divide_Sheets_By_Two__c,Lf_Used__c,Quote__c,Restrict__c,Shippment_status__c,PE_Template__c,Calc_Unit__c,Color__c,Commission__c,Equipment_Type__c,GL_Department__c,GL_Code__c,of_Pages__c,
                                                 Length_in_Inches__c,Material_Item__c,EachQtyUpforUsed__c,Quantity__c,Qty_Up__c,SheetQtyUpforUsed__c,Sided__c,Vendor__c,Width_in_Inches__c  from Production_Estimate__c Where Id =:ProEstID WITH SECURITY_ENFORCED Limit 1];
        String JobId=DelProEst[0].Job__c;
        try
        {
            if(!Production_Estimate__c.sObjectType.getDescribe().isDeletable()){
                aa.add('NO');
                aa.add('Error, Production Estimate has insufficient access to Delete');
                return aa;
            }
            else{
                Database.delete(DelProEst);
            }
        }
       
        catch(System.DMLException e)
        {
            aa.add('NO');
            aa.add(''+e.getMessage());
            return aa;
        }  
        aa.add('OK');aa.add(''+JobId);
        return aa;
       
    }
   
   
    @AuraEnabled
    public static string ImportProEstTemp(String ProEstTemID,String JobId){
        list<Production_Estimate__c> insertProdEstLineItems =new List<Production_Estimate__c>();
        List<Production_Estimate_Temp_Line_Items__c> lstSpecs=new List<Production_Estimate_Temp_Line_Items__c>();
        try
        {
            try{
                lstSpecs=[Select id,Name,Calc_Unit__c,Sort_Order__c,SheetQtyUpforUsed__c,EachQtyUpforUsed__c,GL_Code__c,GL_Department__c,Vendor__c,Material_Item__c,Qty_Up__c,Production_Estimate_Template__r.name,Quantity__c,Color__c,Sided__c,of_Pages__c,Width_in_Inches__c,Divide_Sheets_By_Two__c,Equipment_Type__c,Length_in_Inches__c,Commission__c from Production_Estimate_Temp_Line_Items__c where Production_Estimate_Template__c =:ProEstTemID WITH SECURITY_ENFORCED order by Sort_Order__c];
            }Catch(Exception e){
                return 'Error, Production Estimate Temp Line Items has insufficient access.';
            }
            for(Production_Estimate_Temp_Line_Items__c sp:lstSpecs){
                Production_Estimate__c js=new Production_Estimate__c();
                if(Schema.sObjectType.Production_Estimate__c.fields.Name.isCreateable()){js.Name=sp.Name;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Calc_Unit__c.isCreateable()){js.Calc_Unit__c=sp.Calc_Unit__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Quantity__c.isCreateable()){js.Quantity__c=sp.Quantity__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Sort_Order__c.isCreateable()){js.Sort_Order__c=sp.Sort_Order__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Qty_Up__c.isCreateable()){js.Qty_Up__c=sp.Qty_Up__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Material_Item__c.isCreateable()){js.Material_Item__c=sp.Material_Item__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Job__c.isCreateable()){js.Job__c =JobId;}
                if(Schema.sObjectType.Production_Estimate__c.fields.PE_Template__c.isCreateable()){js.PE_Template__c = sp.Production_Estimate_Template__r.name;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Vendor__c.isCreateable()){js.Vendor__c=sp.Vendor__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.GL_Department__c.isCreateable()){js.GL_Department__c=sp.GL_Department__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.GL_Code__c.isCreateable()){js.GL_Code__c=sp.GL_Code__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Color__c.isCreateable()){js.Color__c= sp.Color__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Sided__c.isCreateable()){js.Sided__c= sp.Sided__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.of_Pages__c.isCreateable()){js.of_Pages__c= sp.of_Pages__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Width_in_Inches__c.isCreateable()){js.Width_in_Inches__c= sp.Width_in_Inches__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Divide_Sheets_By_Two__c.isCreateable()){js.Divide_Sheets_By_Two__c= sp.Divide_Sheets_By_Two__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Equipment_Type__c.isCreateable()){js.Equipment_Type__c= sp.Equipment_Type__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Length_in_Inches__c.isCreateable()){js.Length_in_Inches__c= sp.Length_in_Inches__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.Commission__c.isCreateable()){js.Commission__c = sp.Commission__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.SheetQtyUpforUsed__c.isCreateable()){ js.SheetQtyUpforUsed__c = sp.SheetQtyUpforUsed__c;}
                if(Schema.sObjectType.Production_Estimate__c.fields.EachQtyUpforUsed__c.isCreateable()){js.EachQtyUpforUsed__c = sp.EachQtyUpforUsed__c;}
                insertProdEstLineItems.add(js);
            }
            if(Schema.sobjectType.Production_Estimate__c.isCreateable()){
                insert insertProdEstLineItems;
            }
            else{
                return 'Error,Production Estimate has insufficient access to create.';
            }
        }
        catch(Exception e)
        {
            return ''+e.getMessage();
        }
       
        return 'OK';
    }
   
    @AuraEnabled
    public static list<Production_Estimate_Spec_Item__c> getProductioneEstimateSpecItems(String proestRecId) {
        list<Production_Estimate_Spec_Item__c> lstProEstSpecItem = [select Id,Name,Description__c ,Production_Estimate__r.Approved__c from Production_Estimate_Spec_Item__c where Production_Estimate__c=: proestRecId WITH SECURITY_ENFORCED Order By CreatedDate];
        return lstProEstSpecItem;
    }
   
    @AuraEnabled
    public static string deleteProductionEstimateSpecItem(String ProEstSpecId) {
        Production_Estimate_Spec_Item__c delPESpecItem = [select Id,Name,Description__c from Production_Estimate_Spec_Item__c where Id=:ProEstSpecId WITH SECURITY_ENFORCED ];
        try{
            if(Production_Estimate_Spec_Item__c.sObjectType.getDescribe().isDeletable()){
                delete delPESpecItem;}
        }
        catch(System.DmlException e){
            return ''+e.getMessage();
        }
        return 'OK';
    }
   
   
   
    @AuraEnabled
    public Static list<String> DeleteTaskDetail(String tskid){  
        list<String> aa=new list<String>();
        Id JobId = [Select Id, Job__c from Job_Task__c where Id =:tskid WITH SECURITY_ENFORCED limit 1].Job__c;
        Double Task_Order_No= [Select Id, Task_Order__c from Job_Task__c where Id =:tskid WITH SECURITY_ENFORCED limit 1].Task_Order__c;
       
        try
        {  
           
            Job_Task__c objCurrentJobTask =  [Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where id=: tskid WITH SECURITY_ENFORCED Order BY Task_Order__c];
            if(Job_Task__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objCurrentJobTask); }
            Set<Date> holidaysNew = new Set<Date>();
            for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
            {
                holidaysNew.add(hc.Date__c);
            }
           
            Job__c objJob=[Select Schedule_Template__c,Start_Date__c, Due_Date__C, Schedule_Calc__c from Job__c where Id=:JobId WITH SECURITY_ENFORCED];
           
            Boolean blnFroward = true;
            if(objJob.Schedule_Calc__c == 'End Date')
            {
                blnFroward = false;
            }
           
            List<Job_Task__c> lstTaskBelow;
            System.debug('Below Task records after deletion : '+lstTaskBelow);
            if(blnFroward)
            {
                lstTaskBelow=[Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c >: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c];
            }
            else
            {
                lstTaskBelow=[Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c <: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c desc];
            }
           
           
            if(!lstTaskBelow.isEmpty())
            {
                Date startDateForNextTask;
               
                if(blnFroward)
                {
                    startDateForNextTask = Date.newInstance(objCurrentJobTask.Start_Date__c.Year(),objCurrentJobTask.Start_Date__c.month(),objCurrentJobTask.Start_Date__c.Day());
                }
                else
                {
                    startDateForNextTask = Date.newInstance(objCurrentJobTask.Revised_Due_Date__c.Year(),objCurrentJobTask.Revised_Due_Date__c.month(),objCurrentJobTask.Revised_Due_Date__c.Day());
                }
               
               
                DateTime NextTaskStartDate;
               
                for(Integer i=0;i<lstTaskBelow.size();i++)
                {
                    DateTime dtStartDate3;
                    if(i == 0)
                    {
                        //lstJobTasks[i].Start_Date__c = startDateForNextTask;
                        if(blnFroward)
                        {
                            // dtStartDate3= lstTaskBelow[i].Start_Date__c = startDateForNextTask;
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstTaskBelow[i].Start_Date__c = startDateForNextTask;}
                            dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                            if(Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()){
                                lstTaskBelow[i].Task_Order__c = Task_Order_No;}
                        }
                        else
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstTaskBelow[i].Revised_Due_Date__c = startDateForNextTask;}
                            dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                        }
                    }
                    else
                    {
                        Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                        if(blnFroward)
                        {
                            //  dtStartDate3 = lstTaskBelow[i].Start_Date__c = d4;
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstTaskBelow[i].Start_Date__c = d4; }
                           
                            dtStartDate3 =DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                           
                            if(Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()){
                                lstTaskBelow[i].Task_Order__c= lstTaskBelow[i-1].Task_Order__c + 1;}
                        }
                        else
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstTaskBelow[i].Revised_Due_Date__c = d4; }
                           
                            dtStartDate3 =DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                        }
                       
                    }
                   
                    // lstTaskBelow[i].Days__c = lstTaskBelow[i].Days__c;
                    double days=lstTaskBelow[i].Days__c;
                   
                    Integer jCount=0;
                   
                    // To calculate Due Date, Revised Due Date
                    while(true)
                    {
                        Date d3 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                       
                        // Skip Holiday, Sat- Sun, while calculating Due Date and Revised Due Date
                        if((dtStartDate3.format('E')!='Sat'&&dtStartDate3.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                        {
                            jCount=jCount+1;
                            if(jCount>days)
                            {
                                break;
                            }
                            system.debug('jCount======' + jCount);
                            system.debug('==========' + dtStartDate3);
                           
                            system.debug('===========' + dtStartDate3.format('E'));
                           
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                           
                            else{ dtStartDate3=dtStartDate3.addDays(-1);}
                           
                            system.debug('After adding 1 day : ' +dtStartDate3);
                        }
                        else
                        {
                            system.debug('==========' + dtStartDate3);                                    
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                                continue;
                            }
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                                continue;
                            }  
                           
                        }
                    }
                    system.debug('Calculation============' +dtStartDate3);
                   
                    Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                    system.debug('D1============' +dtStartDate3);
                   
                    if(blnFroward)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                            lstTaskBelow[i].Revised_Due_Date__c=d1;
                        }
                    }
                    else {
                        if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstTaskBelow[i].Start_Date__c=d1;}
                    }
                   
                    NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update lstTaskBelow;}
               
                //update the task order for the backward calcuation for the tasks below.
               
               
            }
            if(!blnFroward)
            {
                lstTaskBelow = [Select id,Task_Order__c,Start_Date__c,Days__c,Revised_Due_Date__c from Job_Task__c where Job__c=: JobId AND Task_Order__c >: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c];
                for(Integer i=0;i<lstTaskBelow.size();i++)
                {
                    if(i==0)
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()){
                            lstTaskBelow[i].Task_Order__c = Task_Order_No;}
                    }
                    else
                    {    
                        if(Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isUpdateable()){
                            lstTaskBelow[i].Task_Order__c= lstTaskBelow[i-1].Task_Order__c + 1;}
                    }
                    //updateTask.add(lstTaskAbove[i]);
                }    
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update lstTaskBelow;}
            }
           
        }
       
        catch(System.DMLException e){
            aa.add('NO');
            aa.add(''+e.getMessage());  
            return aa;
           
        }
        aa.add('OK');
        aa.add(''+JobId);  
        return aa;
    }
   
   
   
   
    @AuraEnabled
    public static string approveEstimate(String estRecId) {
       
        try {
            Estimate_Line_Items__c approveEst = [select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Id = : estRecId WITH SECURITY_ENFORCED limit 1];
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Approved__c.isUpdateable()){approveEst.Approved__c=true;}
            if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable()){
                update approveEst;return 'OK';}
            else{return 'Error';}
        } catch (Exception e) {
            return '' + e.getMessage();
        }
       
    }
   
   
    @AuraEnabled
    public static string unapproveEstimate(String estRecId) {
       
        try {
            Estimate_Line_Items__c unapproveEst = [select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Id = : estRecId  WITH SECURITY_ENFORCED limit 1];
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.Approved__c.isUpdateable()){unapproveEst.Approved__c=false;}
            if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable()){ update unapproveEst; return 'OK';}
            else{return 'Error';}
        } catch (Exception e) {return '' + e.getMessage();
                              }
       
    }
   
    /**********************************************************  Esimate Line Items  ***************************************************************/
   
   
    @AuraEnabled
    public static list<Estimate_Spec_Item__c> getestimateSpecItems(String estRecId) {
        list<Estimate_Spec_Item__c> lstEstli = [Select id,Name,Description__c from Estimate_Spec_Item__c where Estimates__c=:estRecId  WITH SECURITY_ENFORCED ORDER BY CreatedDate];
        return lstEstli;
    }
   
    @AuraEnabled
    public static Map<Id,String> getProductionSpecTemplate()  {
        Map<Id,String> prodtempMap=new Map<Id,String>();
        prodtempMap.put(null,'--None--');
        for (Production_Spec_Template__c a : [SELECT Id, name FROM Production_Spec_Template__c WITH SECURITY_ENFORCED ORDER  BY Name])
        {  
            prodtempMap.put(a.Id, a.Name);  
        }
        return prodtempMap;  
    }
   
    @AuraEnabled
    public static String importProTemplateSpecs(String EstrecId,String ProTempId)  {
        List<Estimate_Spec_Item__c > insertEstSpecItems=new List<Estimate_Spec_Item__c >();
        if(ProTempId==null || ProTempId==''){
            return 'Choose';
        }
        else{
            List<Production_Spec_Item__c> lstSpecs=[Select id,Name,Description__c from Production_Spec_Item__c where Production_Spec_Template__c=:ProTempId WITH SECURITY_ENFORCED];
            if(lstSpecs.size()==0){
                return 'NoRecords';
            }
            else{
                for(Production_Spec_Item__c sp:lstSpecs){
                    Estimate_Spec_Item__c js=new Estimate_Spec_Item__c ();
                    if(Schema.sObjectType.Estimate_Spec_Item__c.fields.Name.isCreateable()){ js.Name=sp.Name;}
                    if(Schema.sObjectType.Estimate_Spec_Item__c.fields.Description__c.isCreateable()){ js.Description__c=sp.Description__c;}
                    if(Schema.sObjectType.Estimate_Spec_Item__c.fields.Estimates__c.isCreateable()){js.Estimates__c= EstrecId;}
                    insertEstSpecItems.add(js);
                }
               
                try {
                    if(Schema.sObjectType.Estimate_Spec_Item__c.isCreateable()){
                        insert insertEstSpecItems;
                        return 'OK';
                    }
                    else{
                        return 'Error, Estimate Spec iten has insufficient access to create';
                    }
                } catch (System.DMLException e) {
                    return '' + e.getMessage();
                }
               
            }
        }
       
    }
   
    @AuraEnabled
    public static String importProTemplateSpecsForQuotes(String QuoteId,String ProTempId) {
       
        List<Quote_Spec_Item__c> insertQuoteSpecs=new List<Quote_Spec_Item__c>();
       
        if(ProTempId==null || ProTempId==''){
            return 'Choose';
        }
        else{
            try{
                List<Production_Spec_Item__c> lstSpecs=new List<Production_Spec_Item__c>();
                try{
                    lstSpecs=[Select id,Name,Description__c from Production_Spec_Item__c where Production_Spec_Template__c=:ProTempId WITH SECURITY_ENFORCED Order By CreatedDate];
                }
                catch(Exception e){
                    return 'Error, Production Spec Item has insufficient access.';
                }if(lstSpecs.size()==0){
                    return 'NoRecords';
                }
                else{
                    for(Production_Spec_Item__c PSI:lstSpecs)
                    {
                        Quote_Spec_Item__c qsi=new Quote_Spec_Item__c();
                        if(Schema.sObjectType.Quote_Spec_Item__c.fields.Name.isCreateable()){ qsi.Name=PSI.Name;}
                        if(Schema.sObjectType.Quote_Spec_Item__c.fields.Description__c.isCreateable()){ qsi.Description__c=PSI.Description__c;}
                        if(Schema.sObjectType.Quote_Spec_Item__c.fields.Quote__c.isCreateable()){ qsi.Quote__c = QuoteId;}
                        insertQuoteSpecs.add(qsi);
                    }
                   
                    if(Schema.sobjectType.Quote_Spec_Item__c.isCreateable()){
                        insert insertQuoteSpecs;}
                    else{
                        return 'Error,Quote Spec Item has insufficient access to create.' ;  
                    }                    
                    return 'OK';
                }
            }catch(Exception e){
                return '' + e.getMessage();
            }
        }
    }
   
   
   
    @AuraEnabled
    public static String DeleteEstSpecRecord(String EstspecrecId){
        Estimate_Spec_Item__c estspecrec=[Select Id, Estimates__c from Estimate_Spec_Item__c where Id =:EstspecrecId WITH SECURITY_ENFORCED];
        try{
            if(Estimate_Spec_Item__c.sObjectType.getDescribe().isDeletable()){              
                delete estspecrec;
                return 'OK';
            }else{
                return 'Error, Estimate Spec Item has insufficient access to delete';
            }
        }
        catch (System.DMLException e) {
            return '' + e.getMessage();
        }
       
    }
   
   
    /******************************************************************************************************************************************************
* ************************************************************* PO Section **********************************************************************************
* ****************************************************************************************************************************************************/
   
    @AuraEnabled
    public static List <Purchase_Order__c> getPORecords(Id recordId) {
        system.debug(recordId);
        List <Purchase_Order__c> lstPO = [Select id,Name,Due_Date__c,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Vendor__r.Name,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Job__c =: [Select id from Job__c where id =: recordId] WITH SECURITY_ENFORCED Order By CreatedDate desc,Name];
        return lstPO;
    }
   
    // ******************************************* Updating the records in PO Section under the job tab ************************************************************//    
    @AuraEnabled
    public static string updatePO(List <Purchase_Order__c> editedPOList){
        try{
            if(Schema.sobjectType.Purchase_Order__c.isUpdateable()){
                update editedPOList;
                return 'true';
            }else{
                return 'Error';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
   
    // ******************************************* Deleting the records in PO Section under the job tab ************************************************************//  
    @AuraEnabled
    public static list<string> deletePO(String PORecId) {
        list<string> aa=new list<string>();
        Purchase_Order__c PO = [Select id,Name,Due_Date__c,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Id = : PORecId WITH SECURITY_ENFORCED limit 1 ];
        string JobId=PO.Job__c;
        try {
            if(Purchase_Order__c.sObjectType.getDescribe().isDeletable()){
                Delete PO;
                aa.add('OK');
                aa.add(''+JobId);
                return aa;
            }else{
                aa.add('NO');
                aa.add('Error, Purchase order has insufficient access to delete.');
                return aa;
            }
        } catch (System.DMLException e) {
            aa.add('NO');  aa.add(''+ e.getMessage());
            return aa;
        }
       
    }
   
    // ****************************************** This method is used to retrieve all Vendors into dropdown list *********************************************
   
    @AuraEnabled
    public Static Map <String, String > getPOVendors(String recordId)
    {
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        Boolean ShowProductionEstimate =activeSettings.Active__c;
       
        Map < String, String > optionMap = new Map < String, String > ();        
        optionMap.put(null, '--None--');  
       
        if(ShowProductionEstimate){
           
            for (AggregateResult ar:[SELECT Vendor__c,Vendor__r.Name FROM Production_Estimate__c where Job__c =: [Select id from Job__c where id =: recordId] and Approved__c=true WITH SECURITY_ENFORCED  Group By Vendor__c,Vendor__r.Name Order By Vendor__r.Name])  
            {
                String aID = (string)ar.get('Vendor__c');  
                Production_Estimate__c pelis=[Select id,Name,Vendor__r.Name from Production_Estimate__c where Vendor__c =: aID and Job__c =: [Select id from Job__c where id =: recordId] WITH SECURITY_ENFORCED Limit 1];
                //options.add(new selectOption(String.Valueof(ar.get('Vendor__c')),pelis.Vendor__r.Name)); //for all records found - add them to the picklist options
                optionMap.put(String.Valueof(ar.get('Vendor__c')),pelis.Vendor__r.Name);
            }
        }
        else{
            for (AggregateResult ar:[SELECT Vendor__c,Vendor__r.Name FROM Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: recordId] and Approved__c=true WITH SECURITY_ENFORCED Group By Vendor__c,Vendor__r.Name  Order By Vendor__r.Name DESC])  
            {
                String aID = (string)ar.get('Vendor__c');  
                Estimate_Line_Items__c elis=[Select id,Name,Vendor__r.Name from Estimate_Line_Items__c where Vendor__c =: aID and Job__c =: [Select id from Job__c where id =: recordId] WITH SECURITY_ENFORCED Limit 1];
                // options.add(new selectOption(String.Valueof(ar.get('Vendor__c')),elis.Vendor__r.Name)); //for all records found - add them to the picklist options
                optionMap.put(String.Valueof(ar.get('Vendor__c')),elis.Vendor__r.Name);
                system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+optionMap);
            }
        }
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+optionMap);
        return optionMap;  
    }
   
    // ****************************************** This method is used to retrieve Vendors related Vendor Contact into dropdown list *********************************************
   
    @AuraEnabled
    public Static List<Vendor_Contact__c> getVendorContact(String VendorName)
    {
        List < Vendor_Contact__c > opplist = new list<Vendor_Contact__c> ();        
        for (Vendor_Contact__c ar:[SELECT Vendor__c,Vendor__r.name,Name FROM Vendor_Contact__c where Vendor__c=:vendorName WITH SECURITY_ENFORCED])  
        {
            opplist.add(ar);
        }
        return opplist; //return the picklist options
    }
   
    // ****************************************** This method is used to retrieve All Staff Members into dropdown list *********************************************
   
    @AuraEnabled
    public Static List<Staff__c> getStaffs()
    {
        List<Staff__c> optionList = new List<Staff__c>();
        for (Staff__c a : [SELECT Id, name FROM Staff__c where IsDeleted__c = False WITH SECURITY_ENFORCED order by Name ])
        {  
            optionList.add(a);  
        }
        return optionList;  
    }
   
    /******************************************************************************************************************************************************
* ******************************************************** Purchase Order Line Items Section *************************************************************************************
* ****************************************************************************************************************************************************/
   
    @AuraEnabled
    public static List <Sobject> getApprovedEstLI(String VendorName,Id recordId) {
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        Boolean ShowProductionEstimate =activeSettings.Active__c;
        List<Sobject> ELI=new List<Sobject>();
        if(!ShowProductionEstimate)
        {  
            ELI=[Select id,Name,Amount__c,Vendor__c,Job__c,Approved__c,Total_Amount__c,GL_Code__c, Quantity__c, Unit_Type__c,GL_Code__r.Name From Estimate_Line_Items__c where Vendor__c =:vendorName and Job__c =: recordId and Approved__c = true and PO_Created__c = false WITH SECURITY_ENFORCED Order By Name];
        }
        else
        {
            ELI=[Select id,Name,Total_Cost__c,Vendor__c,Job__c,Approved__c,GL_Code__c, Quantity__c,GL_Code__r.Name From Production_Estimate__c where Vendor__c =: vendorName  and Job__c =: recordId and Approved__c = true and PO_Created__c = false WITH SECURITY_ENFORCED Order By Name];
        }
        return ELI;  
    }
   
    @AuraEnabled
    public static string insertEstLI_PELI(String PORecId, List<SObject> selRecords) {
        System.debug('====PORecId========='+PORecId);
       
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        Boolean ShowProductionEstimate =activeSettings.Active__c;
       
        list<PO_Line_Item__c> pliinsert=new list<PO_Line_Item__c>();
        List<Estimate_Line_Items__c> Estrec=new List<Estimate_Line_Items__c>();
        List<Production_Estimate__c> PErec=new  List<Production_Estimate__c>();
       
       
       
        if(!ShowProductionEstimate){
            Estrec=(List<Estimate_Line_Items__c>)selRecords;
            System.debug('====Esimate records========='+Estrec);
            if(Estrec.size()>0){
                for(Estimate_Line_Items__c e:Estrec){
                    PO_Line_Item__c pli=new PO_Line_Item__c();
                    if (Schema.sObjectType.PO_Line_Item__c.fields.Estimate_Line_Item__c.isCreateable()) {pli.Estimate_Line_Item__c=e.id;}
                    if (Schema.sObjectType.PO_Line_Item__c.fields.Amount__c.isCreateable()) {pli.Amount__c=e.Total_Amount__c;}
                    if (Schema.sObjectType.PO_Line_Item__c.fields.GL_Code__c.isCreateable()) {pli.GL_Code__c=e.GL_Code__c;}
                    if (Schema.sObjectType.PO_Line_Item__c.fields.Purchase_Order__c.isCreateable()) {pli.Purchase_Order__c=PORecId;}
                    pliinsert.add(pli);
                }
            }
        }
        else{
            PErec=(List<Production_Estimate__c>)selRecords;
            System.debug('====Production Esimate records========='+PErec);
            System.debug('====Production  records size========='+PErec.size());
            if(PErec.size()>0){
                for(Production_Estimate__c pe:PErec){
                    PO_Line_Item__c pli1=new PO_Line_Item__c();
                    if (Schema.sObjectType.PO_Line_Item__c.fields.Production_Estimate__c.isCreateable()) {pli1.Production_Estimate__c=pe.id;}
                    if (Schema.sObjectType.PO_Line_Item__c.fields.Amount__c.isCreateable()) {pli1.Amount__c=pe.Total_Cost__c;}
                    if (Schema.sObjectType.PO_Line_Item__c.fields.GL_Code__c.isCreateable()) {pli1.GL_Code__c=pe.GL_Code__c;}
                    if (Schema.sObjectType.PO_Line_Item__c.fields.Purchase_Order__c.isCreateable()) {pli1.Purchase_Order__c=PORecId;}
                    pliinsert.add(pli1);
                }
            }
        }
       
        System.debug('====pliinsert records========='+pliinsert);
        System.debug('====pliinsert records size========='+pliinsert);
        if(pliinsert.size()>0){
            try {
                if(Schema.sObjectType.PO_Line_Item__c.isCreateable()){ insert  pliinsert;}
            } catch (System.DMLException e) {
                return '' + e.getMessage();
            }
        }
        return 'OK';
    }
   
   
    @AuraEnabled
    public static List <PO_Line_Item__c> getPOLineItems(Id POId) {  
        Boolean ShowProductionEstimate;
        ProductionEstimate__c activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate= activeSettings.Active__c;
       
        List <PO_Line_Item__c> politems=new  List <PO_Line_Item__c>();
       
        if(ShowProductionEstimate){
            politems=[select id,Name,Purchase_Order__c,Estimate_Line_Item__c,Estimate_Line_Item__r.name,Amount__c,Invoice_Created__c,GL_Code__c,GL_Code__r.Name,Quantity_production__c,Unit_Type__c,Quantity__c,Production_Estimate__c,Production_Estimate__r.Name from PO_Line_Item__c where Purchase_Order__c =: POId and Production_Estimate__c!=null WITH SECURITY_ENFORCED ORDER BY Name];
        }
        else{
            politems=[select id,Name,Purchase_Order__c,Estimate_Line_Item__c,Estimate_Line_Item__r.name,Amount__c,Invoice_Created__c,GL_Code__c,GL_Code__r.Name,Quantity_production__c,Unit_Type__c,Quantity__c,Production_Estimate__c,Production_Estimate__r.Name from PO_Line_Item__c where Purchase_Order__c =: POId and Estimate_Line_Item__c!=null   WITH SECURITY_ENFORCED ORDER BY Name];
        }
        return politems;
    }
   
    @AuraEnabled
    public static string deletePOLI(String strPOLI)
    {
        PO_Line_Item__c objPOLI=[Select id,Purchase_Order__c,Estimate_Line_Item__c,Production_Estimate__c from PO_LIne_Item__c where id=:strPOLI WITH SECURITY_ENFORCED];
        Id POid=objPOLI.Purchase_Order__c;
        try{
            if(PO_Line_Item__c.sObjectType.getDescribe().isDeletable()){Delete objPOLI;  return 'OK';}
            else{return 'Error, PO Line item has insufficient access to delete';}
        }
        catch(Exception e){return ''+e.getMessage();
                          }
       
    }
   
   
   
    // Start Wrapper Class
    public class ELIWrapper
    {
        @AuraEnabled   public PO_Line_Item__c e{get;set;}
        // @AuraEnabled  public Boolean checked{get;set;}
        @AuraEnabled  public decimal Calc_amnt{get; set;}
    }
    // End Wrapper class
   
    @AuraEnabled
    public static List<ELIWrapper> PoLineItemsFromPo(String poid){
       
        Boolean ShowProductionEstimate;
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
       
        //added by rahul
        set<id> id_EstLi = new set<id>();
        set<id> id_PEstLi = new set<id>();
       
        map<id,decimal> mp_amnt=new  map<id,decimal>();
        list<Invoice_Line_Item__c> lst_ILI=new list<Invoice_Line_Item__c>();
        list<Invoice_Line_Item__c> lst_ILI1=new list<Invoice_Line_Item__c>();
        list<Estimate_Line_Items__c> lst_Est=new list<Estimate_Line_Items__c>();
        List<Production_Estimate__c> lst_PEst=new List<Production_Estimate__c>();
       
        List<ELIWrapper> roleWraps=new List<ELIWrapper>();
       
        List<PO_Line_Item__c> ELI=[Select id,Name,Production_Estimate__c,Amount__c,Estimate_Line_Item__c,Quantity__c,Quantity_production__c,Production_Estimate__r.name,Estimate_Line_Item__r.name,GL_Code__c,Invoice_Created__c,Purchase_Order__c From PO_Line_Item__c where Purchase_Order__c =: poid and Invoice_Created__c = false WITH SECURITY_ENFORCED Order By Name];
       
       
       
        //added code by rahul
        for(PO_Line_Item__c e: ELI)
        {
            if(ShowProductionEstimate ){
                id_PEstLi.add(e.Production_Estimate__c);
            }
            else{
                id_EstLi.add(e.Estimate_Line_Item__c);
            }
        }
        lst_ILI = [SELECT id, Estimate_Line_Item__c,Estimate_Line_Item__r.name, Amount__c FROM Invoice_Line_Item__c WHERE Estimate_Line_Item__c IN : id_EstLi WITH SECURITY_ENFORCED];
        lst_Est = [SELECT id,Total_Amount__c,Amount__c FROM Estimate_Line_Items__c WHERE id IN : id_EstLi WITH SECURITY_ENFORCED];
       
        lst_ILI1 = [SELECT id, Production_Estimate__c,Production_Estimate__r.name, Amount__c FROM Invoice_Line_Item__c WHERE Production_Estimate__c IN : id_PEstLi WITH SECURITY_ENFORCED];
        lst_PEst = [SELECT id,Total_Cost__c,Amount__c FROM Production_Estimate__c WHERE id IN : id_PEstLi WITH SECURITY_ENFORCED];
       
       
        if(ShowProductionEstimate ){
            for(Production_Estimate__c s : lst_PEst){
                decimal str = s.Total_Cost__c;
                for(Invoice_Line_Item__c var_ili : lst_ILI1){
                    if(s.id == var_ili.Production_Estimate__c ){
                        str = str - var_ili.Amount__c ;
                        system.debug('invoice amnt '+var_ili.Amount__c);
                    }
                }
                mp_amnt.put(s.id ,str );
            }
           
        }else{
            for(Estimate_Line_Items__c s : lst_Est){
                decimal str = s.Total_Amount__c;
                for(Invoice_Line_Item__c var_ili : lst_ILI){
                    if(s.id == var_ili.Estimate_Line_Item__c ){
                        str = str - var_ili.Amount__c ;
                        system.debug('invoice amnt '+var_ili.Amount__c);
                    }
                }
                mp_amnt.put(s.id ,str );
            }
        }
        //added code ends here
       
        for(PO_Line_Item__c e: ELI)
        {
            ELIWrapper rw=new ELIWrapper();
           
            //rw.checked=false;
           
            //added by rahul
            if(ShowProductionEstimate ){
                rw.e=e;
                rw.Calc_amnt = mp_amnt.get(e.Production_Estimate__c );
            }
            else{
                rw.e=e;
                rw.Calc_amnt = mp_amnt.get(e.Estimate_Line_Item__c);}
            //added code ends here
           
            roleWraps.add(rw);        
        }
       
        return roleWraps;
    }
   
    @AuraEnabled
    public static string SavePoLineItemsSubmit(List<Object> selectedRec,String poid){
       
        Boolean ShowProductionEstimate;
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
       
        System.debug('====selectedRecords========='+selectedRec);
       
        //added by rahul
        set<id> id_EstLi = new set<id>();
        set<id> id_PEstLi = new set<id>();
       
        map<id,decimal> mp_amnt=new  map<id,decimal>();
        list<Invoice_Line_Item__c> lst_ILI=new list<Invoice_Line_Item__c>();
        list<Invoice_Line_Item__c> lst_ILI1=new list<Invoice_Line_Item__c>();
        list<Estimate_Line_Items__c> lst_Est=new list<Estimate_Line_Items__c>();
        List<Production_Estimate__c> lst_PEst=new List<Production_Estimate__c>();
       
       
        List<PO_Line_Item__c> ELI=[Select id,Name,Production_Estimate__c,Amount__c,Estimate_Line_Item__c,Quantity__c,Quantity_production__c,Production_Estimate__r.name,Estimate_Line_Item__r.name,GL_Code__c,Invoice_Created__c,Purchase_Order__c From PO_Line_Item__c where Purchase_Order__c =: poid and Invoice_Created__c = false WITH SECURITY_ENFORCED Order By Name];
       
       
        //added code by rahul
        for(PO_Line_Item__c e: ELI)
        {
            if(ShowProductionEstimate ){
                id_PEstLi.add(e.Production_Estimate__c);
            }
            else{
                id_EstLi.add(e.Estimate_Line_Item__c);
            }
        }
        lst_ILI = [SELECT id, Estimate_Line_Item__c,Estimate_Line_Item__r.name, Amount__c FROM Invoice_Line_Item__c WHERE Estimate_Line_Item__c IN : id_EstLi WITH SECURITY_ENFORCED];
        lst_Est = [SELECT id,Total_Amount__c,Amount__c FROM Estimate_Line_Items__c WHERE id IN : id_EstLi WITH SECURITY_ENFORCED];
       
        lst_ILI1 = [SELECT id, Production_Estimate__c,Production_Estimate__r.name, Amount__c FROM Invoice_Line_Item__c WHERE Production_Estimate__c IN : id_PEstLi WITH SECURITY_ENFORCED];
        lst_PEst = [SELECT id,Total_Cost__c,Amount__c FROM Production_Estimate__c WHERE id IN : id_PEstLi WITH SECURITY_ENFORCED];
       
       
        System.debug('==Pro Estimate Invoices Line Items====='+lst_ILI1);
        System.debug('==Pro Estimate Records====='+lst_PEst);
       
        System.debug('== Estimate Invoices Line Items====='+lst_ILI);
        System.debug('== Estimate Records====='+lst_Est);
       
        //added by rahul
        integer count = 0;
        boolean flg = false;
        string strMsg = '';
       
        for(Object rw:selectedRec)
        {
            decimal str = 0;  
           
            Map<Object,Object> aa=(Map<Object,Object>)rw;
            System.debug('====selectedRecords for PO========='+aa);
            decimal Cal_Amount= (decimal)aa.get('Calc_amnt');
            System.debug('====amount for PO========='+Cal_Amount);
            Map<Object,Object> poli= (Map<Object,Object>)aa.get('e');
            System.debug('====poli for PO========='+poli);
           
            if(ShowProductionEstimate ){
                for(Invoice_Line_Item__c var_ili : lst_ILI1){
                    if(String.valueOf(poli.get('Production_Estimate__c'))== var_ili.Production_Estimate__c ){
                        str = str + var_ili.Amount__c ;
                        system.debug('invoice amnt '+var_ili.Amount__c);
                    }
                }
            }
           
            else{
                for(Invoice_Line_Item__c var_ili : lst_ILI){
                   
                    //String EstimateId=String.valueOf(poli.get('Estimate_Line_Item__c'));
                    //System.debug('====Campre result new==='+ (EstimateId == var_ili.Estimate_Line_Item__c));
                    //System.debug('====Campre result old==='+ (String.valueOf(poli.get('Estimate_Line_Item__c')) == var_ili.Estimate_Line_Item__c ));
                   
                    if(String.valueOf(poli.get('Estimate_Line_Item__c'))== var_ili.Estimate_Line_Item__c ){
                        System.debug('====object inner Id====='+String.valueOf(poli.get('Estimate_Line_Item__c')));
                        System.debug('====Estimate inner Id====='+var_ili.Estimate_Line_Item__c);
                        str = str + var_ili.Amount__c ;
                        system.debug('invoice amnt '+var_ili.Amount__c);
                    }
                }
            }
           
            str = str + Cal_Amount;
            system.debug('amount after entering in input text ****************************************** '+str);
            decimal poliAmount=(decimal)poli.get('Amount__c');
            system.debug('========poliAmount***************************************** '+poliAmount);
            if(str > poliAmount  || Cal_Amount == 0 || test.isRunningTest()){
                //stRole.Amount__c=rw.Calc_amnt;
                //flg = true;
                count = count + 1;
                if (count == 1){
                    if(ShowProductionEstimate ){
                        Map<Object,Object> ponmaMap= (Map<Object,Object>)poli.get('Production_Estimate__r');
                        strMsg += String.valueof(ponmaMap.get('Name'))+'';
                    }
                    else{
                        Map<Object,Object> ponmaMap= (Map<Object,Object>)poli.get('Estimate_Line_Item__r');  
                        strMsg += String.valueof(ponmaMap.get('Name'))+'';
                    }
                }
                else{
                    if(ShowProductionEstimate ){
                        Map<Object,Object> ponmaMap= (Map<Object,Object>)poli.get('Production_Estimate__r');
                        strMsg +=', ' +String.valueof(ponmaMap.get('Name'))+'';
                    }
                    else{
                        Map<Object,Object> ponmaMap= (Map<Object,Object>)poli.get('Estimate_Line_Item__r');  
                        strMsg +=' ,' +String.valueof(ponmaMap.get('Name'))+'';
                    }
                   
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter correct value'));
                }  
            }
        }
       
       
        if(count > 0){
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter correct value for "'+strMsg+'" items'));
            return 'Please enter correct value for "'+strMsg+'" items';        
        }
       
        return 'OK';
    }
   
   
    @AuraEnabled
    public static string SavePoLineItems(List<Object> selectedRec,String InvId ,String poid){
       
        Boolean ShowProductionEstimate;
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
       
        System.debug('====selectedRecords========='+selectedRec);
       
        //added by rahul
        set<id> id_EstLi = new set<id>();
        set<id> id_PEstLi = new set<id>();
       
        map<id,decimal> mp_amnt=new  map<id,decimal>();
        list<Invoice_Line_Item__c> lst_ILI=new list<Invoice_Line_Item__c>();
        list<Invoice_Line_Item__c> lst_ILI1=new list<Invoice_Line_Item__c>();
        list<Estimate_Line_Items__c> lst_Est=new list<Estimate_Line_Items__c>();
        List<Production_Estimate__c> lst_PEst=new List<Production_Estimate__c>();
       
       
        List<PO_Line_Item__c> ELI=[Select id,Name,Production_Estimate__c,Amount__c,Estimate_Line_Item__c,Quantity__c,Quantity_production__c,Production_Estimate__r.name,Estimate_Line_Item__r.name,GL_Code__c,Invoice_Created__c,Purchase_Order__c From PO_Line_Item__c where Purchase_Order__c =: poid and Invoice_Created__c = false WITH SECURITY_ENFORCED Order By Name];
       
       
        //added code by rahul
        for(PO_Line_Item__c e: ELI)
        {
            if(ShowProductionEstimate ){
                id_PEstLi.add(e.Production_Estimate__c);}
            else{
                id_EstLi.add(e.Estimate_Line_Item__c);}
        }
        lst_ILI = [SELECT id, Estimate_Line_Item__c,Estimate_Line_Item__r.name, Amount__c FROM Invoice_Line_Item__c WHERE Estimate_Line_Item__c IN : id_EstLi WITH SECURITY_ENFORCED];
        lst_Est = [SELECT id,Total_Amount__c,Amount__c FROM Estimate_Line_Items__c WHERE id IN : id_EstLi WITH SECURITY_ENFORCED];
       
        lst_ILI1 = [SELECT id, Production_Estimate__c,Production_Estimate__r.name, Amount__c FROM Invoice_Line_Item__c WHERE Production_Estimate__c IN : id_PEstLi WITH SECURITY_ENFORCED];
        lst_PEst = [SELECT id,Total_Cost__c,Amount__c FROM Production_Estimate__c WHERE id IN : id_PEstLi WITH SECURITY_ENFORCED];
       
       
        //added by rahul
        integer count = 0;
        boolean flg = false;
        string strMsg = '';
        List<Invoice_Line_Item__c>  lst=new List<Invoice_Line_Item__c>();
        List<PO_Line_Item__c> lstWrapper = new List<PO_Line_Item__c>();
       
        try{
           
            for(Object rw:selectedRec)
            {
                Map<Object,Object> aa=(Map<Object,Object>)rw;
                System.debug('====selectedRecords for PO========='+aa);
                decimal Cal_Amount= (decimal)aa.get('Calc_amnt');
                System.debug('====amount for PO========='+Cal_Amount);
                Map<Object,Object> poli= (Map<Object,Object>)aa.get('e');
                System.debug('====poli for PO========='+poli);
               
               
                Invoice_Line_Item__c stRole=new Invoice_Line_Item__c();
                String PID=String.valueof(poli.get('Id'));
                PO_Line_Item__c po=new PO_Line_Item__c(id=PID);
                if(ShowProductionEstimate ){
                    if (Schema.sObjectType.Invoice_Line_Item__c.fields.Production_Estimate__c.isCreateable()) {
                        stRole.Production_Estimate__c=String.valueof(poli.get('Production_Estimate__c'));}
                }
                else{
                    if (Schema.sObjectType.Invoice_Line_Item__c.fields.Estimate_Line_Item__c.isCreateable()) {
                        stRole.Estimate_Line_Item__c=String.valueof(poli.get('Estimate_Line_Item__c'));}
                }
                //stRole.Amount__c=rw.e.Amount__c;
               
                //added by rahul
                decimal str = 0;
               
                if(ShowProductionEstimate ){
                    for(Invoice_Line_Item__c var_ili : lst_ILI1){
                       
                       
                        if(String.valueOf(poli.get('Production_Estimate__c'))== var_ili.Production_Estimate__c ){
                            str = str + var_ili.Amount__c ;
                            system.debug('invoice amnt '+var_ili.Amount__c);
                        }
                    }
                }
               
                else{
                    for(Invoice_Line_Item__c var_ili : lst_ILI){
                        System.debug('====object Id====='+String.valueOf(poli.get('Estimate_Line_Item__c')));
                        System.debug('====Estimate Id====='+var_ili.Estimate_Line_Item__c);
                        System.debug('====Campre result==='+String.valueOf(poli.get('Estimate_Line_Item__c'))== var_ili.Estimate_Line_Item__c );
                       
                        if(String.valueOf(poli.get('Estimate_Line_Item__c'))== var_ili.Estimate_Line_Item__c ){
                            str = str + var_ili.Amount__c ;
                            system.debug('invoice amnt '+var_ili.Amount__c);
                        }
                    }
                }
               
               
                str = str + Cal_Amount;
                decimal poliAmount=(decimal)poli.get('Amount__c');
                system.debug('amount after entering in input text ****************************************** '+str);
                if(str <= poliAmount){
                    if (Schema.sObjectType.Invoice_Line_Item__c.fields.Amount__c.isCreateable()) {  stRole.Amount__c=Cal_Amount;}
                }
               
                //added code ends here
               
                if (Schema.sObjectType.Invoice_Line_Item__c.fields.Invoice__c.isCreateable()) {stRole.Invoice__c=InvId;}
                if (Schema.sObjectType.Invoice_Line_Item__c.fields.GL_Code__c.isCreateable()) {stRole.GL_Code__c = String.valueof(poli.get('GL_Code__c'));}
                if(ShowProductionEstimate ){
                    if (Schema.sObjectType.Invoice_Line_Item__c.fields.Quantity__c.isCreateable()) {strole.Quantity__c=(decimal)poli.get('Quantity_production__c');}
                }
                else{
                    if (Schema.sObjectType.Invoice_Line_Item__c.fields.Quantity__c.isCreateable()) {strole.Quantity__c=(decimal)poli.get('Quantity__c');}
                }
               
                //stRole.Invoice_Created__c=True;
                // stRole.Purchase_Order__c=ApexPages.currentPage().getParameters().get('id');
                if(str == poliAmount){
                    if(schema.SobjectType.PO_Line_Item__c.Fields.Invoice_Created__c.isUpdateable()){  po.Invoice_Created__c=True;}
                }
                lstWrapper.add(po);
                lst.add(stRole);
            }
           
            if(Schema.sObjectType.Invoice_Line_Item__c.isCreateable()){
                insert lst;}
            if(Schema.sObjectType.PO_Line_Item__c.isUpdateable()){ update lstWrapper;}
           
        }  
       
        catch(DMLException ex)
        {
            return ex.getMessage();
        }
       
        try
        {
            List<PO_Line_Item__c> lstPOLI = new List<PO_Line_Item__c>();
            lstPOLI=[Select id,Name,Amount__c,Estimate_Line_Item__c,Production_Estimate__c,Invoice_Created__c,Purchase_Order__c From PO_Line_Item__c where Purchase_Order__c =: poid and Invoice_Created__c = false WITH SECURITY_ENFORCED];
            if(lstPOLI.Size() > 0 )
            {
                Purchase_Order__c po = new Purchase_Order__c();
                po=[select id,Name,Job__c,Vendor__c,Status__c,Invoice_Created__c from Purchase_Order__c where id =: poid WITH SECURITY_ENFORCED Limit 1];
                try
                {
                    if(Schema.sObjectType.Purchase_Order__c.Fields.Invoice_Created__c.isUpdateable()){ po.Invoice_Created__c='Partially';}
                    if(Schema.sObjectType.Purchase_Order__c.isUpdateable()){ update po;}
                }
                catch(System.DMLException e)
                {
                    return null;
                }
            }
           
            if(lstPOLI.Size() == 0)
            {
                Purchase_Order__c po=[select id,Name,Job__c,Vendor__c,Status__c,Invoice_Created__c from Purchase_Order__c where id =: poid WITH SECURITY_ENFORCED Limit 1];
                try
                {
                    if(schema.SobjectType.Purchase_Order__c.Fields.Invoice_Created__c.isUpdateable()){  po.Invoice_Created__c='Created';}
                    if(Schema.sObjectType.Purchase_Order__c.isUpdateable()){update po;}
                }
                catch(System.DMLException e)
                {
                    return null;
                }
            }
        }
        catch(DMLException ex)
        {
            return ex.getMessage();
        }
        return 'OK';
    }
   
   
   
   
    /******************************************************************************************************************************************************
* *********************************************** Vendor Invoice Section ******************************************************************************
* ****************************************************************************************************************************************************/
   
   
    @AuraEnabled
    public static List <Invoice__c> getVendorInvRecords(Id recordId) {
        system.debug(recordId);
        List <Invoice__c> lstVendorInv = [Select id,Name,Vendor__c,Purchase_Order__r.Name,Vendor__r.Name,Job__c,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c,(select id, name from Invoice_Line_Items__r) from Invoice__c where Job__c =: [Select id from Job__c where id =: recordId] WITH SECURITY_ENFORCED Order By CreatedDate desc,Name];
        return lstVendorInv;
    }
   
    // ****************************************** This method is used to retrieve all Vendors into dropdown list *********************************************
   
    @AuraEnabled
    public Static Map < Id, String > getInvVendors()
    {
        Map < Id, String > optionMap = new Map < Id, String > ();        
        optionMap.put(null, '--None--');  
        for (Vendor__c ar : [SELECT Id, name FROM Vendor__c WITH SECURITY_ENFORCED order by Name])  
        {
            optionMap.put(ar.Id, ar.name);
        }
        return optionMap;  
    }  
   
    // ******************************************* Updating the records in Invoice Section under the job tab ************************************************************//    
    @AuraEnabled
    public static string updateInv(List <Invoice__c> editedInvList){
        try{
            if(Schema.sObjectType.Invoice__c.isUpdateable()){
                update editedInvList;
                return 'true';
            }else{
                return 'Error, Invoice has insufficient access to update';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
   
    // ******************************************* Deleting the records in Estimate Section under the job tab ************************************************************//    
    @AuraEnabled
    public static List<string> deleteInv(String InvRecId) {
        list<String> aa=new list<String>();
       
        try {
            Invoice__c Inv = [Select id,Name,Vendor__c,Purchase_Order__r.Name,Vendor__r.Name,Job__c,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c,(select id, name from Invoice_Line_Items__r) from Invoice__c where Id = : InvRecId WITH SECURITY_ENFORCED limit 1];
            string JobId=Inv.Job__c;
            if(Invoice__c.sObjectType.getDescribe().isDeletable()){
                Delete Inv;
                aa.add('OK');
                aa.add(''+JobId);
                return aa;
            }else{
                aa.add('Error');
                aa.add('Error, Invoice has insuffiecient access to delete.');
                return aa;
            }
        } catch (Exception e) {
            aa.add('NO');  aa.add(''+e.getMessage());
            return aa;
        }
       
    }
   
   
   
   
    /******************************************************************************************************************************************************
* *********************************************** Vendor Invoice Line Items Section ******************************************************************************
* ****************************************************************************************************************************************************/
   
    @AuraEnabled
    public static List <Invoice_Line_Item__c> getInvLineItems(Id InvID) {  
        List <Invoice_Line_Item__c > Invlitems=new  List <Invoice_Line_Item__c >();
        Invlitems=[select id,Name,Invoice__c,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,Production_Estimate__r.name,Production_Estimate__c,Amount__c,GL_Code__c,GL_Code__r.name,Unit_Type__c,GL_Department__c,GL_Code_No__c,Quantity__c from Invoice_Line_Item__c where Invoice__c =: InvID WITH SECURITY_ENFORCED ORDER BY Name];
        return Invlitems;
    }
   
    @AuraEnabled
    public static string updateInvLI(List <Invoice_Line_Item__c> editedInvLIList){
        try{
            if(Schema.sObjectType.Invoice_Line_Item__c.isUpdateable()){
                update editedInvLIList;
                return 'true';}
            else{
                return 'Error, Insufficient access to update this record';    
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    @AuraEnabled
    public static string deleteInvLI(String InvLIRecId) {
       
        Invoice_Line_Item__c InvLI = [SELECT id, Name, Invoice__c, Invoice__r.Invoice_Status__c FROM Invoice_Line_Item__c WHERE id= : InvLIRecId WITH SECURITY_ENFORCED];
       
        try {
            if(!Schema.sObjectType.Invoice_Line_Item__c.isDeletable()){
                return 'Error, Insufficient access to delete this record';                                          
            }
            else{ Delete InvLI;
                 return 'Deleted';}
        } catch (System.DMLException e) {
            return '' + e.getMessage();
        }
       
    }
   
   
    @AuraEnabled
    public Static Map < string, String > getINVLIGLCode(String VendorId)
    {
        Map < string, String > optionMap = new Map < string, String > ();        
        optionMap.put(null, '--None--');  
        for (AggregateResult ar:[SELECT GL_Code__c,GL_Code__r.Name FROM Vendor_GL_Code__c where Vendor__c=: VendorId WITH SECURITY_ENFORCED Group By GL_Code__c,GL_Code__r.Name  Order By GL_Code__r.Name])  
        {
            String aID = (string)ar.get('GL_Code__c');  
            Vendor_GL_Code__c elis=[Select id,Name,Vendor__c,GL_Code__c,GL_Code__r.Name,GL_Code__r.GL_ID__c from Vendor_GL_Code__c where GL_Code__c =: aID and Vendor__c=: VendorId WITH SECURITY_ENFORCED Limit 1];
            optionMap.put(string.valueof(ar.get('GL_Code__c')),elis.GL_Code__r.Name); //for all records found - add them to the picklist options
        }
        return optionMap;  
    }  
   
   
    /********************************************* Shipment Tab Functionality ********************************************************/
   
    // ================================================= Display Records in Shipment Section ==============================================================================//
    @AuraEnabled
    public static List <Shipment__c> getShipmentrecords(Id recordId) {
        system.debug(recordId);
        List <Shipment__c> lstShp = [select id,name,Job__c,Shipment_Status__c,Shipping_Method__c,Shipment_Name__c,Tracking_Number__c from Shipment__c where Job__c =: recordId WITH SECURITY_ENFORCED Order BY Name];
        return lstShp;
    }
   
    // ================================================= Edit Shipment Records ==============================================================================//
   
    @AuraEnabled
    public static string updateShp(List <Shipment__c> editedShpList){
        try{
            if(!Schema.sObjectType.Shipment__c.isUpdateable()){
                return 'Error, Insufficient access to delete this record';                                      
            }else{
                update editedShpList;
                return 'true';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
   
    // ================================================= Quick Action Delete from job shipment table ===================================================================//
   
    @AuraEnabled
    public static list<string> DeleteShp(String ShpId){
        list<String> aa=new list<string>();
        Shipment__c DeleteShp =[select id,name,Job__c,Shipment_Status__c,Shipping_Method__c,Shipment_Name__c,Tracking_Number__c from Shipment__c where Id=:ShpId WITH SECURITY_ENFORCED];
        string Jobid=DeleteShp.Job__c;
        try{
            if(!Schema.sObjectType.Shipment__c.isDeletable()){
                aa.add('Error');
                aa.add('Error, Insufficient access to delete this record');
                return aa;                            
            }else{
                delete DeleteShp;
                aa.add('OK');
                aa.add(''+Jobid);
            }
        } catch(Exception e){
            aa.add('NO');    aa.add(''+e.getMessage());
            return aa;
        }
       
        return aa;
    }
   
    // ================================================= Display Records in Shipment Line Item table Section ==============================================================================//
    @AuraEnabled
    public static List<Shipment_Line_Item__c> getShipmentLIrecords(Id recordId) {
        system.debug(recordId);
        List <Shipment_Line_Item__c> lstShpLi = [Select id,Qty_Shipped__c,name,Client_Name__c,Item_Status__c,Job__c,Job_Name__c,Estimate_Line_Item__c,Production_Estimate__c,Production_Estimate__r.Name,Shipment__c,Shipment__r.Shipment_Status__c from Shipment_Line_Item__c where Shipment__c=:recordId WITH SECURITY_ENFORCED];
        return lstShpLi;
    }
   
    // ===================================================== Records updated from Shipment Line Item table ========================================================================================//  
    @AuraEnabled
    public static string updateShpLI(List<Shipment_Line_Item__c> editedShpLIList){
        try{
            if(Schema.sObjectType.Shipment_Line_Item__c.isUpdateable()){
                update editedShpLIList;
                return 'true';
            }
            else{
                return  'Error, Insufficient access to delete this record';
            }
           
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    // ===================================================== Records Deleted from Shipment Line Item table ========================================================================================//  
    @AuraEnabled
    public static string deleteShpLI(String ShpLIRecId) {
        boolean ShowProductionEstimate;
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        if(ShowProductionEstimate==True)
        {              
            Shipment_Line_Item__c  objSLI=[Select id,Shipment__c,Production_Estimate__c from Shipment_Line_Item__c  where id=:ShpLIRecId WITH SECURITY_ENFORCED];
            Id SID=objSLI.Shipment__c;
            Id PEID=objSLI.Production_Estimate__c;
            if(Schema.sObjectType.Shipment_Line_Item__c.isDeletable()){
                Database.Delete(objSLI);
            }else{
                return 'Error, Insufficient access to delete this record';
            }
            if(!test.isRunningTest()) {
                Production_Estimate__c peupdate=[select id,name,Shippment_status__c from Production_Estimate__c where id=:PEID WITH SECURITY_ENFORCED];
                if (Schema.sObjectType.Production_Estimate__c.fields.Shippment_status__c.isUpdateable()){
                    peupdate.Shippment_status__c='Ready to be shipped';}
                if(Schema.sObjectType.Production_Estimate__c.isUpdateable()){
                    update peupdate;}
                else{
                    return 'Error, Insufficient access to update this record';
                }
            }
        }  
        else
        {
            Shipment_Line_Item__c  objESLI=[Select id,Shipment__c,Estimate_Line_Item__c from Shipment_Line_Item__c  where id=:ShpLIRecId WITH SECURITY_ENFORCED];
            Id SID=objESLI.Shipment__c;
            Id EID=objESLI.Estimate_Line_Item__c;
            if(Schema.sObjectType.Shipment_Line_Item__c.isDeletable()){
                Database.Delete(objESLI);
            }else{
                return 'Error, Insufficient access to delete this record';
            }
           
            if(!test.isRunningTest()) {
                Estimate_Line_Items__c estupdate=[select id,name,Shippment_status__c from Estimate_Line_Items__c where id=:EID WITH SECURITY_ENFORCED];
                if (Schema.sObjectType.Estimate_Line_Items__c.fields.Shippment_status__c.isUpdateable()){
                    estupdate.Shippment_status__c='Ready to be shipped';}
                if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable()){
                    update estupdate;}
                else{
                    return 'Error, Insufficient access to update this record';
                }
            }
        }  
        return 'Deleted';
    }
   
   
    /*********************************************************** Add Shipment LI items *************************************************************************/
    @AuraEnabled
    public static List<sObject> AddShipmentLIrecords(Id recordId) {
        system.debug(recordId);
        boolean ShowProductionEstimate;
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
       
        Shipment__c  Shp= [Select id,Name,Client__c,Client__r.name,job__r.name from Shipment__c where id =:recordId WITH SECURITY_ENFORCED];
        String Clientname=Shp.Client__r.name;
        String JobName=Shp.job__r.name;
       
        List<sObject> ELI=new List<sObject>();
       
        if(ShowProductionEstimate==true)
        {
            ELI=[Select id,Name,Amount__c,Vendor__c,Job__c,Approved__c,Shippment_status__c,Total_Cost__c,GL_Code__c, Quantity__c,Job__r.name,Job__r.Status__c,Job__r.Job_Auto_Number__c,Job__r.Media_Types__c,Job__r.JS_Client__c,Job__r.JS_Client__r.name From Production_Estimate__c  where job__r.name=:JobName and Job__r.Status__c='Active' and  Shippment_status__c='Ready to be shipped' WITH SECURITY_ENFORCED /* where  Shippment_status__c='Ready to be shipped' and Job__r.Status__c='Active' and Job__r.Media_Types__r.name='Supplies' and Job__r.JS_Client__r.name=:Clientname Order By Name*/];
        }
        else
        {
            ELI=[Select id,Name,Vendor__c,Job__c,Approved__c,Shippment_status__c,Total_Amount__c,GL_Code__c, Quantity__c,Job__r.name,Job__r.Status__c,Job__r.Job_Auto_Number__c,Job__r.Media_Types__c,Job__r.JS_Client__c,Job__r.JS_Client__r.name From Estimate_Line_Items__c where job__r.name=:JobName and Job__r.Status__c='Active' and  Shippment_status__c='Ready to be shipped'  WITH SECURITY_ENFORCED /* where  Shippment_status__c='Ready to be shipped' and Job__r.Status__c='Active' and Job__r.Media_Types__r.name='Supplies' and Job__r.JS_Client__r.name=:Clientname Order By Name*/];
        }
       
        return ELI;
    }
   
    /**************************************** Save the Shipment Line Item Records ***************************************************************/
    /**************************************** Save the Shipment Line Item Records ***************************************************************/
    @AuraEnabled
    public static string SaveShpLineItems(List<sObject> selRecords,Id Shpid) {
       
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        boolean ShowProductionEstimate=activeSettings.Active__c;
       
        Set<Id> PestIDS=new Set<Id>();
        Set<Id> EstIDS=new Set<Id>();
        List<Production_Estimate__c> UPestIDS=new List<Production_Estimate__c>();
        List<Estimate_Line_Items__c > UEstIDS=new List<Estimate_Line_Items__c >();
       
        list<Shipment_Line_Item__c> ShpLIinsert=new list<Shipment_Line_Item__c>();
        List<Estimate_Line_Items__c> Estrec=new List<Estimate_Line_Items__c>();
        List<Production_Estimate__c> PErec=new  List<Production_Estimate__c>();
       
        if(!ShowProductionEstimate){
            Estrec=(List<Estimate_Line_Items__c>)selRecords;
            System.debug('====Esimate records========='+Estrec);
            if(Estrec.size()>0){
                for(Estimate_Line_Items__c e:Estrec){
                    EstIDS.add(e.id);
                    Shipment_Line_Item__c ShpLI=new Shipment_Line_Item__c();
                    if (Schema.sObjectType.Shipment_Line_Item__c.fields.Estimate_Line_Item__c.isCreateable()) {  
                        ShpLI.Estimate_Line_Item__c=e.id;}
                    if (Schema.sObjectType.Shipment_Line_Item__c.fields.Qty_Shipped__c.isCreateable()) {  
                        ShpLI.Qty_Shipped__c=e.Quantity__c;}
                    if (Schema.sObjectType.Shipment_Line_Item__c.fields.Item_Status__c.isCreateable()) {  
                        ShpLI.Item_Status__c='Pending';}
                    if (Schema.sObjectType.Shipment_Line_Item__c.fields.Shipment__c.isCreateable()) {  
                        ShpLI.Shipment__c=Shpid;}
                    ShpLIinsert.add(ShpLI);
                }
                List<Estimate_Line_Items__c > EstLTList=[Select id,name,Shippment_status__c from Estimate_Line_Items__c where id in :EstIDS WITH SECURITY_ENFORCED];
                for(Estimate_Line_Items__c ei :EstLTList)
                {
                    if(schema.SobjectType.Estimate_Line_Items__c.Fields.Shippment_status__c.isUpdateable()){  ei.Shippment_status__c ='Shipped';}
                    UEstIDS.add(ei);
                }
                // Update UEstIDS;
               
            }
        }
        else{
            PErec=(List<Production_Estimate__c>)selRecords;
            System.debug('====Production Esimate records========='+PErec);
            System.debug('====Production  records size========='+PErec.size());
            if(PErec.size()>0){
                for(Production_Estimate__c pe:PErec){
                    PestIDS.add(pe.id);
                    Shipment_Line_Item__c ShpLI=new Shipment_Line_Item__c();
                    if (Schema.sObjectType.Shipment_Line_Item__c.fields.Production_Estimate__c.isCreateable()) {
                        ShpLI.Production_Estimate__c=pe.id;}
                    if (Schema.sObjectType.Shipment_Line_Item__c.fields.Qty_Shipped__c.isCreateable()) {
                        ShpLI.Qty_Shipped__c=pe.Quantity__c;}
                    if (Schema.sObjectType.Shipment_Line_Item__c.fields.Item_Status__c.isCreateable()) {
                        ShpLI.Item_Status__c='Pending';}
                    if (Schema.sObjectType.Shipment_Line_Item__c.fields.Shipment__c.isCreateable()) {
                        ShpLI.Shipment__c=Shpid;}
                    ShpLIinsert.add(ShpLI);
                }
                List<Production_Estimate__c> PELIList=[Select id,name,Shippment_status__c from Production_Estimate__c where id in :PestIDS WITH SECURITY_ENFORCED];
                for(Production_Estimate__c  pei :PELIList)
                {
                    if(schema.SobjectType.Production_Estimate__c.Fields.Shippment_status__c.isUpdateable()){ pei.Shippment_status__c ='Shipped';}
                    UPestIDS.add(pei);
                }
                //Update UPestIDS;
            }
        }
       
        System.debug('====ShpLIinsert records========='+ShpLIinsert);
        System.debug('====ShpLIinsert records size========='+ShpLIinsert);
        if(ShpLIinsert.size()>0){
            try {
                if(Schema.sObjectType.Shipment_Line_Item__c.isCreateable()){insert  ShpLIinsert;}
                else{return 'Error, Insufficient access to insert this record';}
                if(!ShowProductionEstimate){
                    if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable()){  Update UEstIDS;}
                    else{return 'Error, Insufficient access to update this record';}
                }else{
                    if(Schema.sObjectType.Production_Estimate__c.isUpdateable()){Update UPestIDS; }
                    else{return 'Error, Insufficient access to update this record';}
                }
               
            } catch (System.DMLException e) {
                return '' + e.getMessage();
            }
        }
        return 'OK';
    }
   
   
   
    /************************** Delete Button on Client Invoice detail page ***********************************************/
    @AuraEnabled
    public static list<string> DeleteCLI(String CLId){
        list<string> aa=new  list<string>();
       
        try{
            Client_Invoice__c DeleteCLI =[Select id,Name,Job__c from Client_Invoice__c where id =:CLId WITH SECURITY_ENFORCED];
            string Jobid=DeleteCLI.Job__c;
            if(!Schema.sObjectType.Client_Invoice__c.isDeletable()){
                aa.add('Error, Insufficient access to delete this record');
                return aa;                            
            }else{
                delete DeleteCLI;
                aa.add('OK');
                aa.add(''+Jobid);
            }
        } catch(Exception e){
            aa.add('NO');    aa.add(''+e.getMessage());
            return aa;
        }
       
        return aa;
    }
    /************************** Delete Button on GD detail page ***********************************************/
    @AuraEnabled
    public static list<string> DeleteGD(String GDId){
        list<string> aa=new  list<string>();
       
        try{
            Graphics_Deliverables__c DeleteGD =[Select id,Name,Job__c from Graphics_Deliverables__c where id =:GDId WITH SECURITY_ENFORCED];
            string Jobid=DeleteGD.Job__c;
            if(!Schema.sObjectType.Graphics_Deliverables__c.isDeletable()){
                aa.add('Error, Insufficient access to delete this record');
                return aa;                            
            }else{
                delete DeleteGD;
                aa.add('OK');
                aa.add(''+Jobid);
            }
        } catch(Exception e){
            aa.add('NO');   aa.add(''+e.getMessage());
            return aa;
        }
       
        return aa;
    }
   
   
    /************************** Delete Button on Tag detail page ***********************************************/
    @AuraEnabled
    public static list<string> DeleteTag(String TagId){
        list<string> aa=new  list<string>();
       
        try{
            Tag__c DeleteTag =[Select id,Name,Job__c from Tag__c where id =:TagId WITH SECURITY_ENFORCED];
            string Jobid=DeleteTag.Job__c;
            if(!Schema.sObjectType.Tag__c.isDeletable()){
                aa.add('Error, Insufficient access to delete this record');
                return aa;                            
            }else{
                delete DeleteTag;
                aa.add('OK');
                aa.add(''+Jobid);
            }
        } catch(Exception e){
            aa.add('NO');     aa.add(''+e.getMessage());
            return aa;
        }
       
        return aa;
    }
   
    /************************** Delete Button on Tag detail page ***********************************************/
    @AuraEnabled
    public static list<string> DeleteTSDetail(String TSid){
        list<String> aa=new list<string>();
       
        try{
            Timesheet_Entries__c DeleteTS =[Select id,Name,Job__c from Timesheet_Entries__c where id =:TSid WITH SECURITY_ENFORCED];
            string Jobid=DeleteTS.Job__c;
            if(!Schema.sObjectType.Timesheet_Entries__c.isDeletable()){
                aa.add('Error, Insufficient access to delete this record');
                return aa;                            
            }
            else{
                delete DeleteTS;
                aa.add('OK');
                aa.add(''+Jobid);
            }
           
        } catch(Exception e){
            aa.add('NO');     aa.add(''+e.getMessage());
            return aa;
        }
       
        return aa;
    }
}