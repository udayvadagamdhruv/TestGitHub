public with sharing class Job_TS_GD_Tags {
    
    
    @AuraEnabled
    public static List<Tool_Tip__c> getHelpTextrecords() {
        List <Tool_Tip__c> lsthelptxt = [Select Id, Job_Time__c,Graphic_Deliverable__c,Tags__c from Tool_Tip__c WITH SECURITY_ENFORCED];
        return lsthelptxt;
    }
    
    
     // ================================================= New and Edit pages FieldSet fields for Timesheet =====================================================================//
   
     @AuraEnabled
    public static String getObjectType(List<String> ObjNames) {
        Map<String,Schema.SobjectType> allObjMap=Schema.getGlobalDescribe();
        List<String> ObjApiNameList=new List<String>();
        for(String SObj:allObjMap.keyset()){
            Schema.DescribeSObjectResult objResult=allObjMap.get(SObj).getDescribe();
            //objResult.getLabel();
            //objResult.getKeyPrefix();
            if(objResult.isCustom())
            {
            	ObjApiNameList.add(objResult.getName());    
            }
            
        }
        System.debug('===SObj====='+ObjApiNameList);
        // Passing the sObject name in the method, it could be multiple objects too
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);   
    }
    
    
    /* 
    @AuraEnabled
    public static List < String > getFieldsforObjectTS(String sObjName) {

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

    }*/
   
    @AuraEnabled 
    public static List<Boolean> getisAccessable()
    {
        boolean ShowJobTimeTab,ShowGD,ShowGDOrgid,ShowGDOrgid2,ShowTags;
        String graphicsValue,tagValue;
        String orgId;
        orgId = UserInfo.getOrganizationId();
        
        // TS custom setting 
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowJobTimeTab= activeSettings.TS_Entry_Button__c;
        
        // GD Custom setting 
        List<Graphics_Setting__c> g=Graphics_Setting__c.getAll().values();
        if(!g.isEmpty())
        {
            System.debug('Custom Setting for Graphics Deliverable is Found');
            graphicsValue = g[0].Name;    
        }
        else
        {
            System.debug('Custom Setting for Graphics Deliverable is Not Found');
            graphicsValue = 'YES';
        }
        if(graphicsValue=='YES')
        {
            ShowGD=true;
        }
        else
        {
            ShowGD=false;
        }
        If(orgId=='00DE0000000Xp80MAC'|| orgId == '00DL00000027DtxMAE')
        {
            ShowGDOrgid=false;
        }
        else
        {
            ShowGDOrgid=true;
        }
        If(orgId=='00Di0000000YKOKEA4'|| orgId == '00De0000001KaOkEAK')
        {
            ShowGDOrgid2=false;
        }
        else
        {
            ShowGDOrgid2=true;
        }
        // Tags
        List<Tag_Setting__c> t=Tag_Setting__c.getAll().values();
        if(!t.isEmpty())
        {   
            System.debug('Custom Setting for Tag is Found');
            tagValue=t[0].Name;
        }   
        else
        {
            System.debug('Custom Setting for Tag is Not Found');   
            tagValue = 'YES';
        }
        if(tagValue=='YES')
        {
            ShowTags=true;
        }
        else
        {
            ShowTags=false;
        }
        
        List<boolean> isAccessList=new  List<boolean>();
        
        isAccessList.add(Schema.sObjectType.Timesheet_Entries__c.isAccessible() && ShowJobTimeTab);
        isAccessList.add(Schema.sObjectType.Graphics_Deliverables__c.isAccessible() && ShowGD && ShowGDOrgid && ShowGDOrgid2);
        isAccessList.add(Schema.sObjectType.Tag__c.isAccessible() && ShowTags);
        isAccessList.add(Schema.sObjectType.Tag_Template__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Timesheet_Entries__c.isCreateable());
        isAccessList.add(Schema.sObjectType.Timesheet_Entries__c.isUpdateable());
        system.debug('>>>>>>>>>> TS object Setting  >>>>>>>>>>>>'+Schema.sObjectType.Timesheet_Entries__c.isAccessible());
        system.debug('>>>>>>>>>> TS Custom settings >>>>>>>>>>>>'+ShowJobTimeTab);
        system.debug('>>>>>>>>>> GD object Setting  >>>>>>>>>>>>'+Schema.sObjectType.Graphics_Deliverables__c.isAccessible());
        system.debug('>>>>>>>>>> GD Custom settings >>>>>>>>>>>>'+ShowGD);
        system.debug('>>>>>>>>>> Tag object Setting  >>>>>>>>>>>>'+Schema.sObjectType.Tag__c.isAccessible());
        system.debug('>>>>>>>>>> GD Custom settings >>>>>>>>>>>>'+ShowTags);
        
        return isAccessList;
    }
    
    // *************** Display today's date in New TS page *************************/
    @AuraEnabled 
    public static date gettodaydate()
    {
        return system.today();
    }
   
    // *************** Display login user id in New TS page *************************/
    @AuraEnabled 
    public static List<String> getUserName()
    {
        List<String> usedetails=new List<String>();
        usedetails.add(UserInfo.getUserId());
        usedetails.add(UserInfo.getname());
        return usedetails;
    }
    
     //Get Total Number of TS
    @AuraEnabled
    public static Integer getTotalRecords(Id recordId){
      
        AggregateResult results = [SELECT Count(Id) TotalRecords  From Timesheet_Entries__c  where Job__c =: recordId WITH SECURITY_ENFORCED];
        Integer TotalRecords = (Integer)results.get('TotalRecords') ; 
        return TotalRecords;
    } 
    
     @AuraEnabled
    public static decimal getTotalHoursWorkedSum(Id recordId){
      
        AggregateResult results = [SELECT Sum(Hours_Worked__c) TotalHours  From Timesheet_Entries__c  where Job__c =: recordId WITH SECURITY_ENFORCED];
        system.debug('---results---'+results);
        Decimal TotalHours = (Decimal)results.get('TotalHours')!=null?(Decimal)results.get('TotalHours'):0 ; 
        return TotalHours;
    } 
    
    // ================================================= Display Records in TS Section ==============================================================================//
    @AuraEnabled 
    public static List <Timesheet_Entries__c> getTSrecords(Id recordId, Integer recordLimit, Integer recordOffset) {
        system.debug(recordId);
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        
        List<Timesheet_Entries__c> lstTS = [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__r.name from Timesheet_Entries__c where Job__c =: recordId WITH SECURITY_ENFORCED Order BY Name DESC LIMIT :intLimit Offset :intOffset];
       system.debug('lstTS==='+lstTS);
        return lstTS;
    }
    
    @AuraEnabled 
    public static List <Timesheet_Entries__c> getTSAllrecords(Id recordId, Integer recordLimit) {
        system.debug(recordId);
        List<Timesheet_Entries__c> lstTS = [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__r.name from Timesheet_Entries__c where Job__c =: recordId WITH SECURITY_ENFORCED Order BY Name DESC LIMIT :recordLimit];
        return lstTS;
    }
    
    // ================================================= Edit TS Records ==============================================================================//
    
    @AuraEnabled
    public static string updateTS(List <Timesheet_Entries__c> editTSList){
        try{
            if(Schema.sObjectType.Timesheet_Entries__c.isUpdateable()){
                update editTSList;
                return 'true';
            }
            else{
                return 'TimeSheet has Insufficient access to update';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    // ================================================= Delete CLI Records ===================================================================//
    
    @AuraEnabled
    public static list<string> DeleteTS(String TSId){
        list<string> aa=new list<string>();
        Timesheet_Entries__c DeleteTS =[Select id,Name,Job__c from Timesheet_Entries__c where id =:TSId WITH SECURITY_ENFORCED];
        string Jobid=DeleteTS.Job__c;
        try{
            if(Schema.sObjectType.Timesheet_Entries__c.isDeletable()){
                delete DeleteTS;
                aa.add('OK');
                return aa;
            }
            else{
                aa.add('TimeSheet has Insufficient access to Delete');
                return aa;
            }
            
        } catch(Exception e){
            aa.add(''+e.getMessage());
            return aa;
        }
    }
    /********* get the all job names login user assigned to the tasks, To display All Timesheet layout in all tabs **********************************/ 
    @AuraEnabled
    public Static List<Job__c> getUserjobName(){
        
       User u=[Select Id, Name from User where id=:UserInfo.getUserID() ]; //WITH SECURITY_ENFORCED
        String strId=u.id;
        string username= '%' + u.Name + '%';
        List<Job_Task__c> objJobTasklist=[Select Id, Name,Assigned_Users__c,Job__c from Job_Task__c where Assigned_Users__c like : username WITH SECURITY_ENFORCED];
        set<id> setjodid = new set<id>();
        
        for(Job_Task__c obj : objJobTasklist){
            setjodid.add(obj.Job__c);
        }
        system.debug('>>>>>>>>>>>>>>>>>>> size >>>>>>>>>>>>>>>>>>>>>>>>>>'+setjodid.size());
        system.debug('>>>>>>>>>>>>>>>>>>> setjodid >>>>>>>>>>>>>>>>>>>>>>>>>>'+setjodid);
        
        List<Job__c> optionList = new  List<Job__c>();        
        optionList=[Select Id, Name, Job_Auto_Number__c from Job__c where (Name <> '' or Name <> Null) and Status__c='Active' and  (CreatedById=:strId or Id In : setjodid) WITH SECURITY_ENFORCED order by Job_Auto_Number__c desc];
        return optionList;  
    }
    
    /******************************************************** Get the Job Name ****************************************************************/
    @AuraEnabled
    public static string getJobName(Id recordId){
        Job__c objJob=[Select id,name,JS_Client__r.name,Job_Auto_Number__c  from Job__c where id=:recordId WITH SECURITY_ENFORCED];
        String JobNameStr=objJob.Job_Auto_Number__c +' - '+objJob.name ;
        return JobNameStr;
    }
   
    @AuraEnabled
    public Static Job_Task__c getTaskInformation(String taskId){
        Job_Task__c JobTask=[Select Id,Name,Email__c,Start_Date__c,Due_Date__c,Job__r.Due_Date__c,Revised_Due_Date__c,Days__c,Job__r.Schedule_Calc__c,Job__c,Job__r.Name,GL_Code__c, GL_Code__r.Name From Job_Task__c  where Id=:taskId WITH SECURITY_ENFORCED];
        return JobTask;  
    }
    /******************************************************** Get the Task Name from the related Job ****************************************************************/
    @AuraEnabled
    public Static List<Job_Task__c> getTaskName(Id recordId){
        List<Job_Task__c> optionList = new  List<Job_Task__c>();        
        optionList=[Select Id, Name from Job_Task__c where Job__c =:recordId WITH SECURITY_ENFORCED order by Task_Order__c,CreatedDate];
        return optionList;  
    }
    
    @AuraEnabled
    public Static Job_Task__c getTaskNameonLoad(Id recordId,string JobTaskNameStr){
        Job_Task__c JT = new  Job_Task__c();        
        JT=[Select id,Job__c,Name,GL_Code__c, GL_Code__r.Name from Job_Task__c where Name=:JobTaskNameStr and Job__c=:recordId WITH SECURITY_ENFORCED limit 1];
        return JT;  
    }  
    /******************************************************** Get the GLCODE from the related Task ****************************************************************/
    @AuraEnabled
    public Static List<String> getGLCodeOfTask(Id recordId,string JobTaskNameStr){  
        String GLCodeVal='';string GLCodeId='';
        List<String> GlC=new List<String>();
        if(string.valueof(JobTaskNameStr) <> '' || string.valueof(JobTaskNameStr)!=null){
            
            List<Job_Task__c> objTask = [Select GL_Code__c, GL_Code__r.Name from Job_Task__c  where Name=:JobTaskNameStr and Job__c=:recordId WITH SECURITY_ENFORCED limit 1];
            if(objTask.size()>0){
                for(Job_Task__c objTemp:objTask){
                    if(string.valueof(objTemp.GL_Code__c)<>'' || string.valueof(objTemp.GL_Code__c)<>null){
                        GLCodeId = string.valueof(objTemp.GL_Code__c);
                        GLCodeVal = string.valueof(objTemp.GL_Code__r.Name);
                        
                    }
                    else{
                        GLCodeVal= '';
                    }
                }
                
            }
            else{
                GLCodeVal= '';            
            }   
        }
        else{
            GLCodeVal = '';
        }
        GlC.add(GLCodeId);GlC.add(GLCodeVal);
        return GlC;
    }
    /******************************************************* Get the Total Hours from the GLCODE related Estimate/PE ****************************************************/
    @AuraEnabled
    public Static  Decimal getTotalHours(string JobNameStr,string GLCode){  
        system.debug('gl code id -- '+GLCode);
        system.debug('job value -- '+JobNameStr );
        
        Decimal TaskTotalHr = 0.00; 
        String GLCodeVal=GLCode; 
        
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        Boolean ShowProductionEstimate =activeSettings.Active__c;
        
        if(ShowProductionEstimate){
            if(String.valueof(GLCodeVal)<>'' || String.valueof(GLCodeVal)<>null){            
                List<Production_Estimate__c> objPES= [select Quantity__c from Production_Estimate__c  where Job__c=:JobNameStr and GL_Code__c=:GLCode WITH SECURITY_ENFORCED];
                system.debug('Production estimate -- '+ objPES);
                if(objPES.size()>0)
                {
                    for(Production_Estimate__c  objTemp:objPES){
                        if(objTemp.Quantity__c <> null ){
                            TaskTotalHr = TaskTotalHr + objTemp.Quantity__c; 
                        }
                        else{
                            TaskTotalHr = 0.00; 
                        }
                    }
                }
                else{
                    TaskTotalHr=0.00;
                }
            }
            else{
                TaskTotalHr=0.00;
            }
            
            return TaskTotalHr;
            
        }
        else{
            
            if(String.valueof(GLCodeVal)<>'' || String.valueof(GLCodeVal)<>null){            
                List<Estimate_Line_Items__c> objES = [select Quantity__c from Estimate_Line_Items__c where Job__c=:JobNameStr and GL_Code__c=:GLCode WITH SECURITY_ENFORCED ];
                system.debug('estimate -- '+ objES);
                if(objES.size()>0)
                {
                    for(Estimate_Line_Items__c objTemp:objES){
                        if(objTemp.Quantity__c <> null ){
                            TaskTotalHr = TaskTotalHr + objTemp.Quantity__c; 
                        }
                        else{
                            TaskTotalHr = 0.00; 
                        }
                    }
                }
                else{
                    TaskTotalHr=0.00;
                }
            }
            else{
                TaskTotalHr=0.00;
            }
            return TaskTotalHr;
            
        }  
    }
    
    /******************************************************* Get the Remaining Hours ****************************************************/
    
    @AuraEnabled
    public Static Decimal getRemainHours(string JobNameStr,string GLCodeId, Decimal TaskTotalHr){ 
        Decimal dHrsRem;           
        decimal remaininghours;
        system.debug('gl code'+GLCodeId);
        dHrsRem  = 0.00;
        
        List<Timesheet_Entries__c> objTsHead  = [select id,Hours_Worked__c,GL_Code__c from Timesheet_Entries__c where Job__c =:JobNameStr and GL_Code__c=:GLCodeId WITH SECURITY_ENFORCED];
        
        system.debug('timesheet size'+objTsHead);
        
        if(objTsHead.size()>0 && TaskTotalHr!=0.00) {
            for(Timesheet_Entries__c  objTemp:objTsHead){
                
                if(objTemp.Hours_Worked__c<> null  ){
                    dHrsRem = dHrsRem +objTemp.Hours_Worked__c; 
                }
                else{
                    dHrsRem  = 0.00; 
                }
                
            }
        }
        else{
            dHrsRem = 0.00;
        }
        
        if(dHrsRem!=0.00){
            remaininghours=TaskTotalHr-dHrsRem;
            return remaininghours;
        }
        else{
            remaininghours=dHrsRem;
            return remaininghours;
        }      
    }  
    
    /******************************************************* Calculate Time from Start watch and End Watch Fields ****************************************************/
    
    @AuraEnabled
    public Static decimal calcTimeDiff(DateTime StWatch,DateTime EndWatch){
        decimal stime;
        string hours;
        string minutes;
        If(StWatch!=null && EndWatch!= null){
            if(StWatch.getTime() <= EndWatch.getTime() ){
                decimal var = ((EndWatch.getTime() - StWatch.getTime()) / (1000.0*60.0*60.0));
                stime=(var-Math.Floor(var))*60;
                hours= string.valueof(Math.Floor(var));
                minutes =string.valueof(stime.setScale(0,System.RoundingMode.HALF_EVEN));
                If(integer.valueof(minutes) == 60){
                    hours = string.valueof(integer.valueof(hours)+1);
                    minutes='00';
                    
                }
                
                return (Decimal.valueof(hours)+((Decimal.valueof(minutes))/60)).setScale(2);
            }
            else{
                
                return 0.01;
            }
        }
        else return 0;
    }
    
    /*******************************************************Graphic Deliverables section Start *******************************************************/
    
    
     /***************************** Dynamic data table for Graphic Deliverables list view in Job detail page **************************************/ 
    
    @AuraEnabled
    public static DataTableDetails getDataTableDetails(String objApi, String fieldSetName, Id JobId){
        DataTableDetails dataTableDtls = new DataTableDetails();
        List<DynamicDataTableFieldSet.FieldSetProperties> lstOfFieldSetProperties = DynamicDataTableFieldSet.getFieldFromFieldSet(objApi, fieldSetName);
        system.debug('lstOfFieldSetProperties is '+lstOfFieldSetProperties);
        if(lstOfFieldSetProperties != null && lstOfFieldSetProperties.size() > 0){
            String strQuery = 'SELECT ';
            for(DynamicDataTableFieldSet.FieldSetProperties inst : lstOfFieldSetProperties){
                 system.debug('inst=== '+inst + '' + '' +inst.fieldName+'\n' );
                dataTableDtls.lstOfFieldLabels.add(inst);
                strQuery = strQuery + inst.fieldName + ',';
                system.debug('dataTableDtls=== '+dataTableDtls+''+''+''+'strQuery ==='+strQuery+'\n');
            }
            if(!strQuery.equalsIgnoreCase('SELECT '))
                strQuery = strQuery + 'Id,Job__r.Name,CreatedBy.Name FROM ' + objApi + ' where Job__c=:JobId WITH SECURITY_ENFORCED Order BY Name desc' ;
                  system.debug('strQuery=== '+strQuery +'\n' );
            dataTableDtls.lstOfSObjs = Database.query(strQuery);
        }
        system.debug('dataTableDtls===='+dataTableDtls+'\n');
        return dataTableDtls;
    }
    
    
    public class DataTableDetails{
        @AuraEnabled
        public List<sObject> lstOfSObjs = new List<sObject>();
        @AuraEnabled
        public List<DynamicDataTableFieldSet.FieldSetProperties> lstOfFieldLabels = new List<DynamicDataTableFieldSet.FieldSetProperties>();
    }
    
    // ================================================= New and Edit pages FieldSet fields for Graphic Deliverables/ Tags =====================================================================//
    
     @AuraEnabled
    public static List < String > getFieldsforObject(String sObjName,String fieldsetname) {
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.FieldSet > fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();
        //  string fieldsetname;
        // for (string s: fieldMap.keyset())
        //   fieldsetname = s;
        List <Schema.FieldSetMember> fields = fieldMap.get(fieldsetname).getFields();
        System.debug('====Fields of Tags==='+fields);
        List <string> fieldsname = new List <string> ();
        for (Schema.FieldSetMember fieldName: fields) {
            fieldsname.add(fieldName.getFieldPath());
        }
        System.debug('====Fields of Tags==='+fieldsname);
        return fieldsname;
    }
    
    @AuraEnabled
    public static String geLabelforObject(String sObjName) {
        string objlabel = Schema.getGlobalDescribe().get(sObjName).getDescribe().getLabel();
        return objlabel;
    }
    
    /*************************************************** Graphics Deliverables *******************************************************************/
    
    @AuraEnabled 
    public static List <Graphics_Deliverables__c> getGDrecords(Id recordId) {
        system.debug(recordId);
        List < Graphics_Deliverables__c> lstGD = [Select Id, Name, Graphics_Type__c, Graphics_Description__c, Graphics_Note__c From Graphics_Deliverables__c where Job__c =: recordId WITH SECURITY_ENFORCED Order BY Name desc];
        return lstGD;
    }
    
    // ================================================= Edit GD Records ==============================================================================//
    
    @AuraEnabled
    public static string updateGD(List <Graphics_Deliverables__c> editGDList){
        try{
            if(Schema.sObjectType.Graphics_Deliverables__c.isUpdateable()){
                update editGDList;
                return 'true';
            }
            else{
                return 'Graphic Deliverables has Insufficient access to update';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    // ================================================= Delete GD Records ===================================================================//
    
    @AuraEnabled
    public static list<string> DeleteGD(String GDId){
        list<string> aa=new list<string>();
        Graphics_Deliverables__c DeleteGD =[Select id,Name,Job__c from Graphics_Deliverables__c where id =:GDId WITH SECURITY_ENFORCED];
        string Jobid=DeleteGD.Job__c;
        
        try{
            if(Schema.sObjectType.Graphics_Deliverables__c.isDeletable()){
                delete DeleteGD;
                aa.add('OK');
                return aa;
            }
            else{
                aa.add('Graphic Deliverables has Insufficient access to Delete');
                return aa;
            }
            
        } catch(Exception e){
            aa.add(''+e.getMessage());
            return aa;
        }
        
    }
    
    /************************************************ Duplicate the Graphics Deliverable Records ************************************************************/
    
    @AuraEnabled
    public static string duplicateGD(String GDId)
    {
        List<Graphics_Deliverables__c> insertGD=new List<Graphics_Deliverables__c>();
        List<Graphics_Deliverables__c> abc = [select id,Job__c,Name,Deliverable_Date__c,Graphics_Description__c,Graphics_Note__c,Graphics_Type__c,
                                              Dummy_Date_1__c,Dummy_Date_2__c,Dummy_Date_3__c,Dummy_Date_4__c,Dummy_Date_5__c,
                                              Dummy_Picklist_1__c,Dummy_Picklist_2__c,Dummy_Picklist_3__c,Dummy_Picklist_4__c,Dummy_Picklist_5__c,
                                              Dummy_Text_1__c,Dummy_Text_2__c,Dummy_Text_3__c,Dummy_Text_4__c,Dummy_Text_5__c,
                                              Dummy_Text_6__c,Dummy_Text_7__c,Dummy_Text_8__c,Dummy_Text_9__c,Dummy_Text_10__c,Dummy_Text_11__c,
                                              Dummy_Text_12__c,Dummy_Text_13__c,Dummy_Text_14__c,Dummy_Text_15__c from Graphics_Deliverables__c where id =: GDId WITH SECURITY_ENFORCED Limit 1];
        
        for(Graphics_Deliverables__c GD:abc) 
        {
            Graphics_Deliverables__c objGD=new Graphics_Deliverables__c();
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Name.isCreateable()){
                objGD.name=GD.Name;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Job__c.isCreateable()){    
                objGD.Job__c=GD.Job__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Deliverable_Date__c.isCreateable()){
                objGD.Deliverable_Date__c=GD.Deliverable_Date__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Graphics_Description__c.isCreateable()){
                objGD.Graphics_Description__c=GD.Graphics_Description__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Graphics_Note__c.isCreateable()){
                objGD.Graphics_Note__c=GD.Graphics_Note__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Graphics_Type__c.isCreateable()){
                objGD.Graphics_Type__c=GD.Graphics_Type__c;
            }
            
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_1__c.isCreateable()){
                objGD.Dummy_Date_1__c=GD.Dummy_Date_1__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_2__c.isCreateable()){
                objGD.Dummy_Date_2__c=GD.Dummy_Date_2__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_3__c.isCreateable()){
                objGD.Dummy_Date_3__c=GD.Dummy_Date_3__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_4__c.isCreateable()){
                objGD.Dummy_Date_4__c=GD.Dummy_Date_4__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Date_5__c.isCreateable()){
                objGD.Dummy_Date_5__c=GD.Dummy_Date_5__c;
            }
            
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_1__c.isCreateable()){
                objGD.Dummy_Picklist_1__c=GD.Dummy_Picklist_1__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_2__c.isCreateable()){
                objGD.Dummy_Picklist_2__c=GD.Dummy_Picklist_2__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_3__c.isCreateable()){
                objGD.Dummy_Picklist_3__c=GD.Dummy_Picklist_3__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_4__c.isCreateable()){
                objGD.Dummy_Picklist_4__c=GD.Dummy_Picklist_4__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Picklist_5__c.isCreateable()){
                objGD.Dummy_Picklist_5__c=GD.Dummy_Picklist_5__c;
            }
            
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_1__c.isCreateable()){
                objGD.Dummy_Text_1__c=GD.Dummy_Text_1__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_2__c.isCreateable()){
                objGD.Dummy_Text_2__c=GD.Dummy_Text_2__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_3__c.isCreateable()){
                objGD.Dummy_Text_3__c=GD.Dummy_Text_3__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_4__c.isCreateable()){
                objGD.Dummy_Text_4__c=GD.Dummy_Text_4__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_5__c.isCreateable()){
                objGD.Dummy_Text_5__c=GD.Dummy_Text_5__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_6__c.isCreateable()){
                objGD.Dummy_Text_6__c=GD.Dummy_Text_6__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_7__c.isCreateable()){
                objGD.Dummy_Text_7__c=GD.Dummy_Text_7__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_8__c.isCreateable()){
                objGD.Dummy_Text_8__c=GD.Dummy_Text_8__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_9__c.isCreateable()){
                objGD.Dummy_Text_9__c=GD.Dummy_Text_9__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_10__c.isCreateable()){
                objGD.Dummy_Text_10__c=GD.Dummy_Text_10__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_11__c.isCreateable()){
                objGD.Dummy_Text_11__c=GD.Dummy_Text_11__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_12__c.isCreateable()){
                objGD.Dummy_Text_12__c=GD.Dummy_Text_12__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_13__c.isCreateable()){
                objGD.Dummy_Text_13__c=GD.Dummy_Text_13__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_14__c.isCreateable()){
                objGD.Dummy_Text_14__c=GD.Dummy_Text_14__c;
            }
            if(Schema.sObjectType.Graphics_Deliverables__c.fields.Dummy_Text_15__c.isCreateable()){
                objGD.Dummy_Text_15__c=GD.Dummy_Text_15__c;
            }
            insertGD.add(objGD);
        }
        
        try{
            if(Schema.sObjectType.Graphics_Deliverables__c.isCreateable()){
                insert insertGD;
                return 'OK';
            }
            else{
                return 'Graphic Deliverables has Insufficient access to Create a duplicate Record';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
        
    }
    
    /************************************************ Tag Section Start ******************************************************************/
    
    // This method is called on to populate all Tag Template into drop down list
    @AuraEnabled
    public Static Map < Id, String > getTagTemplates() 
    {        
        Map < Id, String > optionMap = new Map < Id, String > ();        
        optionMap.put(null, '--None--');  
        for (Tag_Template__c a : [SELECT Id, name FROM Tag_Template__c WITH SECURITY_ENFORCED ORDER BY Name limit 100]) 
        {  
            optionMap.put(a.Id, a.name);
        }
        return optionMap;  
    }
    // End of method getTagTemplates
    
    // This method is called on to Import Tag Items
    @AuraEnabled
    public Static String importTags(Id Jobid,String selectedTagTemp)
    {
        
        List<Tag__c> insertJobTags=new List<Tag__c>();   
        List<Tag_Template_Item__c> lstTags=new List<Tag_Template_Item__c>();
        lstTags=[Select id,Name,Description__c,Air_Time__c, Show_Air_Date__c, Promo_End_Date__c, Promo_Due_Date__c, Air_Date__c, Lengths__c from Tag_Template_Item__c where TagTemplate__c=:selectedTagTemp WITH SECURITY_ENFORCED Order By CreatedDate ];
        
        if (selectedTagTemp == null || selectedTagTemp == '') {
            return 'Please select any Template to Import the Tags';
        }
        else if(lstTags.size()==0){
            return 'This Template doesn\'t have any Line Items to import';
        }
        else{ 
            try
            {
                for(Tag_Template_Item__c tg:lstTags)
                {              
                    Tag__c js=new Tag__c();
                    if(Schema.sObjectType.Tag__c.fields.Name.isCreateable()){
                        js.Name=tg.Name;
                    }
                    if(Schema.sObjectType.Tag__c.fields.Tag_Program_Title__c.isCreateable()){
                        js.Tag_Program_Title__c=tg.Description__c;
                    }
                    if(Schema.sObjectType.Tag__c.fields.Job__c.isCreateable()){
                        js.Job__c = jobId;
                    }
                    if(Schema.sObjectType.Tag__c.fields.Tag_Air_Time__c.isCreateable()){
                        js.Tag_Air_Time__c = tg.Air_Time__c;
                    }
                    if(Schema.sObjectType.Tag__c.fields.Tag_Start_Date__c.isCreateable()){
                        js.Tag_Start_Date__c = tg.Show_Air_Date__c;
                    }
                    if(Schema.sObjectType.Tag__c.fields.Tag_End_Date__c.isCreateable()){
                        js.Tag_End_Date__c = tg.Promo_End_Date__c;
                    }
                    if(Schema.sObjectType.Tag__c.fields.Tag_Due_Date__c.isCreateable()){
                        js.Tag_Due_Date__c = tg.Promo_Due_Date__c;
                    }
                    if(Schema.sObjectType.Tag__c.fields.Tag_Air_Date__c.isCreateable()){
                        js.Tag_Air_Date__c = tg.Air_Date__c;
                    }
                    if(Schema.sObjectType.Tag__c.fields.Tag_Lengths__c.isCreateable()){
                        js.Tag_Lengths__c = tg.Lengths__c;
                    }
                    insertJobTags.add(js);
                }
                if(Schema.sObjectType.Tag__c.isCreateable()){
                    insert insertJobTags;
                    return 'Sucessfully Imported Tag records';
                }
                else
                {
                    return 'Tags has Insufficient access to Create';
                }
            }
            catch(System.DMLException e)
            {
                return ''+e.getMessage();
            }
        }
        
    }
   
      // ================================================= Edit Tag Records ==============================================================================//
    
    @AuraEnabled
    public static string updateTag(List <Tag__c> editTagList){
        try{
            if(Schema.sObjectType.Tag__c.isUpdateable()){
                update editTagList;
                return 'true';
            }
            else{
                return 'Tags has Insufficient access to update';
            }
            
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    // ================================================= Delete GD Records ===================================================================//
    
    @AuraEnabled
    public static list<string> DeleteTag(String TagId){
        list<string> aa=new list<string>();
        Tag__c DeleteTag =[Select id,Name,Job__c from Tag__c where id =:TagId WITH SECURITY_ENFORCED];
        string Jobid=DeleteTag.Job__c;
        try{
            if(Schema.sObjectType.Tag__c.isDeletable()){
                delete DeleteTag;
                aa.add('OK');
                return aa;
            }
            else{
                aa.add('Tag has Insufficient access to Delete');
                return aa;
            }
            
        } catch(Exception e){
            aa.add('NO');
            aa.add(''+e.getMessage());
            return aa;
        }
        
    }
    
    /************************************************ Duplicate the Graphics Deliverable Records ************************************************************/
    
    @AuraEnabled
    public static string duplicateTag(String TagId)
    {
        string tagName;
        Tag__c objTag = new Tag__c();
        For(Tag__c objTemp:[Select Name,Dummy_Date_2__c,Dummy_Date_1__c,Dummy_Date_3__c,Dummy_Date_4__c,Dummy_Text_1__c,Dummy_Text_2__c,Dummy_Text_3__c,Dummy_Text_4__c,Dummy_Picklist_1__c,Dummy_Picklist_2__c,Dummy_Picklist_3__c,Dummy_Picklist_4__c, Tag_Air_Date__c, Tag_Air_Time__c, Job__c, Tag_Lengths__c, Tag_Due_Date__c, Tag_End_Date__c, Tag_Start_Date__c, Tag_Program_Title__c from Tag__c where ID=:TagId WITH SECURITY_ENFORCED limit 1]) 
        {
            tagName = 'Dup : '+DateTime.Now()+' '+objTemp.Name;
            if(tagName.length() > 80)
            {
                tagName = tagName.substring(0,80);
            }   
            if(Schema.sObjectType.Tag__c.fields.Name.isCreateable()){
                objTag.Name = tagName;
            }
            if(Schema.sObjectType.Tag__c.fields.Tag_Air_Date__c.isCreateable()){
                objTag.Tag_Air_Date__c = objTemp.Tag_Air_Date__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Tag_Air_Time__c.isCreateable()){
                objTag.Tag_Air_Time__c = objTemp.Tag_Air_Time__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Job__c.isCreateable()){
                objTag.Job__c = objTemp.Job__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Tag_Lengths__c.isCreateable()){
                objTag.Tag_Lengths__c = objTemp.Tag_Lengths__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Tag_Due_Date__c.isCreateable()){
                objTag.Tag_Due_Date__c = objTemp.Tag_Due_Date__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Tag_End_Date__c.isCreateable()){
                objTag.Tag_End_Date__c = objTemp.Tag_End_Date__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Tag_Start_Date__c.isCreateable()){
                objTag.Tag_Start_Date__c = objTemp.Tag_Start_Date__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Tag_Program_Title__c.isCreateable()){
                objTag.Tag_Program_Title__c = objTemp.Tag_Program_Title__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Date_1__c.isCreateable()){
                objTag.Dummy_Date_1__c = objTemp.Dummy_Date_1__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Date_2__c.isCreateable()){
                objTag.Dummy_Date_2__c = objTemp.Dummy_Date_2__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Date_3__c.isCreateable()){
                objTag.Dummy_Date_3__c = objTemp.Dummy_Date_3__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Date_4__c.isCreateable()){
                objTag.Dummy_Date_4__c = objTemp.Dummy_Date_4__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Text_1__c.isCreateable()){
                objTag.Dummy_Text_1__c= objTemp.Dummy_Text_1__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Text_2__c.isCreateable()){
                objTag.Dummy_Text_2__c= objTemp.Dummy_Text_2__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Text_3__c.isCreateable()){
                objTag.Dummy_Text_3__c= objTemp.Dummy_Text_3__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Text_4__c.isCreateable()){
                objTag.Dummy_Text_4__c= objTemp.Dummy_Text_4__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Picklist_1__c.isCreateable()){
                objTag.Dummy_Picklist_1__c= objTemp.Dummy_Picklist_1__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Picklist_2__c.isCreateable()){
                objTag.Dummy_Picklist_2__c= objTemp.Dummy_Picklist_2__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Picklist_3__c.isCreateable()){
                objTag.Dummy_Picklist_3__c= objTemp.Dummy_Picklist_3__c;
            }
            if(Schema.sObjectType.Tag__c.fields.Dummy_Picklist_4__c.isCreateable()){
                objTag.Dummy_Picklist_4__c= objTemp.Dummy_Picklist_4__c;
            }
        }  
        
        try{
            if(Schema.sObjectType.Tag__c.isCreateable()){
            Insert objTag;
                return 'OK';
            }
            else{
                return 'Tags has Insufficient access to Create';
            }
            
        } catch(Exception e){
            return ''+e.getMessage();
        }
        
    }
    
}