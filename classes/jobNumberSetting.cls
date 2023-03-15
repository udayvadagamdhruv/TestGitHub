global with sharing class jobNumberSetting {
/*
    public string str_Auto {get; set;}
    public string str_Code {get; set;}
    public string str_DateForm {get; set;}
    public string str_radibtn {get; set;}
    public Job_Number_Settings__c var_JNoSetng;
    map<string,Job_Number_Settings__c> map_JNoSetng;

    
    public jobNumberSetting(){
    
         map_JNoSetng = Job_Number_Settings__c.getAll();
      var_JNoSetng= map_JNoSetng.get('shashi1');
      system.debug('getting the settings:::::::::' + var_JNoSetng);
      if(var_JNoSetng == null)
      {
      this.str_radibtn = 'Auto';
      } 
      else
      {
          
      // var_JNoSetng = testSushma__JobNumberSettings__c.getValues('JobSettings');
     if(var_JNoSetng.Type__c == 'Auto')
         {
          this.str_Auto = var_JNoSetng.Auto__c;
          this.str_radibtn = 'Auto';
         }
     else if(var_JNoSetng.Type__c == 'Date')
         {
          this.str_Code = var_JNoSetng.Date__c;
          this.str_radibtn = 'Date';
         }
     else if(var_JNoSetng.Type__c == 'Code')
         {
          this.str_DateForm = var_JNoSetng.Code__c;
          this.str_radibtn = 'Code';
         }
         }
    
    }
        
        
    public PageReference savePage() {
        var_JNoSetng = new Job_Number_Settings__c();
        map_JNoSetng = Job_Number_Settings__c.getAll();
        var_JNoSetng = map_JNoSetng.get('shashi1');
        
        if(var_JNoSetng == null){
            //creating new instance of variable to insert new record.
            var_JNoSetng  = new Job_Number_Settings__c();
            if(schema.SobjectType.Job_Number_Settings__c.Fields.Name.isCreateable() && schema.SobjectType.Job_Number_Settings__c.Fields.Name.isUpdateable() ){
                var_JNoSetng.Name = 'shashi1';
            }
        }
        if(schema.SobjectType.Job_Number_Settings__c.Fields.Auto__c.isCreateable() && schema.SobjectType.Job_Number_Settings__c.Fields.Auto__c.isUpdateable() ){
            var_JNoSetng.Auto__c = str_Auto;
        }
        if(schema.SobjectType.Job_Number_Settings__c.Fields.Code__c.isCreateable() && schema.SobjectType.Job_Number_Settings__c.Fields.Code__c.isUpdateable() ){
            var_JNoSetng.Code__c = str_Code;
        }
        if(schema.SobjectType.Job_Number_Settings__c.Fields.Date__c.isCreateable() && schema.SobjectType.Job_Number_Settings__c.Fields.Date__c.isUpdateable() ){
            var_JNoSetng.Date__c = str_DateForm;
        }
        if(schema.SobjectType.Job_Number_Settings__c.Fields.Type__c.isCreateable() && schema.SobjectType.Job_Number_Settings__c.Fields.Type__c.isUpdateable() ){
            var_JNoSetng.Type__c = str_radibtn;
        }
        
         if(str_radibtn == 'Auto' && str_Auto == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter value in Auto field'));
        }
        else if(str_radibtn == 'Date' && str_DateForm == 'None'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select Date format'));        
        }
        else if(str_radibtn == 'Code' && str_Code == 'None'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select Code'));        
        }
        else{
            if(Schema.sObjectType.Job_Number_Settings__c.isCreateable() && Schema.sObjectType.Job_Number_Settings__c.isUpdateable() ){ 
                upsert var_JNoSetng;
            }
         
        PageReference pt = new PageReference('/home/home.jsp');
            return pt;        
        }
        
        return null;
    }
    
     public PageReference cancelPage(){
            PageReference pt = new PageReference('/home/home.jsp');
            return pt;
        }*/
}