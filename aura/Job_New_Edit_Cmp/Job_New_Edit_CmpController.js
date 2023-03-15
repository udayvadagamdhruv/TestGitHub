({
    doInit : function(component, event, helper) {
       
        var sObj = component.get("v.sObjectName");
        console.log('sobj doinit  '+sObj);
        if(sObj){
            console.log('===sobject name==='+sObj); 
            helper.getFieldsforObject(component, sObj);
            helper.fetchCustomSettingdata(component, event, helper);
        }
        var action = component.get( "c.getObjectType" );
        action.setCallback( helper, function( response ) {
            //console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                var res =  response.getReturnValue();
                console.log('The res is '+res);
                component.set('v.ObjectType',JSON.parse(response.getReturnValue()));
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse(response.getReturnValue())));
            } else {
                console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );
            }
        });
        $A.enqueueAction(action);   
    },
    
    onloadrecord : function(component, event, helper){
      
        try
        {
            console.log('>>>>>>>>>>>>>>>>>>>Onload>>>>>>>>>>>>>>>>>>>>>>>>');
            var recId=component.get("v.recordId");
            var fieldsets=component.get("v.fieldSet");
            var CConInfo=component.get("v.ClientInfo");
            var PECustomSetting=component.get("v.PECustomSetting");
            console.log('The setings are====== '+JSON.stringify(PECustomSetting));
            var OrgInfo=component.get("v.OrgInfo");
            var ProInfo=component.get("v.ProInfo");    
            var ShowNotrequiredJob =PECustomSetting.Remove_Required_of_Job_name__c;
            var ShowNotReScheduleJob=PECustomSetting.Recalculate_Schedule_Job__c;
            var displayclientcontact = PECustomSetting.Display_Client_Contact__c;
            console.log('===record Load==='+(recId==null));
            console.log('===ClientContactInfo=='+CConInfo);
            console.log('===update schdule=='+fieldsets.includes('UpdateSchedDateFieldCheck__c'));
            
            var CampPopulate=component.get("v.CampPopulate");
            console.log('===CampPopulate===='+CampPopulate);
            if(CampPopulate!=null && CampPopulate!=''){
                console.log('===CampPopulate after if===='+JSON.stringify(CampPopulate));
                component.find("CampauraId").sampleMethod(CampPopulate);
            }
            console.log('The recid is '+recId); 
            if(recId==null){
                if(CConInfo!=null){
                    var CObj={"Id":CConInfo.Client__c, "Name":CConInfo.Client__r.Name};
                    var CCTObj={"Id":CConInfo.Id,"Name":CConInfo.Name};
                    component.find("C_CConId").sampleMethod(CObj,CCTObj);
                }
                if(ProInfo.Name == 'Client Contact' || ProInfo.Name == 'SP Client Contact'){
                    if(OrgInfo.Name == 'Healthy Directions') {
                        component.find("schuleCalauraId").set("v.value",'End Date');
                    }  
                }
                if(fieldsets.includes('UpdateSchedDateFieldCheck__c')){
                    if(ShowNotReScheduleJob==true)
                    {
                        component.find("RecaluauraId").set("v.value",true);
                    }
                    else
                    {
                        component.find("RecaluauraId").set("v.value",false);
                    }
                }
                
                if(OrgInfo.Id == '00DG0000000k48JMAQ' || OrgInfo.Id == '00DJ000000371J9MAI'){
                    var today = new Date();
                    var dd = String(today.getDate()).padStart(2, '0');
                    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                    var yyyy = today.getFullYear();
                    
                    today = yyyy + '-' + mm + '-' + dd;
                    component.find("NotNameRequiredId").set("v.value",today);
                }
            }
            else{  
                var simRec=component.get("v.simpleRecord");
                console.log('===Simple Record Data Load==='+JSON.stringify(simRec));
                if(simRec.Start_Time__c!=null ){
                    var CmpObj={"Id":simRec.Start_Time__c, "Name":simRec.Campaign__r.Name};
                    component.find("CampauraId").sampleMethod(CmpObj);
                }
                
                if(simRec.Campaign__c!=null ){
                    var CmpObj={"Id":simRec.Campaign__c, "Name":simRec.Campaign__r.Name};
                    component.find("CampauraId").sampleMethod(CmpObj);
                }
                
                if(simRec.Media_Types__c!=null){
                    var MTObj={"Id":simRec.Media_Types__c, "Name":simRec.Media_Types__r.Name};
                    var STObj;
                    if(simRec.Schedule_Template__c!=null){
                        STObj={"Id":simRec.Schedule_Template__c,"Name":simRec.Schedule_Template__r.Name};
                    }
                    else {
                        STObj={};
                    }
                    //var STObj={"Id":simRec.Schedule_Template__c, "Name":simRec.Schedule_Template__r.Name};
                    component.find("MT_STempId").sampleMethod(MTObj,STObj);
                }
                
                if(displayclientcontact)
                {
                    if(simRec.JS_Client__c!=null){
                        var CObj={"Id":simRec.JS_Client__c, "Name":simRec.JS_Client__r.Name};
                        var CCTObj;
                        if(simRec.JS_Client_Contact__c!=null){
                            CCTObj={"Id":simRec.JS_Client_Contact__c,"Name":simRec.JS_Client_Contact__r.Name};
                            component.find("C_CConId").sampleMethod(CObj,CCTObj);
                        }
                        else {
                            CCTObj={};
                            component.find("C_CConId").sampleMethod(CObj,CCTObj);
                           // alert('CCTObj '+CCTObj);
                        }
                    }
                }
                
                else
                {
                    if(simRec.JS_Client__c!=null){
                        var CObj={"Id":simRec.JS_Client__c, "Name":simRec.JS_Client__r.Name};
                        component.find("C_CConId2").sampleMethod(CObj);
                    }
                }
                
                
                if(simRec.Specification_Template__c!=null){
                    var Stemp={"Id":simRec.Specification_Template__c, "Name":simRec.Specification_Template__r.Name};
                    component.find("STempId").sampleMethod(Stemp);
                }
                var Jobfields = event.getParam("recordUi");
                console.log('>>>>>>>>>>>>> Job Fields'+JSON.stringify(Jobfields));
                component.find("StartTime").set("v.value",Jobfields.record.fields.Start_Time__c.value);
                component.find("EndTime").set("v.value",Jobfields.record.fields.End_Time__c.value);
            }
        }
        catch (e) {
            // Handle error
            // console.log(error(e));
            var ToastMsgName=$A.get("e.force:showToast");
            ToastMsgName.setParams({
                "title": "Error!!",
                "type": "error",
                "message": e.message
            }); 
        }
    },
    
    RecordSubmit : function(component, event, helper) {
        var recId=component.get("v.recordId");
        var PECustomSetting=component.get("v.PECustomSetting");
        var OrgInfo=component.get("v.OrgInfo");
        var ProInfo=component.get("v.ProInfo");    
        var ShowNotrequiredJob =PECustomSetting.Remove_Required_of_Job_name__c;
        var ShowNotReScheduleJob=PECustomSetting.Recalculate_Schedule_Job__c;
        var ShowPE=PECustomSetting.Active__c;
        console.log('===PECustomSetting=='+JSON.stringify(PECustomSetting));
        console.log('===OrgInfo=='+JSON.stringify(OrgInfo));
        console.log('===ProInfo=='+JSON.stringify(ProInfo));
        console.log('===ShowNotrequiredJob=='+JSON.stringify(ShowNotrequiredJob));
        console.log('===ShowNotReScheduleJob=='+JSON.stringify(ShowNotReScheduleJob));
        event.preventDefault(); // Prevent default submit
        var fields = event.getParam("fields");
        console.log('===fields=='+JSON.stringify(fields));
        //fields["Job_Description__c"] = 'This is a default description'; // Prepopulate Description field
        var NamemissField="";
        var SchuCalMissing="";
        var SchuCal="";
        var missField="";
        if(ShowNotrequiredJob==false) {
            if(( OrgInfo.Id !='00DG0000000k48JMAQ' || OrgInfo.Id !='00DJ000000371J9MAI' )){
                NamemissField=component.find("NameRequiredId").get("v.value");
                if(NamemissField==null || NamemissField=='' ){
                    NamemissField="Name";
                    console.log('name======'+Name+'and NamemissField===='+NamemissField);
                }
            }
        }
        SchuCalMissing=component.find("schuleCalauraId").get("v.value");
        if(SchuCalMissing==null || SchuCalMissing==''){
            missField="Schedule Calc";
            console.log('SchuCalMissing======'+SchuCalMissing+'and missField===='+missField);
        }
        else
        {
            SchuCal=component.find("schuleCalauraId").get("v.value");
            var reduceReutrn=component.find('fsOne').reduce(function (validFields, inputCmp) {
                //console.log("fieldName :"+inputCmp.get("v.fieldName")+"----value--"+inputCmp.get("v.value"));
                if(SchuCal=="Start Date")
                {
                    if(inputCmp.get("v.fieldName") == "Start_Date__c")
                    {
                        var StartDate=inputCmp.get("v.value");
                        if( (SchuCal=="Start Date") && (StartDate=='' || StartDate==null)){
                            missField="Start Date";
                            console.log('SchuCalMissing in else======'+SchuCal+'and missField===='+missField);
                        }
                    }
                }
                if(SchuCal=="End Date"){
                    if(inputCmp.get("v.fieldName") == "Due_Date__c"){
                        var DueDate=inputCmp.get("v.value");
                        if( (SchuCal=="End Date") && (DueDate=='' || DueDate==null)){
                            missField="Due Date";          
                            console.log('SchuCalMissing in end date======'+SchuCal+'and missField===='+missField+'DueDate==='+DueDate);
                        }
                    }
                }
            }, true);
        }
        var ToastMsgName=$A.get("e.force:showToast");
        ToastMsgName.setParams({
            "title":NamemissField,
            "type": "error",
            "message": NamemissField+" Field is required."
        });
        var ToastMsg=$A.get("e.force:showToast");
        ToastMsg.setParams({
            "title":missField,
            "type": "error",
            "message": missField+" Field is required."
        });
        if(NamemissField=="Name"){
            ToastMsgName.fire();
            event.preventDefault();
        }
        else if(missField=="Schedule Calc"){
            ToastMsg.fire();
            event.preventDefault();
        }
            else if(missField=="Start Date"){
                ToastMsg.fire();
                event.preventDefault();
            }
                else if(missField=="Due Date"){
                    ToastMsg.fire();
                    event.preventDefault();
                }
                    else if(component.get("v.selectedLookUpRecord_MT").Id==null){
                        var ToastMsg1=$A.get("e.force:showToast");
                        ToastMsg1.setParams({
                            "title":"Media Type",
                            "type": "error",
                            "message":"Media Type Field is required."
                        });   
                        ToastMsg1.fire();
                        event.preventDefault();   
                    }
                        else if(component.get("v.selectedLookUpRecord_ST").Id==null ){
                            var ToastMsg2=$A.get("e.force:showToast");    
                            ToastMsg2.setParams({
                                "title":"Schedule Template",
                                "type": "error",
                                "message":"Schedule Template Field is required."
                            });   
                            ToastMsg2.fire();
                            event.preventDefault();   
                        }
                            else{
                                if(typeof(component.get("v.selectedLookUpRecord_CMP").Id)==="undefined"){
                                    fields["Campaign__c"]="";
                                }
                                else{
                                    fields["Campaign__c"]=component.get("v.selectedLookUpRecord_CMP").Id;  
                                }
                                if(typeof(component.get("v.selectedLookUpRecord_CT").Id)==="undefined"){
                                    fields["Specification_Template__c"]="";
                                } 
                                else{
                                    fields["Specification_Template__c"]=component.get("v.selectedLookUpRecord_CT").Id;
                                }
                                
                                if(typeof(component.get("v.selectedLookUpRecord_C").Id)==="undefined"){
                                    fields["JS_Client__c"]="";
                                }
                                else{
                                    fields["JS_Client__c"]=component.get("v.selectedLookUpRecord_C").Id;
                                }
                                if(typeof(component.get("v.selectedLookUpRecord_CC").Id)==="undefined"){
                                    fields["JS_Client_Contact__c"]="";
                                }
                                else{
                                    fields["JS_Client_Contact__c"]=component.get("v.selectedLookUpRecord_CC").Id;
                                }
                                if((OrgInfo.Id == '00DG0000000k48JMAQ' || OrgInfo.Id == '00DJ000000371J9MAI') && recId==null){
                                    var jbName = '';
                                    if(typeof(component.get("v.selectedLookUpRecord_CMP").Id)!="undefined"){
                                        jbName += component.get("v.selectedLookUpRecord_CMP").Name + ' ';
                                        console.log('The campaing name is '+jbName);
                                    }
                                    if(typeof(component.get("v.selectedLookUpRecord_ST").Id)!="undefined"){
                                        jbName += component.get("v.selectedLookUpRecord_ST").Name + ' ';
                          console.log('The slectlookup rcd name is '+jbName);
                                    }
                                    var d = new Date();
                                    jbName +=d.getFullYear();
                                       console.log('The d is '+jbName);
                                    fields["Name"]=jbName;  
                                }
                                if(recId!=null ){
                                    var MarkDoneAll=component.get("v.isMarkDoneAllTasks");
                                    var ApprovePEAll=component.get("v.isApproveAllPE");
                                      console.log('=======recId===='+recId);
                                    console.log('=======MarkDoneAll===='+MarkDoneAll);
                                    console.log('=======ApprovePEAll===='+ApprovePEAll);
                                    console.log('=======ShowPE===='+ShowPE);
                                    if(MarkDoneAll){
                                        fields["marked_Done__c"]=true;
                                    }
                                    else{
                                        fields["marked_Done__c"]=false;
                                    }
                                    if(ApprovePEAll && ShowPE ){
                                        fields["Approve_PE__c"]=true;
                                    }
                                    else{
                                        fields["Approve_PE__c"]=false;
                                    }
                                }
                                fields["Media_Types__c"]=component.get("v.selectedLookUpRecord_MT").Id;
                                fields["Schedule_Template__c"]=component.get("v.selectedLookUpRecord_ST").Id;
                                var starttimeval;           
                                if(component.find("StartTime")!=null){
                                    starttimeval=component.find("StartTime").get("v.value");
                                    console.log('>>>>>>>> Start time >>>>>>>>>>>>>>'+ starttimeval);
                                    if(starttimeval!=null){
                                        if(starttimeval.length==0){
                                            fields["Start_Time__c"]=null; 
                                        }
                                        else{
                                            fields["Start_Time__c"]=starttimeval;
                                        }
                                    }else{
                                        fields["Start_Time__c"]=null;
                                    }
                                }
                                var EndTimeval;
                                if(component.find("EndTime")!=null){
                                    EndTimeval=component.find("EndTime").get("v.value");
                                    console.log('>>>>>>>> End time >>>>>>>>>>>>>>'+ EndTimeval);                
                                    if(EndTimeval!=null){
                                        if(EndTimeval.length==0){
                                            fields["End_Time__c"]=null; 
                                        }
                                        else{
                                            fields["End_Time__c"]=EndTimeval;
                                        }
                                    } 
                                    else{
                                        fields["End_Time__c"]=null;
                                    }
                                }        
                                console.log('===fields22 finaal with confiramtion of submit=='+JSON.stringify(fields));
                                component.find("createEditForm").submit(fields);
                            }
    },
    onRecordSuccess: function(component, event, helper) 
    { 
        console.log("====responseid==="+event.getParam("response").id);
        var navEvt = $A.get("e.force:navigateToSObject"); 
        var resultsToast = $A.get("e.force:showToast");
        navEvt.setParams({ 
            "recordId": event.getParam("response").id, 
            "slideDevName": "detail" }); 
        navEvt.fire(); 
        resultsToast.setParams({
            "title": "Saved",
            "type" : "success",
            "message": "The record was saved."
        });
        resultsToast.fire();
    },
    
    YesAllTaskDone : function(component,event,helper) {
        component.set("v.isMarkDoneAllTasks",true);
        component.get('v.overlayPanelForTask').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    NoAllTaskDone : function(component,event,helper) {
        component.set("v.isMarkDoneAllTasks",false);
        component.get('v.overlayPanelForTask').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    JobStatusChanges: function(component, event, helper) {
        var JobStatus=component.find("StatusauraId").get("v.value");
        var PECustomSetting=component.get("v.PECustomSetting");
        var ShowPE=PECustomSetting.Active__c;
        console.log('=====JobStatus========'+JobStatus);
        console.log('=====ShowPE========'+ShowPE);
        if(JobStatus=='Completed'){
            helper.JobStatusChangehandle(component, event, helper,ShowPE);
        }
    },
    
    YesAllApprovePE : function(component,event,helper) {
        component.set("v.isApproveAllPE",true);
        component.get('v.overlayPanelForPE').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    NoAllApprovePE : function(component,event,helper) {
        component.set("v.isApproveAllPE",false);
        component.get('v.overlayPanelForPE').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    
    doCancel:function(component, event, helper) {
        var CampPopulate=component.get("v.CampPopulate");
        console.log('===CampPopulate===='+CampPopulate);
        if(CampPopulate!=null && CampPopulate!=''){
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": CampPopulate.Id
            });
            navEvt.fire();
        }
        else{
            if(component.get("v.recordId")!=null){
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.recordId")
                });
                navEvt.fire();
            }
            else
            {
                var navEvt = $A.get("e.force:navigateToObjectHome");
                navEvt.setParams({
                    "scope":component.get("v.sObjectName")
                });
                navEvt.fire();
            }
        }
    }
})