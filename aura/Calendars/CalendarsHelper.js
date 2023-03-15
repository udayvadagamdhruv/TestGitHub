({
    /*************************************** Fetch Object and Field Labels *****************************************/
    FetchLabels : function(component, event, helper) {
        console.log('>>>>>>>>FetchLabels');
        //Object Labels
        var ObjLabels=component.get("c.getLabelsforObject");
        ObjLabels.setCallback(this, function(resp){
            console.log('>>>>>>>>Object Labels State>>>>>>>>>>>>>'+resp.getState());
            if(resp.getState() === "SUCCESS"){
                //console.log('>>>>>>>>Object Labels State if enter>>>>>>>>>>>>>');
                component.set('v.Labelname', resp.getReturnValue());
                
                //console.log('>>>>>>>>Object Labels Values>>>>>>>>>>>>>'+JSON.stringify(resp.getReturnValue()));
            }
        });
        $A.enqueueAction(ObjLabels); 
        
        // Field Labels
        var FieldLabels=component.get("c.getObjectFieldLabels");
        FieldLabels.setParams({
            ObjNames:['Campaign__c','Job__c','Job_Task__c']
        });
        FieldLabels.setCallback(this, function(res){
            console.log('>>>>>>>>Object Fields Labels State>>>>>>>>>>>>>'+res.getState());
            if(res.getState() === "SUCCESS"){
                component.set('v.ObjectType', JSON.parse(res.getReturnValue()));
                //console.log('>>>>>>>>Object Fields Labels >>>>>>>>>>>>>'+JSON.stringify(JSON.parse(res.getReturnValue())));
            }
        });
        $A.enqueueAction(FieldLabels); 
        
    },
    
    
    /******************************* Fetch Job Search criteria Field values **************************************/
    FetchJobCalcriteriaVal : function(component, event, helper) {
        console.log('>>>>>>>>FetchJobCalcriteriaVal');
        // 1. Fetch Campaign values
        var CampVal = component.get("c.getCampaigns");
        CampVal.setCallback(this, function(CampValRes) {
            var CampValstate = CampValRes.getState();
            console.log('>>>>>>>>>>>Job Campaign state>>>>>>>>>>>>>>>'+CampValstate);
            //console.log('>>>>>>>>>>>Job Campaign Res>>>>>>>>>>>>>>>'+JSON.stringify(CampValRes.getReturnValue()));
            if (CampValstate === "SUCCESS") {
                component.set("v.CampaignRec", CampValRes.getReturnValue());
            }
        });
        $A.enqueueAction(CampVal);
        
        // 2. Fetch Client values
        var ClientVal = component.get("c.getClients");
        ClientVal.setCallback(this, function(ClientValRes) {
            var ClientValstate = ClientValRes.getState();
            console.log('>>>>>>>>>>>Job Client state>>>>>>>>>>>>>>>'+ClientValstate);
            //console.log('>>>>>>>>>>>Job Client Res>>>>>>>>>>>>>>>'+JSON.stringify(ClientValRes.getReturnValue()));
            if (ClientValstate === "SUCCESS") {
                component.set("v.ClientRec", ClientValRes.getReturnValue());
            }
        });
        $A.enqueueAction(ClientVal);
        
        // 3. Fetch Mediatype values
        var MediaVal = component.get("c.getMediatype");
        MediaVal.setCallback(this, function(MediaValRes) {
            var MediaValstate = MediaValRes.getState();
            console.log('>>>>>>>>>>>Job Media Type state>>>>>>>>>>>>>>>'+MediaValstate);
            //console.log('>>>>>>>>>>>Job Media Type RES>>>>>>>>>>>>>>>'+JSON.stringify(MediaValRes.getReturnValue()));
            if (MediaValstate === "SUCCESS") {
                component.set("v.MediaTypeRec", MediaValRes.getReturnValue());
            }
        });
        $A.enqueueAction(MediaVal);
        
        // 5. Fetch Job Status values
        var StatusVal = component.get("c.fetchJobStatusPicklistval");
        StatusVal.setCallback(this, function(StatusValRes) {
            var StatusValstate = StatusValRes.getState();
            console.log('>>>>>>>>>>>Job status picstate>>>>>>>>>>>>>>>'+StatusValstate);
            //console.log('>>>>>>>>>>>Job status Picklist>>>>>>>>>>>>>>>'+JSON.stringify(StatusValRes.getReturnValue()));
            if (StatusValstate === "SUCCESS") {
                component.set("v.JobstatusPicklist", StatusValRes.getReturnValue());
            }
        });
        $A.enqueueAction(StatusVal);
    },
    
    // 4. Fetch Schedule values based on Media type values
    FetchSchedTemp : function(component, event, helper) { 
        console.log('>>>>>>>>FetchSchedTemp');
        var jobsearch=component.get("v.ShowJobCal");
        var tasksearch=component.get("v.ShowTaskCal");
        if(jobsearch){
            var MediaType=component.get("v.SelectedMediatypeRec");
            //console.log('>>>>>>MediaType Selected values>>>>>>>>job>'+JSON.stringify(MediaType));
        }
        if(tasksearch){
            var MediaType=component.get("v.SelectedtskMediatypeRec");
            // console.log('>>>>>>MediaType Selected values>>>>task>>>>>'+JSON.stringify(MediaType));
        }
        
        var SchedVal = component.get("c.getscheduletemp");
        SchedVal.setParams({
            mediatyp:MediaType
        });
        SchedVal.setCallback(this, function(SchedValRes) {
            var SchedValstate = SchedValRes.getState();
            console.log('>>>>>>>>>>>Schedule Template state>>>>>>>>>>>>>>>'+SchedValstate);
            //console.log('>>>>>>>>>>>Schedule Template RES>>>>>>>>>>>>>>>'+JSON.stringify(SchedValRes.getReturnValue()));
            if (SchedValstate === "SUCCESS") {
                component.set("v.SchedTempRec", SchedValRes.getReturnValue());
            }
        });
        $A.enqueueAction(SchedVal);
    },
    
    // 6. Fetch Job Names based on Status values on the job calendar
    FetchJobs : function(component, event, helper) { 
        console.log('>>>>>>>>FetchJobs');
        var statusSel;
        
        var Showjob=component.get("v.ShowJobCal");
        var Showtsk=component.get("v.ShowTaskCal");
        if(Showjob){
            statusSel=component.get("v.SelectedStatus");
            //console.log('>>>>>>statusSel>>>>>>>>>'+statusSel);
        }
        if(Showtsk){
            statusSel=component.get("v.SelectedtskStatus");
            //console.log('>>>>>>statusSel>>>>>>>>>'+statusSel);
        }
        
        var JobVal = component.get("c.getJobs");
        JobVal.setParams({
            status:statusSel
        });
        JobVal.setCallback(this, function(JobValRes) {
            var JobValstate = JobValRes.getState();
            console.log('>>>>>>>>>>>Job state>>>>>>>>>>>>>>>'+JobValstate);
            console.log('>>>>>>>>>>>Job Names Length>>>>>>>>>>>>>>>'+JobValRes.getReturnValue().length);
            if (JobValstate === "SUCCESS") {
                component.set("v.JobRec", JobValRes.getReturnValue());
            }
        });
        $A.enqueueAction(JobVal);
    },
    
    
    /******************************* Fetch Campaign Search criteria Field values **************************************/
    FetchCampCalcriteriaVal : function(component, event, helper) {
        console.log('>>>>>>>>FetchCampCalcriteriaVal');
        // 1. Fetch Campaign Status values
        var CampStatusVal = component.get("c.fetchCampStatusPicklistval");
        CampStatusVal.setCallback(this, function(CampStatusValRes) {
            var CampStatusValstate = CampStatusValRes.getState();
            console.log('>>>>>>>>>>>Camp status pic state>>>>>>>>>>>>>>>'+CampStatusValstate);
            //console.log('>>>>>>>>>>>Camp status Picklist>>>>>>>>>>>>>>>'+JSON.stringify(CampStatusValRes.getReturnValue()));
            if (CampStatusValstate === "SUCCESS") {
                component.set("v.CampstatusPicklist", CampStatusValRes.getReturnValue());
            }
        });
        $A.enqueueAction(CampStatusVal);
        
        //3. Fetch Active User values
        var CreatedbyVal = component.get("c.getuserNames");
        
        CreatedbyVal.setCallback(this, function(CreatedbyValRes) {
            var CreatedbyValstate = CreatedbyValRes.getState();
            console.log('>>>>>>>>>>>Campaign Created by state>>>>>>>>>>>>>>>'+CreatedbyValstate);
            //console.log('>>>>>>>>>>>Campaign Created by Res>>>>>>>>>>>>>>>'+JSON.stringify(CreatedbyValRes.getReturnValue()));
            if (CreatedbyValstate === "SUCCESS") {
                component.set("v.CampaignCreatedby", CreatedbyValRes.getReturnValue());
            }
        });
        $A.enqueueAction(CreatedbyVal);
        
    },
    
    //2. Fetch Campaign Names based on Status values
    FetchCampName:  function(component, event, helper) {
        
        console.log('>>>>>>>>FetchCampName');
        var CampstatusSel=component.get("v.SelectedCampStatus");
        // console.log('>>>>>>Camp status Sel>>>>>>>>>'+CampstatusSel);
        
        var CampNameVal = component.get("c.getCampaignNames");
        CampNameVal.setParams({
            status:CampstatusSel
        });
        CampNameVal.setCallback(this, function(CampNameValRes) {
            var CampNameValstate = CampNameValRes.getState();
            console.log('>>>>>>>>>>>Campaign Name state>>>>>>>>>>>>>>>'+CampNameValstate);
            console.log('>>>>>>>>>>>Campaign Names Length>>>>>>>>>>>>>>>'+CampNameValRes.getReturnValue().length);
            if (CampNameValstate === "SUCCESS") {
                component.set("v.CampaignNameRec", CampNameValRes.getReturnValue());
            }
        });
        $A.enqueueAction(CampNameVal);
    },
    
    
    /******************************* Fetch Task Search criteria Field values **************************************/
    FetchTaskCalcriteriaVal : function(component, event, helper) {
        console.log('>>>>>>>>FetchTaskCalcriteriaVal');
        //7. Fetch Task values
        var taskVal = component.get("c.getTasks");
        
        taskVal.setCallback(this, function(taskValRes) {
            var taskValstate = taskValRes.getState();
            console.log('>>>>>>>>>>>Task Names state>>>>>>>>>>>>>>>'+taskValstate);
            //console.log('>>>>>>>>>>>Task Names Res>>>>>>>>>>>>>>>'+JSON.stringify(taskValRes.getReturnValue()));
            if (taskValstate === "SUCCESS") {
                component.set("v.TaskNames", taskValRes.getReturnValue());
            }
        });
        $A.enqueueAction(taskVal);
        
        //8. Fetch staff values
        var RoleVal = component.get("c.getRole");
        
        RoleVal.setCallback(this, function(RoleValRes) {
            var RoleValstate = RoleValRes.getState();
            console.log('>>>>>>>>>>>Task Roles state>>>>>>>>>>>>>>>'+RoleValstate);
            //console.log('>>>>>>>>>>>Task Roles Res>>>>>>>>>>>>>>>'+JSON.stringify(RoleValRes.getReturnValue()));
            if (RoleValstate === "SUCCESS") {
                component.set("v.TaskRoles", RoleValRes.getReturnValue());
            }
        });
        $A.enqueueAction(RoleVal);
        
        //9. Fetch staff values
        var StaffVal = component.get("c.getStaff");
        
        StaffVal.setCallback(this, function(StaffValRes) {
            var StaffValstate = StaffValRes.getState();
            console.log('>>>>>>>>>>>Task Staff state>>>>>>>>>>>>>>>'+StaffValstate);
            //console.log('>>>>>>>>>>>Task Staff Res>>>>>>>>>>>>>>>'+JSON.stringify(StaffValRes.getReturnValue()));
            if (StaffValstate === "SUCCESS") {
                component.set("v.TaskStaff", StaffValRes.getReturnValue());
            }
        });
        $A.enqueueAction(StaffVal);
    }
    
    
})