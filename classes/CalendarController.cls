global with sharing class CalendarController
{
    public CalendarController() 
    {
    }
    // public list<String> mts = new list<String>();
   /* public Boolean includeMyJobs {get;set;}
    public list<calEvent> events {get;set;}
    transient Public List<string> strJobName{get;set;}
    public List<string> strCampaignName{get;set;}
    transient public List<string> strClientName{get;set;}
    Public string StatusString {get;set;}
    public List<string> strstaff{get;set;}
    public List<string> strstafftemp{get;set;}
    public List<string> strrole{get;set;}
    public List<string> strroletemp{get;set;}
    public List<string> strmediatype{get;set;}
    public List<string> strscheduletemp{get;set;}
    public List<string> strtaskname{get;set;}
    Public string JobStatusString {get;set;}
    transient Public list<Campaign__c> camplist{get;set;}
    transient Public list<Job__C> joblist{get;set;}
    transient Public list<Job__C> joblistcal{get;set;}
    transient Public list<Job_Task__c> jobTask{get;set;}
    transient Public list<Job_Task__c> jobTaskTime{get;set;}
    Public string  soql{get;set;}
    Public string  soqlJob{get;set;}
    transient  Public string  soqlJobcal{get;set;}
    transient Public string  soqlJobTask{get;set;}
    transient Public string  soqlJobTaskForJobs{get;set;}
    Public string  soqlJobTaskTime{get;set;}
    Public map<integer,string> colormap{get;set;}
    public boolean Jscampaign{get;set;}
    public boolean Jobs{get;set;}
    public boolean Task{get;set;}
    public boolean TaskTime{get;set;}
    //Public String regExp = '["\']';
    
    /* strCampaignName
strJobName
strClientName
JobStatusString 
StatusString  
    
    
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    String dtFormat = 'EEE- yyyy d MMM HH:mm:ss z';
    
    // moment().format();
    public String calDate{get; set;}
    //constructor
    public CalendarController() 
    {
        StatusString='Active';
        JobStatusString ='Active';
        colormap=new map<integer,string>();
        Jscampaign=false;
        Jobs=true;
        Task=false;
        Job();
        
        includeMyJobs = false;
        calDate = ApexPages.CurrentPage().getParameters().get('calDate');
        Date todaysDate = system.today();
        if(calDate == null || calDate == ''){
            calDate = string.valueof(system.today());
        }
        
    }
    
    // This method is used to retrieve all Campaigns into dropdown list
    public list<selectOption> getCampaigns() 
    {    
        system.debug('-----------selected value----------------->'+StatusString );
        transient list<selectOption> optionList = new list<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Campaign__c  a : [SELECT Id, name FROM Campaign__c where status__c=:StatusString WITH SECURITY_ENFORCED order by Name limit 10000]) 
        {  
            optionList.add(new selectOption(a.name, a.Name ));    
        }
        return optionList;  
    }   
    // End of method getCampaigns
    
    // This method is used to retrieve all Task into dropdown list
    public list<selectOption> getTasks() 
    {    
        system.debug('-----------selected value----------------->'+StatusString );
        set<selectOption> optionListTask = new set<selectOption>();
        optionListTask .add(new selectOption('', '- None -'));  
        for (Schedule_Task__c a : [SELECT Id, name,Schedule_Template__r.name ,Schedule_Template__r.Active__c FROM Schedule_Task__c where Schedule_Template__r.Active__c=:True WITH SECURITY_ENFORCED order by Name limit 10000]) 
        {  
            optionListTask .add(new selectOption(a.name, a.Name));    
        }
        list<selectOption> toptlist = new list<selectOption>();
        toptlist.addall(optionListTask );
        return toptlist;  
    }   
    // End of method getTask
    
    // This method is used to retrieve all Mediatype into dropdown list
    public List<selectOption> getMediatype() 
    {    
        system.debug('-----------selected value----------------->'+StatusString );
        List<selectOption> optionListmedia = new List<selectOption>();
        optionListmedia.add(new selectOption('', '- None -'));  
        for (Media_Type__c a : [SELECT Id, name FROM Media_Type__c  WITH SECURITY_ENFORCED order by Name limit 10000]) 
        {  
            optionListmedia.add(new selectOption(a.name, a.Name ));    
        }
        return optionListmedia;  
    }   
    // End of method Mediatype
    
    // This method is used to retrieve all scheduletemp into dropdown list
    public List<selectOption> getscheduletemp() 
    {    
        system.debug('-----------selected value----------------->'+StatusString );
        List<selectOption> optionListsched = new List<selectOption>();
        optionListsched.add(new selectOption('', '- None -'));  
        for (Schedule_Template__c a : [SELECT Id, name,Media_Types__c,Active__c FROM Schedule_Template__c where Active__c =:True WITH SECURITY_ENFORCED order by Name limit 10000]) 
        {  
            optionListsched.add(new selectOption(a.name, a.Name ));    
        }
        return optionListsched;  
    }   
    // End of method scheduletemp
    
    
    // This method is used to retrieve all Clients into dropdown list
    public List<selectOption> getClients() 
    {    
        List<selectOption> optionList = new List<selectOption>();
        // optionList.add(new selectOption('', '- None -'));  
        for (Client__c a : [SELECT Id, name,Client_Code__c FROM Client__c where Active__c=:true WITH SECURITY_ENFORCED order by Name limit 10000]) 
        {  
            optionList.add(new selectOption(a.name, a.Name ));    
        }
        return optionList;  
    }   
    // End of method getClients
    
    // This method is used to get Campaign Status Picklist values 
    public List<SelectOption> getCampStatus()
    {
        List<SelectOption> CampstatusoptionList = new List<selectOption>();
        
        for(schema.picklistEntry p : Campaign__c.Status__c.getDescribe().getPicklistValues())
        {
            CampstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        
        return CampstatusoptionList;
    } 
    
    
    // This method is used to get Staff Records 
    public List<SelectOption> getStaff()
    {
        List<SelectOption> StaffoptionList = new List<selectOption>();
        
        // StaffoptionList.add(new selectOption('', '- None -'));  
        for (Staff__c a : [SELECT Id, name FROM Staff__c where Active__c=:true WITH SECURITY_ENFORCED limit 10000 ] ) 
        {  
            StaffoptionList.add(new selectOption(a.name, a.Name ));    
        }
        
        for (Vendor_Contact__c a : [SELECT Id, name FROM Vendor_Contact__c where Active__c=:true WITH SECURITY_ENFORCED]) 
        {  
            StaffoptionList.add(new selectOption(a.name, a.Name ));    
        }
        
        for (Client_Contact__c a : [SELECT Id, name FROM Client_Contact__c where Active__c=:true WITH SECURITY_ENFORCED]) 
        {  
            StaffoptionList.add(new selectOption(a.name, a.Name ));    
        }
        
        StaffoptionList.sort();
        
        return StaffoptionList;  
    }   
    // End of method getStaff
    
    
    // This method is used to get Roles Records 
    public List<SelectOption> getRole()
    {
        List<SelectOption> RoleoptionList = new List<selectOption>();
        
        //  RoleoptionList .add(new selectOption('', '- None -'));  
        for (UserRole a : [SELECT Id, name FROM UserRole WITH SECURITY_ENFORCED order by Name limit 1000]) 
        {  
            RoleoptionList.add(new selectOption(a.name, a.Name ));    
        }
        return RoleoptionList;  
    }   
    // End of method getRloes
    
    // This method is used to get Job Records 
    public List<SelectOption> getJobNames()
    {
        List<SelectOption> JoboptionList = new List<selectOption>();
        
        //   JoboptionList.add(new selectOption('', '- None -'));
        //   JoboptionList.add(new selectOption('', '-None-'));  
        for (Job__c a : [SELECT Id, name FROM Job__c where Status__c=:JobStatusString WITH SECURITY_ENFORCED  order by Name limit 1000]) 
        {  
            JoboptionList.add(new selectOption(a.name, a.Name ));
            // mts.add(a.Name);
            // System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+mts);    
        }
        return JoboptionList;  
    }   
    // End of method 
    
    
    // This method is used to get JobStatus picklist Values
    public List<SelectOption> getjobStatus()
    {
        List<SelectOption> jobstatusoptionList = new List<selectOption>();
        
        for(schema.picklistEntry p : Job__c.Status__c.getDescribe().getPicklistValues())
        {
            jobstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        
        return jobstatusoptionList;
    } 
    
    
    
    public PageReference JSCampaignRender() 
    {
        StatusString  = 'Active';
        strCampaignName=null;
        Jscampaign=true;
        strstaff = null;
        strrole = null;
        Jobs=false;
        Task=false;
        JSCampaign();
        //    clearForm();
        return null;
    }
    
    public PageReference JobRender() 
    {
        JobStatusString = 'Active';
        strCampaignName=null;
        strstaff = null;
        strrole = null;
        Jscampaign=false;
        Jobs=true;
        Task=false;
        Job();
        clearForm();
        return null;
    }
    
    public PageReference JobTaskRender() 
    {
        //  strJobName.clear();
        JobStatusString = 'Active';
        strCampaignName=null;
        Jscampaign=false;
        Jobs=false;
        Task=true;
        JobTask();
        clearForm();
        
        return null;
    }
    
    
    
    public PageReference JSCampaign() 
    {
        
        /*
colormap.put(00,'#000000');colormap.put(1,'#006633');colormap.put(2,'#330033');colormap.put(3,'#66CC66');colormap.put(4,'#000066');colormap.put(5,'#6A5ACD');colormap.put(6,'#6B8E23');colormap.put(7,'#708090');colormap.put(8,'#800000');colormap.put(9,'#800080');
colormap.put(10,'#00CC00');colormap.put(11,'#CCCCCC');colormap.put(12,'#FF0099');colormap.put(13,'#FF66CC');colormap.put(14,'#DA70D6');colormap.put(15,'#006400');colormap.put(16,'#FF8C00');colormap.put(17,'#4B0082');colormap.put(18,'#808000');colormap.put(19,'#D8BFD8');
colormap.put(20,'#33CC00');colormap.put(21,'#6666FF');colormap.put(22,'#2E8B57');colormap.put(23,'#996633');colormap.put(24,'#3399FF');colormap.put(25,'#336633');colormap.put(26,'#6666CC');colormap.put(27,'#CC0066');colormap.put(28,'#336699');colormap.put(29,'#330066');
colormap.put(30,'#00CC99');colormap.put(31,'#3366CC');colormap.put(32,'#CC6633');colormap.put(33,'#3366FF');colormap.put(34,'#660066');colormap.put(35,'#99CC66');colormap.put(36,'#00CCCC');colormap.put(37,'#99CCCC');colormap.put(38,'#66CC33');colormap.put(39,'#CC66CC');
colormap.put(40,'#006699');colormap.put(41,'#990033');colormap.put(42,'#666699');colormap.put(43,'#990000');colormap.put(44,'#336600');colormap.put(45,'#66CCCC');colormap.put(46,'#660033');colormap.put(47,'#9900FF');colormap.put(48,'#666666');colormap.put(49,'#FF00FF');
colormap.put(50,'#330000');colormap.put(51,'#66CCFF');colormap.put(52,'#9900CC');colormap.put(53,'#33CCFF');colormap.put(54,'#990099');colormap.put(55,'#0066CC');colormap.put(56,'#33CC66');colormap.put(57,'#66CC00');colormap.put(58,'#00CC33');colormap.put(59,'#99CCFF');
colormap.put(60,'#666600');colormap.put(61,'#CC0099');colormap.put(62,'#99CC99');colormap.put(63,'#6600FF');colormap.put(64,'#CCCC66');colormap.put(65,'#FF6699');colormap.put(66,'#CCCC99');colormap.put(67,'#FF6666');colormap.put(68,'#9966CC');colormap.put(69,'#CC66FF');
colormap.put(70,'#990066');colormap.put(71,'#99CC33');colormap.put(72,'#FF6600');colormap.put(73,'#CC6699');colormap.put(74,'#FF66FF');colormap.put(75,'#3300FF');colormap.put(76,'#CCCCFF');colormap.put(77,'#006666');colormap.put(78,'#CC00CC');colormap.put(79,'#996666');
colormap.put(80,'#99CC00');colormap.put(81,'#FFCC99');colormap.put(82,'#33CC33');colormap.put(83,'#FF00CC');colormap.put(84,'#33CC99');colormap.put(85,'#FF0066');colormap.put(86,'#660099');colormap.put(87,'#0000CC');colormap.put(88,'#CC00CC');colormap.put(89,'#006600');
colormap.put(90,'#FF0000');colormap.put(91,'#3300CC');colormap.put(92,'#996699');colormap.put(93,'#FFCC00');colormap.put(94,'#00CCFF');colormap.put(95,'#66CC99');colormap.put(96,'#00CC66');colormap.put(97,'#9966FF');colormap.put(98,'#330099');colormap.put(99,'#FFCCFF');

        list<string> Colors = new list<string>{'Blue','BlueViolet','Brown','BurlyWood','CadetBlue','Chartreuse','Chocolate','Coral','CornflowerBlue','Crimson','Cyan','DarkBlue','DarkCyan','DarkGoldenRod','DarkGray','DarkGrey','DarkGreen','DarkKhaki','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSalmon','DarkSeaGreen','DarkSlateBlue','DarkSlateGray','DarkSlateGrey','DarkTurquoise','DarkViolet','DeepPink','DeepSkyBlue','DimGray','DimGrey','DodgerBlue','FireBrick','FloralWhite','ForestGreen','Fuchsia','Gainsboro','GhostWhite','Gold','GoldenRod','Gray','Grey','Green','GreenYellow','HoneyDew','HotPink','IndianRed','Indigo','Ivory','Khaki','Lavender','LavenderBlush','LawnGreen','LemonChiffon','LightBlue','LightCoral','LightCyan','LightGoldenRodYellow','LightGray','LightGrey','LightGreen','LightPink','LightSalmon','LightSeaGreen','LightSkyBlue','LightSlateGray','LightSlateGrey','LightSteelBlue','LightYellow','Lime','LimeGreen','Linen','Magenta','Maroon','MediumAquaMarine','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumSpringGreen','MediumTurquoise','MediumVioletRed','MidnightBlue','MintCream','MistyRose','Moccasin','NavajoWhite','Navy','OldLace','Olive','OliveDrab','Orange','OrangeRed','Orchid','PaleGoldenRod','PaleGreen','PaleTurquoise','PaleVioletRed','PapayaWhip','PeachPuff','Peru','Pink','Plum','PowderBlue','Purple','Red','RosyBrown','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','Silver','SkyBlue','SlateBlue','SlateGray','SlateGrey','Snow','SpringGreen','SteelBlue','Tan','Teal','Thistle','Tomato','Turquoise','Violet','Wheat','Yellow','YellowGreen'};
            for(Integer i=0; i<Colors.Size(); i++){
                colormap.put(i,Colors[i]);
            } 
        
        events = new list<calEvent>();
        
        camplist= new List<Campaign__c>();
        
        soql='select Id, Name, Start_Date__c, End_Date__c from Campaign__c where Name!=null and Start_Date__c!=null and End_Date__c!=null';
        
        system.debug('>>>>>>>>>>>>>>>>>>>>>>> StatusString>>>>>>>>>>>>>>>>>>>>>>>>>>>'+StatusString);
        system.debug('>>>>>>>>>>>>>>>>>>>>>>> strCampaignName>>>>>>>>>>>>>>>>>>>>>>>>>>>'+strCampaignName);
        
        if(StatusString!=Null)
            soql +=' And Status__c =:StatusString';
        
        if(strCampaignName!=Null && strCampaignName.size()>0)
            soql +=' And name =:strCampaignName';
        
        soql+=' Limit 1000';
        system.debug('>>>>>>>>>>>>>>>>>>>>>>> soql >>>>>>>>>>>>>>>>>>>>>>>>>>>'+soql);    
        camplist=Database.query(soql);
        
        
        system.debug('>>>>>>>>>>>>>>>>>>>>>>> Camp >>>>>>>>>>>>>>>>>>>>>>>>>>>'+camplist.size());
        system.debug('>>>>>>>>>>>>>>>>>>>>>>> camp >>>>>>>>>>>>>>>>>>>>>>>>>>>'+camplist);           
        
        
        integer j=0;
        set<String> campIds = new set<String>();
        map<string, Integer> campColors = new map<string, Integer>();
        //Get Campaigns
        if(camplist.size() >0)
        {
            for(Campaign__c camp : camplist)
            {
                campIds.add(camp.id);
                DateTime startDT = camp.Start_Date__c+1;
                DateTime endDT = camp.End_Date__c+2;
                
                calEvent campEvent = new calEvent();
                
                String Campname = camp.Name; 
                String regExp = '["\']';
                if(Campname != NULL)
                    Campname = Campname.replaceAll(regExp, '\\ ');
                
                campEvent.title = 'JS Campaign'+' : '+Campname ;
                campEvent.titleNew = 'JS Campaign'+' : '+Campname ;
                campEvent.allDay = True;
                campEvent.startString = startDT.format();
                campEvent.endString = endDT.format();
                campEvent.url = '/' + camp.Id;
                campEvent.color=colormap.get(j);
                campColors.put(camp.id, j);
                campEvent.className = 'event-JSCampaign';
                events.add(campEvent);
                if(j == Colors.Size()-1)
                    j=0;
                else
                    j++;
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No Campaigns to display from this criteria'));
        }
        
        
        if(includeMyJobs)
        {
            
            joblist= new List<Job__c>();
            String act1 = 'Active';
            soqlJob='select Id, Name,Job_Auto_Number__c, Start_Date__c,Due_Date__c,Campaign__c,Campaign__r.name,JS_Client__r.name,Media_Types__r.name,Schedule_Template__r.name from Job__c where Status__c = :act1 and campaign__c IN :campIds'; 
            
            if(strCampaignName!= null && strCampaignName.size()>0)
                soqlJob+=' and Campaign__r.name=:strCampaignName';
            
            soqlJob+=' Limit 1000';  
            
            system.debug('>>>>>>>>>>>>>>>>>>>>>>> show jobs string >>>>>>>>>>>>>>>>>>>>>>>>>>>'+soqlJob);  
            
            joblist=Database.query(soqlJob);
            
            system.debug('>>>>>>>>>>>>>>>>>>>>>>> show jobs >>>>>>>>>>>>>>>>>>>>>>>>>>>'+joblist.size());
            system.debug('>>>>>>>>>>>>>>>>>>>>>>> show jobs >>>>>>>>>>>>>>>>>>>>>>>>>>>'+joblist);  
            
            
            integer i=0;
            
            if(joblist.size() > 0)
            {
                for(Job__c Jo : joblist)
                {
                    DateTime startDT = Datetime.now();
                    DateTime endDT = Datetime.now();
                    
                    
                    if(Jo.Start_Date__c == NULL && Jo.Due_Date__c == NULL)
                    {
                        // startDT = Jo.Start_Date__c+1;
                        // endDT = Jo.Due_Date__c+2;
                        continue;    
                    }
                    
                    else if(Jo.Start_Date__c == NULL)
                    {
                        system.debug('>>>>>>>>>>Job.Due_Date__c>>>>>>>>>>>>>'+Jo.Due_Date__c+' ................'+jo.id); 
                        startDT = Jo.Due_Date__c.addDays(1);
                        endDT = Jo.Due_Date__c+2;
                    }
                    else if(Jo.Due_Date__c == NULL)
                    {
                        system.debug('>>>>>>>>>>Job.Start_Date__c>>>>>>>>>>>>>'+Jo.Start_Date__c+' ................'+jo.id);
                        startDT = Jo.Start_Date__c+1;
                        endDT = Jo.Start_Date__c+2;
                    }
                    else 
                    {
                        startDT = Jo.Start_Date__c+1;
                        endDT = Jo.Due_Date__c+2;
                    }  
                    
                    
                    
                    calEvent campEvent = new calEvent();
                    
                    String CampJname = Jo.Name; 
                    
                    String regExp = '["\']';
                    if(CampJname != NULL)
                        CampJname = CampJname .replaceAll(regExp, '\\ ');
                    
                    campEvent.title = 'Job :'+' '+CampJname +' - '+' # '+Jo.Job_Auto_Number__c;
                    campEvent.titleNew = 'Job :'+' '+CampJname +' - '+' # '+Jo.Job_Auto_Number__c;
                    campEvent.allDay = True;
                    campEvent.startString = startDT.format();
                    campEvent.endString = endDT.format();
                    campEvent.url = '/' + jo.Id;
                    campEvent.JN1 = ' ';
                    campEvent.color=colormap.get(campColors.get(jo.campaign__c));
                    
                    String CampCamname = jo.Campaign__r.name; 
                    //String regExp = '["\']';
                    if(CampCamname != NULL)
                        CampCamname = CampCamname .replaceAll(regExp, '\\ ');
                    
                    campEvent.staff = CampCamname;
                    
                    String CampCliname = jo.JS_Client__r.name; 
                    //String regExp = '["\']';
                    if(CampCliname != NULL)
                        CampCliname = CampCliname .replaceAll(regExp, '\\ ');
                    
                    campEvent.client1 = CampCliname ;
                    campEvent.className = 'event-Jobs';
                    
                    events.add(campEvent);
                    
                    if(i == Colors.Size()-1)
                        i=0;
                    else
                        i++;
                }
            }
            
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No Jobs to display from this criteria'));
            }
        } 
        return null;
    }
    
    
    //Get Jobs
    public PageReference Job() 
    {
        Jscampaign=false;
        Jobs=true;
        Task=false;
        /*
colormap.put(0,'#000000');colormap.put(1,'#006633');colormap.put(2,'#330033');colormap.put(3,'#66CC66');colormap.put(4,'#000066');colormap.put(5,'#6A5ACD');colormap.put(6,'#6B8E23');colormap.put(7,'#708090');colormap.put(8,'#800000');colormap.put(9,'#800080');
colormap.put(10,'#00CC00');colormap.put(11,'#CCCCCC');colormap.put(12,'#FF0099');colormap.put(13,'#FF66CC');colormap.put(14,'#DA70D6');colormap.put(15,'#006400');colormap.put(16,'#FF8C00');colormap.put(17,'#4B0082');colormap.put(18,'#808000');colormap.put(19,'#D8BFD8');
colormap.put(20,'#33CC00');colormap.put(21,'#6666FF');colormap.put(22,'#2E8B57');colormap.put(23,'#996633');colormap.put(24,'#3399FF');colormap.put(25,'#336633');colormap.put(26,'#6666CC');colormap.put(27,'#CC0066');colormap.put(28,'#336699');colormap.put(29,'#330066');
colormap.put(30,'#00CC99');colormap.put(31,'#3366CC');colormap.put(32,'#CC6633');colormap.put(33,'#3366FF');colormap.put(34,'#660066');colormap.put(35,'#99CC66');colormap.put(36,'#00CCCC');colormap.put(37,'#99CCCC');colormap.put(38,'#66CC33');colormap.put(39,'#CC66CC');
colormap.put(40,'#006699');colormap.put(41,'#990033');colormap.put(42,'#666699');colormap.put(43,'#990000');colormap.put(44,'#336600');colormap.put(45,'#66CCCC');colormap.put(46,'#660033');colormap.put(47,'#9900FF');colormap.put(48,'#666666');colormap.put(49,'#FF00FF');
colormap.put(50,'#330000');colormap.put(51,'#66CCFF');colormap.put(52,'#9900CC');colormap.put(53,'#33CCFF');colormap.put(54,'#990099');colormap.put(55,'#0066CC');colormap.put(56,'#33CC66');colormap.put(57,'#66CC00');colormap.put(58,'#00CC33');colormap.put(59,'#99CCFF');
colormap.put(60,'#666600');colormap.put(61,'#CC0099');colormap.put(62,'#99CC99');colormap.put(63,'#6600FF');colormap.put(64,'#CCCC66');colormap.put(65,'#FF6699');colormap.put(66,'#CCCC99');colormap.put(67,'#FF6666');colormap.put(68,'#9966CC');colormap.put(69,'#CC66FF');
colormap.put(70,'#990066');colormap.put(71,'#99CC33');colormap.put(72,'#FF6600');colormap.put(73,'#CC6699');colormap.put(74,'#FF66FF');colormap.put(75,'#3300FF');colormap.put(76,'#CCCCFF');colormap.put(77,'#006666');colormap.put(78,'#CC00CC');colormap.put(79,'#996666');
colormap.put(80,'#99CC00');colormap.put(81,'#FFCC99');colormap.put(82,'#33CC33');colormap.put(83,'#FF00CC');colormap.put(84,'#33CC99');colormap.put(85,'#FF0066');colormap.put(86,'#660099');colormap.put(87,'#0000CC');colormap.put(88,'#CC00CC');colormap.put(89,'#006600');
colormap.put(90,'#FF0000');colormap.put(91,'#3300CC');colormap.put(92,'#996699');colormap.put(93,'#FFCC00');colormap.put(94,'#00CCFF');colormap.put(95,'#66CC99');colormap.put(96,'#00CC66');colormap.put(97,'#9966FF');colormap.put(98,'#330099');colormap.put(99,'#FFCCFF');


        list<string> Colors = new list<string>{'Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen',
                       'Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green',
                       'HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy',
                       'Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','SlateBlue',
                       'SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod',
                       'DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick',
                       'ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown',
                       'SeaGreen','SeaShell','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson',
                       'DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink',
                       'DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple',
                       'MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown',
                       'Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue',
                       'Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue',
                       'DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell',
                       'Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen',
                       'Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green',
                       'HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy',
                       'Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','SlateBlue',
                       'SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod',
                       'DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick',
                       'ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown',
                       'SeaGreen','SeaShell','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson',
                       'DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink',
                       'DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple',
                       'MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown',
                       'Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue',
                       'Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue',
                       'DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell',
                       'Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab'};
            for(Integer i=0; i<Colors.Size(); i++){
                colormap.put(i,Colors[i]);
            } 
        
        /*
colormap.put(00,'#1B4F72');colormap.put(1,'#0E6251');colormap.put(2,'#145A32');colormap.put(3,'#7D6608');colormap.put(4,'#784212');colormap.put(5,'#7B7D7D');
colormap.put(6,'#424949');colormap.put(7,'#17202A');colormap.put(8,'#3498DB');
colormap.put(9,'#FF0000');colormap.put(10,'#FF6C00');colormap.put(12,'#09C603');colormap.put(13,'#03C6C6');colormap.put(14,'#038EC6');colormap.put(15,'#033EC6');
colormap.put(16,'#4A03C6');colormap.put(17,'#8803C6');colormap.put(18,'#C003C6');colormap.put(11,'#C60367');
colormap.put(19,'#D8BFD8');

        events = new list<calEvent>();
        
        
        joblistcal= new List<Job__c>();
        
        soqlJobcal='select Id, Name,Job_Auto_Number__c, Start_Date__c,Due_Date__c,Campaign__r.name,JS_Client__r.name,Media_Types__r.name,Schedule_Template__r.name from Job__c where id != null ';
        
        if(strCampaignName!=Null && strCampaignName.size()>0)
            soqlJobcal+=' And Campaign__r.name=:strCampaignName';
        
        if(JobStatusString !=Null)
            soqlJobcal+=' And Status__c =:JobStatusString ';
        
        if(strmediatype!=null && strmediatype.size()>0)
            soqlJobcal+=' And Media_Types__r.name=:strmediatype';    
        
        if(strJobName!=null && strJobName.size()>0)
            soqlJobcal+=' And name=:strJobName';  
        
        if(strscheduletemp!=null && strscheduletemp.size()>0)
            soqlJobcal+=' And Schedule_Template__r.name=:strscheduletemp';          
        
        if(strClientName !=Null && strClientName.size()>0)
            soqlJobcal+=' And JS_Client__r.name =:strClientName';  
        
        soqlJobcal+=' Limit 1000'; 
        
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>'+strClientName); 
        
        joblistcal=Database.query(soqlJobcal);
        
        integer i=0;
        
        if(joblistcal.size() >0)
        {
            for(Job__c job: joblistcal)
            {
                DateTime startDT = Datetime.now();
                
                DateTime endDT = Datetime.now();
                
                
                if(Job.Start_Date__c == NULL && Job.Due_Date__c == NULL)
                {
                    continue;    
                }
                else if(Job.Start_Date__c == NULL)
                {
                    system.debug('>>>>>>>>>>Job.Due_Date__c>>>>>>>>>>>>>'+Job.Due_Date__c+' ................'+job.id); 
                    startDT = Job.Due_Date__c.addDays(1);
                    endDT = Job.Due_Date__c+2;
                }
                else if(Job.Due_Date__c == NULL)
                {
                    startDT = Job.Start_Date__c+1;
                    //endDT = Job.Start_Date__c+2;
                    endDT = Job.Start_Date__c.addDays(2);
                }
                else
                {
                    startDT = Job.Start_Date__c+1;
                    endDT = Job.Due_Date__c+2;
                }
                
                
                calEvent J= new calEvent();
                // String jobnameescaping = job.name;
                // str.replace(/""/g,'\"');
                // jobnameescaping = jobnameescaping.replace(/""/,'\"');
                // String jobnameescaping1 = jobnameescaping.unescapeJava();
                //system.debug('------------------jobnameescaping1 -------------------'+jobnameescaping);
                String Jname = job.name; 
                String regExp = '["\']';
                Jname = Jname.replaceAll(regExp, '\\ ');
                //  J.title = Jname +' (Job# '+' '+Job.Job_Auto_Number__c+')';
                
                J.title = 'Job :'+' '+Jname +' (Job# '+' '+Job.Job_Auto_Number__c+')';
                J.titleNew = Jname +' - '+' '+Job.Job_Auto_Number__c;
                //J.title = Jname +' ('+''+Job.Job_Auto_Number__c+')';
                J.allDay = true;
                J.startString = startDT.format();
                J.endString = endDT.format();
                J.url = '/' + job.Id;
                j.color=colormap.get(i);
                String JCampname = job.Campaign__r.name; 
                //String regExp = '["\']';
                if(JCampname != NULL)
                    JCampname = JCampname .replaceAll(regExp, '\\ ');
                j.staff = JCampname ;
                String JCliname = job.JS_Client__r.name; 
                //String regExp = '["\']';
                if(JCLIname != NULL)
                    JCliname = JCliname.replaceAll(regExp, '\\ ');
                j.client1 = JCLIname;
                J.className = 'event-Jobs';
                events.add(J);
                if(i == Colors.Size()-1)
                    i=0;
                else
                    i++;  
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No Jobs to display from this criteria'));
        }
        
        
        return null;
    }
    
    //Get Task
    public PageReference JobTask() 
    {
        
        system.debug('----> i am jobtask--->');
        Jscampaign=false;
        Jobs=false;
        Task=true;
        strstafftemp = new list<String>();
        strroletemp = new list<string>();
        /*
colormap.put(00,'#000000');colormap.put(1,'#006633');colormap.put(2,'#330033');colormap.put(3,'#66CC66');colormap.put(4,'#000066');colormap.put(5,'#6A5ACD');colormap.put(6,'#6B8E23');colormap.put(7,'#708090');colormap.put(8,'#800000');colormap.put(9,'#800080');
colormap.put(10,'#00CC00');colormap.put(11,'#CCCCCC');colormap.put(12,'#FF0099');colormap.put(13,'#FF66CC');colormap.put(14,'#DA70D6');colormap.put(15,'#006400');colormap.put(16,'#FF8C00');colormap.put(17,'#4B0082');colormap.put(18,'#808000');colormap.put(19,'#D8BFD8');
colormap.put(20,'#33CC00');colormap.put(21,'#6666FF');colormap.put(22,'#2E8B57');colormap.put(23,'#996633');colormap.put(24,'#3399FF');colormap.put(25,'#336633');colormap.put(26,'#6666CC');colormap.put(27,'#CC0066');colormap.put(28,'#336699');colormap.put(29,'#330066');
colormap.put(30,'#00CC99');colormap.put(31,'#3366CC');colormap.put(32,'#CC6633');colormap.put(33,'#3366FF');colormap.put(34,'#660066');colormap.put(35,'#99CC66');colormap.put(36,'#00CCCC');colormap.put(37,'#99CCCC');colormap.put(38,'#66CC33');colormap.put(39,'#CC66CC');
colormap.put(40,'#006699');colormap.put(41,'#990033');colormap.put(42,'#666699');colormap.put(43,'#990000');colormap.put(44,'#336600');colormap.put(45,'#66CCCC');colormap.put(46,'#660033');colormap.put(47,'#9900FF');colormap.put(48,'#666666');colormap.put(49,'#FF00FF');
colormap.put(50,'#330000');colormap.put(51,'#66CCFF');colormap.put(52,'#9900CC');colormap.put(53,'#33CCFF');colormap.put(54,'#990099');colormap.put(55,'#0066CC');colormap.put(56,'#33CC66');colormap.put(57,'#66CC00');colormap.put(58,'#00CC33');colormap.put(59,'#99CCFF');
colormap.put(60,'#666600');colormap.put(61,'#CC0099');colormap.put(62,'#99CC99');colormap.put(63,'#6600FF');colormap.put(64,'#CCCC66');colormap.put(65,'#FF6699');colormap.put(66,'#CCCC99');colormap.put(67,'#FF6666');colormap.put(68,'#9966CC');colormap.put(69,'#CC66FF');
colormap.put(70,'#990066');colormap.put(71,'#99CC33');colormap.put(72,'#FF6600');colormap.put(73,'#CC6699');colormap.put(74,'#FF66FF');colormap.put(75,'#3300FF');colormap.put(76,'#CCCCFF');colormap.put(77,'#006666');colormap.put(78,'#CC00CC');colormap.put(79,'#996666');
colormap.put(80,'#99CC00');colormap.put(81,'#FFCC99');colormap.put(82,'#33CC33');colormap.put(83,'#FF00CC');colormap.put(84,'#33CC99');colormap.put(85,'#FF0066');colormap.put(86,'#660099');colormap.put(87,'#0000CC');colormap.put(88,'#CC00CC');colormap.put(89,'#006600');
colormap.put(90,'#FF0000');colormap.put(91,'#3300CC');colormap.put(92,'#996699');colormap.put(93,'#FFCC00');colormap.put(94,'#00CCFF');colormap.put(95,'#66CC99');colormap.put(96,'#00CC66');colormap.put(97,'#9966FF');colormap.put(98,'#330099');colormap.put(99,'#FFCCFF');

        list<string> Colors = new list<string>{'Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen',
                       'Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green',
                       'HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy',
                       'Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','SlateBlue',
                       'SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod',
                       'DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick',
                       'ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown',
                       'SeaGreen','SeaShell','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson',
                       'DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink',
                       'DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple',
                       'MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown',
                       'Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue',
                       'Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue',
                       'DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell',
                       'Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen',
                       'Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green',
                       'HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy',
                       'Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','SlateBlue',
                       'SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod',
                       'DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick',
                       'ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown',
                       'SeaGreen','SeaShell','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson',
                       'DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink',
                       'DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple',
                       'MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown',
                       'Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue',
                       'Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkRed','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue',
                       'DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','SeaShell',
                       'Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab'};
            for(Integer i=0; i<Colors.Size(); i++){
                colormap.put(i,Colors[i]);
            } 
        
        
        events = new list<calEvent>();
        
        
        integer i=0;
        
        // joblist = [select id,Dummy_Text_6__c,status__c from job__C where status__C != 'completed'];
        
        // jobTask= new List<Job_Task__c>();
        Date myDate = system.today();
        String completed = 'completed';
        //  String false= 'false';
        soqlJobTask='Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.Media_Types__r.name,Job__r.Schedule_Template__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__r where marked_done__c=false';
        soqlJobTaskForJobs='Select Job__c from Job_Task__c where marked_done__c=false';
        if(strtaskname!=Null && strtaskname.size()>0){
            soqlJobTask+=' And name=:strtaskname';
            soqlJobTaskForJobs+=' And name=:strtaskname';
        } 
        if(strCampaignName!=Null && strCampaignName.size()>0){
            soqlJobTask+=' And Job__r.campaign__r.name=:strCampaignName';
            soqlJobTaskForJobs+=' And Job__r.campaign__r.name=:strCampaignName';
        }
        if(JobStatusString !=Null){
            soqlJobTask+=' And Job__r.status__c=:JobStatusString ';
            soqlJobTaskForJobs+=' And Job__r.status__c=:JobStatusString ';
        }
        if(strmediatype!=null && strmediatype.size()>0){
            soqlJobTask+=' And Job__r.Media_Types__r.name=:strmediatype';
             soqlJobTaskForJobs+=' And Job__r.Media_Types__r.name=:strmediatype';
        }
        if(strscheduletemp!=null && strscheduletemp.size()>0){
            soqlJobTask+=' And Job__r.Schedule_Template__r.name=:strscheduletemp';
             soqlJobTaskForJobs+=' And Job__r.Schedule_Template__r.name=:strscheduletemp';
        }
        if(strClientName !=Null && strClientName.size()>0){
            soqlJobTask+=' And Job__r.JS_Client__r.name =:strClientName';
             soqlJobTaskForJobs+=' And Job__r.JS_Client__r.name =:strClientName';
        }
        if(strstaff !=null && strstaff.size()>0)
        {
            for(String str : strstaff )
            {
                strstafftemp.add('%'+str+'%');
            }
            soqlJobTask+=' And Assigned_Users__c  like :strstafftemp';
             soqlJobTaskForJobs+=' And Assigned_Users__c  like :strstafftemp';
        }
        if(strrole!=null && strrole.size()>0)
        {
            for(String role: strrole)
            {
                //strroletemp.add(role);
                strroletemp.add('Schedule_Roles__c includes (:role)');
                
            }
            String strroletempstring = String.join(strroletemp,' or ');
            System.debug('---------------------strroletempstring ---------------------'+strroletempstring );        
            //soqlJobTask+=' And Schedule_Roles__c includes (:strroletempstring )';
            soqlJobTask+=' And ( strroletempstring )';
            soqlJobTaskForJobs+=' And ( strroletempstring )';
            System.debug('---------------------soqlJobTask---------------------'+soqlJobTask);
             System.debug('---------------------soqlJobTaskForJobs---------------------'+soqlJobTaskForJobs);
            soqlJobTask = soqlJobTask.replace('strroletempstring',strroletempstring);
            soqlJobTaskForJobs = soqlJobTaskForJobs.replace('strroletempstring',strroletempstring);
        }
        
        if(strJobName !=null && strJobName .size()>0){
            soqlJobTask+=' And Job__r.Name =:strJobName';
            soqlJobTaskForJobs+=' And Job__r.Name =:strJobName';
        }
        // jobTask=Database.query(soqlJobTask);
        String qStr = 'select id,Dummy_Text_6__c,status__c,('+String.escapeSingleQuotes(soqlJobTask)+') from job__C where status__C =:JobStatusString and id in ('+String.escapeSingleQuotes(soqlJobTaskForJobs)+') limit 75';
        System.debug('---------------------qStr ---------------------'+qStr);
        joblist =Database.query(qStr);
        system.debug('joblist  size()  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+joblist.size() );
        system.debug('joblist task  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+joblist );
        
        
        //   Joblist=Database.query('select Id, Name,Job_Auto_Number__c, Start_Date__c,Due_Date__c,('+soqlJobTask+') from Job__c where status__C<>completed');
        
        
        //  integer i=0;
        
        
        if(joblist.size() >0)
        {
            for(Job__c job : joblist)
            {
                for(Job_Task__c  jobt: job.Job_Task__r)
                {    
                    //DateTime startDT = job.Job__r.Start_Date__c+1;
                    DateTime endDT = jobt.Revised_Due_Date__c+1;
                    
                    calEvent J= new calEvent();
                    
                    string strTaskName =jobt.Name;
                    string strJobName = jobt.Job__r.Name;
                    String Taskname = jobt.Name; 
                    String regExp = '["\']';
                    if(Taskname  != NULL)
                        Taskname = Taskname .replaceAll(regExp, '\\ ');
                    
                    J.title = Taskname +', Job - # '+jobt.Job__r.Job_Auto_Number__c;     // Task Name, Job - # 100
                    J.titleNew = Taskname +' - '+jobt.Job__r.Job_Auto_Number__c;
                    J.allDay = true;
                    J.startString = endDT.format();
                    J.endString = endDT.format();
                    if(UserInfo.getUiTheme() == 'Theme4d'){
                        J.url = '/'+jobt.Job__c;
                    }
                    else{
                        J.url = '/apex/JobListView?id='+jobt.Job__c+'&intFocus=2';
                    }
                    String TaskCampname = jobt.Job__r.campaign__r.name; 
                    //String regExp = '["\']';
                    if(TaskCampname != NULL)
                        TaskCampname = TaskCampname .replaceAll(regExp, '\\ ');
                    
                    String TaskJobname = jobt.Job__r.Name; 
                    //String regExp = '["\']';
                    if(TaskJobname != NULL)
                        TaskJobname = TaskJobname .replaceAll(regExp, '\\ ');
                    
                    j.JN1 = TaskCampname  +' : '+TaskJobname +'id='+jobt.id; // Use this field to send the campaign name and Job Name and task id(only in task)
                    String TaskJobCliname = jobt.Job__r.JS_Client__r.name; 
                    //String regExp = '["\']';
                    if(TaskJobCliname != NULL)
                        TaskJobCliname = TaskJobCliname .replaceAll(regExp, '\\ ');
                    
                    j.client1 = TaskJobCliname;
                    j.color=colormap.get(i);
                    String TaskUsersname = jobt.Assigned_Users__c; 
                    //String regExp = '["\']';
                    if(TaskUsersname != NULL)
                        TaskUsersname = TaskUsersname .replaceAll(regExp, '\\ ');
                    
                    j.Staff= TaskUsersname ;
                    J.className = 'event-Jobs';
                    events.add(J);
                    system.debug('>>>>>>>>>>>>>>>>>>>>////////////////////////////////////////////////'+events);
                }
                if(i == Colors.Size()-1)
                    i=0;
                else
                    i++;
            }
            system.debug('--events---'+events.size());
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No Tasks to display from this criteria'));
        }
        return null;      
    } 
    
    
    
    public PageReference JobTaskTime() 
    {
        // PageReference pageRef = new PageReference('/apex/CalendarsTaskTime');
        PageReference pageRef = Page.CalendarsTaskTime;
        pageRef.setredirect(True);
        return pageRef;
    }
    
    
    public PageReference toggleMyJobs() 
    {
        if(includeMyJobs)
        {
            includeMyJobs = false;
        }
        else
        {
            includeMyJobs = true;
        }
        JSCampaign();
        
        return null;
    }
    
    /* public PageReference printcal() 
{
PageReference pageRef = new PageReference('/apex/calendarprint');
//  pageref.setredirect(true);
return pageref;
}*/
    
    // Start of Remote Action
    @RemoteAction
    global static boolean updateJSCampaign(String name, String cntid, String endate, String stdate,string jn) 
    {
        
       /* list<Campaign__c> campList = new list<Campaign__c>();
        list<job__c> jobList = new  list<job__c>();
        String id1 = cntid.Substring(cntid.length()-18,cntid.length());
        String name2 = name.Substring(0,2);
        Campaign__c cam = new Campaign__c();
        String name1 = '%'+name2+'%';
        integer eyear = integer.valueof(endate.substring(0,4));
        integer emonth = integer.valueof(endate.substring(5,7));
        integer eday = integer.valueof(endate.substring(8,10));
        integer syear = integer.valueof(stdate.substring(0,4));
        integer smonth = integer.valueof(stdate.substring(5,7));
        integer sday = integer.valueof(stdate.substring(8,10));
        //  Date ed = Date.newInstance(eyear,emonth,eday-1);
        // Date sd = Date.newInstance(syear,smonth,sday-1);
        System.debug('::::::::::::::Hello before IF::::::::::::::::::::'+name.substring(0, 11));
        if(name.substring(0, 11) == 'JS Campaign')
        {
            Date ed = Date.newInstance(eyear,emonth,eday-1);
            Date sd = Date.newInstance(syear,smonth,sday);
            
            cam = [select Id, Name, Start_Date__c, End_Date__c from Campaign__c where id = :id1];
            if(schema.SobjectType.Campaign__c.Fields.End_Date__c.isUpdateable()){
                cam.End_Date__c = ed;
            }
            if(schema.SobjectType.Campaign__c.Fields.Start_Date__c.isUpdateable()){
                cam.Start_Date__c = sd;
            }
            //upsert cam;
            
            if(Schema.sObjectType.Campaign__c.isUpdateable()){
                update cam; 
            }
            
            
        }
        else if(name.Substring(0,3) == 'Job' || jn == 'true')
        {
            Date ed = Date.newInstance(eyear,emonth,eday-1);
            Date sd = Date.newInstance(syear,smonth,sday);
            
            Job__c job = new Job__C();
            job = [select Id, Name, Job_Description__c,Start_Date__c,Due_Date__c from Job__c where id = :id1];
            if(schema.SobjectType.Job__c.Fields.Start_Date__c.isUpdateable()){
                job.Start_Date__c = sd;
            }
            if(schema.SobjectType.Job__c.Fields.Due_Date__c.isUpdateable()){
                job.Due_Date__c = ed;
            }
            //upsert job; 
            if(Schema.sObjectType.Job__c.isUpdateable()){
                update job; 
            }
        
            
        }
        
        else
        {
            System.debug(':::::::::::::Entered:::::::::::::::'+name.substring(0, 11));
            Date sd = Date.newInstance(syear,smonth,sday);
            Date ed = Date.newInstance(eyear,emonth,eday-1);
            String taskID = jn.Substring(jn.indexof('id')+3,jn.indexof('id')+3+18);
            //String taskID = jn;
            system.debug('<<<<<<<<<Task ID is>>>>>>>>>>>>>>>>>>>'+taskID);
            
            Set<Date> holidaysNew= new Set<Date>();
            for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED])
            {
                holidaysNew.add(hc.Date__c);
            } 
            DateTime NextTaskStartDate;
            //code for the update of the current schedule 
            Job_Task__c jobTask1,jobTask2,objJobTask;
            
            jobTask1= new Job_Task__c();
            jobTask1.id=taskID;
            //jobTask=[Select Id,Name,Revised_Due_Date__c,Status__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.Name,Job__r.campaign__r.name,Job__r.status__c,Job__r.JS_Client__r.name,Assigned_Users__c,Schedule_Roles__c from Job_Task__c where id = :taskID WITH SECURITY_ENFORCED];
            if(schema.SobjectType.Job_Task__c.Fields.Revised_Due_Date__c.isUpdateable()){
                jobTask1.Revised_Due_Date__c = sd;
            }
            
            if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                update jobTask1; 
            }
            objJobTask = [Select Id, Name, Job__c, Job__r.Name,Job__r.Schedule_Calc__c, Due_Date__c,Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Id =: jobTask1.Id WITH SECURITY_ENFORCED LIMIT 1];
            Boolean blnFroward = true;
            if(objJobTask.Job__r.Schedule_Calc__c == 'End Date')
            {
                blnFroward = false;
            }  
            if(!blnFroward )
            {
                System.debug('Job Name is : '+ objJobTask.Job__r.Name);
                //code for updating the start date of the current task
                Integer jCount = 0;
                //Integer newDaysValue = objJobTask.Days__c;
                Datetime dtStartDate=DateTime.newInstance(syear,smonth,sday);
                System.debug('jCount value '+jCount);
                
                while(true)
                {
                    System.debug('jCount value in while '+jCount);
                    Date d3=Date.newInstance(dtStartDate.Year(),dtStartDate.Month(),dtStartDate.Day());
                    if(dtStartDate.format('E')!='Sat' && dtStartDate.format('E')!= 'Sun'&& (!holidaysNew.contains(d3)))
                    {
                        jCount = jCount + 1;
                        if(jCount > objJobTask.Days__c)
                        {
                            break;
                        }
                        dtStartDate = dtStartDate.addDays(-1);
                        
                    }
                    else
                    {
                        dtStartDate = dtStartDate.addDays(-1);
                        System.debug('=====dtStartDate ===='+dtStartDate);                                          
                        continue;
                    }
                }
                Date afterDaysUpdate = Date.newInstance(dtStartDate .Year(), dtStartDate .Month(), dtStartDate .Day());
                system.debug('=========afterDaysUpdate =========='+afterDaysUpdate);
                 if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                     objJobTask.Start_Date__c = afterDaysUpdate;}
                 if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                     update objJobTask;}
            } 
            
            
            System.debug('Update current Job Task : '+jobTask1);
            System.debug('jn : '+jn);
            if(true)
            {                        
                
                // Now retrive all those tasks which are below the current tasks ( Not marked Done) for this current job
                Date startDateForNextTask ;
                if(blnFroward)
                {
                    startDateForNextTask = Date.newInstance(objJobTask.Revised_Due_Date__c.Year(),objJobTask.Revised_Due_Date__c.month(),objJobTask.Revised_Due_Date__c.Day());
                }
                else
                {
                    startDateForNextTask = Date.newInstance(objJobTask.Start_Date__c.Year(),objJobTask.Start_Date__c.month(),objJobTask.Start_Date__c.Day());
                }
                
                List<Job_Task__c> lstJobTasks ;//= [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: jobId and Id!=: objJobTask.Id and Marked_Done__c =: False Order BY Task_Order__c ASC];
                
                if(blnFroward)
                {
                    lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c >=: objJobTask.Task_Order__c and Job__c =: id1 and Id!=: objJobTask.Id and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];
                }
                else
                {
                    lstJobTasks = [Select Id, Name, Status__c, Start_Date__c, Due_Date__c, Revised_Due_Date__c,Days__c, Task_Order__c From Job_Task__c where Task_Order__c <=: objJobTask.Task_Order__c and Job__c =: id1 and Id!=: objJobTask.Id and Marked_Done__c =: False WITH SECURITY_ENFORCED Order BY Task_Order__c DESC];
                }
                System.debug('Need to update remaining Job Tasks : '+lstJobTasks);
                
                System.debug('Size of Update Tasks : '+lstJobTasks.size());
                
                for(Integer i = 0; i <lstJobTasks.size(); i++)
                {
                    System.debug('Value of i' +i);
                    DateTime dtStartDate3;
                    if(i == 0)
                    {
                         if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                             lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                        if(blnFroward)
                        {
                             if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                 lstJobTasks[i].Start_Date__c = startDateForNextTask;}
                            dtStartDate3=DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                            
                        }
                        else
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c = startDateForNextTask;}
                            dtStartDate3= DateTime.newInstance(startDateForNextTask.Year(),startDateForNextTask.Month(),startDateForNextTask.Day());
                            
                            
                        }
                    }
                    else
                    {
                        Date d4 = Date.newInstance(NextTaskStartDate.Year(), NextTaskStartDate.Month(), NextTaskStartDate.Day());
                        if(blnFroward)
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                lstJobTasks[i].Start_Date__c = d4;}
                            dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                        }
                        else
                        {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c = d4;}
                            dtStartDate3 = DateTime.newInstance(d4.Year(),d4.Month(),d4.Day());
                        }
                        
                    }
                    
                    
                    
                    
                    System.debug('Day is:'+dtStartDate3.format('E'));
                    
                    System.debug('Start Date is : ' +dtStartDate3);
                    if(Schema.sObjectType.Job_Task__c.fields.Days__c.isUpdateable()){
                        lstJobTasks[i].Days__c = lstJobTasks[i].Days__c;}
                    
                    Integer jCount=0;
                    
                    // To calculate Due Date, Revised Due Date
                    while(true)
                    {
                        Date d3 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                        
                        // Skip Holiday, Sat- Sun, while calculating Due Date and Revised Due Date
                        if((dtStartDate3.format('E')!='Sat'&&dtStartDate3.format('E')!='Sun') && ! (holidaysNew.contains(d3)))
                        {
                            jCount=jCount+1;
                            if(jCount>lstJobTasks[i].Days__c)
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
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }                                   
                            system.debug('After adding 1 day : ' +dtStartDate3);
                        }
                        else
                        {
                            system.debug('==========' + dtStartDate3);                                     
                            if(blnFroward)
                            {
                                dtStartDate3=dtStartDate3.addDays(1);
                            }
                            else
                            {
                                dtStartDate3=dtStartDate3.addDays(-1);
                            }  
                            continue;
                        }
                    }
                    system.debug('Calculation============' +dtStartDate3);
                    
                    Date d1 = Date.newInstance(dtStartDate3.Year(),dtStartDate3.Month(),dtStartDate3.Day());
                    system.debug('D1============' +dtStartDate3);
                    
                    if(blnFroward)
                    {
                            if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                                lstJobTasks[i].Revised_Due_Date__c=d1;}
                        system.debug('Revise due============' +lstJobTasks[i].Revised_Due_Date__c); 
                    }
                    else
                    {
                        if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            lstJobTasks[i].Start_Date__c=d1;}
                    }    
                    NextTaskStartDate = DateTime.valueOf(dtStartDate3);
                }
                 if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                     update lstJobTasks;}
                System.debug('Updated List : '+lstJobTasks);
            }
				
              
        }*/
        
        return true;
        
    }
    // End of Remote Action
    /*    
    public PageReference clearForm() 
    {
        
        if(strstaff!=null && strstaff.size()>0)
        {
            strstaff.clear();
            JobTask(); 
        }
        if(strrole!=null && strrole.size()>0)
        {
            strrole.clear();
            JobTask(); 
        }
        
        if(strtaskname!=null && strtaskname.size()>0)
        {
            strtaskname.clear();
            JobTask(); 
        }
        
        if(strClientName!=null && strClientName.size()>0)
        {
            strClientName.clear();
            if(Jobs == false)
            {
                JobTask();
            }
            else
            {
                Job(); 
            }
            
        }
        
        if(strscheduletemp!=null && strscheduletemp.size()>0)
        {
            strscheduletemp.clear();
            if(Jobs == false)
            {
                JobTask();
            }
            else
            {
                Job(); 
            }
            
        }
        
        if(strmediatype!=null && strmediatype.size()>0)
        {
            strmediatype.clear();
            if(Jobs == false)
            {
                JobTask();
            }
            else
            {
                Job(); 
            }
            
        }
        
        if(strCampaignName!=null && strCampaignName.size()>0)
        {
            strCampaignName.clear();
            if(Jobs == false)
            {
                JobTask();
            }
            else
            {
                Job(); 
            }
        }
        
        
        if(strJobName!=null && strJobName.size()>0)
        {
            strJobName.clear();
            if(Jobs == false)
            {
                JobTask();
            }
            else
            {
                Job(); 
            }
        }
        
        return null;
    } 
    
    
    //Class to hold calendar event data
    public class calEvent
    {
        public string titleNew {get;set;}
        public String title {get;set;}
        public Boolean allDay {get;set;}
        public String startString {get;set;}
        public String endString {get;set;}
        public String url {get;set;}
        public string color{get;set;}
        public String JN1{get;set;} //jobnumber
        public String client1{get;set;}
        public String Staff{get;set;} // used for assigning task staff and used for assigning campaign of the job
        public String className {get;set;}
    }*/
}