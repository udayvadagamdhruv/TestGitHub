({
    doInit : function(component, event, helper) {
        helper.FetchValues(component, event, helper);
    },
    
    // 1. Campaign onchange method
    CampChange: function(component, event, helper) {
        console.log('>>>>>>>onchange Campaign');
        var CampRec=component.find("Camp").get("v.value");
        console.log('>>>>>>>onchange Campaign>>>>>>>>>>>'+CampRec);
        component.set('v.SelectedCampaignRec',CampRec);
    },
    
    //  2. Client onchange method
    ClientChange: function(component, event, helper) {
        console.log('>>>>>>>onchange Client');
        var ClientRec=component.find("Client").get("v.value");
        console.log('>>>>>>>> onchange Client>>>>>>>>>>'+ClientRec);
        component.set('v.SelectedClientRec',ClientRec);
    }, 
    
    //3. Job Status OnChange
    JobStatusChange: function(component, event, helper) {
        console.log('>>>>>>>onchange Status');
        var Status=component.find("JobStatus").get("v.value");
        component.set('v.SelectedStatus',Status);
    },
    
    doSearch: function(component, event, helper) {
        
        var SearchVal = component.get("c.getJobs");
        var DueDateFrom=component.find("DueDateFrom").get("v.value");
        var DueDateTo=component.find("DueDateTo").get("v.value");
         console.log('>>>>>>>>>>>SelectedCampaignRece>>>>>>>>>>>>>>>'+component.find("Camp").get("v.value"));
         console.log('>>>>>>>>>>>SelectedClientRec>>>>>>>>>>>>>>>'+component.find("Client").get("v.value"));
         console.log('>>>>>>>>>>>JobStatus>>>>>>>>>>>>>>>'+component.find("JobStatus").get("v.value"));
         console.log('>>>>>>>>>>>DueDateFrom>>>'+DueDateFrom);
         console.log('>>>>>>>>>>>DueDateTo>>>>>>>>>>>>>>>'+DueDateTo);
       
        SearchVal.setParams({
            "Campaign" :component.find("Camp").get("v.value") ,
            "Client" : component.find("Client").get("v.value"),
            "status" : component.find("JobStatus").get("v.value"),
            "promoDueDate1":DueDateFrom,
            "promoDueDate2":DueDateTo
        });
        SearchVal.setCallback(this, function(SearchValRes) {
            var SearchValstate = SearchValRes.getState();
            console.log('>>>>>>>>>>>SearchVal state>>>>>>>>>>>>>>>'+SearchValstate);
            console.log('>>>>>>>>>>>SearchVal response>>>>>>>>>>>>>>>'+JSON.stringify(SearchValRes.getReturnValue()));
            
            if (SearchValstate == 'SUCCESS') {
                component.set("v.SearchValRec", SearchValRes.getReturnValue());
            }
            if(SearchValstate === "ERROR") {
                //var errCode=JSON.stringify(SearchValRes.getError()[0].pageErrors[0].statusCode);
                 
                //var errMsg=JSON.stringify(SearchValRes.getError()[0].pageErrors[0].message);
                var errors = JSON.stringify(SearchValRes.getError());
            //console.log('>>>>>>>>>>>errCodee>>>>>>>>>>>>>>>'+errCode);
            //console.log('>>>>>>>>>>>errMsg>>>>>>>>>>>>>>>'+errMsg);
            console.log('>>>>>>>>>>>errors >>>>>>>>>>>>>>>'+errors );}
        });
        $A.enqueueAction(SearchVal);
    }
    
})