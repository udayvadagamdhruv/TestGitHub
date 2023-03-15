({
    doInit : function(component, event, helper) {
        
        console.log('>>>>> 1. Do Init>>>>>');
        helper.FetchLabels(component, event, helper); 
        helper.FetchJobCalcriteriaVal(component, event, helper);
        helper.FetchJobs(component, event, helper);
        helper.FetchCampCalcriteriaVal(component, event, helper);
        helper.FetchCampName(component, event, helper);
        helper.FetchTaskCalcriteriaVal(component, event, helper);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCal();
        
    },
    
    /********************************** Calendar selected method **************************************************/
    handleOnSelect: function(component, event, helper) {
        var selectedVal=component.get("v.selectedCal");
        console.log('>>>>> 1. handleOnSelect>>>>>');
        if(selectedVal=='Job Calendar')
        {
            console.log('>>>>> 1.1 Job calendar selected>>>>>');
            component.set('v.ShowJobCal',true);
            component.set('v.ShowCampCal',false);
            component.set('v.ShowTaskCal',false);
            
            component.set('v.SelectedCampaignRec','');
            component.set('v.SelectedClientRec','');
            component.set('v.SelectedMediatypeRec','');
            component.set('v.SelectedScheduleTempRec','');
            component.set('v.SelectedStatus','Active');
            component.set('v.SelectedJobRec','');
            
            helper.FetchSchedTemp(component, event, helper);
            helper.FetchJobs(component, event, helper);
            
            
            var JobCalendar = component.find("JobCal");
            JobCalendar.loadCalforjobs();
            
            
        }
        if(selectedVal=='Campaign Calendar')
        {
            console.log('>>>>> 1.2 Campaign calendar selected>>>>>');
            component.set('v.ShowJobCal',false);
            component.set('v.ShowCampCal',true);
            component.set('v.ShowTaskCal',false);
            
            component.set('v.SelectedCampStatus','Active');
            component.set('v.SelectedCampName','');
            component.set('v.SelectedCampcreatedby','');
            
            helper.FetchCampName(component, event, helper);
            
            var JobCalendar = component.find("JobCal");
            JobCalendar.loadCalforcampagins();
        }
        if(selectedVal=='Task Calendar')
        {
            console.log('>>>>> 1.3 Task calendar selected>>>>>');
            component.set('v.ShowJobCal',false);
            component.set('v.ShowCampCal',false);
            component.set('v.ShowTaskCal',true);
            
            component.set('v.SelectedtskCampaignRec','');
            component.set('v.SelectedtskClientRec','');
            component.set('v.SelectedtskMediatypeRec','');
            component.set('v.SelectedtskScheduleTempRec','');
            component.set('v.SelectedtskStatus','Active');
            component.set('v.SelectedtskJobRec','');
            component.set('v.SelectedTask','');
            component.set('v.SelectedRole','');
            component.set('v.SelectedStaff','');
            
            helper.FetchSchedTemp(component, event, helper);
            helper.FetchJobs(component, event, helper);
            var JobCalendar = component.find("JobCal");
            JobCalendar.loadCalforTasks();
        }
    },
    
    /*************************** Job Calendar Search criteria starts **********************************************/
    
    // 1. Campaign onchange method
    CampChange: function(component, event, helper) {
        console.log('>>>>>>>Job Calendar onchange Campaign');
        var CampRec=component.find("Camp").get("v.value");
        //console.log('>>>>>>>Job Calendar onchange Campaign>>>>>>>>>>>'+CampRec);
        component.set('v.SelectedCampaignRec',CampRec);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforjobs();
        
    },
    
    //  2. Client onchange method
    ClientChange: function(component, event, helper) {
        console.log('>>>>>>>Job Calendar onchange Client');
        var ClientRec=component.find("Client").get("v.value");
        //console.log('>>>>>>>>Job Calendar onchange Client>>>>>>>>>>'+ClientRec);
        component.set('v.SelectedClientRec',ClientRec);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforjobs();
    },
    
    //  3. Media type onchange method
    MediaChange: function(component, event, helper) {
        console.log('>>>>>>>Job Calendar onchange Medial Type');
        var MediaRec=component.find("Media").get("v.value");
        //console.log('>>>>>>>>Job Calendar onchange Medial Type>>>>>>>>>>'+MediaRec);
        component.set('v.SelectedMediatypeRec',MediaRec);
        
        component.set('v.SelectedScheduleTempRec','');
        
        helper.FetchSchedTemp(component, event, helper);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforjobs();
        
    },
    
    //  4. Schedule Template onchange method
    SchedChange: function(component, event, helper) {
        console.log('>>>>>>>Job Calendar onchange Schedule');
        var SchedRec=component.find("Schedule").get("v.value");
        //console.log('>>>>>>>>>>Job Calendar onchange Schedule>>>>>>>>>>>>'+SchedRec);
        component.set('v.SelectedScheduleTempRec',SchedRec);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforjobs();
    },
    
    //  5. Job Status onchange method
    JobStatusChange: function(component, event, helper) {
        console.log('>>>>>>>Job Calendar onchange Status');
        var Status=component.find("JobStatus").get("v.value");
        //console.log('>>>>>>>Job Calendar onchange Status>>>>>>>>>>>'+Status);
        component.set('v.SelectedStatus',Status);
        component.set('v.SelectedJobRec','');
        helper.FetchJobs(component, event, helper);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforjobs();
        
    },
    
    //  6. Job Name onchange method
    JobChange: function(component, event, helper) {
        console.log('>>>>>>>Job Calendar onchange Name');
        var JobRec=component.find("Jobs").get("v.value");
        //console.log('>>>>>>>Job Calendar onchange Name>>>>>>>>>>>'+JobRec);
        component.set('v.SelectedJobRec',JobRec);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforjobs();
    },
    
    /************************************ Campaign Calendar search criteria starts **********************************/
    
    //  1. Campaign Status onchange method
    CampStatusChange: function(component, event, helper) {
        console.log('>>>>>>>Campaign Calendar onchange Status');
        var Status=component.find("CampStatus").get("v.value");
        //console.log('>>>>>>>Campaign Calendar onchange Status >>>>>>>>>>>'+Status);
        component.set('v.SelectedCampStatus',Status);
        component.set('v.SelectedCampName','');
        helper.FetchCampName(component, event, helper);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforcampagins();
        
    },
    
    //  2. Campaign Name onchange method
    CampNameChange: function(component, event, helper) {
        console.log('>>>>>>>Campaign Calendar onchange Name');
        var Name=component.find("CampName").get("v.value");
        //console.log('>>>>>>Campaign Calendar onchange Name>>>>>>>>>>>>'+Name);
        component.set('v.SelectedCampName',Name);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforcampagins();
        
    },
    
    //  3. Campaign Created by onchange method
    CampCreatedbyChange: function(component, event, helper) {
        console.log('>>>>>>>Campaign Calendar onchange createdby');
        var createdby=component.find("Campcreateby").get("v.value");
        //console.log('>>>>>>Campaign Calendar onchange createdby>>>>>>>>>>>>'+createdby);
        component.set('v.SelectedCampcreatedby',createdby);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforcampagins();
        
    },
    
    /************************************ Task Calendar search criteria starts **********************************/
    
    
    // 1. Campaign onchange method
    tskCampChange: function(component, event, helper) {
        console.log('>>>>>>>tsk Calendar onchange Campaign');
        var CampRec=component.find("tskCamp").get("v.value");
        //console.log('>>>>>>>tsk Calendar onchange Campaign>>>>>>>>>>>'+CampRec);
        component.set('v.SelectedtskCampaignRec',CampRec);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforTasks();
        
    },
    
    //  2. Client onchange method
    tskClientChange: function(component, event, helper) {
        console.log('>>>>>>>tsk Calendar onchange Client');
        var ClientRec=component.find("tskClient").get("v.value");
        //console.log('>>>>>>>>tsk Calendar onchange Client>>>>>>>>>>'+ClientRec);
        component.set('v.SelectedtskClientRec',ClientRec);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforTasks();
    },
    
    //  3. Media type onchange method
    tskMediaChange: function(component, event, helper) {
        console.log('>>>>>>>tsk Calendar onchange Medial Type');
        var MediaRec=component.find("tskMedia").get("v.value");
        //console.log('>>>>>>>>tsk Calendar onchange Medial Type>>>>>>>>>>'+MediaRec);
        component.set('v.SelectedtskMediatypeRec',MediaRec);
        component.set('v.SelectedtskScheduleTempRec','');
        
        helper.FetchSchedTemp(component, event, helper);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforTasks();
        
    },
    
    //  4. Schedule Template onchange method
    tskSchedChange: function(component, event, helper) {
        console.log('>>>>>>>tsk Calendar onchange Schedule');
        var SchedRec=component.find("tskSchedule").get("v.value");
        //console.log('>>>>>>>>>>tsk Calendar onchange Schedule>>>>>>>>>>>>'+SchedRec);
        component.set('v.SelectedtskScheduleTempRec',SchedRec);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforTasks();
    },
    
    //  5. Job Status onchange method
    tskJobStatusChange: function(component, event, helper) {
        console.log('>>>>>>>tsk Calendar onchange Status');
        var Status=component.find("tskJobStatus").get("v.value");
        //console.log('>>>>>>>tsk Calendar onchange Status>>>>>>>>>>>'+Status);
        component.set('v.SelectedtskStatus',Status);
        component.set('v.SelectedtskJobRec','');
        helper.FetchJobs(component, event, helper);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforTasks();
        
    },
    
    //  6. Job Name onchange method
    tskJobChange: function(component, event, helper) {
        console.log('>>>>>>>tsk Calendar onchange Name');
        var JobRec=component.find("tskJobs").get("v.value");
        //console.log('>>>>>>>tsk Calendar onchange Name>>>>>>>>>>>'+JobRec);
        component.set('v.SelectedtskJobRec',JobRec);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforTasks();
    },
    
    //  7. Task onchange method
    TaskChange: function(component, event, helper) {
        console.log('>>>>>>>Task Calendar onchange task');
        var task=component.find("Task").get("v.value");
        //console.log('>>>>>>Task Calendar onchange task>>>>>>>>>>>>'+task);
        component.set('v.SelectedTask',task);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforTasks();
    },
    
    //  8. Role onchange method
    RoleChange: function(component, event, helper) {
        console.log('>>>>>>>Task Calendar onchange Role');
        var role=component.find("Role").get("v.value");
        //console.log('>>>>>>Task Calendar onchange Role>>>>>>>>>>>>'+role);
        component.set('v.SelectedRole',role);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforTasks();
    },
    
    //  9. Staff onchange method
    StaffChange: function(component, event, helper) {
        console.log('>>>>>>>Task Calendar onchange Staff');
        var staff=component.find("Staff").get("v.value");
        //console.log('>>>>>>Task Calendar onchange Staff>>>>>>>>>>>>'+staff);
        component.set('v.SelectedStaff',staff);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforTasks();
    },
    
    // Clears the Search criteria values
    ClearsJobCriteria: function(component, event, helper) {
        
        console.log('>>>>Job clear>>>>>>');
        
        component.find('Camp').set('v.value','--None--');
        component.find('Client').set('v.value','--None--');
        component.find('Media').set('v.value','--None--');
        component.find('Schedule').set('v.value','--None--');
        component.find('JobStatus').set('v.value','Active');
        component.find('Jobs').set('v.value','--None--');
        
        component.set('v.SelectedCampaignRec','');
        component.set('v.SelectedClientRec','');
        component.set('v.SelectedMediatypeRec','');
        component.set('v.SelectedScheduleTempRec','');
        component.set('v.SelectedStatus','Active');
        component.set('v.SelectedJobRec','');
        
        helper.FetchSchedTemp(component, event, helper);
        helper.FetchJobs(component, event, helper);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforjobs();
        
    },
    
    // Clears the Camp Search criteria values
    ClearsCmpCriteria: function(component, event, helper) {
        
        console.log('>>>>Campaign clear>>>>>>');
        
        component.find('CampStatus').set('v.value','Active');
        component.find('CampName').set('v.value','--None--');
        component.find('Campcreateby').set('v.value','--None--');
        
        component.set('v.SelectedCampStatus','Active');
        component.set('v.SelectedCampName','');
        component.set('v.SelectedCampcreatedby','');
        
        helper.FetchCampName(component, event, helper);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforcampagins();
        
    },
    
    // Clears the task Search criteria values
    ClearstaskCriteria: function(component, event, helper) {
        
        console.log('>>>>clear tasks>>>');
        
        component.find('tskCamp').set('v.value','--None--');
        component.find('tskClient').set('v.value','--None--');
        component.find('tskMedia').set('v.value','--None--');
        component.find('tskSchedule').set('v.value','--None--');
        component.find('tskJobStatus').set('v.value','Active');
        component.find('tskJobs').set('v.value','--None--');
        component.find('Task').set('v.value','--None--');
        component.find('Role').set('v.value','--None--');
        component.find('Staff').set('v.value','--None--');
        
        
        component.set('v.SelectedtskCampaignRec','');
        component.set('v.SelectedtskClientRec','');
        component.set('v.SelectedtskMediatypeRec','');
        component.set('v.SelectedtskScheduleTempRec','');
        component.set('v.SelectedtskStatus','Active');
        component.set('v.SelectedtskJobRec','');
        component.set('v.SelectedTask','');
        component.set('v.SelectedRole','');
        component.set('v.SelectedStaff','');
        
        helper.FetchSchedTemp(component, event, helper);
        helper.FetchJobs(component, event, helper);
        
        var JobCalendar = component.find("JobCal");
        JobCalendar.loadCalforTasks();
    }
    
})