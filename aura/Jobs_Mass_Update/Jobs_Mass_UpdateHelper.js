({
    FetchMassUpdateJobRecords : function(component, event, helper,offSetLimit) {
        var JobsAction= component.get("c.getJobsForMassUpdate");
        JobsAction.setParams({
            offsetLimit:offSetLimit
        });
        JobsAction.setCallback(this, function(response){ 
            console.log('=======mass update response==='+response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('====rows===='+JSON.stringify(rows));
                
                var currentData=component.get('v.data'); 
                console.log('===currentData==='+currentData);
                component.set("v.data", currentData.concat(rows));
                event.getSource().set("v.isLoading", false);
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        }); 
        
        $A.enqueueAction(JobsAction);
    },
    
    
    ShowProductionEstimate :function(component, event){
        var showPEAction = component.get("c.showProductionEstimate");
        showPEAction.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var isShowPE=response.getReturnValue();
                
                component.set("v.ShowProductionEstimate",isShowPE);
                console.log('>>>>Showwww PEEEEE >>>>>>>>>>'+JSON.stringify(component.get("v.ShowProductionEstimate")));
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(showPEAction);                          
    },
    
    getFiltersandCustomSetting :function(component, event, helper){
        var frec=component.get("c.getFiltersData");
        frec.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var freclist=response.getReturnValue();
                component.set("v.CampaignList",freclist[0]);
                component.set("v.MediaTypeList",freclist[1]);
                component.set("v.ScheduleTempList",freclist[2]);
                component.set("v.ClientList",freclist[3]);
            } 
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        
        var csAct=component.get("c.getCustomSettingdata");
        csAct.setCallback(this, function (CSresponse) {
            var CSstate = CSresponse.getState();
            if (CSstate === "SUCCESS") {
                component.set("v.CSdata",CSresponse.getReturnValue());
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',CSresponse.getError()[0].message);
                var errors = CSresponse.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        
        $A.enqueueAction(frec);
        $A.enqueueAction(csAct);
    },
    
    getTotalActiveJobRecords :function(component, event, helper){
        
        var activeTotalJobs=component.get("c.getTotalNoOfActiveJobs");
        activeTotalJobs.setCallback(this, function (res) {
            if (res.getState() === "SUCCESS") {
                component.set("v.totalAcitveJobRows",res.getReturnValue());
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        
        $A.enqueueAction(activeTotalJobs);
    },
    
    
    runFilterJobs : function(component, event, helper,CampainStringList,MTypeStringList,STempStringList,ClientStringList) {
        
        var FJobAction= component.get("c.FilterChangesJobs");
        FJobAction.setParams({
            strCampaignName:CampainStringList,
            strmediatype:MTypeStringList,
            strscheduletemp:STempStringList,
            strClientName:ClientStringList
        });
        FJobAction.setCallback(this, function(response){ 
            
            console.log('======Run filters job response==='+response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('====Run filters rows Length===='+rows.length);
                console.log('====Run filters rows===='+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                }
                component.set("v.data",rows);
                component.set("v.totalAcitveJobRows",rows.length);
                
            } 
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });  
        $A.enqueueAction(FJobAction);
        //(List<string> strCampaignName,List<string> strmediatype,List<string> strscheduletemp,List<string> strClientName);
    },
    
    
    MarkCompleteJobsApproveConfirmation : function(component, event, helper,showPE) {
        if(showPE){            
            var modalBody;
            var modalFooter; 
            $A.createComponents([
                ["lightning:button",
                 {
                     "aura:id": "NoApprovePEId",
                     "label": "No",
                     "onclick":component.getReference("c.NoAllApprovePE") 
                 }],
                ["lightning:button",
                 {
                     "aura:id": "YesApprovePEId",
                     "variant" :"brand",
                     "label": "Yes",
                     "onclick": component.getReference("c.YesAllApprovePE") 
                 }]
            ],
                                function(content, status, errorMessage){
                                    if (status === "SUCCESS") {
                                        modalBody = 'Do you want to Aprrove  all Production Estimate Line Items?';
                                        modalFooter=content;
                                        var ApprovePEModal=component.find('overlayLibForPE').showCustomModal({
                                            header: "Aprrove Production Estimate Line Items",
                                            body: modalBody,
                                            footer: modalFooter,
                                            showCloseButton: true,
                                            cssClass: "mymodal"
                                        });
                                        
                                        component.set("v.overlayPanelForPE", ApprovePEModal);   
                                    } 
                                    else if (status === "ERROR") {
                                        console.log("Error: " + errorMessage);
                                    }
                                    
                                }
                               );
            
        }      
    },
    
    MarkCompleteJobsApproveConfirmationTasks : function(component, event, helper) {
        
        var modalBody1;
        var modalFooter1; 
        $A.createComponents([
            ["lightning:button",
             {
                 "aura:id": "NoCompleteId",
                 "label": "No",
                 "onclick":component.getReference("c.NoAllTaskDone") 
             }],
            ["lightning:button",
             {
                 "aura:id": "YesCompleteId",
                 "variant" :"brand",
                 "label": "Yes",
                 "onclick": component.getReference("c.YesAllTaskDone") 
             }]
        ],
                            function(content, status, errorMessage){
                                if (status === "SUCCESS") {
                                    modalBody1 = 'Do you want to mark  all Tasks done?';
                                    modalFooter1=content;
                                    var completeModal=component.find('overlayLibForTask').showCustomModal({
                                        header: "Status Complete",
                                        body: modalBody1,
                                        footer: modalFooter1,
                                        showCloseButton: true,
                                        cssClass: "mymodal"
                                    });
                                    
                                    component.set("v.overlayPanelForTask", completeModal);   
                                } 
                                else if (status === "ERROR") {
                                    console.log("Error: " + errorMessage);
                                }
                                
                            }
                           );
        
    },
    
    MarkFinalCompleteJobs : function(component, event, helper) {
        var selectedJobs=component.get("v.Selected_Jobs");
        var isApprovePE=component.get("v.isApproveAllPE");
        var isMarkDoneTaks=component.get("v.isMarkDoneAllTasks");
        console.log('=======selectedJobs final stage=============='+selectedJobs);
        var CmpAction=component.get("c.MarkDoneCompleteJobs");
        CmpAction.setParams({
            selJobs:selectedJobs,
            completePEItems:isApprovePE,
            completeTaskItems:isMarkDoneTaks
            
        });
        CmpAction.setCallback(this, function (Cmpresponse) {
            var Cmpstate = Cmpresponse.getState();
            if (Cmpstate === "SUCCESS") {
                if(Cmpresponse.getReturnValue()=="OK"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "message": selectedJobs.length +" Jobs Sucessfully Completed."
                    });
                    toastEvent.fire(); 
                    component.set("v.isApproveAllPE",false);
                    component.set("v.Selected_Jobs",[]);
                    component.set("v.selectedRowsCount",0);
                    component.set("v.data",[]);
                    // helper.FetchMassUpdateJobRecords(component, event, helper,0);
                    // helper.getTotalActiveJobRecords(component, event, helper);
                     helper.filerJobRefecth(component, event, helper);
                    // helper.resetFiltersHelper(component, event, helper);
                    
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!!",
                        "message": Cmpresponse.getReturnValue()
                    });
                    toastEvent.fire();   
                    
                }
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!!",
                    "message": Cmpresponse.getReturnValue()
                });
                toastEvent.fire();   
                
            }
        });
        
        $A.enqueueAction(CmpAction);
        // MarkDoneCompleteJobs(List<Job__c> selJobs ,boolean completeItems)
    },
    
    resetFiltersHelper : function(component, event, helper){
        component.set("v.CampaignList",null);
        component.set("v.MediaTypeList",null);
        component.set("v.ScheduleTempList",null);
        component.set("v.ClientList",null);
        component.set("v.data",[]);
        component.set("v.enableInfiniteLoading",true);
        component.set("v.selectedRowsCount",0);
        component.set("v.Selected_Jobs",[]);
        helper.getFiltersandCustomSetting(component, event, helper);
        helper.FetchMassUpdateJobRecords(component, event, helper,0);
        helper.getTotalActiveJobRecords(component, event, helper);
    },
    
    filerJobRefecth : function(component, event, helper){
        var CampainStringList=[];
        var MTypeStringList=[];
        var STempStringList=[];
        var ClientStringList=[];
        var camp=document.getElementById("CampAuraId");
        var MT=document.getElementById("MTAuraId");
        var ST=document.getElementById("STAuraId");
        var C=document.getElementById("ClientAuraId");
        
        for (var i = 0; i < camp.options.length; i++) {
            if(camp.options[i].selected ==true){
                CampainStringList.push(camp.options[i].value);
            }
        }
        
        for (var i = 0; i < MT.options.length; i++) {
            if(MT.options[i].selected ==true){
                MTypeStringList.push(MT.options[i].value);
            }
        }
        
        for (var i = 0; i < ST.options.length; i++) {
            if(ST.options[i].selected ==true){
                STempStringList.push(ST.options[i].value);
            }
        }
        
        for (var i = 0; i < C.options.length; i++) {
            if(C.options[i].selected ==true){
                ClientStringList.push(C.options[i].value);
            }
        }
        
        
        console.log('======CampainStringList=='+CampainStringList);
        console.log('======MTypeStringList=='+MTypeStringList);
        console.log('======STempStringList=='+STempStringList);
        console.log('======ClientStringList=='+ClientStringList);
        
        if(CampainStringList.length>0 || MTypeStringList.length>0 || STempStringList.length>0 || ClientStringList.length>0){
            component.set("v.enableInfiniteLoading",false);
            console.log('===Filtere with Off INfine Load====');
            helper.runFilterJobs(component, event, helper,CampainStringList,MTypeStringList,STempStringList,ClientStringList);          
        }
        else{
            
            component.set("v.enableInfiniteLoading",true); 
            component.set("v.data",[]);
            console.log('===Filtere with Off INfine Load==ON==');
            helper.FetchMassUpdateJobRecords(component, event, helper, 0);
            helper.getTotalActiveJobRecords(component, event, helper);
        }
        
        
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})