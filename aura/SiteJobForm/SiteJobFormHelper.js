({
    
    FetchFieldsfromFS :  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Job__c",
            fieldsetname : "JobRequestFormFields"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", JSON.stringify(response.getReturnValue()));
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldSet",response.getReturnValue()); 
                
            }
        });
        
        $A.enqueueAction(action);
    },
    
    fetchOrgLogo :  function(component, event, helper){
        var action = component.get("c.imageURL");
        action.setCallback(this, function(response) {
            console.log("=====Logo Response====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.orgImageURL",response.getReturnValue()); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    fetchCusSettingdata :  function(component, event, helper){
        var action = component.get("c.CustomSettingData");
        action.setCallback(this, function(response) {
            console.log("=====Response Custom Setting Data====", JSON.stringify(response.getReturnValue()));
            if (response.getState() === "SUCCESS") {
                var CusSettingData = response.getReturnValue();
                console.log("====constant values==" + JSON.stringify(CusSettingData));
                
                component.set("v.ImageHeight",CusSettingData[0]); 
                component.set("v.ImageWidth",CusSettingData[1]); 
                component.set("v.RequestNameHeader",CusSettingData[2]); 
                component.set("v.CustomText",CusSettingData[3]); 
                component.set("v.FileSectionAccess",CusSettingData[4]); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getSpecObjLabels: function(component, event, helper) {
        var SpecObjaction = component.get( "c.geLabelforObject" );
        SpecObjaction.setParams({
            sObjName : 'Job_Spec__c'
        }); 
        SpecObjaction.setCallback( helper, function( response ) {
            console.log('>>>>>>Spec Label Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set('v.SpecObjName', response.getReturnValue());
                console.log('>>>>>> Result of Spec labels >>>>>>>>>>'+response.getReturnValue());
            } else {
                console.log('>>>>>> else >>>>>>>>>>');
                console.log('>>>>>> Result of else Spec labels >>>>>>>>>>'+response.getReturnValue());
            }
        });
        $A.enqueueAction(SpecObjaction);   
    },
    
    getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Job__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
            } else {
                console.log('>>>>>> else >>>>>>>>>>');
                // console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    
    
    getSpecTemplates: function(component, event, helper){
        var SpecTemp = component.get("c.getSpecTemp");
        SpecTemp.setCallback(this, function(response1) {
            console.log("=====Spec Templates====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                var SpecTempss=response1.getReturnValue();
                console.log('>>>>>>>>>>>>Spec Template Name>>>>>>>>>>>>'+JSON.stringify(SpecTempss));
                component.set("v.SpecTemplate", SpecTempss);
                console.log('>>>>>>>>>>>>Spec Template Namesssss>>>>>>>>>>>>'+JSON.stringify(component.get("v.SpecTemplate")));
            }
        });
        $A.enqueueAction(SpecTemp);
    },
    
    fetchJobSpec : function(component, event, SpecId) {
        var FetchSpecs = component.get("c.getSpecrecords");
        FetchSpecs.setParams({
            recordId : SpecId,
        });
        
        FetchSpecs.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('>>>Result>>>>>>', JSON.stringify(response.getReturnValue()));
                component.set("v.SpecRecords",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(FetchSpecs);
        
    },
    
    reloadComponent : function(){
        console.log('==========reload Component Page======');
        var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
    
    showToastMessage : function(component, messageData, toastMsgId, msgType) {
        
        console.log("-----js_LightningUtility:showToast----messageData----------"+messageData);
        if(msgType == undefined || msgType == ''){
            msgType = 'other';
        }
        var msgArray = [];
        if (Array.isArray(messageData)) {
            msgArray = messageData;
        } else {
            msgArray.push(messageData);
        }
        var msgContent = "";
        for(var i=0; i < msgArray.length ; i++){
            msgContent+= msgArray[i]+"\n";
        }
        if(toastMsgId!=null){
            console.log("-container id-"+toastMsgId);
            var msgContainer = component.find(toastMsgId);
            var msgThemeContainer = component.find(toastMsgId+"Theme");
            $A.util.removeClass(msgThemeContainer, 'slds-theme_error');
            $A.util.removeClass(msgThemeContainer, 'slds-theme_info');
            $A.util.removeClass(msgThemeContainer, 'slds-theme_success');
            $A.util.removeClass(msgThemeContainer, 'slds-theme_warning');
            $A.util.removeClass(msgThemeContainer, 'slds-theme_other');
            
            $A.util.addClass(msgThemeContainer, 'slds-theme_'+msgType);
            
            var toastMessageLocalId = toastMsgId.replace("Toast", "ToastMessage");
            component.find(toastMessageLocalId).set("v.value", msgContent);
            
            $A.util.addClass(msgContainer, 'slds-show');
            $A.util.removeClass(msgContainer, 'slds-hide');
        }
        
    },
    
    
    hideToastMessage : function(component, event){
        console.log("--js_LightningUtility:hideToastMessage()--");
        var iconBtn = event.getSource();
        var iconBtnLocalId = iconBtn.getLocalId();
        console.log('Icon Button LocalId: ' + iconBtnLocalId);
        if (iconBtnLocalId != null) {
            var toastContainerLocalId = iconBtnLocalId.replace("ToastIcon", "Toast");
            var container = component.find(toastContainerLocalId);
            
            var toastMessageLocalId = iconBtnLocalId.replace("ToastIcon", "ToastMessage");
            component.find(toastMessageLocalId).set("v.value", "");
            
            $A.util.addClass(container, "slds-hide");
        }
    },
    
    
    MAX_FILE_SIZE: 4500000, //Max file size 2 MB 
    CHUNK_SIZE: 750000,    //Chunk Max size 450Kb  
    
    uploadHelper: function(component, event,recId) {
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fuploader").get("v.files");
        console.log('==fileInput==='+fileInput);
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents, recId);
        });
        
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents,recId) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);//172,250      
        console.log('==uploadProcess==='+recId);
        console.log('==uploadProcess File Length==='+fileContents.length);
         console.log('---startPosition--1st-'+startPosition);
                console.log('---endPosition--1st-'+endPosition);
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, recId);
    },
    
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition,  recId, attachId) {
        // call the apex method 'SaveFile'
        console.log('>>>>>>> Upload file parent id',recId);
        console.log('>>>>>>> Upload file type',file.type);
        console.log('>>>>>>> Upload file Name',file.name);
         console.log('>>>>>>> attachId file Name',attachId);
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: recId, 
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            console.log('>>>>>>> Upload file attachId',attachId);
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('>>>>>>>SUCCESS');
                // update the start position with end postion
                startPosition = endPosition;//172
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);//172,322
                 console.log('---startPosition--2nd-'+startPosition);
                console.log('---endPosition--2nd-'+endPosition);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                //console.log('>>>>>>> Upload file Start Position',startPosition);
                //console.log('>>>>>>> Upload file End Position',endPosition);
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, recId, attachId);
                } else {
                    //  alert('File has been uploaded successfully');
                }
               // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    recordSubmitHelp: function(component, event, helper) {
           var recId=component.get("v.recordId");
                var missField = "";
                var DuemissField = "";
                event.preventDefault(); 
                var Spec=component.find("SpecTemp");
                var SpecTemp=Spec.get("v.value");
                console.log('===Job Spec Template==='+JSON.stringify(SpecTemp));
                
                var reduceReutrn=component.find('fsOne').reduce(function (validFields, inputCmp) {
                    if(inputCmp.get("v.fieldName") == "Name" ){
                        var JobName = inputCmp.get("v.value");
                        if (JobName == null || JobName == '') 
                            missField = "Name";
                    } 
                    
                    if(inputCmp.get("v.fieldName") == "Due_Date__c" ){
                        var DueDate = inputCmp.get("v.value");
                        if (DueDate == null || DueDate == '') 
                            DuemissField = "DueDate";
                    } 
                    
                }, true);
                if (missField == "Name"){
                    helper.showToastMessage(component, "Please enter the Job Name.", "LightningMsgToast", "error");
                    event.preventDefault();
                }
                
                else if (DuemissField == "DueDate"){
                    helper.showToastMessage(component, "Due Date Field is required.", "LightningMsgToast", "error");
                    event.preventDefault();
                }
                    else if(component.get("v.selectedLookUpRecord_MT").Id==null){
                        helper.showToastMessage(component, "Media Type Field is required.", "LightningMsgToast", "error");
                        event.preventDefault();   
                    }
                
                        else if(component.get("v.selectedLookUpRecord_ST").Id==null ){
                            helper.showToastMessage(component, "Schedule Template Field is required.", "LightningMsgToast", "error");
                            event.preventDefault();   
                        }
                
                            else if(SpecTemp==null || SpecTemp=='')
                            {
                                helper.showToastMessage(component, "Creative Brief Field is required.", "LightningMsgToast", "error");
                                event.preventDefault(); 
                            }
                
                                else
                                {
                                    var fields = event.getParam("fields");
                                    
                                    if(typeof(component.get("v.selectedLookUpRecord_CMP").Id)==="undefined"){
                                        fields["Campaign__c"]="";
                                    }
                                    else{
                                        fields["Campaign__c"]=component.get("v.selectedLookUpRecord_CMP").Id;  
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
                                    
                                    if(typeof(component.get("v.selectedLookUpRecord_MT").Id)==="undefined"){
                                        fields["Media_Type__c"]="";
                                    }
                                    else{
                                        fields["Media_Type__c"]=component.get("v.selectedLookUpRecord_MT").Id;
                                    }
                                    
                                    if(typeof(component.get("v.selectedLookUpRecord_ST").Id)==="undefined"){
                                        fields["Schedule_Template__c"]="";
                                    }
                                    else{
                                        fields["Schedule_Template__c"]=component.get("v.selectedLookUpRecord_ST").Id;
                                    }
                                    fields["Campaign__c"]=component.get("v.selectedLookUpRecord_CMP").Id;
                                    fields["Media_Types__c"]=component.get("v.selectedLookUpRecord_MT").Id;
                                    fields["Schedule_Template__c"]=component.get("v.selectedLookUpRecord_ST").Id;
                                    fields["JS_Client__c"]=component.get("v.selectedLookUpRecord_C").Id;
                                    fields["JS_Client_Contact__c"]=component.get("v.selectedLookUpRecord_CC").Id;
                                    fields["Specification_Template__c"]=SpecTemp;
                                    
                                    component.find("createEditForm").submit(fields);
                                    console.log('===form fields==='+JSON.stringify(fields));
                                }
    }
    
    
})