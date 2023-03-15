public with sharing class CampaignSwitchExt 
{
    public string CampId{get;set;}
    public CampaignSwitchExt(ApexPages.StandardController controller) 
    {
        CampId = controller.getRecord().id;
    }

}