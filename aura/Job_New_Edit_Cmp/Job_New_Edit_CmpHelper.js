({
    getFieldsforObject : function(component, sObj){
        var action = component.get("c.getFieldsforJobObject");
        action.setParams({
            sObjName : sObj,
            fieldsetname : "Job_Field_sets"
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("list of fiels name===" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.fieldSet", response.getReturnValue());
                /*  var fiquery=response.getReturnValue().toString();
                var fixiedfields=['Campaign__r.Name','Media_Types__r.Name','Schedule_Template__r.Name','JS_Client__r.Name','JS_Client_Contact__r.Name','Specification_Template__r.Name'];
                var filedlist=response.getReturnValue();
            
                filedlist.push(fixiedfields[0]);
                filedlist.push(fixiedfields[1]);
                filedlist.push(fixiedfields[2]);
                filedlist.push(fixiedfields[3]);
                filedlist.push(fixiedfields[4]);
                filedlist.push(fixiedfields[5]);
               
                //console.log('==fianl filedlist===='+filedlist);
                //component.set("v.fieldtoQuery", filedlist);
                //component.find("Jobrecord").reloadRecord();
                */
            } 
        });
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName : sObj
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            } 
        });
        $A.enqueueAction(action1);
        $A.enqueueAction(action);
    },
    
    fetchCustomSettingdata :function(component, event , helper){
        var csAction = component.get("c.CustomSettingvalues");
        csAction.setCallback(this, function(response){
            var state = response.getState();
            console.log("custom setting response===" + JSON.stringify(response.getReturnValue()));
            if(state === "SUCCESS"){
                var PECSData=response.getReturnValue();
                console.log("Data===" + JSON.stringify(PECSData));
                console.log("lenght===" + JSON.stringify(PECSData.length));
              var PECC =  PECSData[0].Display_Client_Contact__c;
                if(PECC)
                {
                    //alert(PECC);
                     component.set("v.PECC",PECC);// PE Client Contact
                }
                else
                {
                    //alert(PECC);
                    component.set("v.PECC",PECC);
                }
                component.set("v.PECustomSetting",PECSData[0]);
               
                component.set("v.OrgInfo",PECSData[1]); 
                component.set("v.ProInfo",PECSData[2]);
                if(PECSData.length==4){
                    component.set("v.ClientInfo",PECSData[3]);  
                }
                
            }
        });
        $A.enqueueAction(csAction);
    },
    
    JobStatusChangehandle: function (component, event, helper, showPE){
        if(showPE)  {
            var modalBody1;
            var modalFooter1; 
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
                                        modalBody1 = 'Do you want to Aprrove  all Production Estimate Line Items?';
                                        modalFooter1=content;
                                        var AppPEModal=component.find('overlayLibForPE').showCustomModal({
                                            header: "Status Complete",
                                            body: modalBody1,
                                            footer: modalFooter1,
                                            showCloseButton: true,
                                            cssClass: "mymodal"
                                        });
                                        alert('AppPEModal==='+AppPEModal);
                                        component.set("v.overlayPanelForPE", AppPEModal);   
                                    } 
                                    else if (status === "ERROR") {
                                        console.log("Error: " + errorMessage);
                                    }
                                }
                               );
        }
        var modalBody;
        var modalFooter; 
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
                                    modalBody = 'Do you want to mark  all Tasks done?';
                                    modalFooter=content;
                                    var completeModal=component.find('overlayLibForTask').showCustomModal({
                                        header: "Status Complete",
                                        body: modalBody,
                                        footer: modalFooter,
                                        showCloseButton: true,
                                        cssClass: "mymodal"
                                    });
                                    alert('completeModal==='+completeModal);
                                    component.set("v.overlayPanelForTask", completeModal);   
                                } 
                                else if (status === "ERROR") {
                                    console.log("Error: " + errorMessage);
                                }
                                
                            }
                           );
    },
    
})