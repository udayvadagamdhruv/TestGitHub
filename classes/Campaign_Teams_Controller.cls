public with sharing class Campaign_Teams_Controller {
    
    @AuraEnabled
    public static list<TeamWrapper> getTeamPhotos(Id recordId) {
        system.debug(recordId);
        list<TeamWrapper> teamwrappelst=new list<TeamWrapper>();
        List < Campaign_Team__c > lstJobTeam = [Select Id, Role__c, Staff__c,Email__c from Campaign_Team__c where Campaign_Template__c = : recordId WITH SECURITY_ENFORCED order by CreatedDate];
        //List < Campaign_Team__c > lstJobTeam = [Select Id, Role__c, Staff__c, Job__r.Name from Job_Team__c where Job__c = : recordId order by CreatedDate];
        
        List < String > staffNames = new List < String > ();
        Map<String,Campaign_Team__c> gg=new  Map<String,Campaign_Team__c>();
        for (Campaign_Team__c Tstaff: lstJobTeam) {
            gg.put(Tstaff.Staff__c,Tstaff);
            staffNames.add(Tstaff.Staff__c);
        }
        
        Map < SObject, String > TeamImageURlMap = new Map < SObject, String > ();
        list < User > Userlist = new list < User > ();
        
        Userlist = [Select Id, Name, SmallPhotoUrl, FullPhotoUrl From User where Name IN: staffNames and ( User_Types__c!=null OR IsClientContact__c=true OR IsVendorContact__c=true)]; // WITH SECURITY_ENFORCED
        for (User a: Userlist) {
            if(!a.FullPhotoUrl.contains('/profilephoto/005/F')){
                teamwrappelst.add(new TeamWrapper(gg.get(a.Name),a.FullPhotoUrl));
                TeamImageURlMap.put(gg.get(a.Name), a.FullPhotoUrl);
            }
        }
        
        for (Campaign_Team__c Tstaff: lstJobTeam) {
            if (!TeamImageURlMap.Containskey(gg.get(Tstaff.Staff__c))) {
                teamwrappelst.add(new TeamWrapper(Tstaff,''));
                TeamImageURlMap.put(Tstaff, '');
            }
        }
        
        system.debug('=====TeamImageURlMap=====' + TeamImageURlMap);
        system.debug('==========lstJobTeam=====' + lstJobTeam);
        return teamwrappelst;
    }
    
    
    public class TeamWrapper{
        @AuraEnabled public Campaign_Team__c team {set;get;}
        @AuraEnabled public string photoUrl {set;get;}
        
        public TeamWrapper(Campaign_Team__c jt,String phourl ){
            this.team=jt;
            this.photoUrl=phourl;
        }
        
    }
    
    
    //Start Adding staffs to team
    @AuraEnabled
    public static String AddstafftoJobTeam(String CTempId,String selectedJobTeam) {
        System.debug('==Add Staff Json Sting===='+selectedJobTeam);
        Map<String,Campaign_Team__c> staffJobTeamMap = new Map<String,Campaign_Team__c>();
        Set < string > staffNameSet = new Set < String > ();
        List < Campaign_Team__c > lstCampaignTeam = [Select Id, Role__c, Staff__c,Email__c from Campaign_Team__c where Campaign_Template__c = : CTempId WITH SECURITY_ENFORCED order by CreatedDate];
        //List<StaffWrappers> AllstaffWrappers = (List<StaffWrappers>)JSON.deserialize(selectedJobTeam, List<StaffWrappers>.class);
        List<Object> AllstaffWrappers = (List<Object>)JSON.deserializeUntyped(selectedJobTeam);
        System.debug('==jsonlist===='+AllstaffWrappers);
        for (Campaign_Team__c jt: lstCampaignTeam) {
            staffNameSet.add(jt.Staff__c);
            staffJobTeamMap.put(jt.Staff__c, jt);
        }
        if (!AllstaffWrappers.isEmpty()) {
            
            List <Campaign_Team__c>  AddJobTeam = new List < Campaign_Team__c > ();
            List < Campaign_Team__c > deleteJobteam = new List < Campaign_Team__c > ();
            //List < Job_Task_Role__c > lstJTRDelete = new List < Job_task_Role__c > ();
            
            for (Object apw: AllStaffWrappers) {
                Map<String,Object> mapstaff=(Map<String,Object>)apw;
                boolean existing = staffNameSet.contains(string.valueof(mapstaff.get('Staffname'))); //(apw.staff.First_Name__c+' '+apw.staff.Last_Name__c);
                
                if ( boolean.valueOf(mapstaff.get('selection')) == True) {
                    if (!existing)
                    {
                        Campaign_Team__c cpt=new Campaign_Team__c();                        
                        if(Schema.sObjectType.Campaign_Team__c.fields.Campaign_Template__c.isCreateable()){cpt.Campaign_Template__c = CTempId;}
                        if(Schema.sObjectType.Campaign_Team__c.fields.Role__c.isCreateable()){cpt.Role__c =string.valueof(mapstaff.get('Rolename'));}
                        if(Schema.sObjectType.Campaign_Team__c.fields.Staff__c.isCreateable()){cpt.Staff__c = string.valueof(mapstaff.get('Staffname'));} 
                        if(Schema.sObjectType.Campaign_Team__c.fields.Email__c.isCreateable()){cpt.Email__c = string.valueof(mapstaff.get('Email'));}
                        AddJobTeam.add(cpt); 
                    }
                } else if (existing) {
                    
                    if (staffJobTeamMap.containsKey(string.valueof(mapstaff.get('Staffname')))) {
                        Campaign_Team__c objJTR = staffJobTeamMap.get(string.valueof(mapstaff.get('Staffname')));
                        system.debug('HERE1' + objJTR);
                        
                      /*  lstJTRDelete = [Select Id, Job_Task__c, Job_Task__r.Job__c from Job_Task_Role__c where Name = : objJTR.Role__c and Job_Task__r.Job__c = : objJTR.job__c AND User__c = : objJTR.Staff__c];
                        
                        system.debug('HERE2' + lstJTRDelete);
                        
                        if (lstJTRDelete.size() > 0)
                            if (!Job_Task_Role__c.sObjectType.getDescribe().isDeletable()) {
                                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient access'));
                                return 'Insufficient access to Delete Job Task Role.';
                                
                            } else {
                                delete lstJTRDelete;
                            }
                     */
                        deleteJobteam.add(objJTR);
                        
                    }
                }
                
            }
            
            if (!AddJobTeam.isEmpty()) {
                if (!Campaign_Team__c.sObjectType.getDescribe().isCreateable()) {
                    return 'Insufficient access to Create  Team.';
                } else {
                    insert AddJobTeam;
                }
                
            }
            
            if (!deleteJobteam.isEmpty()) {
                if (!Campaign_Team__c.sObjectType.getDescribe().isDeletable()) {
                    return 'Insufficient access to Delete the  Team.';
                } else {
                    delete deleteJobteam;
                }
                
            }
            return 'OK'; 
        }
        return 'OK';
    }
    //End method Adding staffs to team

    @AuraEnabled
    public static  list<StaffWrappers>  JobTeamAddEditStaffCont(String recordId) {
        system.debug('==staffwrapper=recordId===='+recordId);
        list<StaffWrappers>  AllstaffWrappers = new List<StaffWrappers>();       
        Set<String> StaffNameJobTeam =new Set<String>();
        List<Staff__c> staffs = new List<Staff__c>();
        Set<Id> sTempset=new Set<Id>(); 
        Campaign_Template__c  camTemp=[select Id,Name, (select Id,Name,Creative_Brief_Template__c,Schedule_Template__c,Media_Type__c from Campaign_Jobs__r) from Campaign_Template__c where id =:recordId WITH SECURITY_ENFORCED];
        for(Campaign_Jobs__c cJob:camTemp.Campaign_Jobs__r){
            sTempset.add(cJob.Schedule_Template__c);
        }
        //String  clientid=jobrecord.JS_Client__c;
        //system.debug('ClientId'+clientid);
        list<Campaign_Team__c> campaignTeams=[Select Id, Role__c,Staff__c, Campaign_Template__c from Campaign_Team__c where Campaign_Template__c =:recordId WITH SECURITY_ENFORCED order by CreatedDate];
        
        Set<string> Srole=new Set<String>();
        Set<Id> Staskid=new Set<Id>();
        
        
        List<Schedule_Task__c> STaskslist=[select id,name,Schedule_Template__c,(select id,name  from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c IN:sTempset WITH SECURITY_ENFORCED];
        
        for(Schedule_Task__c st:STaskslist){
            Staskid.add(st.id);
        }
        system.debug('=====Staskid==='+Staskid);
        
        List<ScheduleTaskRole__c> STRolelist =[select id,name from ScheduleTaskRole__c where Schedule_Task__c IN:Staskid WITH SECURITY_ENFORCED];
        for(ScheduleTaskRole__c str:STRolelist ){
            Srole.add(str.name);
        }
        system.debug('===SRoles====='+Srole);
        
        Set<string> staffNameSet = new Set<String>();
        Map<String,Campaign_Team__c> staffJobTeamMap = new Map<String,Campaign_Team__c>();
        
        String query ='SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Role__c,Username__c from Staff__c where Active__c=true and IsDeleted__c=False WITH SECURITY_ENFORCED order by Role__c,name';
        
        staffs = Database.query(query);
        
        if(!staffs.isEmpty()){
            for(Campaign_Team__c jt :campaignTeams){
                staffNameSet.add(jt.Staff__c);
                staffJobTeamMap.put(jt.Staff__c,jt);
            }
            
            
            for(Staff__c s:staffs){
                
                if(! staffNameSet.contains(s.name))//(s.First_Name__c+' '+s.Last_Name__c))
                    AllstaffWrappers.add(new StaffWrappers(s,String.valueof(s.getSobjectType()),Srole.contains(s.role__C)));
                
                else{ 
                    StaffWrappers w =new StaffWrappers(s,String.valueof(s.getSobjectType()),Srole.contains(s.role__C));
                    w.selection = TRUE; 
                    AllstaffWrappers.add(w);
                    StaffNameJobTeam.add(s.name); 
                }
            }
        } 
        System.debug('=====AllstaffWrappers debug==='+AllstaffWrappers);
        return AllstaffWrappers;
    }
    
    
    @AuraEnabled
    public static list < StaffWrappers > SerachStaffforCampaignTeam(String CTempId, String StatusString) {
        //String clientid;
        list < Staff__c > staffs = new list < Staff__c > ();
        list < Client_Contact__c > CCs = new list < Client_Contact__c > ();
        list < Vendor_Contact__c > VCs = new list < Vendor_Contact__c > ();
        Map<String,Campaign_Team__c> staffJobTeamMap = new Map<String,Campaign_Team__c>();
        Set<String> StaffNameJobTeam =new Set<String>();
        Set < string > staffNameSet = new Set < String > ();
        Set < string > Srole = new Set < String > ();
        Set < Id > Staskid = new Set < Id > ();
        Set<Id> sTempset=new Set<Id>(); 
            
        list < StaffWrappers > AllstaffWrappers = new List < StaffWrappers > ();
        
        list < Campaign_Team__c > lstCampaignTeam = [Select Id, Role__c, Staff__c,Campaign_Template__c from Campaign_Team__c where Campaign_Template__c = : CTempId WITH SECURITY_ENFORCED order by CreatedDate];
        Campaign_Template__c  camTemp=[select Id,Name, (select Id,Name,Creative_Brief_Template__c,Schedule_Template__c,Media_Type__c from Campaign_Jobs__r) from Campaign_Template__c where Id =:CTempId WITH SECURITY_ENFORCED];
        for(Campaign_Jobs__c cJob:camTemp.Campaign_Jobs__r){
            sTempset.add(cJob.Schedule_Template__c);
        }
        
        List < Schedule_Task__c > STaskslist = [select id, name, Schedule_Template__c, (select id, name from ScheduleTaskRole__r) from Schedule_Task__c where Schedule_Template__c IN:sTempset WITH SECURITY_ENFORCED];
        for (Schedule_Task__c st: STaskslist) {
            Staskid.add(st.id);
        }
        
        List < ScheduleTaskRole__c > STRolelist = [select id, name from ScheduleTaskRole__c where Schedule_Task__c in : Staskid WITH SECURITY_ENFORCED];
        for (ScheduleTaskRole__c str: STRolelist) {
            Srole.add(str.name);
            system.debug('SRoles' + Srole);
        }
        
           
        if (StatusString == 'All') {
            
            //Staff Operation Details
            
            String query = 'SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Role__c,Username__c from Staff__c where Active__c=true and IsDeleted__c=False WITH SECURITY_ENFORCED order by Role__c,name';
            
            staffs = Database.query(query);
            
            if (!staffs.isEmpty()) {
                for (Campaign_Team__c jt: lstCampaignTeam) {
                    staffNameSet.add(jt.Staff__c);
                    staffJobTeamMap.put(jt.Staff__c, jt);
                }
                
                for (Staff__c s: staffs) {
                    
                    if (!staffNameSet.contains(s.name)) //(s.First_Name__c+' '+s.Last_Name__c))
                        AllstaffWrappers.add(new staffWrappers(s, String.valueof(s.getSobjectType()), Srole.contains(s.role__C)));
                    
                    else {
                        staffWrappers w = new staffWrappers(s, String.valueof(s.getSobjectType()), Srole.contains(s.role__C));
                        w.selection = TRUE;
                        AllstaffWrappers.add(w);
                        StaffNameJobTeam.add(s.name);
                    }
                }
            }
            //End Staff Operation Details
            
            //Vendor Contact Operation Details
            
            String query2 = 'SELECT id,name,Active__c,First_Name__c,Email__c,Last_Name__c,Role__c,User_Name__c from Vendor_Contact__c where Active__c=true WITH SECURITY_ENFORCED order by Role__c,name';
            
            VCs = Database.query(query2);
            
            if (!VCs.isEmpty()) {
                for (Campaign_Team__c jt: lstCampaignTeam) {
                    staffNameSet.add(jt.Staff__c);
                    staffJobTeamMap.put(jt.Staff__c, jt);
                }
                
                for (Vendor_Contact__c v: VCs) {
                    
                    if (!staffNameSet.contains(v.name)) //(s.First_Name__c+' '+s.Last_Name__c))
                        AllstaffWrappers.add(new staffWrappers(v, String.valueof(v.getSobjectType()), Srole.contains(v.Role__c)));
                    
                    else {
                        staffWrappers w = new staffWrappers(v, String.valueof(v.getSobjectType()), Srole.contains(v.Role__c));
                        w.selection = TRUE;
                        AllstaffWrappers.add(w);
                        StaffNameJobTeam.add(v.name);
                    }
                }
            } //Vendor Contact  Operation Details
            
        }
        if (StatusString == 'Staff') {
            AllstaffWrappers.clear();
            
            //Staff Operation Details
            String query = 'SELECT id,name,Active__c,First_Name__c,Last_Name__c,Email__c,Role__c,Username__c from Staff__c where Active__c=true and IsDeleted__c=False WITH SECURITY_ENFORCED order by Role__c,name';
            
            staffs = Database.query(query);
            
            if (!staffs.isEmpty()) {
                
                for (Campaign_Team__c jt: lstCampaignTeam) {
                    staffNameSet.add(jt.Staff__c);
                    staffJobTeamMap.put(jt.Staff__c, jt);
                }
                
                for (Staff__c s: staffs) {
                    
                    if (!staffNameSet.contains(s.name)) //(s.First_Name__c+' '+s.Last_Name__c))
                        AllstaffWrappers.add(new staffWrappers(s, String.valueof(s.getSobjectType()), Srole.contains(s.role__C)));
                    
                    else {
                        staffWrappers w = new staffWrappers(s, String.valueof(s.getSobjectType()), Srole.contains(s.role__C));
                        w.selection = TRUE;
                        AllstaffWrappers.add(w);
                        StaffNameJobTeam.add(s.name);
                    }
                }
            }
            //End Staff Operation Details
            
        }
        
        if (StatusString == 'Vendor Contact') {
            AllstaffWrappers.clear();
            String query2 = 'SELECT id,name,Active__c,First_Name__c,Email__c,Last_Name__c,Role__c,User_Name__c from Vendor_Contact__c where Active__c=true WITH SECURITY_ENFORCED order by Role__c,name';
            VCs = Database.query(query2);
            
            if (!VCs.isEmpty()) {
                
                for (Campaign_Team__c jt: lstCampaignTeam) {
                    staffNameSet.add(jt.Staff__c);
                    staffJobTeamMap.put(jt.Staff__c, jt);
                }
                
                for (Vendor_Contact__c v: VCs) {
                    
                    if (!staffNameSet.contains(v.name)) //(s.First_Name__c+' '+s.Last_Name__c))
                        AllstaffWrappers.add(new staffWrappers(v, String.valueof(v.getSobjectType()), Srole.contains(v.Role__c)));
                    
                    else {
                        staffWrappers w = new staffWrappers(v, String.valueof(v.getSobjectType()), Srole.contains(v.Role__c));
                        w.selection = TRUE;
                        AllstaffWrappers.add(w);
                        StaffNameJobTeam.add(v.name);
                    }
                }
            } //Vendor Contact  Operation Details
            
        }
        return AllstaffWrappers;
    }
    //End method Search for staffs
    
    
     public class StaffWrappers{
        @AuraEnabled public Sobject sobjet{get;set;}
        @AuraEnabled public boolean selection{get;set;}
        @AuraEnabled Public boolean Sroles{get;set;}
        @AuraEnabled Public String SobjType{get;set;}
        
        
        @AuraEnabled   Public String  Staffname{get;set;}
        @AuraEnabled   Public String  Username{get;set;}
        @AuraEnabled   Public String  Rolename{get;set;}
        @AuraEnabled   Public Boolean Active{get;set;}
        @AuraEnabled   Public String  Email{get;set;}
        
        public StaffWrappers(Sobject sb, String st, Boolean STroles){
            this.sobjet=sb;
            this.SobjType=st;
            selection = False;
            this.Sroles=STroles;
            
            if(SobjType=='Client_Contact__c'){
                Client_Contact__c CContact=(Client_Contact__c)sb;
                this.Staffname=CContact.Name;
                this.Username=CContact.Username__c;
                this.Rolename=CContact.Client_Contact_Role__c;
                this.Active=CContact.Active__c;
                this.Email=CContact.Email__c;
            }
            
            if(SobjType=='Vendor_Contact__c'){
                Vendor_Contact__c VContact =(Vendor_Contact__c)sb;
                this.Staffname=VContact.Name;
                this.Username=VContact.User_name__c;
                this.Rolename=VContact.Role__c;
                this.Active=VContact.Active__c;
                this.Email=VContact.Email__c;
            }
            
            if(SobjType=='Staff__c'){
                Staff__c staff=(Staff__c)sb;
                this.Staffname=staff.Name;
                this.Username=staff.Username__c;
                this.Rolename=staff.Role__c;
                this.Active=staff.Active__c;
                this.Email=staff.Email__c;
            }
        }
    }
    
}