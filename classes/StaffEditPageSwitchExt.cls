public with sharing class StaffEditPageSwitchExt
{
    public string StaffId{get;set;}
    public StaffEditPageSwitchExt(ApexPages.StandardController controller) 
    {
        StaffId= controller.getRecord().id;
    }

}