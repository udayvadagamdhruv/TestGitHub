({
    FetchValues : function(component, event, helper) {
        
        var CampVal = component.get("c.getCampaigns");
        CampVal.setCallback(this, function(CampValRes) {
            var CampValstate = CampValRes.getState();
            console.log('>>>>>>>>>>> Campaign state>>>>>>>>>>>>>>>'+CampValstate);
            //console.log('>>>>>>>>>>> Campaign Res>>>>>>>>>>>>>>>'+JSON.stringify(CampValRes.getReturnValue()));
            if (CampValstate === "SUCCESS") {
                component.set("v.CampaignRec", CampValRes.getReturnValue());
            }
        });
        $A.enqueueAction(CampVal);
        
        // 2. Fetch Client values
        var ClientVal = component.get("c.getClients");
        ClientVal.setCallback(this, function(ClientValRes) {
            var ClientValstate = ClientValRes.getState();
            console.log('>>>>>>>>>>>Client state>>>>>>>>>>>>>>>'+ClientValstate);
            //console.log('>>>>>>>>>>>Client Res>>>>>>>>>>>>>>>'+JSON.stringify(ClientValRes.getReturnValue()));
            if (ClientValstate === "SUCCESS") {
                component.set("v.ClientRec", ClientValRes.getReturnValue());
            }
        });
        $A.enqueueAction(ClientVal);
        
        // 3. Fetch Job Status values
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
})