public with sharing class TSMobileExt {
    
    //Wrapper Class For Timesheet Entries DataTable  
    public class TSDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<Timesheet_Entries__c> TSList {get;set;}
    }
    
    @AuraEnabled 
    public static TSDataTableWrapper getMobTsEntyRecs(Decimal pageNumber, Decimal pageSize)
    {
        
            String strGetUserName=UserInfo.getUserName();
            User u=[Select id,Name from User where Username=: strGetUserName ];//WITH SECURITY_ENFORCED
            String strId=u.id;
            
            Integer pSize = (Integer)pageSize;
            Integer pNumber = (Integer)pageNumber;
            
            //Offset for SOQL
            Integer offset = (pNumber - 1) * pSize;
            
            //Total Records
            Integer totalRecords = [SELECT COUNT() FROM Timesheet_Entries__c where CreatedById=:strId WITH SECURITY_ENFORCED];
            Integer recordEnd = pSize * pNumber;
            
            //Instance of TS DataTable Wrapper Class
            TSDataTableWrapper objDT =  new TSDataTableWrapper();  
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.TSList = [select id,name,Task_Name__c,Job__c,Job__r.Name,Job__r.Job_Auto_Number__c,Date__c,Hours_Worked__c,CreatedById from Timesheet_Entries__c  where CreatedById=:strId WITH SECURITY_ENFORCED order by name DESC LIMIT :pSize OFFSET :offset ];
            return objDT;
        
        
        //List<Timesheet_Entries__c> lstTsEntry= [select id,name,Task_Name__c,Job__c,Job__r.Job_Auto_Number__c,Date__c,Hours_Worked__c,CreatedById from Timesheet_Entries__c  where CreatedById=:strId  order by name DESC];
        // return lstTsEntry;
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
        List<String> userdetails=new List<String>();
        userdetails.add(UserInfo.getUserId());
        userdetails.add(UserInfo.getName());
        return userdetails;
    }
    
    /******************************************************** Get the Job Name  ****************************************************************/
    @AuraEnabled
    public Static List<Job__c> getjobName(){
        
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
    
    /******************************************************** Get the Task Name from the related Job ****************************************************************/
    @AuraEnabled
    public Static List<Job_Task__c> getTaskName(Id JobId){
        List<Job_Task__c> optionList = new  List<Job_Task__c>();        
        optionList=[Select Id, Name from Job_Task__c where Job__c =:JobId WITH SECURITY_ENFORCED order by Task_Order__c,CreatedDate];
        return optionList;  
    }
    
    /******************************************************** Get the GLCODE from the related Task ****************************************************************/
    @AuraEnabled
    public Static List<String> getGLCodeOfTask(Id JobId,string JobTaskNameStr){  
        String GLCodeVal='';string GLCodeId='';
        List<String> GlC=new List<String>();
        if(string.valueof(JobTaskNameStr) <> '' || string.valueof(JobTaskNameStr)!=null){
            
            List<Job_Task__c> objTask = [Select GL_Code__c, GL_Code__r.Name from Job_Task__c where Name=:JobTaskNameStr and Job__c=:JobId WITH SECURITY_ENFORCED limit 1];
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
                List<Production_Estimate__c> objPES= [select Quantity__c from Production_Estimate__c where Job__c=:JobNameStr and GL_Code__c=:GLCode WITH SECURITY_ENFORCED ];
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
                List<Estimate_Line_Items__c> objES = [select Quantity__c from Estimate_Line_Items__c where Job__c=:JobNameStr and GL_Code__c=:GLCode WITH SECURITY_ENFORCED];
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
                
                return 0.00;
            }
        }
        else return 0;
    }
    
}