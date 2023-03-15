({
    doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var sObj = component.get("v.sObjectName");
        if(sObj){
            helper.getFieldsforObject(component, sObj);
        }
        helper.getProfile(component, event, helper);
        helper.getRoles(component, event, helper);
    },
    
    StaffOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        
        var Pro=component.find("StaffProfileId");
        var Profile=Pro.get("v.value");
        console.log('===Profile==='+JSON.stringify(Profile));
        
        var Rol=component.find("staffRoleId");
        var Role=Rol.get("v.value");
        console.log('===Role==='+JSON.stringify(Role));
        
        var FName=component.find("StaffFName");
        var SFName=FName.get("v.value");
        console.log('===First Name==='+JSON.stringify(SFName));
        
        var LName=component.find("StaffLName");
        var SLName=LName.get("v.value");
        console.log('===Last Name==='+JSON.stringify(SLName));
        
        var SEmail=component.find("StaffEmail");
        var StaffEmail=SEmail.get("v.value");
        console.log('===Email==='+JSON.stringify(StaffEmail));
        
        var SUName=component.find("StaffUName");
        var StaffUserName=SUName.get("v.value");
        console.log('===UserName==='+JSON.stringify(StaffUserName));
        
        if(SFName==null || SFName=='')
        {
            var ToastMsgFN=$A.get("e.force:showToast");
            ToastMsgFN.setParams({
                "title":"First Name",
                "type": "error",
                "message":"First Name must have at least three characters."
            });   
            ToastMsgFN.fire();
            event.preventDefault(); 
        }
        else if(SFName.length < 3)
        {
            var ToastMsg1=$A.get("e.force:showToast");
            ToastMsg1.setParams({
                "title":"First Name",
                "type": "error",
                "message":"First Name must have at least three characters."
            });   
            ToastMsg1.fire();
            event.preventDefault(); 
        }
            else if(SLName==null || SLName=='')
            {
                var ToastMsgLN=$A.get("e.force:showToast");
                ToastMsgLN.setParams({
                    "title":"Last Name",
                    "type": "error",
                    "message":"Please enter the Last Name"
                });   
                ToastMsgLN.fire();
                event.preventDefault(); 
            }
                else if(StaffEmail==null || StaffEmail=='')
                {
                    var ToastMsgEmail=$A.get("e.force:showToast");
                    ToastMsgEmail.setParams({
                        "title":"Email",
                        "type": "error",
                        "message":"Please enter the Email"
                    });   
                    ToastMsgEmail.fire();
                    event.preventDefault(); 
                }
                    else if(StaffUserName==null || StaffUserName=='')
                    {
                        var ToastMsgUN=$A.get("e.force:showToast");
                        ToastMsgUN.setParams({
                            "title":"User Name",
                            "type": "error",
                            "message":"Please enter the User Name"
                        });   
                        ToastMsgUN.fire();
                        event.preventDefault(); 
                    }
        
                        else if(Profile==null || Profile=='' || Profile=='--None--')
                        {
                            var ToastMsg=$A.get("e.force:showToast");
                            ToastMsg.setParams({
                                "title":"Profile",
                                "type": "error",
                                "message":"You must select a Profile."
                            });   
                            ToastMsg.fire();
                            event.preventDefault(); 
                        }
                            else if(Role==null || Role=='' || Role=='--None--')
                            {
                                var ToastMsg1=$A.get("e.force:showToast");
                                ToastMsg1.setParams({
                                    "title":"Role",
                                    "type": "error",
                                    "message":"You must select a Role."
                                });   
                                ToastMsg1.fire();
                                event.preventDefault(); 
                            }
        
                                else
                                {
                                    
                                    var Stafffields = event.getParam("fields");
                                    var FName=component.find("StaffFName").get("v.value");
                                    var LName=component.find("StaffLName").get("v.value");
                                    var alias=FName.substring(0,3)+''+LName.substring(0,1);
                                    var UserType=component.find("StaffType").get("v.value");
                                    console.log('>>>>>>Alias>>>>>>>>>>'+alias);
                                    Stafffields["Id"]=component.get("v.recordId");
                                    Stafffields["Name"]=FName+' '+LName;
                                    Stafffields["Profile__c"]=component.find("StaffProfileId").get("v.value");
                                    console.log('===Profile==='+component.find("StaffProfileId").get("v.value"));
                                    Stafffields["Role__c"]=component.find("staffRoleId").get("v.value");
                                    console.log('===Role==='+component.find("staffRoleId").get("v.value"));
                                    Stafffields["Alias__c"]=alias;
                                    if(UserType=='Licensed User'){
                                        var StaffString=JSON.stringify(Stafffields);
                                        var action1=component.get("c.Staff_To_User");
                                        action1.setParams({
                                            staffString : StaffString
                                        });
                                        action1.setCallback(this, function(response){
                                            var state = response.getState();
                                            console.log("label name" + response.getReturnValue());
                                            if(state === "SUCCESS"){
                                                if(response.getReturnValue()=="OK"){
                                                     component.find("StaffEditform").submit(Stafffields);
                                                }else{
                                                    var ToastMsg1=$A.get("e.force:showToast");
                                                    ToastMsg1.setParams({
                                                        "title":"Error!!",
                                                        "type": "error",
                                                        "message":response.getReturnValue()
                                                    });   
                                                    ToastMsg1.fire();
                                                }
                                               
                                            } 
                                        });
                                        $A.enqueueAction(action1);
                                    }
                                    else{
                                        component.find("StaffEditform").submit(Stafffields);
                                    }    
                                     console.log('===form Stafffields==='+JSON.stringify(Stafffields));
                                }
    },
    
    StaffRecordSuccess: function(component, event, helper) 
    { 
        var resultsToast = $A.get("e.force:showToast");
        /*var navEvt = $A.get("e.force:navigateToComponent");
        navEvt.setParams({ 
            componentDef : "c:Admin_Staff"
        }); 
        navEvt.fire(); */
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'Admin_Staff',
            }         
        };
        component.set("v.pageReference", pageReference);
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
        resultsToast.setParams({
            "title": "Saved",
            "type" : "success",
            "message": "The record was saved."
        });
        resultsToast.fire();
    },
    
    doCancel: function(component, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
        }
        else
        {
            var navEvt = $A.get("e.force:navigateToObjectHome");
            navEvt.setParams({
                "scope":component.get("v.sObjectName")
            });
        }
        navEvt.fire();
    },
    
    Staffload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.recordId");
        console.log('===Recordid after==='+recId); 
        
        if(recId!=null){
            console.log('===Recordid 33333 after==='+recId);    
            var Stafffields = event.getParam("recordUi");
            setTimeout($A.getCallback(function() {
                component.find("StaffProfileId").set("v.value",Stafffields.record.fields.Profile__c.value);
            }), 500);
            setTimeout($A.getCallback(function() {
                component.find("staffRoleId").set("v.value",Stafffields.record.fields.Role__c.value);
            }), 500);

            
        }
    }
    
})