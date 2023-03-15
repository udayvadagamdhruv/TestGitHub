public with sharing class JobRequestFormdetailpageext {

    Public job__c j {
        get;
        set;
    }
    String strJobId;
    public Job__c job;
    public Boolean isError {
        get;
        set;
    }
    public list < Job_Task__c > jtlist {
        get;
        set;
    }
    public List < Job_Team__c > lstJobTeam {
        get;
        set;
    }
    public id strJTID {
        get;
        set;
    }
    public string tab {
        get;
        set;
    }
    public string section {
        get;
        set;
    }
    public string Dup {
        get;
        set;
    }
    public Boolean TS {
        get;
        set;
    }
    public Boolean ShowJCTab {
        get;
        set;
    }
    public Boolean ShowJBTab {
        get;
        set;
    }
    public Boolean hideQuip {
        get;
        set;
    }
    public boolean ShowWDocs {
        set;
        get;
    }
    public boolean ShowChatter {
        set;
        get;
    }
    public Map < Id, list < String >> AssignedUsers {
        set;
        get;
    }

    public Integer noOfRecords {
        set;
        get;
    }
    public Integer totalRecs {
        set;
        get;
    }
    public Integer size {
        set;
        get;
    }
    public String ciid {
        get;
        set;
    }
    
    Public Map<String,String> TeamImageURlMap {set;get;}
    
    public JobRequestFormdetailpageext(ApexPages.StandardController controller) {
        isError = False;
        TS = False;
        totalRecs = 0;
        
        TeamImageURlMap=new Map<String,String>();

        /* Dup=apexpages.currentpage().getparameters().get('dupjob');

          if(!test.isRunningTest() && Dup!='1')
          {
              controller.addFields(new List<String> {'Campaign__r.name','Media_Types__r.name','Schedule_Template__r.name','JS_Client__r.name','JS_Client_Contact__r.name','Specification_Template__r.name'});
          }*/
        this.j = (job__c) controller.getrecord();

        totalRecs = [select count() from Timesheet_Entries__c where Job__c = : j.id];

        Job_Detail_Tab_Controls__c JobCost = Job_Detail_Tab_Controls__c.getOrgDefaults();
        Job_Detail_Tab_Controls__c PCS = Job_Detail_Tab_Controls__c.getInstance(Userinfo.getProfileId());
        Job_Detail_Tab_Controls__c UCS = Job_Detail_Tab_Controls__c.getInstance(UserInfo.getUserId());

        if (UCS.Name != null || PCS.Name != null) {
            if (UCS.Name.Contains('(User)')) {
                ShowJCTab = UCS.Disable_Job_Cost_Tab__c;
                ShowJBTab = UCS.Disable_Job_Billing_Tab__c;
                hideQuip = UCS.Disable_Quip__c;
                ShowWDocs = UCS.Enable_WorkDocs__c;
                ShowChatter = UCS.Disable_Chatter__c;
            } else if (PCS.Name.Contains('(Profile)')) {
                ShowJCTab = PCS.Disable_Job_Cost_Tab__c;
                ShowJBTab = PCS.Disable_Job_Billing_Tab__c;
                hideQuip = PCS.Disable_Quip__c;
                ShowWDocs = PCS.Enable_WorkDocs__c;
                ShowChatter = PCS.Disable_Chatter__c;
            } else {
                ShowJCTab = JobCost.Disable_Job_Cost_Tab__c;
                ShowJBTab = JobCost.Disable_Job_Billing_Tab__c;
                hideQuip = JobCost.Disable_Quip__c;
                ShowWDocs = JobCost.Enable_WorkDocs__c;
                ShowChatter = JobCost.Disable_Chatter__c;
            }
        } else {
            ShowJCTab = JobCost.Disable_Job_Cost_Tab__c;
            ShowJBTab = JobCost.Disable_Job_Billing_Tab__c;
            hideQuip = JobCost.Disable_Quip__c;
            ShowWDocs = JobCost.Enable_WorkDocs__c;
            ShowChatter = JobCost.Disable_Chatter__c;
        }
        job = [select id, Name from Job__c where id = : j.id];
        strJobId = job.id;
        jtlist = new list < Job_Task__c > ();
        jtlist = [Select Name, Due_Date__c, Task_Order__c, Assigned_Users__c, Marked_Done__c, Completion_Date__c, Revised_Due_Date__c, Status__c from Job_Task__c where Job__c = : j.Id Order By Task_Order__c];

        AssignedUsers = new Map < Id, list < String >> ();

        if (jtlist.size() > 0) {

            for (Job_Task__c jt: jtlist) {
                list < String > slist = new list < String > ();
                list < String > addslist = new list < String > ();
                if ((jt.Assigned_Users__c) != null) {
                    string assstring = jt.Assigned_Users__c;
                    //Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+assstring));

                    if (assstring.contains(',')) {
                        slist = (jt.Assigned_Users__c).split(',');
                        for (String s: slist) {
                            addslist.add(s);
                        }
                    } else {
                        addslist.add(assstring);
                        // Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,'AddList Without ,'+addslist));
                    }
                    AssignedUsers.put(jt.id, addslist);
                    //Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,'AssignedUsers :'+AssignedUsers));
                } else {
                    addslist.add('');
                    AssignedUsers.put(jt.id, addslist);
                }

            }
        }

        lstJobTeam = new list < Job_Team__c > ();
        lstJobTeam = [Select Id, Role__c, Staff__c, Job__r.Name from Job_Team__c where Job__c = : j.Id order by CreatedDate];
        List<String> staffNames=new  List<String>();
        for(Job_Team__c Tstaff:lstJobTeam ){
        staffNames.add(Tstaff.Staff__c);
        }
        
       list<User> Userlist=new list<User>();
       
       Userlist=[Select Id,Name, SmallPhotoUrl, FullPhotoUrl From User where Name IN:staffNames and User_Types__c!=null];
       for(User a:Userlist) {
        TeamImageURlMap.put(a.Name,a.FullPhotoUrl);
        }
        
        for(Job_Team__c Tstaff:lstJobTeam ){
         if(!TeamImageURlMap.Containskey(Tstaff.Staff__c)){
         TeamImageURlMap.put(Tstaff.Staff__c,'');
         }
        }

        tab = apexpages.currentpage().getparameters().get('tab');
        section = apexpages.currentpage().getparameters().get('section');

        /* comment */

        User u = [Select Id, Name from User where id = : UserInfo.getUserID()];
        String strId = u.id;
        string username = '%' + u.Name + '%';

        List < Job_Task__c > objJobTasklist = [Select Id, Name, Assigned_Users__c, Job__c from Job_Task__c where Assigned_Users__c like: username and Job__c = : j.Id];
        if (objJobTasklist.size() > 0) {
            TS = true;
        }

    }

    public ApexPages.StandardSetController setCon {
        get {
            if (setCon == null) {
                size = 20;
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [select id, name, Hours_Worked__c, GL_Code__c, Task_Name__c, Date__c, User__c from Timesheet_Entries__c where Job__c = : j.id Order BY Name desc]));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }
        set;
    }

    //Changes the size of pagination

    // Initialize setCon and return a list of record    

    public List < Timesheet_Entries__c > getTimeSheetList() {
        return (List < Timesheet_Entries__c > ) setCon.getRecords();
    }

    public Void delTimesheet() {
        System.Debug('CIID=======================' + ciid);
        try {

            Timesheet_Entries__c delci = [Select id, Name from Timesheet_Entries__c where id = : ciid];
            delete delci;

            //TimeSheetEnt= [select id,name,Hours_Worked__c,GL_Code__c,Task_Name__c,Date__c,User__c from Timesheet_Entries__c where Job__c =: j.id Order BY Name LIMIT :LimitSize OFFSET :OffsetSize];
            totalRecs = [select count() from Timesheet_Entries__c where Job__c = : j.id];

            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                [select id, name, Hours_Worked__c, GL_Code__c, Task_Name__c, Date__c, User__c from Timesheet_Entries__c where Job__c = : j.id Order BY Name desc]));
            setCon.setPageSize(size);
            noOfRecords = setCon.getResultSize();

        } catch (System.DMLException e) {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }

        /*PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=15');
        p.setRedirect(true);
        return p;*/

    }

    public List < Job_Spec__c > getjobspecs() {
        return [select Id, Name, Description__c from Job_Spec__c where Job__c = : j.Id];
    }

    public List < Job_Task__c > getjobTasks() {
        //return [Select Name,Due_Date__c,Task_Order__c,Assigned_Users__c,Marked_Done__c,Completion_Date__c,Revised_Due_Date__c,Status__c from Job_Task__c where Job__c =:j.Id Order By Task_Order__c ];
        return jtlist;
    }

    public PageReference JobListView() {
        PageReference p = new PageReference('/apex/JobTabOverrideMobile');
        p.setRedirect(true);
        return p;
    }

    public PageReference editmethod() {
        PageReference p = new PageReference('/apex/JobRequestFormEditMobile?id=' + j.id);
        p.setRedirect(true);
        return p;
    }

    public PageReference editLight() {
        PageReference p = new PageReference('/apex/EditJobNewLightning?id=' + j.id);
        p.setRedirect(true);
        return p;
    }

    public PageReference deleteLight() {
        PageReference p = new PageReference('/apex/DeleteJob?id=' + j.id);
        p.setRedirect(true);
        return p;
    }

    public PageReference deleteMethod() {
        Job__c obj = [select id, Name from Job__c where id = : strJobId];
        try {
            Database.delete(obj);
        } catch (System.DMLException e) {
            isError = True;
            TS = False;
            tab = '';
            PageReference p = new PageReference('/apex/JobRequestFormdetailpageMobile?id=' + j.id);
            p.setRedirect(false);
            return p;
        }

        PageReference p = new PageReference('/apex/JobTabOverrideMobile');
        p.setRedirect(true);
        return p;
    }

    public PageReference TSEntryMethod() {
        PageReference pa = new PageReference('/apex/TimesheetEntriesMobile?jobId='+j.id+'&page=Jobdetailpage');
        pa.setRedirect(true);
        return pa;
    }

    public PageReference DupMethod() {
        PageReference pa = new PageReference('/apex/createDuplicateJob?id=' + j.Id);
        pa.setRedirect(true);
        return pa;
    }

    public void assignMarkedDone1() {
        Job_Task__c objJT = [Select id, Marked_Done__c, Job__c, Completion_Date__c from Job_Task__c where id = : strJTID];
        TS = False;

        If(objJT.Marked_Done__c == False) {
            objJT.Completion_Date__c = System.Today();
            objJT.Status__c = 'Completed';
            objJT.Marked_Done__c = True;
        } else if (objJT.Marked_Done__c == True) {
            objJT.Completion_Date__c = NULL;
            objJt.Status__c = 'Active';
            objJT.Marked_Done__c = False;

        }

        /* objJT.Marked_Done__c=True;
         objJT.Completion_Date__c=System.Today();
         objJT.Status__c='Completed';*/
        update objJT;
        jtlist = [Select Name, Due_Date__c, Task_Order__c, Assigned_Users__c, Marked_Done__c, Completion_Date__c, Revised_Due_Date__c, Status__c from Job_Task__c where Job__c = : j.Id Order By Task_Order__c];

        // PageReference pa = new PageReference('/apex/JobRequestFormdetailpageMobile?id='+j.Id+'&tab=RelatedList'+'&section=Schedule');
        // pa.setRedirect(true); 
        // return pa;

    }

    // This method is called on to editJobTask
    public Pagereference editJobTask() {
            Pagereference p = new Pagereference('/apex/EditJobTaskSwitchPage?id=' + strJTID + '&page=Jobdetailpage');
            p.setRedirect(true);
            return p;
        }
        // End method editJobTask

    // This method is called on to deleteJobTask
    /*   public Pagereference deleteJobTask()
      {    
          // Pagereference p=new Pagereference('/apex/DeleteJobSpec?id='+strJTID);
          // p.setRedirect(true);
          // return p;
      }*/
    // End method deleteJobTask

    public Pagereference AddEditStaff() {

            PageReference pa = new PageReference('/apex/taskroleaddeditstaffMobile?id=' + strJTID);
            pa.setredirect(true);
            return pa;
        }
        //End Method to go to the JobTeamAddEditStaff page

    //start Method to go to the JobTeamAddEditStaff page
    public Pagereference AddStaffs() {
            //  String theId=ApexPages.CurrentPage().getParameters().get('id');
            // PageReference p = Page.jobteamaddeditstaffSwitchPage;

            PageReference pa = new PageReference('/apex/jobteamaddeditstaffSwitchPage?id=' + j.Id + '&tab=RelatedList');

            pa.setredirect(true);
            //  p.getParameters().put('id',theID); 
            return pa;
        }
        //End Method to go to the JobTeamAddEditStaff page
    public PageReference CreateTsEntry() {
        String jobid;
        String theId = ApexPages.CurrentPage().getParameters().get('id');

        Job__c job = [Select Id from Job__c where id = : theID];
        jobid = job.Id;

        PageReference p = Page.NewTimesheetEntriesMobile;
        p.setredirect(true);
        p.getParameters().put('jobid', theID);
        return p;

    }

}