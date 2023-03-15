public with sharing class JobTimesheetViewExt {
/*
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d' || theme=='Theme4t')?true:false;
                                          }
    }

    private Decimal TaskTotalHr;
    private Decimal TaskTotalHrtmp;
    private Decimal TaskTotalHrR;
    private Decimal TaskTotalHrtmpR;
    Public string Jobid{get;set;}
    Public Map<Id,decimal> MapTotalno{get;set;}
    Public Map<Id,decimal> MapremainTotalno{get;set;}
    Public  List<Timesheet_Entries__c> objTsHead;
    Public  List<Timesheet_Entries__c> objTsHeadwithnoglcodes{get;set;}
    Public  List<Timesheet_Entries__c> objTsHeadone ; 
    public Transient List<TimesheetWrapper>  TW;
    public Transient List<GlcodeWrapper>  GlWrapper{get;set;}
    Public string  Job{get;set;}
    public Transient GlcodeWrapper tmpGlWrapper;
    Public Boolean ShowProductionEstimate{get;set;}
   
   
    public JobTimesheetViewExt() {
      
      TaskTotalHr =0.00;
      TaskTotalHrR =0.00;
      MapTotalno=new Map<Id,decimal>();
      MapremainTotalno=new Map<Id,decimal>();
      jobId = ApexPages.currentPage().getParameters().get('jobId');
      GlWrapper= new List<GlcodeWrapper>();
      TW= new List<TimesheetWrapper>();
    
      Job__c job1= [select id,name,Job_Auto_Number__c from Job__c where id=:jobId ];
     
      Job=job1.name+'-'+job1.Job_Auto_Number__c ;
      
      ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
      ShowProductionEstimate =activeSettings.Active__c;
      
      if(!ShowProductionEstimate){
      
      
      List<Estimate_Line_Items__c> objES = [select Quantity__c,GL_Code__c from Estimate_Line_Items__c where Job__c=:jobId ];
         system.debug('estimate -- '+ objES);
          
            if(objES.size()>0)
            {
                for(Estimate_Line_Items__c objTemp:objES){
                
                    if(objTemp.Quantity__c <> null ){
                    
                       if(!MapTotalno.containskey(objTemp.GL_Code__c )){
                       TaskTotalHr=objTemp.Quantity__c;
                       MapTotalno.put(objTemp.GL_Code__c ,TaskTotalHr);
                       
                       }
                        else{
                        
                        TaskTotalHrtmp=MapTotalno.get(objTemp.GL_Code__c );
                        TaskTotalHr=TaskTotalHrtmp+objTemp.Quantity__c;
                        MapTotalno.put(objTemp.GL_Code__c ,TaskTotalHr);
                        
                        }
                        
                        
                    }
                  
                }
            }
    
           system.debug('map'+MapTotalno);
           
          }
          else{
          
          List<Production_Estimate__c> objpES = [select Quantity__c,GL_Code__c from Production_Estimate__c where Job__c=:jobId ];
         system.debug('pestimate -- '+ objpES);
          
            if(objpES.size()>0)
            {
                for(Production_Estimate__c objTemp:objpES){
                
                    if(objTemp.Quantity__c <> null ){
                    
                       if(!MapTotalno.containskey(objTemp.GL_Code__c )){
                       TaskTotalHr=objTemp.Quantity__c;
                       MapTotalno.put(objTemp.GL_Code__c ,TaskTotalHr);
                       
                       }
                        else{
                        
                        TaskTotalHrtmp=MapTotalno.get(objTemp.GL_Code__c );
                        TaskTotalHr=TaskTotalHrtmp+objTemp.Quantity__c;
                        MapTotalno.put(objTemp.GL_Code__c ,TaskTotalHr);
                        
                        }
                        
                        
                    }
                  
                }
            }
    
           system.debug('map'+MapTotalno);
          
          
          
          
          
          }
          
          
          
           
           
          objTsHeadone  = [select id,name,Hours_Worked__c,GL_Code__c,GL_Code__r.Name from Timesheet_Entries__c where Job__c =:jobId and GL_Code__c=:MapTotalno.keyset()  ];
            system.debug('estimate -- '+ objTsHeadone);
            if(objTsHeadone.size()>0)
            {
                for(Timesheet_Entries__c  objTemp:objTsHeadone){
                
                    if(objTemp.Hours_Worked__c <> null ){
                    
                       if(!MapremainTotalno.containskey(objTemp.GL_Code__c )){
                       TaskTotalHrR=objTemp.Hours_Worked__c;
                       MapremainTotalno.put(objTemp.GL_Code__c ,TaskTotalHrR);
                       
                       }
                        else{
                        
                        TaskTotalHrtmpR=MapremainTotalno.get(objTemp.GL_Code__c );
                        TaskTotalHrR=TaskTotalHrtmpR+objTemp.Hours_Worked__c;
                        MapremainTotalno.put(objTemp.GL_Code__c ,TaskTotalHrR);
                        
                        }
                        
                        
                    }
                  
                }
            }
    
           system.debug('map'+MapremainTotalno);
           
           
        objTsHeadwithnoglcodes  = [select id,name,Task_Name__c,Notes__c,User__c,date__c,Hours_Worked__c,GL_Code__c,GL_Code__r.Name from Timesheet_Entries__c where Job__c =:jobId and (GL_Code__c !=:MapTotalno.keyset() OR GL_Code__c =null) order by date__c];
     
           
           
           
    
         objTsHead  = [select id,name,Task_Name__c,Notes__c,User__c,date__c,Hours_Worked__c,GL_Code__c,GL_Code__r.Name from Timesheet_Entries__c where Job__c =:jobId and GL_Code__c=:MapTotalno.keyset()  order by GL_Code__r.Name,date__c];
                
            string strGlNameNew;
           
          for(Timesheet_Entries__c  aa:objTsHead)
         {
           if (strGlNameNew!= aa.GL_Code__r.Name)
            {
            
            
               
                 if (strGlNameNew!= null)
               {     
               
                    system.debug('TW::::'+TW);                           
                    tmpGlWrapper.TWrapper= TW;
                    GlWrapper.add(tmpGlWrapper);
                    
                    system.debug('gWrapper :::::::::'+GlWrapper);                                                                      
               }  
                
                  
               tmpGlWrapper= new GlcodeWrapper();     
                    
                
                tmpGlWrapper.strGlcodeName = strGlNameNew= aa.GL_Code__r.Name;
                tmpGlWrapper.estimatehours=MapTotalno.get(aa.GL_Code__c);
                tmpGlWrapper.remainhours=MapTotalno.get(aa.GL_Code__c)-MapremainTotalno.get(aa.GL_Code__c);
                
                
                
               TW = new List<TimesheetWrapper>();
                
            }   
           
            TimesheetWrapper obTWrapper = new TimesheetWrapper();
            obTWrapper.Ts= aa;              
            
            
            
            TW.add(obTWrapper); 
        }
       if (strGlNameNew!= null){
           
                    tmpGlWrapper.TWrapper= TW;
                    GlWrapper.add(tmpGlWrapper);
                   system.debug('cWrapper :::::::::'+GlWrapper);
                    
       }
                
                
                
        

    }
   
    
    Public pagereference NewTs(){
    
     pagereference pg = new pagereference('/apex/TimesheetEntries?jobId='+jobId);
            pg.setRedirect(true);
            return pg;
    
    }
  
     public class GlcodeWrapper
    {
       public List<TimesheetWrapper> TWrapper{get;set;}
       Public decimal estimatehours{get;set;}
       Public decimal remainhours{get;set;}
     
       public string strGlcodeName {get;set;} 
       
        public GlcodeWrapper()
        {
          if(TWrapper== NULL) {TWrapper= new List<TimesheetWrapper>();}
        }
     }
  
  
  
       public class TimesheetWrapper
        {              
           public Timesheet_Entries__c  Ts{get;set;}
           
           public TimesheetWrapper()
            {
                 
            }
    }*/
}