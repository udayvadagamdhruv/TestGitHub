// This page is used to display tasks on home page of logged in User
public with sharing class getMyTasksController 
{
    
    public boolean isLtng{ set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }
    
    public boolean isMobile{ set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }
    
    // Global variables
    TRANSIENT public String str{get;set;}
    TRANSIENT public Job__c j{get;set;}
    TRANSIENT public String strJTID{get;set;}
    TRANSIENT public String strJTID2{get;set;}
    TRANSIENT public String strGetName{get;set;}
    TRANSIENT public List<Job__c> lstJob{get;set;}
    TRANSIENT public List<Job_Task__c> lstJT{get;set;}
    TRANSIENT public List<Job_Task__c> lstJT1{get;set;}
    TRANSIENT public List<Job_Task_Role__c> lstJTR{get;set;}
    public Set<Id> stJobId=new Set<Id>();
    public Set<Id> stJobTaskId=new Set<Id>();
    public Set<Id> stJobTaskRoleId=new Set<Id>();
    Public Boolean ShowTsEntryButton{get;set;}
    private String sortDirection = 'ASC';
    private String sortExp = 'Job_Task__r.Name';
    
    public integer totalRecs{get;set;}    
    private integer index = 0;
    private integer blockSize =400;         
    
    // End of Global variables
 
   public integer rowIndex {set;get;}
 
   
   public list<taskWrapper> taskroleWrap{get;set;}
   Public String strColor{get; set;} 
   
   Class taskWrapper
   {
        public string color {get;set;}
        public Job_Task_Role__c jobTaskrole{get;set;}
    
        public taskWrapper(string str,Job_Task_Role__c taskrole)
        {
             color = str;
             jobTaskrole = taskrole ;     
        }
         
        @TestVisible public taskWrapper()
        {
              if(jobTaskrole== NULL)
              {
                 jobTaskrole = new Job_Task_Role__c();
              }
              if(color == NULL)
              {
               // color = new String;
              }
                
        }
  } 

    public getMyTasksController()
    {
        
        ViewData();   
    }
    // This method is called on to retrive active tasks of active jobs of Logged In User
 
    // End of method Load
    
    
     public String sortExpression
     {
        get
        {
            return sortExp;
        }
        set
        {
            // if the columns is clicked on then switch between ascending and descending modes
            if( value == sortExp)
            {
                sortDirection = (sortDirection== 'ASC')?'DESC' : 'ASC';
            }
            else
            {
                sortDirection='ASC';
            } 
            sortExp=value;
        }
    }
    
    public string getSortDirection()
    {
        // if not columns is selected
        if(sortExpression==NULL || sortExpression=='')
        {
            return 'ASC';
        }
        else
        {
            return sortDirection;
        }
    }
    
    public void setSortDirection(String value)
    {
        sortDirection=value;
    }
    
    public List<Job_Task_Role__c> getlstJTR()
    {
        return lstJTR;
    }
    
    
     public List<taskWrapper> getViewData() 
    {
    
        lstJob=new List<Job__c>();
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowTsEntryButton=activeSettings.TS_Entry_Button__c;
        
       
    
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        string sortDateExp;
        if(sortExpression == null || sortExpression == 'Job_Task__r.Revised_Due_Date__c')
        {
            sortDateExp = 'Job_Task__r.Revised_Due_Date__c' + ' '+sortDirection;
        }
        else
        {
            sortDateExp = 'Job_Task__r.Revised_Due_Date__c';
        }
        //query the database based on the sort expression
       
        String strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName];
        String strName=u.Name;
        lstJob=[Select Id,Name from Job__c where Status__c=: 'Active'];
        for(Job__c j:lstJob)
        {
           stJobId.add(j.id);
        }
        lstJT=[Select Id,Name,Revised_Due_Date__c,Next_Task_Due__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Task_Order__c from Job_Task__c where Job__c in : stJobId and Status__c=:'Active' and Marked_Done__c=: False  Order by Name];
   
      
        for(Job_Task__c jt: lstJT)
        {
            stJobTaskId.add(jt.id);
        } 
        //list<Job_Task_Role__c> lstid= [Select Job_Task__r.id,User__c from Job_Task_Role__c where User__c =: strName];
        
       //Boolean isDone = false; 
       lstJTR=Database.query('Select Id,Name,Job_Task__r.Name,Job_Task__r.Job__r.Name,Job_Task__r.Revised_Due_Date__c,Job_Task__r.Next_Task_Due__c,Job_Task__r.Status__c,Job_Task__r.Task_Order__c,Job_Task__r.Job__r.Job_Auto_Number__c from Job_Task_Role__c where Job_Task__c IN : stJobTaskId and User__c =: strName  ORDER By'+' '+sortDateExp+','+ sortFullExp+' LIMIT :blockSize OFFSET :index' ); //Job_Task__r.Revised_Due_Date__c'+' '+ sortDirection + ',' + sortFullExp);
     
      totalRecs = [select count() from Job_Task_Role__c where Job_Task__c IN : stJobTaskId and User__c =: strName];   
     
     
       taskroleWrap = new List<taskWrapper>();
       
      
       //List<Job_Task__c>  ltask = new  List<Job_Task__c> (); 
       //[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Task_Order__c,Marked_Done__c from Job_Task__c where Status__c=:'Active' and Marked_Done__c=: False ]);
       Map<Id,List<Job_Task__c>> taskListMap = new Map<Id,List<Job_Task__c>>(); 
       Set<id>  trSet = new  set<id> ();
      
       for(Job_Task_Role__c jtr: lstJTR)
       {
          trSet.add(jtr.Job_Task__r.Job__r.id);
       }
      
      
       List<Job_Task__c> ltask1 = [Select Id,Name,Revised_Due_Date__c,Next_Task_Due__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Task_Order__c,Marked_Done__c from Job_Task__c where Status__c=:'Active' and Marked_Done__c=: False and Job__r.id in:trSet ORDER BY Task_Order__c  ];// and  id IN(Select User__c from Job_Task_Role__c where User__c =: strName) ];
      
       for(Job_Task__c jtask: ltask1)
       {
              if(taskListMap.get(jtask.Job__r.id)!= null)
              {
                   list<Job_Task__c> lst = taskListMap.get(jtask.Job__r.Id);
                   lst.add(jtask);
                   taskListMap.put(jtask.Job__r.Id,lst);
              } 
              else
              {
                  taskListMap.put(jtask.Job__r.Id,new list<Job_Task__c>{jtask});
              }
             
       }
       
        
        
         
      Map<id,string> newmap=new  Map<id,string>();
          
       for(Job_Task_Role__c jtr:lstJTR)
       {
       
       
       
           List<Job_Task__c> lstTask = new List<Job_Task__c>();
            if(taskListMap.ContainsKey(jtr.Job_Task__r.Job__r.id)){
             lstTask=taskListMap.get(jtr.Job_Task__r.Job__r.id);
             }
          
            
         //    system.debug(':( :( :( :( :( :('+lstTask.size());
            
              Boolean flagAbove = false;
             
                for(Job_Task__c t : lstTask)
                {
                
                     if(t.task_order__c < jtr.Job_Task__r.Task_Order__c)
                     {
                        flagAbove = true;
                        break;
                     }
                }
                if(flagAbove)
                {
                   strColor = 'Black'; 
                }
                else
                {
                       if(jtr.Job_Task__r.Revised_Due_Date__c < System.today())
                       {
                          strColor= 'Red'; 
                       }
                       else
                       {
                          strColor = 'Green';
                       }
                }
                taskWrapper taskWrap = new taskWrapper ();
               
               if(newmap.get(jtr.Job_Task__r.Job__r.id)==null && !newmap.containskey(jtr.Job_Task__r.Job__r.id) && jtr.Job_Task__r.Next_Task_Due__c==true){
               
                        taskWrap.color = strColor;
                        taskWrap.jobTaskrole = jtr;
                        taskroleWrap.add(taskWrap);
                       newmap.put(jtr.Job_Task__r.Job__r.id,jtr.Job_Task__r.Job__r.name);
               }
           
             }
           
           
            
             
          return taskrolewrap;
          
    }
     
      
    
    
   
     public pagereference ViewData() 
    {
    
       lstJob=new List<Job__c>();
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowTsEntryButton=activeSettings.TS_Entry_Button__c;
        
       
    
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        string sortDateExp;
        if(sortExpression == null || sortExpression == 'Job_Task__r.Revised_Due_Date__c')
        {
            sortDateExp = 'Job_Task__r.Revised_Due_Date__c' + ' '+sortDirection;
        }
        else
        {
            sortDateExp = 'Job_Task__r.Revised_Due_Date__c';
        }
        //query the database based on the sort expression
       
        String strGetUserName=UserInfo.getUserName();
        User u=[Select id,Name from User where Username=: strGetUserName];
        String strName=u.Name;
        lstJob=[Select Id,Name from Job__c where Status__c=: 'Active'];
        for(Job__c j:lstJob)
        {
           stJobId.add(j.id);
        }
        lstJT=[Select Id,Name,Revised_Due_Date__c,Next_Task_Due__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Task_Order__c from Job_Task__c where Job__c in : stJobId and Status__c=:'Active' and Marked_Done__c=: False  Order by Name ];
   
      
        for(Job_Task__c jt: lstJT)
        {
            stJobTaskId.add(jt.id);
        } 
        //list<Job_Task_Role__c> lstid= [Select Job_Task__r.id,User__c from Job_Task_Role__c where User__c =: strName];
        
       //Boolean isDone = false; 
       lstJTR=Database.query('Select Id,Name,Job_Task__r.Name,Job_Task__r.Job__r.Name,Job_Task__r.Revised_Due_Date__c,Job_Task__r.Next_Task_Due__c,Job_Task__r.Status__c,Job_Task__r.Task_Order__c,Job_Task__r.Job__r.Job_Auto_Number__c from Job_Task_Role__c where Job_Task__c IN : stJobTaskId and User__c =: strName   ORDER By'+' '+sortDateExp+','+ sortFullExp+' LIMIT :blockSize OFFSET :index'); //Job_Task__r.Revised_Due_Date__c'+' '+ sortDirection + ',' + sortFullExp);
     
      totalRecs = [select count() from Job_Task_Role__c where Job_Task__c IN : stJobTaskId and User__c =: strName];   
     
     
       taskroleWrap = new List<taskWrapper>();
       
      
       //List<Job_Task__c>  ltask = new  List<Job_Task__c> (); 
       //[Select Id,Name,Revised_Due_Date__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Task_Order__c,Marked_Done__c from Job_Task__c where Status__c=:'Active' and Marked_Done__c=: False ]);
       Map<Id,List<Job_Task__c>> taskListMap = new Map<Id,List<Job_Task__c>>(); 
       Set<id>  trSet = new  set<id> ();
      Map<id,string> newmap=new  Map<id,string>();
      
       for(Job_Task_Role__c jtr: lstJTR)
       {
          trSet.add(jtr.Job_Task__r.Job__r.id);
       }
      
      
       List<Job_Task__c> ltask1 = [Select Id,Name,Revised_Due_Date__c,Next_Task_Due__c,Assigned_Users__c,Status__c,Job__c,Job__r.Name,Task_Order__c,Marked_Done__c from Job_Task__c where Status__c=:'Active' and Marked_Done__c=: False and Job__r.id in:trSet ORDER BY Task_Order__c];// and  id IN(Select User__c from Job_Task_Role__c where User__c =: strName) ];
      
       for(Job_Task__c jtask: ltask1)
       {
              if(taskListMap.get(jtask.Job__r.id)!= null)
              {
                   list<Job_Task__c> lst = taskListMap.get(jtask.Job__r.Id);
                   lst.add(jtask);
                   taskListMap.put(jtask.Job__r.Id,lst);
              } 
              else
              {
                  taskListMap.put(jtask.Job__r.Id,new list<Job_Task__c>{jtask});
              }
             
       }
          
       for(Job_Task_Role__c jtr:lstJTR)
       {
           
              List<Job_Task__c> lstTask = taskListMap.get(jtr.Job_Task__r.Job__r.id);
            
              system.debug(':( :( :( :( :( :('+lstTask.size());
            
              Boolean flagAbove = false;
             
                for(Job_Task__c t : lstTask)
                {
                     if(t.task_order__c < jtr.Job_Task__r.Task_Order__c)
                     {
                        flagAbove = true;
                        break;
                     }
                }
                if(flagAbove)
                {
                   strColor = 'Black'; 
                }
                else
                {
                       if(jtr.Job_Task__r.Revised_Due_Date__c < System.today())
                       {
                          strColor= 'Red'; 
                       }
                       else
                       {
                          strColor = 'Green';
                       }
                }
                
                
                
                taskWrapper taskWrap = new taskWrapper ();
                
                
                
                if(newmap.get(jtr.Job_Task__r.Job__r.id)==null && !newmap.containskey(jtr.Job_Task__r.Job__r.id) && jtr.Job_Task__r.Next_Task_Due__c==true){
               
                       taskWrap.color = strColor;
                        taskWrap.jobTaskrole = jtr;
                        taskroleWrap.add(taskWrap);
                       newmap.put(jtr.Job_Task__r.Job__r.id,jtr.Job_Task__r.Job__r.name);
               }
                
                 system.debug('>>>>>>>>>>>taskWrap>>>>>>>>>>'+taskWrap);
                system.debug('>>>>>>>>>>>taskroleWrap>>>>>>>>>>'+taskroleWrap);
           }
          
        return null;
      }
    
    
   
    // This method is called on to marked Done the task
    public Pagereference assignMarkedDone1()
    {
        System.debug('strJTID is'+strJTID);
        
        Job_Task__c objJT=[Select id,Marked_Done__c,Completion_Date__c,Status__c,Job__c from Job_Task__c where id =:strJTID];
        //code commented as not required block (Sushma 7th Jan 2013) 
        //if(objJT.Marked_Done__c==True)
        //{
        //    objJT.Marked_Done__c=False;
        //    objJT.Completion_Date__c=NULL;
        //    objJT.Status__c='Active';
       // }
       // else
       // {
            objJT.Marked_Done__c=True;
            objJT.Completion_Date__c=System.Today();
            objJT.Status__c='Completed';
       //}
        update objJT;
     //   Load();
     //code commented as no need of the view data as the section is already loaded Sushma 7th Jan 2013     
        //ViewData();
       return NULL;
    }
    // End of method assignMarkedDone
    
    
     public void assignMarkedDoneMobile()
    {
        System.debug('strJTID is'+strJTID);
        
        Job_Task__c objJT=[Select id,Marked_Done__c,Completion_Date__c,Status__c,Job__c from Job_Task__c where id =:strJTID];
       
            objJT.Marked_Done__c=True;
            objJT.Completion_Date__c=System.Today();
            objJT.Status__c='Completed';
            
            taskroleWrap[rowIndex-1].jobTaskrole.Job_Task__r.Id=strJTID;
            taskroleWrap[rowIndex-1].jobTaskrole.Job_Task__r.Marked_Done__c=true;
            taskroleWrap[rowIndex-1].jobTaskrole.Job_Task__r.Completion_Date__c=System.Today();
             taskroleWrap[rowIndex-1].jobTaskrole.Job_Task__r.Status__c='Completed';        
             update taskroleWrap[rowIndex-1].jobTaskrole.Job_Task__r;
             //update taskroleWrap[rowIndex-1].jobTaskrole;
    
            //PageReference p =  new pagereference('/apex/getmytasksMobile');
            //p.setRedirect(true);
           //return p; 
    }
    // End of method ass
    
    
    
    
    
    public Pagereference TsEntry()
    {
        if(isMobile)
        {
             PageReference p =  new pagereference('/apex/newtsentrieshometasksMobile?tid='+strJTID2);
             p.setRedirect(true);
             return p;
        }
        else if(isLtng)
        {
             PageReference p =  new pagereference('/apex/newtsentrieshometasksLightning?tid='+strJTID2);
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new pagereference('/apex/newtsentrieshometasks?tid='+strJTID2);
                p.setRedirect(true);
                return p;
        }
       
    }
    
    
     public void beginning()
    {
        index = 0;
    }
    
    public void previous()
    {
        index = index - blockSize;
    }
    
    public void next()
    {
        index = index + blockSize;
    }

    public void end()
    {
        index = totalrecs - math.mod(totalRecs,blockSize);
    }        
    
    public boolean getprev()
    {
        if(index == 0)
        return true;
        else
        return false;
    }  
    
    public boolean getnxt()
    {
        if((index + blockSize) >= totalRecs)
        return true;
        else
        return false;
    }         
    
   
    
    
    
    
    
   
    
    
/*
    // Test Coverage 
    static testMethod void Test_getMyTasksController()
    {
          Profile p=[Select Id from Profile where Name=: 'System Administrator'];
          
          User u=[Select Id,Name from User where IsActive=: True and ProfileId=: p.Id LIMIT 1];
          
          System.runAs(u)
          {

            Job_Number_Setting__c customSetting810 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting810;
          
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 810');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 810',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Schedule_Task__c testScheduleTask1=new Schedule_Task__c(Name='Test Schedule Task 810',Schedule_Template__c=testST.Id);
                insert testScheduleTask1;

          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 810');
                insert testSpec;
                
          Job__c testJob1=new Job__c( Job_Auto_Number__c = '111',Status__c = 'Active',Name='Test Job 111',Start_Date__c=System.Today(),Flag__c=True,Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         
                 insert testJob1;
          
          System.assertEquals('Test Job 111',testJob1.Name);
                 
          Job_Task__c testJT1=new Job_Task__c(Name='Test Job Task 8100',Job__c=testJob1.Id,Marked_Done__c=False, Days__c=1);
             insert testJT1; 
             
          Job_Task__c testJT3=new Job_Task__c(Name='Test Job Task 8107',Job__c=testJob1.Id,Marked_Done__c=True, Days__c=1);
             insert testJT3;
             
          Job_Task__c testJT4=new Job_Task__c(Name='Test Job Task 8101',Job__c=testJob1.Id,Marked_Done__c=False, Days__c=1);
             insert testJT4;       
         
         Job_Task__c testJT2=new Job_Task__c(Name='Test Job Task 8110',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=1);
            insert testJT2;
            
         Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Test Designer',Job_Task__c=testJT1.Id, User__c=u.Name);
            insert testJTR1;   
            
         System.assertEquals('Test Designer',testJTR1.Name);   
         
         
        // Instantiate the extention instance with the custom controller 
          getMyTasksController ext=new getMyTasksController();
          ext.strJTID=testJT1.id;
          ext.sortDirection='ASC';
           string str;
          list<Job_Task_Role__c> lst;
          taskWrapper twrap = new taskWrapper();
          // Invoke the primary method on the extension
          
          ApexPages.Pagereference result1=ext.assignMarkedDone1();
          ext.strJTID=testJT2.id;
          ApexPages.Pagereference result2=ext.assignMarkedDone1();
          }
   }*/
// End Of Test Coverage 
}
// ENd of Class