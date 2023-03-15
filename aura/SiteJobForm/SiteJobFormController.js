({
    doInit : function(component, event, helper) {
        console.log("Job Form Doinit child");
        helper.FetchFieldsfromFS(component, event, helper); 
        helper.fetchOrgLogo(component, event, helper); 
        helper.fetchCusSettingdata(component, event, helper); 
        //  helper.showToastMessage(component, "Thank You..! Your Job was saved in our database.", "LightningMsgToast", "success");
        helper.getSpecTemplates(component, event, helper);
        helper.getFieldLabels(component, event, helper);
        helper.getSpecObjLabels(component, event, helper);
    //    document.body.setAttribute('style', 'overflow: hidden;');
        
    },
    mediaTypeChange : function(component, event, helper) {
        console.log('------called----');
    },
    SpecChanges : function(component, event, helper) {
        var SpecId = component.find('SpecTemp').get('v.value');
        if(SpecId==null || SpecId=='')
        {
            component.set("v.SpecRecords",null);
        }
        else
        {
            component.set("v.SpecOpen", true);
            //component.find('SpecTempId').FetchSpecRecs();
            helper.fetchJobSpec(component, event, SpecId);
        }
        
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        var file = component.find("fuploader").get("v.files");
        
        if (event.getSource().get("v.files").length > 0) {
            console.log('>> Length IF >>');
            if (file[0].size > 4500000) {
                component.set("v.enable",true);
                console.log('>> Size IF >>');
                helper.showToastMessage(component, "File size cannot exceed 2MB", "LightningMsgToast", "error");
                component.set("v.fileName", 'Alert : File size cannot exceed 2MB.\n' + ' Selected file size: ' + file[0].size);
            }
            else
            {
                component.set("v.enable",false);
                console.log('>> else size IF >>');
                fileName = event.getSource().get("v.files")[0]['name'];
                component.set("v.fileName", fileName);
            }
            
        }
        
    },
    
    
    RecordSubmit : function(component, event, helper) {
      
         var FileAccess = component.get("v.FileSectionAccess");
       if(FileAccess && component.find("fuploader").get("v.files")){
             var file = component.find("fuploader").get("v.files");
             console.log('>> Length IF >>'+file[0].length);
            if (file[0].size > 4500000) {
                console.log('>> Size IF >>'+file[0].size );
                helper.showToastMessage(component, "File size cannot exceed 2MB", "LightningMsgToast", "error");
                component.set("v.fileName", 'Alert : File size cannot exceed 2MB.\n' + ' Selected file size: ' + file[0].size);
            }
            else
            {
                helper.recordSubmitHelp(component, event, helper);
            }
        }else{
             helper.recordSubmitHelp(component, event, helper);
        }
       
        
       /* if (file[0].length > 0) {
            console.log('>> Length IF >>'+file[0].length);
            if (file[0].size > 2000000) {
                console.log('>> Size IF >>'+file[0].size );
                helper.showToastMessage(component, "File size cannot exceed 2MB", "LightningMsgToast", "error");
                component.set("v.fileName", 'Alert : File size cannot exceed 2MB.\n' + ' Selected file size: ' + file[0].size);
            }
            else
            {
                
             
            }
        }*/
    },
    
    onRecordSuccess: function(component, event, helper) 
    {   component.set("v.enable",true);
        var SpecRec = component.get("v.SpecRecords");
        var FileAccess = component.get("v.FileSectionAccess");
        console.log('==SpecRec==='+JSON.stringify(SpecRec));
        console.log('==File Access==='+JSON.stringify(FileAccess));
      //  console.log('==File Length===',component.find("fuploader").get("v.files"));
        var JobSpecSave =component.get("c.SaveSpecrecWithJob");
        JobSpecSave.setParams({ 
            recordId: event.getParam("response").id, 
            Specs:SpecRec
        }); 
    
        $A.enqueueAction(JobSpecSave);
        
        if(FileAccess && component.find("fuploader").get("v.files")){
            if (component.find("fuploader").get("v.files").length > 0) {
                console.log('==File===',event.getParam("response").id);
                helper.uploadHelper(component, event,event.getParam("response").id);
               
            } else {
                alert('Please Select a Valid File');
            }
        }
     helper.showToastMessage(component, "Record Submitted successfully.", "LightningMsgToast", "success");
     setTimeout($A.getCallback(function () {
         
         window.location.reload();
     }), 5000);
        
    },
    
    
    handleToast:function(component, event, helper) {
        helper.hideToastMessage(component, event);
    },
    
    closeModel:function(component, event, helper) {
        window.location.reload();
    }
    
    
})