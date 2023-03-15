global with sharing class customSettingsInroPg{

//global variables
    public string str_Auto {get; set;}
    public string str_Code {get; set;}
    public string str_DateForm {get; set;}
    public string str_radibtn {get; set;}
    public Job_Number_Settings__c var_JNoSetng;
    public list<JobDetails__c> objlist1 { get; set; }
    
    public string tabid{get; set;}
    public boolean ren1{get; set;}
    public string ren2{get; set;}
    map<string,Job_Number_Settings__c> map_JNoSetng;
    
    public list<SettingsWrapper> cstWrap{get;set;}
    Public string checked{get; set;}

     
    public customSettingsInroPg(){
      strQuery();
      loadData();
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
    
    public pageReference strQuery(){
        
        objlist1 = [select Name, Order__c,Active__c,Tabs_Order__c from JobDetails__c ORDER By Order__c];
        return null;
        }
        
    public PageReference MoveUp() {
        system.debug('Id..........'+tabid);
        list<JobDetails__c> objListUpdate = new list<JobDetails__c>();
        JobDetails__c obj1 = [select Name, Order__c,Active__c from JobDetails__c where Id =:tabid ];
        Decimal CurOrder = obj1.Order__c;
        obj1.Order__c = CurOrder-1;
        objListUpdate.add(obj1);
        
        JobDetails__c objup = [select Name, Order__c,Active__c from JobDetails__c where Order__c =: curOrder-1];         
        objup.Order__c  = CurOrder;
        objListUpdate.add(objup);
        
        update objListUpdate;
        strQuery(); 
            
        return null;
        }
    
    public PageReference MoveDown() {
        system.debug('Id..........'+tabid);
        
        
        system.debug('Id..........'+tabid);
        list<JobDetails__c> objListUpdate = new list<JobDetails__c>();
        JobDetails__c obj1 = [select Name, Order__c,Active__c from JobDetails__c where Id =:tabid ];
        Decimal CurOrder = obj1.Order__c;
        obj1.Order__c = CurOrder+1;
        objListUpdate.add(obj1);
        
        JobDetails__c objup = [select Name, Order__c,Active__c from JobDetails__c where Order__c =: curOrder + 1];         
        objup.Order__c  = CurOrder;
        objListUpdate.add(objup);
        
        update objListUpdate;
        
        
      
        
        strQuery();
        
        return null;
    }
    
    public PageReference savePage() {
        var_JNoSetng = new Job_Number_Settings__c();
        map_JNoSetng = Job_Number_Settings__c.getAll();
        var_JNoSetng = map_JNoSetng.get('shashi1');
        
        if(var_JNoSetng == null){
            //creating new instance of variable to insert new record.
            var_JNoSetng  = new Job_Number_Settings__c();
            var_JNoSetng.Name = 'shashi1';
        }
        var_JNoSetng.Auto__c = str_Auto;
        var_JNoSetng.Code__c = str_Code;
        var_JNoSetng.Date__c = str_DateForm;
        var_JNoSetng.Type__c = str_radibtn;
        
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
        upsert var_JNoSetng;
        update objlist1;
        PageReference pt = new PageReference('/home/home.jsp');
            return pt;        
        }
        
        return null;
    }
    
    public List<SelectOption> getItems() 
    {
            List<Profile> lstProfile = [SELECT Id,Name from Profile];
            //List<Profile> lstProfile = [SELECT Id,Name,csr__Profiles__c from csr__NotesFiles__c];
            
            List<SelectOption> options = new List<SelectOption>();
            
            for(Profile p : lstProfile)
            {
              options.add(new SelectOption(p.Id,p.Name));
            }
            return options;
       
    }
    
    public class SettingsWrapper
    {
        public string isSelected {get;set;}
        public String strProfile {get;set;}
        public void SettingsWrapper(string strProfile, string isSelected)
        {
           this.isSelected =isSelected;
           this.strProfile  = strProfile;
        }
    
    }
    
    //This method is for loading all salescted profiles
    
    public pagereference loadData()
    {
      List<Profile> lstProfile = [SELECT Id,Name from Profile];
      NotesFiles__c objProfile = [SELECT Id,Name,Profiles__c from NotesFiles__c];
      string strpro = objProfile.Profiles__c;
      cstWrap = new list<SettingsWrapper>();
      //SplitString(strpro);
      List<string> lstPro = strpro.Split(';') ; 
      set<string> stPro = new set<string>();
      stPro.addAll(lstPro);
      for(Profile p:lstProfile)
      {
         SettingsWrapper proWrap = new SettingsWrapper();
         if(stPro.contains(P.Name))
             {
               
               proWrap.isSelected = 'true';
              
             }else{
               proWrap.isSelected = 'false';
             }
          system.debug(proWrap.isSelected);   
          proWrap.strProfile = p.Name;
          cstWrap.add(proWrap);
      
      }
      return null;
    }  
    
    // Cancel button method
        public PageReference cancelPage(){
            PageReference pt = new PageReference('/home/home.jsp');
            return pt;
        }
  /*
    //Test starts
  static testmethod void testclass(){
  
        Job_Number_Settings__c var_JNoSetng = new Job_Number_Settings__c(Name='shashi1', Auto__c='Auto123',Type__c='Auto');
        insert var_JNoSetng;
        
        NotesFiles__c  NF = new NotesFiles__c (Name = 'Profiles',Profiles__c = 'System Administrator' );
        insert NF;
         
        customSettingsInroPg tct = new customSettingsInroPg();

        var_JNoSetng.Date__c = 'mm-dd-yy';
        var_JNoSetng.Type__c = 'Date';
        update var_JNoSetng;
        customSettingsInroPg tct2 = new customSettingsInroPg();

        var_JNoSetng.Code__c='Client';
        var_JNoSetng.Type__c='Code';
        update var_JNoSetng;
        customSettingsInroPg tct3 = new customSettingsInroPg();
        
        tct.savePage();

        delete var_JNoSetng;
        string str_DateForm = 'yy';
        string str_Code = 'Client';
        tct.savePage();
        tct.cancelPage();    
         
         
        
  }*/
}