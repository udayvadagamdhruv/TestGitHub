({
    doInit : function(component,event,helper) {
        var DateAction=component.get("c.todaySystemDate");
        DateAction.setCallback(this, function(Dtresponse){
            if (Dtresponse.getState() === "SUCCESS") {
                console.log('=Create Scule settings=='+Dtresponse.getReturnValue());
                component.set("v.todayDate",Dtresponse.getReturnValue());  
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',Dtresponse.getError());
                var errors = Dtresponse.getError();             
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }
        }); 
        $A.enqueueAction(DateAction); 
        helper.fetchObjectLabels(component,event,helper);
    },
    
    
    YesEditDaysAction : function(component,event,helper) {
        component.set("v.isDaysChanged",true);
        //component.set("v.isDueDateChanged",false);
        //var overlayPanel = component.get('v.overlayPanel1');
        // overlayPanel[0].close();
        component.get('v.overlayPanel1').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    NoEditDaysAction : function(component,event,helper) {
        component.set("v.isDaysChanged",false);
        //component.set("v.isDueDateChanged",false);
        //var overlayPanel = component.get('v.overlayPanel1');
        // overlayPanel[0].close();
        component.get('v.overlayPanel1').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    EditDaysChanged : function(component,event,helper) {
        var Days=event.getParam('value');
        console.log('=== changed value==='+Days!=null);
        console.log('===Days  changed value==='+(Days!=''));
        if(Days!=null && Days!=''  ){          
            helper.EditTaskDaysChanged(component,event,helper);
        }
        
    },
    
    
    YesEditDateAction : function(component,event,helper) {
        component.set("v.isDueDateChanged",true);
        //component.set("v.isDaysChanged",false);
        //var overlayPanel = component.get('v.overlayPanel1');
        // overlayPanel[0].close();
        component.get('v.overlayPanel1').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    NoEditDateAction : function(component,event,helper) {
        component.set("v.isDueDateChanged",false);
        //component.set("v.isDaysChanged",false);
        //var overlayPanel = component.get('v.overlayPanel1');
        // overlayPanel[0].close();
        component.get('v.overlayPanel1').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    EditDueDateChanged : function(component,event,helper) {
        var Date=event.getParam('value');
        console.log('=== changed value==='+Date!=null);
        console.log('===Date  changed value==='+(Date!=''));
        if(Date!=null && Date!=''  ){          
            helper.EditTaskDateChanged(component,event,helper);
        }
        
    },
    
    
    closeTaskModel: function(component, event, helper) {
        component.set("v.isDueDateChanged",false);
        component.set("v.isDaysChanged",false);
        
        var rec=component.get("v.record");
        console.log('=====simplerec===='+JSON.stringify(rec));
        var TaskId=component.get("v.recordId");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": TaskId,
            "slideDevName": "detail"
        });
        navEvt.fire();   
    },
    
    
    TaskOnLoad : function(component, event, helper){
        
        var TaskrecId=component.get("v.recordId");
        console.log('===record Load==='+TaskrecId);
        if(TaskrecId!=null){
            
            var Taskfields = event.getParam("recordUi");
            console.log('===record filed data=='+JSON.stringify(Taskfields.record));
            console.log('===GL Code Id=='+(Taskfields.record.fields.GL_Code__c.value));
            component.set("v.isTaskLocked",Taskfields.record.fields.Locked__c.value);
            // component.set("v.isLoadedDate",Taskfields.record.fields.Revised_Due_Date__c.value);
            //component.set("v.isLoadedDays",Taskfields.record.fields.Days__c.value); 
            if(Taskfields.record.fields.GL_Code__c.value!=null ){
                var GLcodeObj={"Id":Taskfields.record.fields.GL_Code__r.value.fields.Id.value, "Name":Taskfields.record.fields.GL_Code__r.value.fields.Name.value};
                component.find("GL_CodeId").sampleMethod(GLcodeObj);
            }
            
        }
        
    },
    
    TaskOnsubmit : function(component, event, helper){
        event.preventDefault(); // Prevent default submit
        var fields = event.getParam("fields");
        console.log('===fields=='+JSON.stringify(fields));
        //fields["Job_Description__c"] = 'This is a default description'; // Prepopulate Description field
        
        var NameField="";
        var StausField="";
        var DueDateField="";
        var reduceReutrn=component.find('JobTaskFields').reduce(function (validFields, inputCmp) {
            //console.log("fieldName :"+inputCmp.get("v.fieldName")+"----value--"+inputCmp.get("v.value"));
            if(inputCmp.get("v.fieldName") == "Name"){
                var TaskName =inputCmp.get("v.value");
                if(TaskName==null || TaskName==''){
                    NameField="Name";
                }
            }
            else if(inputCmp.get("v.fieldName") == "Status__c"){
                var status =inputCmp.get("v.value");
                if(status==null || status==''){
                    StausField="Status";
                }
                
                else if(status=='Completed')
                {
                    if(fields["Completion_Date__c"] == null)
                    {
                        var today = component.get("v.todayDate");
                        fields["Completion_Date__c"]=today;
                    }
                    fields["Marked_Done__c"]=true;
                }
                
                    else if(status=='Active'|| status=='Requested')
                    {
                        fields["Marked_Done__c"]=false;
                        fields["Completion_Date__c"]=null;
                    }
            }
                else if(inputCmp.get("v.fieldName") == "Revised_Due_Date__c"){
                    var DueDate =inputCmp.get("v.value");
                    if(DueDate==null || DueDate==''){
                        DueDateField="Due Date";
                    }
                }
            
        }, true);
        
        var ToastMsg=$A.get("e.force:showToast");
        ToastMsg.setParams({
            "title":NameField,
            "type": "error",
            "message": NameField+" Field is required."
            
        });
        var ToastMsg1=$A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title":StausField,
            "type": "error",
            "message": StausField+" Field is required."
            
        });
        var ToastMsg2=$A.get("e.force:showToast");
        ToastMsg2.setParams({
            "title":DueDateField,
            "type": "error",
            "message": DueDateField+" Field is required."
            
        });
        if(NameField=="Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else if(StausField=="Status"){
            ToastMsg1.fire();
            event.preventDefault();
        }
            else if(DueDateField=="Due Date"){
                ToastMsg2.fire();
                event.preventDefault();
            }
                else{
                    
                    if(typeof(component.get("v.selectedLookUpRecord_GLCode").Id)==="undefined"){
                        fields["GL_Code__c"]="";
                    }
                    else{
                        fields["GL_Code__c"]=component.get("v.selectedLookUpRecord_GLCode").Id;  
                    }
                    
                    console.log('===fields last=='+JSON.stringify(fields));
                    component.find("TaskEditForm").submit(fields);
                }
        
        
    },
    
    TaskOnSuccess : function(component, event, helper){
        var TaskId=component.get("v.recordId");
        var UpdateRestDays=component.get("v.isDaysChanged");
        var UpdateRestDates=component.get("v.isDueDateChanged");
        helper.TaskEditSucess(component, event, helper,TaskId,UpdateRestDays,UpdateRestDates);
    }, 
    
    
    
})