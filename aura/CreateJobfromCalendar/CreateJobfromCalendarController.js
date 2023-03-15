({
    doInit : function(component, event, helper) {
        var sObj = 'Job__c';
        if(sObj){
            helper.getFieldsforObject(component, sObj);
            helper.fetchCustomSettingdata(component, event, helper);
            
        }
        
        var action = component.get( "c.getObjectType" );
        action.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
                
            } else {
                console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );
            }
        });
        $A.enqueueAction( action );   
    },
    
    
    onloadrecord : function(component, event, helper){
        try
        {
            var StartDate=component.get("v.startDate");
            console.log('>>>>>>>'+StartDate);
            var SchuCalVal=component.find("schuleCalauraId").get("v.value");
            console.log('>>>>>>>>SchuCalVal>>>>>>'+SchuCalVal);
            var recId=component.get("v.recordId");
            var fieldsets=component.get("v.fieldSet");
            var CConInfo=component.get("v.ClientInfo");
            var PECustomSetting=component.get("v.PECustomSetting");
            var OrgInfo=component.get("v.OrgInfo");
            var ProInfo=component.get("v.ProInfo");    
            var ShowNotrequiredJob =PECustomSetting.Remove_Required_of_Job_name__c;
            var ShowNotReScheduleJob=PECustomSetting.Recalculate_Schedule_Job__c;
            console.log('===record Load fieldsets==='+fieldsets);
            console.log('===record Load==='+(recId==null));
            console.log('===ClientContactInfo=='+CConInfo);
            console.log('===update schdule=='+fieldsets.includes('UpdateSchedDateFieldCheck__c'));
            
            var CampPopulate=component.get("v.CampPopulate");
            console.log('===CampPopulate===='+CampPopulate);
            if(CampPopulate!=null && CampPopulate!=''){
                console.log('===CampPopulate after if===='+JSON.stringify(CampPopulate));
                component.find("CampauraId").sampleMethod(CampPopulate);
            }
            
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
                if(SchuCalVal=='Start Date'){
                    component.find("StartDateVal").set("v.value",StartDate);
                }
                if(SchuCalVal=='End Date'){
                    component.find("DueDateVal").set("v.value",StartDate);
                }
                 var Jobfields = event.getParam("recordUi");
                console.log('>>>>>>>>>>>>> Job Fields'+JSON.stringify(Jobfields));
                component.find("StartTime").set("v.value",Jobfields.record.fields.Start_Time__c.value);
                component.find("EndTime").set("v.value",Jobfields.record.fields.End_Time__c.value);
            }
            
        }
        catch (e) {
            // Handle error
            var ToastMsgName=$A.get("e.force:showToast");
            //var errors = response.getError();
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
        var StrtVal="";
        var DueVal="";
        var missField="";
        
        if(ShowNotrequiredJob==false) {
            if(( OrgInfo.Id !='00DG0000000k48JMAQ' || OrgInfo.Id !='00DJ000000371J9MAI' )){
                NamemissField=component.find("NameRequiredId").get("v.value");
                if(NamemissField==null || NamemissField=='' ){
                    NamemissField="Name";
                }
            }
        }
        
        SchuCalMissing=component.find("schuleCalauraId").get("v.value");
        if(SchuCalMissing==null || SchuCalMissing==''){
            missField="Schedule Calc";
        }
        
        SchuCal=component.find("schuleCalauraId").get("v.value");
        StrtVal=component.find("StartDateVal").get("v.value");
        DueVal=component.find("DueDateVal").get("v.value");
        
        if(SchuCal=="Start Date"){
            if(StrtVal==null || StrtVal==''){
                missField="Start Date";
            }
        }
        if(SchuCal=="End Date"){
            if(DueVal==null || DueVal==''){
                missField="Due Date";
            }
        }
        
        
       /* StrtVal=component.find("StartDateVal").get("v.value");
        DueVal=component.find("DueDateVal").get("v.value");
        if(StrtVal==null || StrtVal==''){
            missField="Start Date";
        }
        
        if(DueVal==null || DueVal==''){
            missField="Due Date";
        }*/
        
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
                                    }
                                    
                                    if(typeof(component.get("v.selectedLookUpRecord_ST").Id)!="undefined"){
                                        jbName += component.get("v.selectedLookUpRecord_ST").Name + ' ';
                                    }
                                    
                                    var d = new Date();
                                    jbName +=d.getFullYear();
                                    fields["Name"]=jbName;  
                                }
                                
                                if(recId!=null ){
                                    var MarkDoneAll=component.get("v.isMarkDoneAllTasks");
                                    var ApprovePEAll=component.get("v.isApproveAllPE");
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
        
       /* var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Calendars",
        });
        evt.fire();*/
        
       // var url = window.location.href; 
       // var value = url.substr(0,url.lastIndexOf('/') + 1);
       // 
       // window.history.back();
        
        
        resultsToast.setParams({
            "title": "Saved",
            "type" : "success",
            "message": "The record was saved."
        });
        resultsToast.fire();
      
        navEvt.setParams({
            "recordId": event.getParam("response").id,
             "slideDevName": "detail"          
        });
        navEvt.fire();
    },
    
    doCancel:function(component, event, helper) {
        
        if(component.get("v.recordId")!=null){
          /*  var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:Calendars",
            });
            evt.fire();*/
             
            window.history.back();
        }
        else
        {
           /* var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:Calendars",
                componentAttributes: {
                    selectedCal : 'Job Calendar'
                }
            });
            evt.fire();**/
            window.history.back();
           
        }
        
    }
})